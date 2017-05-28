# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitSubjectPrefix do
  let(:content) { "Added test subject." }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), subject: content }
  let(:settings) { {enabled: true, prefixes: %w[Added Removed Fixed]} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_subject_prefix)
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when invalid" do
      let(:content) { "Bogus subject line." }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with empty prefixes" do
      let(:prefixes) { [] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end
  end

  describe "#error" do
    context "when valid" do
      it "answers empty string" do
        expect(subject.error).to eq("")
      end
    end

    context "when invalid" do
      let(:content) { "Bogus subject line." }

      it "answers error message" do
        expect(subject.error).to eq(%(Invalid prefix. Use: "Added", "Removed", "Fixed".))
      end
    end
  end
end
