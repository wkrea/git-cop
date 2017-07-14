# frozen_string_literal: true

module Git
  module Cop
    class Runner
      def initialize configuration:, collector: Collector.new
        @configuration = configuration
        @collector = collector
      end

      def run shas: Branches::Feature.new.shas
        Array(shas).map { |sha| check Commits::Saved.new(sha: sha) }
        collector
      end

      private

      attr_reader :configuration, :collector

      def load_cop id, commit, settings
        klass = Styles::Abstract.descendants.find { |descendant| descendant.id == id }
        fail(Errors::Base, "Invalid cop: #{id}. See docs for supported cops.") unless klass
        klass.new commit: commit, settings: settings
      end

      def check commit
        cops = configuration.map { |id, settings| load_cop id, commit, settings }
        cops.select(&:enabled?).map { |cop| collector.add cop }
      end
    end
  end
end
