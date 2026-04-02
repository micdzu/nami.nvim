---@module "nami.palette.utils"
---
--- Perceptual color utilities for Nami.
---
--- FIXES:
--- - derive_bg_adaptive now works for light backgrounds (darkens instead of lightens)
--- - Increased max_delta from 0.25 to 0.4 for better accessibility adjustments
--- - Added hex color validation

local M = {}

-------------------------------------------------
-- CONSTANTS
-------------------------------------------------

local WCAG_AA = 4.5

-------------------------------------------------
-- VALIDATION
-------------------------------------------------

---Validate hex color string format.
---@param hex string
---@param context string Description for error messages
---@return boolean valid
function M.validate_hex(hex, context)
	if type(hex) ~= "string" then
		vim.notify(
			string.format("[nami] Invalid color in %s: expected string, got %s", context, type(hex)),
			vim.log.levels.ERROR
		)
		return false
	end
	if not hex:match("^#%x%x%x%x%x%x$") then
		vim.notify(
			string.format("[nami] Invalid hex color in %s: '%s' (expected #RRGGBB)", context, hex),
			vim.log.levels.ERROR
		)
		return false
	end
	return true
end

-------------------------------------------------
-- HEX ↔ RGB
-------------------------------------------------

---@param hex string #RRGGBB
---@return number, number, number
local function hex_to_rgb(hex)
	return tonumber(hex:sub(2, 3), 16) / 255, tonumber(hex:sub(4, 5), 16) / 255, tonumber(hex:sub(6, 7), 16) / 255
end

---@param r number
---@param g number
---@param b number
---@return string
local function rgb_to_hex(r, g, b)
	r = math.floor(math.max(0, math.min(1, r)) * 255)
	g = math.floor(math.max(0, math.min(1, g)) * 255)
	b = math.floor(math.max(0, math.min(1, b)) * 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

-------------------------------------------------
-- LINEARIZATION
-------------------------------------------------

local function to_linear(c)
	return c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
end

local function to_srgb(c)
	return c <= 0.0031308 and 12.92 * c or 1.055 * c ^ (1 / 2.4) - 0.055
end

local function clamp(x)
	return math.max(0, math.min(1, x))
end

-------------------------------------------------
-- LUMINANCE + CONTRAST
-------------------------------------------------

---@param hex string
---@return number
local function relative_luminance(hex)
	local r, g, b = hex_to_rgb(hex)
	r, g, b = to_linear(r), to_linear(g), to_linear(b)
	return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

---@param fg string
---@param bg string
---@return number
function M.contrast(fg, bg)
	local L1 = relative_luminance(fg)
	local L2 = relative_luminance(bg)
	if L1 < L2 then
		L1, L2 = L2, L1
	end
	return (L1 + 0.05) / (L2 + 0.05)
end

-------------------------------------------------
-- OKLCH
-------------------------------------------------

local function rgb_to_oklab(r, g, b)
	r, g, b = to_linear(r), to_linear(g), to_linear(b)

	local l = 0.4122 * r + 0.5363 * g + 0.0514 * b
	local m = 0.2119 * r + 0.6807 * g + 0.1074 * b
	local s = 0.0883 * r + 0.2817 * g + 0.6300 * b

	l, m, s = l ^ (1 / 3), m ^ (1 / 3), s ^ (1 / 3)

	return {
		L = 0.2105 * l + 0.7936 * m - 0.0041 * s,
		a = 1.9780 * l - 2.4286 * m + 0.4506 * s,
		b = 0.0259 * l + 0.7828 * m - 0.8087 * s,
	}
end

local function oklab_to_rgb(L, a, b)
	local l = (L + 0.3963 * a + 0.2158 * b) ^ 3
	local m = (L - 0.1056 * a - 0.0639 * b) ^ 3
	local s = (L - 0.0895 * a - 1.2915 * b) ^ 3

	local r = 4.0767 * l - 3.3077 * m + 0.2310 * s
	local g = -1.2684 * l + 2.6098 * m - 0.3413 * s
	local b_ = -0.0042 * l - 0.7034 * m + 1.7076 * s

	return clamp(to_srgb(r)), clamp(to_srgb(g)), clamp(to_srgb(b_))
end

local function hex_to_oklch(hex)
	local r, g, b = hex_to_rgb(hex)
	local lab = rgb_to_oklab(r, g, b)
	return {
		L = lab.L,
		C = math.sqrt(lab.a ^ 2 + lab.b ^ 2),
		h = math.atan2(lab.b, lab.a),
	}
end

local function oklch_to_hex(L, C, h)
	local a = C * math.cos(h)
	local b = C * math.sin(h)
	local r, g, b_ = oklab_to_rgb(L, a, b)
	return rgb_to_hex(r, g, b_)
end

-------------------------------------------------
-- TARGET POLICY
-------------------------------------------------

---@param role string
---@param opts table
---@return number
function M.get_target(role, opts)
	opts = opts or {}
	local base = (opts.accessibility and opts.accessibility.contrast) or WCAG_AA

	if opts.accessibility and opts.accessibility.enabled then
		return base
	end

	return ({
		definition = 3.2,
		constant = 3.0,
		string = 2.7,
		comment = 2.3,
	})[role] or base
end

-------------------------------------------------
-- CONTRAST SOLVER (CLAMPED)
-------------------------------------------------

---@param fg string
---@param bg string
---@param target number
---@return string
function M.adjust_to_contrast_target(fg, bg, target)
	local current = M.contrast(fg, bg)
	if current >= target then
		return fg
	end

	local bg_lum = relative_luminance(bg)
	local fg_lum = relative_luminance(fg)

	local make_darker = fg_lum > bg_lum
	local target_lum = make_darker and (bg_lum + 0.05) / target - 0.05 or target * (bg_lum + 0.05) - 0.05

	target_lum = math.max(0, math.min(1, target_lum))

	local c = hex_to_oklch(fg)
	local original_L = c.L
	-- INCREASED: from 0.25 to 0.4 to allow sufficient adjustment for light themes
	local max_delta = 0.4

	local low, high = 0, 1

	for _ = 1, 12 do
		local mid = (low + high) / 2

		local clamped_L = math.max(original_L - max_delta, math.min(original_L + max_delta, mid))

		local test = oklch_to_hex(clamped_L, c.C, c.h)
		local lum = relative_luminance(test)

		if make_darker then
			if lum > target_lum then
				high = mid
			else
				low = mid
			end
		else
			if lum < target_lum then
				low = mid
			else
				high = mid
			end
		end
	end

	local final_L = math.max(original_L - max_delta, math.min(original_L + max_delta, (low + high) / 2))

	return oklch_to_hex(final_L, c.C, c.h)
end

-------------------------------------------------
-- CHROMA (ROLE-AWARE)
-------------------------------------------------

---@param hex string
---@param role string
---@return string
function M.adjust_chroma(hex, role)
	local c = hex_to_oklch(hex)

	local factor = ({
		definition = 1.05,
		constant = 1.00,
		string = 0.95,
		comment = 0.85,
	})[role] or 1.0

	local cap = ({
		definition = 0.55,
		constant = 0.50,
		string = 0.45,
		comment = 0.35,
	})[role] or 0.5

	c.C = math.min(c.C * factor, cap)

	return oklch_to_hex(c.L, c.C, c.h)
end

-------------------------------------------------
-- MAIN ENTRY (ROLE-AWARE PRESERVE)
-------------------------------------------------

---@param fg string
---@param bg string
---@param role string
---@param opts table
---@return string
function M.ensure(fg, bg, role, opts)
	opts = opts or {}

	-- Validate inputs
	if not M.validate_hex(fg, "ensure(fg)") or not M.validate_hex(bg, "ensure(bg)") then
		return fg -- Return original on error to prevent cascade failures
	end

	local target = M.get_target(role, opts)

	local base_preserve = (opts.accessibility and opts.accessibility.preserve) or 0.9

	local preserve_map = {
		definition = 0.95,
		constant = 0.9,
		string = 0.85,
		comment = 0.75,
	}

	local preserve = preserve_map[role] or base_preserve

	local current = M.contrast(fg, bg)

	if current >= target * preserve then
		return fg
	end

	local adjusted = M.adjust_to_contrast_target(fg, bg, target)

	if adjusted ~= fg then
		return M.adjust_chroma(adjusted, role)
	end

	return fg
end

-------------------------------------------------
-- UI LAYERS
-------------------------------------------------

---Derive UI background layers (selection, cursorline, etc.)
---FIX: Now handles light backgrounds correctly by darkening instead of lightening.
---@param bg string
---@param _opts table|nil
---@return table
function M.derive_bg_adaptive(bg, _opts)
	-- Check if background is light or dark
	local c = hex_to_oklch(bg)
	local is_light = c.L > 0.5

	local function adjust(hex, delta)
		local c_bg = hex_to_oklch(hex)
		-- For light backgrounds, darken; for dark backgrounds, lighten
		local direction = is_light and -1 or 1
		c_bg.L = math.max(0.05, math.min(0.95, c_bg.L + (delta * direction)))
		return oklch_to_hex(c_bg.L, c_bg.C, c_bg.h)
	end

	return {
		bg_light = adjust(bg, 0.05),
		selection = adjust(bg, 0.10),
		cursorline = adjust(bg, 0.03),
	}
end

return M
