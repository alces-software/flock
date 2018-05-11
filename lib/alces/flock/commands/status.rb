require 'alces/flock/commands/report'

module Alces
  module Flock
    module Commands
      class Status
        def status(args, options)
          Report.new.show(['status'], options)
        end
      end
    end
  end
end
