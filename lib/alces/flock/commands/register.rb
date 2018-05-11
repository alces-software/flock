module Alces
  module Flock
    module Commands
      class Register
        def register(args, options)
          endpoint_url = args[0]
          auth = args[1]
          if endpoint_url.nil? || auth.nil?
            puts "Usage: bad thing"
            return
          end
          result = Flock.hub.register(endpoint_url, auth)
          if result == :ok
            puts "OK!"
          else
            puts "FAIL: #{result}"
          end
        end
      end
    end
  end
end
