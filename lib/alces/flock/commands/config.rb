require 'alces/flock/comms/cluster'

module Alces
  module Flock
    module Commands
      class Config
        Retry = Class.new(RuntimeError)

        def configure(args, options)
          Flock.config.local_endpoint = get_endpoint('Local', :local_endpoint)
          Flock.config.hub_endpoint = get_endpoint('Hub', :hub_endpoint)
          Flock.config.save
        end

        def get_endpoint(name, key)
          v = ask("#{name} endpoint URL [#{Flock.config.send(key)}]: ")
          v = Flock.config.send(key) if v == ""
          if reachable?(v)
            puts "#{name} endpoint is reachable."
          else
            if !agree("#{name} endpoint is unreachable; continue anyway (Y/N)? ", true)
              raise Retry
            end
          end
          v
        rescue Retry
          retry
        end

        def reachable?(endpoint)
          Comms::Cluster.new(endpoint).pingable?
        rescue
          false
        end
      end
    end
  end
end
