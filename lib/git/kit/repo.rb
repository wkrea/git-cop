# frozen_string_literal: true

module Git
  module Kit
    class Repo
      def initialize shell: Open3
        @shell = shell
      end

      def exist?
        shell.capture2e("git rev-parse --git-dir > /dev/null 2>&1")
             .then { |result, status| result && status.success? }
      end

      private

      attr_reader :shell
    end
  end
end
