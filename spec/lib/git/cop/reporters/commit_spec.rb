# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Commit do
  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "abcdef"), sha: "abcdef",
                                                               author_name: "Test Tester",
                                                               author_date_relative: "1 day ago",
                                                               subject: "A test subject."
  end

  let(:issue) { {label: "A test label.", hint: "A test hint."} }
  let(:cop_class) { class_spy Git::Cop::Styles::CommitAuthorEmail, label: "Commit Author Email" }

  let :cop_instance do
    instance_spy Git::Cop::Styles::CommitAuthorEmail,
                 class: cop_class,
                 severity: :warn,
                 invalid?: true,
                 issue: issue
  end

  describe "#to_s" do
    context "with single cop" do
      subject { described_class.new commit: commit, cops: [cop_instance] }

      it "answers commit (SHA, author name, relative time, subject) and single cop report" do
        expect(subject.to_s).to eq(
          "abcdef (Test Tester, 1 day ago): A test subject.\n" \
          "\e[33m  WARN: Commit Author Email. A test label. A test hint.\n\e[0m" \
          "\n"
        )
      end
    end

    context "with multiple cops" do
      subject { described_class.new commit: commit, cops: [cop_instance, cop_instance] }

      it "answers commit (SHA, author name, relative time, subject) and multiple cop report" do
        expect(subject.to_s).to eq(
          "abcdef (Test Tester, 1 day ago): A test subject.\n" \
          "\e[33m  WARN: Commit Author Email. A test label. A test hint.\n\e[0m" \
          "\e[33m  WARN: Commit Author Email. A test label. A test hint.\n\e[0m" \
          "\n"
        )
      end
    end
  end
end
