require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/module/delegation'

require 'alces/flock/comms/cluster'
require 'alces/flock/errors'

module Alces
  module Flock
    class Cluster
      class << self
        include Enumerable

        def all
          @all ||= Flock.hub.clusters.map {|c| Cluster.new(**c.symbolize_keys)}
        end

        def get(name)
          all.find {|c| c.name == name}.tap do |c|
            raise ClusterNotFoundError, name if c.nil?
          end
        end

        def local
          @local ||= Cluster.new(endpoint: Flock.config.local_endpoint)
        end

        def each(&block)
          all.each(&block)
        end
      end

      attr_accessor :name, :endpoint
      delegate :get, :set, :report, :reports, :report_descriptor, :trigger, to: :comms

      def initialize(endpoint: 'http://127.0.0.1:9292', name: nil)
        self.endpoint = endpoint
        self.name = name
      end

      def name
        @name ||= comms.name
      end

      private
      def comms
        @comms ||= Comms::Cluster.new(endpoint)
      end
    end
  end
end
