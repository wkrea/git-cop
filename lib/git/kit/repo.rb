# frozen_string_literal: true

module Git
  module Kit
    class Repo
      def self.exist?
        system "git rev-parse --git-dir > /dev/null 2>&1"
      end
    end
  end
end
