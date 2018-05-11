require 'commander'
require 'alces/flock/commands/access'
require 'alces/flock/commands/config'
require 'alces/flock/commands/list'
require 'alces/flock/commands/register'
require 'alces/flock/commands/report'
require 'alces/flock/commands/status'
require 'alces/flock/commands/triggers'
require 'alces/flock/commands/values'

module Alces
  module Flock
    class CLI
      include Commander::Methods

      def run
        program :name, 'flock'
        program :version, '0.0.1'
        program :description, 'Alces Flight Flock'

        command :list do |c|
          c.syntax = 'flock list'
          c.summary = 'List members of the flock'
          c.description = 'List members of the flock.'
          c.action Commands::List, :list
        end
        alias_command :ls, :list

        command :status do |c|
          c.syntax = 'flock status'
          c.summary = 'Display status of the flock'
          c.description = 'Display status of the flock.'
          c.action Commands::Status, :status
        end
        alias_command :ls, :list

        command :report do |c|
          c.syntax = 'flock report'
          c.summary = 'Display report for flock'
          c.description = 'Display report for flock.'
          c.action Commands::Report, :show
        end

        command :register do |c|
          c.syntax = 'flock register'
          c.summary = 'Register to a flock'
          c.description = 'Register to a flock.'
          c.action Commands::Register, :register
        end

        command :set do |c|
          c.syntax = 'flock set'
          c.summary = 'Set a value for this cluster'
          c.description = 'Set a value for this cluster.'
          c.option '--hub', 'Store value in the flock hub'
          c.action Commands::Values, :set
        end

        command :get do |c|
          c.syntax = 'flock get'
          c.summary = 'Get a value for this cluster'
          c.description = 'Get a value for this cluster.'
          c.option '--hub', 'Retrieve value from the flock hub'
          c.option '--cluster NAME', String, 'Retrieve value from the specified cluster'
          c.action Commands::Values, :get
        end

        command :login do |c|
          c.syntax = 'flock login'
          c.summary = 'Log in to a flock cluster'
          c.description = 'Log in to a flock cluster.'
          c.action Commands::Access, :login
        end

        command :configure do |c|
          c.syntax = 'flock configure'
          c.summary = 'Configure the flock tool'
          c.description = 'Configure the flock tool.'
          c.action Commands::Config, :configure
        end

        command :trigger do |c|
          c.syntax = 'flock trigger'
          c.summary = 'Trigger a flock operation'
          c.description = 'Trigger a flock operation.'
          c.action Commands::Triggers, :trigger
        end
        
        run!
      end
    end
  end
end
