require 'alces/flock/cluster'
require 'alces/flock/cluster_table'
require 'json'

module Alces
  module Flock
    module Commands
      class Report
        def show(args, options)
          if args[0].nil?
            list(args, options)
          else
            report_name = args[0]
            descriptor =
              begin
                Cluster.local.report_descriptor(report_name)
              rescue ReportNotFoundError
                Flock.hub.report_descriptor(report_name)
              end
            if descriptor['type'] == 'local'
              local_report(descriptor, options)
            else
              cluster_report(descriptor, report_name, options)
            end
          end
        end

        def cluster_report(descriptor, report_name, options)
          ClusterTable.new(
            options,
            Cluster.all,
            headings: descriptor['fields'].map{|h| h['title'].bold },
            title: descriptor['title'].bold
          ) do |c|
            report_data = c.report(report_name) || {}
            descriptor['fields'].map do |f|
              report_data[f['name']]
            end
          end.render
        end

        def local_report(descriptor, options)
          table = Terminal::Table.new
          table.headings = descriptor['columns'].map{|s|s.bold}
          table.title = descriptor['title'].bold
          data_json = Cluster.local.get(descriptor['source'])
          if data_json != '-'
            data = JSON.parse(data_json)
            table.rows = data.map {|d| d == 'separator' ? :separator : d}
            (0..table.number_of_columns-1).each do |c|
              table.align_column(c, :right)
            end
            puts table
          else
            puts "No data."
          end
        end

        def list(args, options)
          local_reports = Cluster.local.reports
          hub_reports = Flock.hub.reports
          hub_reports.merge(local_reports).each do |k,v|
            puts "#{k}: #{v['title']}"
          end
        end
      end
    end
  end
end
