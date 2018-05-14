require 'alces/flock/cluster'
require 'colorize'
require 'terminal-table'

module Alces
  module Flock
    module Commands
      class Access
        def login(args, options)
          cluster_name = args[0]
          username_args = ['-l',args[1]] if args[1]
          cluster = Cluster.get(cluster_name)
          access_ip = cluster.get('access_ip')
          puts "Access IP: #{access_ip}"
          Kernel.exec('ssh',*username_args,access_ip)
        end
      end
    end
  end
end
