# frozen_string_literal: true

require "thor"
require "thor/actions"
require "thor_plus/actions"
require "runcom"

module Git
  module Cop
    # The Command Line Interface (CLI) for the gem.
    class CLI < Thor
      include Thor::Actions
      include ThorPlus::Actions

      package_name Identity.version_label

      def self.configuration
        defaults = Styles::Abstract.descendants.reduce({}) do |settings, cop|
          settings.merge cop.id => cop.defaults
        end

        Runcom::Configuration.new file_name: Identity.file_name, defaults: defaults
      end

      def initialize args = [], options = {}, config = {}
        super args, options, config
        @runner = Runner.new configuration: self.class.configuration.to_h
      end

      desc "-c, [--config]", %(Manage gem configuration ("#{configuration.computed_path}").)
      map %w[-c --config] => :config
      method_option :edit,
                    aliases: "-e",
                    desc: "Edit gem configuration.",
                    type: :boolean, default: false
      method_option :info,
                    aliases: "-i",
                    desc: "Print gem configuration.",
                    type: :boolean, default: false
      def config
        path = self.class.configuration.computed_path

        if options.edit? then `#{editor} #{path}`
        elsif options.info? then say(path)
        else help(:config)
        end
      end

      desc "-p, [--police]", "Police current branch for issues."
      map %w[-p --police] => :police
      # :reek:TooManyStatements
      def police
        report = runner.run

        if report.empty?
          say "No issues detected."
        else
          cops = report.cops
          cops.each { |cop| say_status :error, "#{cop.class.id} (#{cop.sha}): #{cop.error}", :red }
          abort "#{cops.size} issues detected."
        end
      end

      desc "-v, [--version]", "Show gem version."
      map %w[-v --version] => :version
      def version
        say Identity.version_label
      end

      desc "-h, [--help=COMMAND]", "Show this message or get help for a command."
      map %w[-h --help] => :help
      def help task = nil
        say and super
      end

      private

      attr_reader :runner

      def print_issues
      end
    end
  end
end
