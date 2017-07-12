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

  describe "#to_s" do
    context "with warnings" do
      let(:collector) { Git::Cop::Collector.new }

      let :cop_instance do
        instance_spy Git::Cop::Styles::CommitAuthorEmail, class: cop_class,
                                                          commit: commit,
                                                          severity: :warn,
                                                          invalid?: true,
                                                          warning?: true,
                                                          error?: false,
                                                          issue: issue
      end

      subject { described_class.new collector: collector }
      before { collector.add cop_instance }

      it "answers detected issues" do
        expect(subject.to_s).to eq(
          "Running Git Cop...\n" \
          "\n" \
          "fa4a269f4fe9 (Test Tester, 1 second ago): A subject.\n" \
          "\e[33m  WARN: Commit Author Email. A test label. A test hint.\n\e[0m" \
          "\n" \
          "1 commit inspected. \e[33m1 issue\e[0m detected " \
          "(\e[33m1 warning\e[0m, \e[32m0 errors\e[0m).\n"
        )
      end
    end

    context "with errors" do
      let(:collector) { Git::Cop::Collector.new }

      let :cop_instance do
        instance_spy Git::Cop::Styles::CommitAuthorEmail, class: cop_class,
                                                          commit: commit,
                                                          severity: :error,
                                                          invalid?: true,
                                                          warning?: false,
                                                          error?: true,
                                                          issue: issue
      end

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
          "\e[31m  ERROR: Commit Author Email. A test label. A test hint.\n\e[0m" \
          "\e[31m  ERROR: Commit Author Email. A test label. A test hint.\n\e[0m" \
          "\n" \
          "1 commit inspected. \e[31m2 issues\e[0m detected " \
          "(\e[32m0 warnings\e[0m, \e[31m2 errors\e[0m).\n"
        )
      end
    end

    context "without issues" do
      it "answers zero detected issues" do
        expect(subject.to_s).to eq(
          "Running Git Cop...\n" \
          "0 commits inspected. \e[32m0 issues\e[0m detected.\n"
        )
      end
    end
  end
end
