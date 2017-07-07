# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    class Collector
      using Refinements::Strings

      def initialize
        @collection = Hash.new { |default, missing_id| default[missing_id] = [] }
      end

      def add cop
        collection[cop.commit] << cop
        cop
      end

      def retrieve id
        collection[id]
      end

      def empty?
        collection.empty?
      end

      def warnings?
        collection.values.flatten.any?(&:warning?)
      end

      def errors?
        collection.values.flatten.any?(&:error?)
      end

      def issues?
        collection.values.flatten.any?(&:invalid?)
      end

      def total_warnings
        collection.values.flatten.select(&:warning?).size
      end

      def total_errors
        collection.values.flatten.select(&:error?).size
      end

      def total_issues
        collection.values.flatten.select(&:invalid?).size
      end

      def total_commits
        collection.keys.size
      end

      def to_h
        collection
      end

      private

      attr_reader :collection
    end
  end
end
