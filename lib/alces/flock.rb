require 'alces/flock/cli'
require 'alces/flock/comms/hub'
require 'alces/flock/config'

module Alces
  module Flock
    class << self
      def config
        @config ||= Config.new
      end

      def hub
        @hub ||= Comms::Hub.new(config.hub_endpoint)
      end
    end
  end
end
