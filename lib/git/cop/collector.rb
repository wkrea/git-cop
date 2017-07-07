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

      def to_h
        collection
      end

      private

      attr_reader :collection
    end
  end
end
