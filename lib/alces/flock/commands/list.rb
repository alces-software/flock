require 'alces/flock/cluster'
require 'alces/flock/cluster_table'

module Alces
  module Flock
    module Commands
      class List
        def list(args, options)
          ClusterTable.new(
            options,
            Cluster.all,
            headings: ['Endpoint']
          ) do |c|
            [c.endpoint]
          end.render
        end
      end
    end
  end
end
