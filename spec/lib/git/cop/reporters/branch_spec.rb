# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Branch do
  let :commit do
    object_double Git::Cop::Kit::Commit.new(sha: "abcdef"), sha: "fa4a269f4fe9",
                                                            author_name: "Test Tester",
                                                            author_date_relative: "1 second ago",
                                                            subject: "A subject."
  end

  let(:issue) { {label: "A test label.", hint: "A test hint."} }
  let(:cop_class) { class_spy Git::Cop::Styles::CommitAuthorEmail, label: "Commit Author Email" }

  let :cop_instance do
    instance_spy Git::Cop::Styles::CommitAuthorEmail, class: cop_class,
                                                      commit: commit,
                                                      severity: :error,
                                                      invalid?: true,
                                                      warning?: false,
                                                      error?: true,
                                                      issue: issue
  end

  describe "#to_s" do
    context "with issues" do
      let(:collector) { Git::Cop::Collector.new }
      subject { described_class.new collector: collector }

      before do
        collector.add cop_instance
        collector.add cop_instance
      end

      it "answers detected issues" do
        expect(subject.to_s).to eq(
          "Running Git Cop...\n" \
          "\n" \
          "fa4a269f4fe9 (Test Tester, 1 second ago): A subject.\n" \
          "  ERROR: Commit Author Email. A test label. A test hint.\n" \
          "  ERROR: Commit Author Email. A test label. A test hint.\n" \
          "\n" \
          "1 commit inspected. 2 issues detected (0 warnings, 2 errors).\n"
        )
      end
    end

    context "without issues" do
      it "answers zero detected issues" do
        expect(subject.to_s).to eq(
          "Running Git Cop...\n" \
          "0 commits inspected. 0 issues detected.\n"
        )
      end
    end
  end
end
