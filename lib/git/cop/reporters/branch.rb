# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      # Reports issues related to a single feature branch.
      class Branch
        def initialize collector: Collector.new
          @collector = collector
        end

        def to_s
          "Running #{Identity.label}...#{branch_report}\n" \
          "#{collector.total_commits} commit(s) inspected. #{stats}\n"
        end

        private

        attr_reader :collector

        def commit_reports
          collector.to_h.reduce("") do |details, (commit, cops)|
            details + Commit.new(commit: commit, cops: cops).to_s
          end
        end

        def branch_report
          return "" unless collector.issues?
          "\n\n#{commit_reports}".chomp "\n"
        end

        def stats
          if collector.issues?
            "#{collector.total_issues} issue(s) detected " \
            "(#{collector.total_warnings} warning(s), #{collector.total_errors} error(s))."
          else
            "0 issues detected."
          end
        end
      end
    end
  end
end
