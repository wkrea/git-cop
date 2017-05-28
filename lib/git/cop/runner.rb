# frozen_string_literal: true

module Git
  module Cop
    class Runner
      def initialize configuration:, root_dir: Dir.pwd, reporter: Reporter.new
        @configuration = configuration
        @root_dir = root_dir
        @reporter = reporter
      end

      def run
        commits.each { |commit| report commit }
        reporter
      end

      private

      attr_reader :configuration, :root_dir, :reporter

      def current_branch
        `git rev-parse --abbrev-ref HEAD | tr -d '\n'`
      end

      def commits
        `git log --pretty=format:"%H" master...#{current_branch}`.split("\n").map do |sha|
          Git::Cop::Commit.new sha: sha
        end
      end

      def initialize_cop id, commit, settings
        klass = Styles::Abstract.descendants.find { |descendant| descendant.id == id }
        fail(StandardError, "Invalid cop: #{id}. See docs for supported cops.") unless klass
        klass.new commit: commit, settings: settings
      end

      def report commit
        cops = configuration.map { |id, settings| initialize_cop id, commit, settings }
        cops.select(&:enabled?).map { |cop| reporter.add cop }
      end
    end
  end
end
