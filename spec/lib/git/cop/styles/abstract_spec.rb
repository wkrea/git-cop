# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::Abstract do
  let(:sha) { "123" }
  let(:commit) { object_double Git::Cop::Kit::Commit.new(sha: sha), sha: sha }
  let(:enabled) { true }
  let(:settings) { {enabled: enabled} }
  subject { described_class.new commit: commit, settings: settings }

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
        Git::Cop::Styles::CommitBodyBullet,
        Git::Cop::Styles::CommitBodyLeadingSpace,
        Git::Cop::Styles::CommitBodyLineLength,
        Git::Cop::Styles::CommitBodyPhrase,
        Git::Cop::Styles::CommitBodyPresent,
        Git::Cop::Styles::CommitSubjectLength,
        Git::Cop::Styles::CommitSubjectPrefix,
        Git::Cop::Styles::CommitSubjectSuffix
      )
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

  describe "#error" do
    it "fails with NotImplementedError" do
      result = -> { subject.error }
      expect(&result).to raise_error(NotImplementedError, /.+\#error.+/)
    end
  end
end
