require 'alces/flock/comms/base'

require 'faraday'

module Alces
  module Flock
    module Comms
      class Cluster
        include Base

        def name
          resp = connection.get("query/name")
          resp.body['report']
        end

        def report(r)
          resp = connection.get("reports/#{r}")
          resp.body
        rescue Faraday::ConnectionFailed
          nil
        end
      end
    end
  end
end
