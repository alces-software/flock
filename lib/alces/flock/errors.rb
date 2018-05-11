module Alces
  module Flock
    class ClusterNotFoundError < RuntimeError
      def to_s
        "cluster not found: #{super}"
      end
    end

    class UnreachableHubError < RuntimeError
      def to_s
        "unreachable hub: #{super}"
      end
    end

    class ReportNotFoundError < RuntimeError
      def to_s
        "report not found: #{super}"
      end
    end
  end
end
