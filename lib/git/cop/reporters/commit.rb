# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      # Reports issues related to a single commit.
      class Commit
        def initialize commit:, cops: []
          @commit = commit
          @cops = cops
        end

        def to_s
          "#{commit.sha} (#{commit.author_name}, #{commit.author_date_relative}): " \
          "#{commit.subject}\n#{cop_report}\n"
        end

        private

        attr_reader :commit, :cops

        def cop_report
          cops.select(&:invalid?).reduce("") { |report, cop| report + Cop.new(cop).to_s }
        end
      end
    end
  end
end
