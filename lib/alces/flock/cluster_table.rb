require 'terminal-table'
require 'colorize'

module Alces
  module Flock
    class ClusterTable
      class << self
        def render(*args, &block)
          table = new(*args, &block)
          table.render
        end
      end

      def initialize(options, clusters, headings: [], title: nil, &block)
        @table = Terminal::Table.new
        @table.headings = ['Cluster'.bold].concat(headings)
        @table.title = title
        clusters.each do |c|
          @table << [name_for(c)].concat(block.call(c))
        end
        (0..@table.number_of_columns-1).each do |c|
          @table.align_column(c, :right)
        end
      end

      def render
        puts @table
      end

      def method_missing(s, *a, &b)
        if @table.respond_to?(s)
          @table.send(s, *a, &b)
        else
          super
        end
      end

      def respond_to_missing?(s)
        @table.respond_to?(s) || super
      end

      private
      def name_for(cluster)
        if cluster.name == Cluster.local.name
          "#{cluster.name} (local)".green.bold
        else
          cluster.name
        end
      end
    end
  end
end
