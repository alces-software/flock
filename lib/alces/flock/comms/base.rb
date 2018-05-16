require 'faraday'
require 'faraday_middleware'
require 'json'

module Alces
  module Flock
    module Comms
      module Base
        def initialize(endpoint)
          @endpoint = endpoint
        end

        def pingable?
          connection.get('ping')
          true
        rescue Faraday::ConnectionFailed
          false
        end

        def trigger(op)
          resp = connection.post("trigger") do |req|
            req.headers['Content-Type'] = 'application/json'
            req.body = {op: op}.to_json
          end
          resp.status == 204
        end
        
        def get(v)
          resp = connection.get("query/value", {name: v})
          resp.body['report']
        rescue Faraday::ConnectionFailed
          '-'
        end

        def set(k, v, auth)
          resp = connection(auth).post('set') do |req|
            req.headers['Content-Type'] = 'application/json'
            req.body = {key: k, value: v}.to_json
          end
          resp.status == 204
        end

        def reports
          resp = connection.get("reports")
          resp.body
        rescue Faraday::ConnectionFailed
          raise UnreachableEndpointError, @endpoint
        end

        def report_descriptor(name)
          reports[name].tap do |r|
            raise ReportNotFoundError, name if r.nil?
          end
        rescue Faraday::ConnectionFailed
          raise UnreachableEndpointError, @endpoint
        end

        private
        def connection(auth = nil)
          Faraday.new(@endpoint) do |conn|
            conn.response :json, :content_type => /\bjson$/
            conn.basic_auth(Process.euid,auth) unless auth.nil?
            conn.adapter Faraday.default_adapter
          end
        end
      end
    end
  end
end
