# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    class Collector
      using Refinements::Strings

      def self.label commit
        "#{commit.sha} (#{commit.author_name}, #{commit.author_date_relative}): #{commit.subject}"
      end

      def self.issues cops
        cops.reduce("") { |message, cop| message + "  #{cop.class.label}: #{cop.issue}\n" }
      end

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

      def to_s
        klass = self.class

        to_h.reduce("") do |summary, (commit, cops)|
          summary + "#{klass.label commit}\n#{klass.issues cops}\n"
        end
      end

      private

      attr_reader :collection
    end
  end
end
