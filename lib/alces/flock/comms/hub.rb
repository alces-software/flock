require 'alces/flock/comms/base'
require 'alces/flock/errors'

require 'faraday'
require 'json'

module Alces
  module Flock
    module Comms
      class Hub
        include Base

        def register(endpoint_url, auth)
          resp = connection(auth).post('register') do |req|
            req.headers['Content-Type'] = 'application/json'
            req.body = {endpoint: endpoint_url}.to_json
          end
          if resp.status == 204
            :ok
          else
            result = resp.body
            if result.is_a?(Hash)
              resp.body.dig('error')
            else
              'unknown'
            end
          end
        rescue Faraday::ConnectionFailed
          raise UnreachableHubError, @endpoint
        end

        def clusters
          resp = connection.get("query/clusters")
          resp.body['report']
        rescue Faraday::ConnectionFailed
          raise UnreachableHubError, @endpoint
        end
      end
    end
  end
end
