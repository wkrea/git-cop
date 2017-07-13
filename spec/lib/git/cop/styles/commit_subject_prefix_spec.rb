# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitSubjectPrefix do
  let(:content) { "Added test subject." }
  let(:commit) { object_double Git::Cop::Commits::Saved.new(sha: "1"), subject: content }
  let(:settings) { {enabled: true, whitelist: %w[Added Removed Fixed]} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_subject_prefix)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Subject Prefix")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with empty whitelist" do
      let(:whitelist) { [] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with invalid prefix" do
      let(:content) { "Bogus subject line." }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    context "when valid" do
      it "answers empty string" do
        expect(subject.issue).to eq({})
      end
    end

    context "when invalid" do
      let(:content) { "Bogus subject line." }
      let(:issue) { subject.issue }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid prefix.")
      end

      it "answres issue hint" do
        expect(issue[:hint]).to eq(%(Use: "Added", "Removed", "Fixed".))
      end
    end
  end
end
