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
          "#{commit_total}. #{issue_totals}.\n"
        end

        private

        attr_reader :collector

        def commit_report
          collector.to_h.reduce("") do |details, (commit, cops)|
            details + Commit.new(commit: commit, cops: cops).to_s
          end
        end

        def branch_report
          return "" unless collector.issues?
          "\n\n#{commit_report}".chomp "\n"
        end

        def commit_total
          %(#{Kit::String.pluralize "commit", count: collector.total_commits} inspected)
        end

        def issue_total
          Kit::String.pluralize "issue", count: collector.total_issues
        end

        def warning_total
          Kit::String.pluralize "warning", count: collector.total_warnings
        end

        def error_total
          Kit::String.pluralize "error", count: collector.total_errors
        end

        def issue_totals
          if collector.issues?
            "#{issue_total} detected (#{warning_total}, #{error_total})"
          else
            "0 issues detected"
          end
        end
      end
    end
  end
end
