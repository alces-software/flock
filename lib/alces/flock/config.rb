require 'yaml'

module Alces
  module Flock
    class Config
      FLOCK_ROOT = ENV['FLOCK_ROOT'] || '/opt/flock'
      CONFIG_FILE = ENV['FLOCK_CONFIG'] || "#{FLOCK_ROOT}/etc/config.yml"
      DEFAULTS = {
        hub_endpoint: ENV['FLOCK_HUB_URL'] || 'http://127.0.0.1:9393',
        local_endpoint: ENV['FLOCK_LOCAL_URL'] || 'http://127.0.0.1:9292',
      }

      def method_missing(s, *a, &b)
        if data.key?(s)
          data[s]
        else
          setter = s.to_s.chomp('=').to_sym
          if data.key?(setter)
            data[setter] = a[0]
          else
            super
          end
        end
      end

      def respond_to_missing(s)
        data.key?(s)
        super
      end

      def save
        File.write(CONFIG_FILE, data.to_yaml)
      end

      private
      def data
        @data ||= load
      end

      def load
        DEFAULTS.dup.tap do |config|
          if File.exists?(CONFIG_FILE)
            config.merge!(YAML.load_file(CONFIG_FILE))
          end
        end
      end
    end
  end
end
