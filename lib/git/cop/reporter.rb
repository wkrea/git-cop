# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    class Reporter
      using Refinements::Strings

      def self.errors cops
        cops.reduce("") { |message, cop| message + "  #{cop.class.label}: #{cop.error}\n" }
      end

      def initialize
        @collection = Hash.new { |default, missing_id| default[missing_id] = [] }
      end

      # :reek:FeatureEnvy
      def add cop
        return if cop.valid?
        collection[cop.sha] << cop
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

      def to_s
        to_h.reduce("") do |summary, (sha, cops)|
          summary + "Commit #{sha}:\n#{self.class.errors cops}\n"
        end
      end

      private

      attr_reader :collection
    end
  end
end
