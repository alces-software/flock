require 'alces/flock/cluster'

module Alces
  module Flock
    module Commands
      class Triggers
        def trigger(args, options)
          operation_name = args[0]
          Cluster.local.trigger(operation_name)
        end
      end
    end
  end
end
