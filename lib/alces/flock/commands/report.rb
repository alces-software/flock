require 'alces/flock/cluster'
require 'alces/flock/cluster_table'

module Alces
  module Flock
    module Commands
      class Report
        def show(args, options)
          report_name = args[0]
          descriptor = Flock.hub.report(report_name)
          ClusterTable.new(
            options,
            Cluster.all,
            headings: descriptor['fields'].map{|h| h['title']},
            title: descriptor['title']
          ) do |c|
            report_data = c.report(report_name) || {}
            descriptor['fields'].map do |f|
              report_data[f['name']]
            end
          end.render
        end
      end
    end
  end
end
