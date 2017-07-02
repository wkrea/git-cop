# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitSubjectSuffix do
  let(:content) { "Added test subject." }
  let(:commit) { object_double Git::Cop::Kit::Commit.new(sha: "1"), subject: content }
  let(:enabled) { true }
  let(:settings) { {enabled: enabled, whitelist: [".", "[✓]", "#skip"]} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_subject_suffix)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Subject Suffix")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with empty whitelist" do
      let(:suffixes) { [] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with invalid suffix" do
      let(:content) { "Added bad subject" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    context "when valid" do
      it "answers empty hash" do
        expect(subject.issue).to eq({})
      end
    end

    context "when invalid" do
      let(:content) { "Added bad subject" }
      let(:issue) { subject.issue }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid suffix.")
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq(%(Use: ".", "[✓]", "#skip".))
      end
    end
  end
end
