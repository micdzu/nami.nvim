# This is a comment — should recede (comment)

module Payment
  API_VERSION = "v1" # constant + string

  class Processor
    DEFAULT_TIMEOUT = 30 # constant (numeric)

    def initialize(client:, retries: 3)
      @client = client            # instance variable
      @retries = retries          # parameter / number
    end

    def process(user, amount_cents)
      log_info("Processing payment", user: user.id)

      if amount_cents <= 0
        raise ArgumentError, "Amount must be positive" # error + string
      end

      response = @client.post(
        "/payments/#{user.id}",   # string interpolation
        {
          amount: amount_cents,
          currency: :usd,        # symbol
          metadata: build_metadata(user)
        }
      )

      handle_response(response)
    end

    private

    def handle_response(response)
      case response.status
      when 200
        log_info("Payment successful", id: response.id)
      when 402
        log_warn("Payment declined", code: response.code)
      else
        log_error("Unexpected error", status: response.status)
      end
    end

    def build_metadata(user)
      {
        user_email: user.email,
        signup_date: user.created_at.strftime("%Y-%m-%d")
      }
    end

    def log_info(message, **context)
      puts "[INFO] #{message} -- #{context.inspect}"
    end

    def log_warn(message, **context)
      puts "[WARN] #{message} -- #{context.inspect}"
    end

    def log_error(message, **context)
      puts "[ERROR] #{message} -- #{context.inspect}"
    end
  end
end
