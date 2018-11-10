# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::Abstract do
  subject { described_class.new commit: commit, settings: settings }

  let(:sha) { "123" }
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }
  let(:commit) { object_double Git::Cop::Commits::Saved.new(sha: sha, shell: shell), sha: sha }
  let(:enabled) { true }
  let(:settings) { {enabled: enabled} }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:abstract)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Abstract")
    end
  end

  describe ".defaults" do
    it "fails with NotImplementedError" do
      result = -> { described_class.defaults }
      expect(&result).to raise_error(NotImplementedError, /.+\.defaults.+/)
    end
  end

  describe ".descendants" do
    it "answers descendant classes" do
      expect(described_class.descendants).to contain_exactly(
        Git::Cop::Styles::CommitAuthorEmail,
        Git::Cop::Styles::CommitAuthorNameCapitalization,
        Git::Cop::Styles::CommitAuthorNameParts,
        Git::Cop::Styles::CommitBodyBulletCapitalization,
        Git::Cop::Styles::CommitBodyBulletDelimiter,
        Git::Cop::Styles::CommitBodyIssueTrackerLink,
        Git::Cop::Styles::CommitBodyBullet,
        Git::Cop::Styles::CommitBodyLeadingLine,
        Git::Cop::Styles::CommitBodyLineLength,
        Git::Cop::Styles::CommitBodyParagraphCapitalization,
        Git::Cop::Styles::CommitBodyPhrase,
        Git::Cop::Styles::CommitBodyPresence,
        Git::Cop::Styles::CommitBodySingleBullet,
        Git::Cop::Styles::CommitSubjectLength,
        Git::Cop::Styles::CommitSubjectPrefix,
        Git::Cop::Styles::CommitSubjectSuffix
      )
    end
  end

  describe ".build_issue_line" do
    it "answers isuse line" do
      expect(described_class.build_issue_line(1, "Test.")).to eq(number: 3, content: "Test.")
    end
  end

  describe "#enabled?" do
    context "when enabled" do
      let(:enabled) { true }

      it "answers true" do
        expect(subject.enabled?).to eq(true)
      end
    end

    context "when disabled" do
      let(:enabled) { false }

      it "answers false" do
        expect(subject.enabled?).to eq(false)
      end
    end
  end

  describe "#severity" do
    context "with severity" do
      let(:settings) { {severity: :error} }

      it "answers severity" do
        expect(subject.severity).to eq(:error)
      end
    end

    context "without severity" do
      let(:settings) { Hash.new }

      it "fails with key error" do
        result = -> { subject.severity }
        expect(&result).to raise_error(KeyError)
      end
    end

    context "with invalid severity" do
      let(:settings) { {severity: :bogus} }

      it "fails with invalid severity error" do
        result = -> { subject.severity }
        expect(&result).to raise_error(Git::Cop::Errors::Severity)
      end
    end
  end

  describe "#valid?" do
    it "fails with NotImplementedError" do
      result = -> { subject.valid? }
      expect(&result).to raise_error(NotImplementedError, /.+\#valid\?.+/)
    end
  end

  describe "#invalid?" do
    it "answers true when not valid" do
      allow(subject).to receive(:valid?).and_return(false)
      expect(subject.invalid?).to eq(true)
    end

    it "answers false when valid" do
      allow(subject).to receive(:valid?).and_return(true)
      expect(subject.invalid?).to eq(false)
    end

    it "fails with NotImplementedError when not implemented" do
      result = -> { subject.invalid? }
      expect(&result).to raise_error(NotImplementedError, /.+\#valid\?.+/)
    end
  end

  describe "#warning?" do
    let(:settings) { {enabled: enabled, severity: :warn} }

    it "answers true when invalid" do
      allow(subject).to receive(:valid?).and_return(false)
      expect(subject.warning?).to eq(true)
    end

    it "answers false when valid" do
      allow(subject).to receive(:valid?).and_return(true)
      expect(subject.warning?).to eq(false)
    end

    it "fails with NotImplementedError when not implemented" do
      result = -> { subject.warning? }
      expect(&result).to raise_error(NotImplementedError, /.+\#valid\?.+/)
    end
  end

  describe "#error?" do
    let(:settings) { {enabled: enabled, severity: :error} }

    it "answers true when invalid" do
      allow(subject).to receive(:valid?).and_return(false)
      expect(subject.error?).to eq(true)
    end

    it "answers false when valid" do
      allow(subject).to receive(:valid?).and_return(true)
      expect(subject.error?).to eq(false)
    end

    it "fails with NotImplementedError when not implemented" do
      result = -> { subject.error? }
      expect(&result).to raise_error(NotImplementedError, /.+\#valid\?.+/)
    end
  end

  describe "#issue" do
    it "fails with NotImplementedError" do
      result = -> { subject.issue }
      expect(&result).to raise_error(NotImplementedError, /.+\#issue.+/)
    end
  end
end
