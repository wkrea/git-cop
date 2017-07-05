# frozen_string_literal: true

module Git
  module Cop
    class Runner
      def initialize configuration:, reporter: Reporter.new
        @configuration = configuration
        @reporter = reporter
        @commits = Branch.new.shas.map { |sha| Git::Cop::Commit.new sha: sha }
      end

      def run
        commits.each { |commit| check commit }
        reporter
      end

      def number_commits
        commits.count
      end

      private

      attr_reader :configuration, :reporter, :commits

      def load_cop id, commit, settings
        klass = Styles::Abstract.descendants.find { |descendant| descendant.id == id }
        fail(StandardError, "Invalid cop: #{id}. See docs for supported cops.") unless klass
        klass.new commit: commit, settings: settings
      end

      def check commit
        cops = configuration.map { |id, settings| load_cop id, commit, settings }
        cops.select(&:enabled?).map { |cop| reporter.add cop }
      end
    end
  end
end
