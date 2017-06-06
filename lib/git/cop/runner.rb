# frozen_string_literal: true

module Git
  module Cop
    class Runner
      def initialize configuration:, reporter: Reporter.new
        @configuration = configuration
        @reporter = reporter
        @branch = Branch.new
      end

      def run
        commits.each { |commit| report commit }
        reporter
      end

      private

      attr_reader :configuration, :reporter, :branch

      def commits
        branch.shas.map { |sha| Git::Cop::Commit.new sha: sha }
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
