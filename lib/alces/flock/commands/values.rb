require 'alces/flock/cluster'

module Alces
  module Flock
    module Commands
      class Values
        def set(args, options)
          if target(options).set(args[0], args[1], args[2])
            puts "OK!"
          else
            puts "FAIL!"
          end
        end

        def get(args, options)
          puts target(options).get(args[0])
        end

        private
        def target(options)
          if options.hub
            Flock.hub
          elsif options.cluster
            Cluster.get(options.cluster)
          else
            Cluster.local
          end
        end
      end
    end
  end
end
