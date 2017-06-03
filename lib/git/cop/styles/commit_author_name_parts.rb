# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitAuthorNameParts < Abstract
        def self.defaults
          {
            enabled: true,
            minimum: 2
          }
        end

        def valid?
          return false if parts.size < minimum
          parts.all? { |name| !String(name).empty? }
        end

        def error
          return "" if valid?
          %(Invalid name: "#{full_name}". Detected #{parts.size} out of #{minimum} parts required.)
        end

        private

        def full_name
          commit.author_name.strip
        end

        def minimum
          settings.fetch :minimum
        end

        def parts
          full_name.split(/\s{1}/)
        end
      end
    end
  end
end
