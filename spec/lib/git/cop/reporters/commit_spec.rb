# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Commit do
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "abcdef", shell: shell),
                  sha: "abcdef",
                  author_name: "Test Tester",
                  author_date_relative: "1 day ago",
                  subject: "A test subject."
  end

  let(:cop_class) { class_spy Git::Cop::Styles::CommitAuthorEmail, label: "Commit Author Email" }
  let(:issue) { {hint: "A test hint."} }

  let :cop_instance do
    instance_spy Git::Cop::Styles::CommitAuthorEmail,
                 class: cop_class,
                 severity: :warn,
                 invalid?: invalid,
                 issue: issue
  end

  describe "#to_s" do
    context "with invalid cop" do
      subject(:commit_reporter) { described_class.new commit: commit, cops: [cop_instance] }

      let(:invalid) { true }

      it "answers commit (SHA, author name, relative time, subject) and single cop report" do
        expect(commit_reporter.to_s).to eq(
          "abcdef (Test Tester, 1 day ago): A test subject.\n" \
          "\e[33m  Commit Author Email Warning. A test hint.\n\e[0m" \
          "\n"
        )
      end
    end

    context "with invalid cops" do
      subject :commit_reporter do
        described_class.new commit: commit, cops: [cop_instance, cop_instance]
      end

      let(:invalid) { true }

      it "answers commit (SHA, author name, relative time, subject) and multiple cop report" do
        expect(commit_reporter.to_s).to eq(
          "abcdef (Test Tester, 1 day ago): A test subject.\n" \
          "\e[33m  Commit Author Email Warning. A test hint.\n\e[0m" \
          "\e[33m  Commit Author Email Warning. A test hint.\n\e[0m" \
          "\n"
        )
      end
    end

    context "with valid cops" do
      subject(:commit_reporter) do
        described_class.new commit: commit, cops: [cop_instance, cop_instance]
      end

      let(:invalid) { false }

      it "empty string" do
        expect(commit_reporter.to_s).to eq("")
      end
    end
  end
end
