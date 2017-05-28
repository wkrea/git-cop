# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    class Reporter
      using Refinements::Strings

      def initialize
        @collection = Hash.new { |default, missing_id| default[missing_id] = [] }
      end

      # :reek:FeatureEnvy
      def add cop
        return if cop.valid?
        collection[cop.class.id] << cop
        cop
      end

      def retrieve id
        collection[id]
      end

      def cops
        collection.values.flatten
      end

      def empty?
        collection.empty?
      end

      private

      attr_reader :collection
    end
  end
end
