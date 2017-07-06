# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    class Collector
      using Refinements::Strings

      def initialize
        @collection = Hash.new { |default, missing_id| default[missing_id] = [] }
      end

      # :reek:FeatureEnvy
      def add cop
        return if cop.valid?
        collection[cop.commit] << cop
        cop
      end

      def retrieve id
        collection[id]
      end

      def empty?
        collection.empty?
      end

      def total
        collection.values.flatten.size
      end

      def to_h
        collection
      end

      private

      attr_reader :collection
    end
  end
end
