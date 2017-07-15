# frozen_string_literal: true

require "thor"
require "thor/actions"
require "runcom"
require "pastel"

module Git
  module Cop
    # The Command Line Interface (CLI) for the gem.
    class CLI < Thor
      include Thor::Actions

      package_name Identity.version_label

      def self.configuration
        defaults = Styles::Abstract.descendants.reduce({}) do |settings, cop|
          settings.merge cop.id => cop.defaults
        end

        Runcom::Configuration.new project_name: Identity.name, defaults: defaults
      end

      def initialize args = [], options = {}, config = {}
        super args, options, config
        @runner = Runner.new configuration: self.class.configuration.to_h
        @colorizer = Pastel.new
      end

      desc "-c, [--config]", "Manage gem configuration."
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
        path = self.class.configuration.path

        if options.edit? then `#{ENV["EDITOR"]} #{path}`
        elsif options.info?
          path ? say(path) : say("Configuration doesn't exist.")
        else help(:config)
        end
      end

      desc "-p, [--police]", "Check feature branch for issues."
      map %w[-p --police] => :police
      method_option :commits,
                    aliases: "-c",
                    desc: "Check specific commit SHA(s).",
                    type: :array,
                    default: []
      def police
        collector = analyze_commits options.commits
        abort if collector.errors?
      rescue Errors::Base => exception
        abort colorizer.red("#{Identity.label}: #{exception.message}")
      end

      desc "--hook", "Add Git Hook support."
      map "--hook" => :hook
      method_option :commit_message,
                    desc: "Check commit message.",
                    banner: "PATH",
                    type: :string
      def hook
        if options.commit_message?
          check_commit_message options.commit_message
        else
          help "--hook"
        end
      rescue Errors::Base => exception
        abort colorizer.red("#{Identity.label}: #{exception.message}")
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

      attr_reader :runner, :colorizer

      def load_collector shas
        commits = shas.map { |sha| Commits::Saved.new sha: sha }
        commits.empty? ? runner.run : runner.run(commits: commits)
      end

      def analyze_commits shas
        load_collector(shas).tap do |collector|
          reporter = Reporters::Branch.new collector: collector
          say reporter.to_s
        end
      end

      def check_commit_message path
        commit = Commits::Unsaved.new path: path
        collector = runner.run commits: commit
        reporter = Reporters::Branch.new collector: collector
        say reporter.to_s
        abort if collector.errors?
      end
    end
  end
end
