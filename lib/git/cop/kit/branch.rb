# frozen_string_literal: true

require "forwardable"

module Git
  module Cop
    module Kit
      class Branch
        extend Forwardable

        def_delegators :environment, :name, :shas

        def self.environment
          if ENV["CIRCLECI"] == "true"
            Environments::CircleCI.new
          elsif ENV["TRAVIS"] == "true"
            Environments::TravisCI.new
          else
            Environments::Local.new
          end
        end

        def initialize
          @environment = self.class.environment
        end

        private

        attr_reader :environment
      end
    end
  end
end
