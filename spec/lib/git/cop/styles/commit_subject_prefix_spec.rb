# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitSubjectPrefix do
  let(:content) { "Added test file." }
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
    context "with no issues" do
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

    context "with unsaved fixup commit" do
      let(:content) { "fixup! Added test file." }

      before do
        allow(commit).to receive(:is_a?).with(Git::Cop::Commits::Unsaved).and_return(true)
        allow(commit).to receive(:fixup?).and_return(true)
      end

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with unsaved squash commit" do
      let(:content) { "squash! Added test file." }

      before do
        allow(commit).to receive(:is_a?).with(Git::Cop::Commits::Unsaved).and_return(true)
        allow(commit).to receive(:fixup?).and_return(false)
        allow(commit).to receive(:squash?).and_return(true)
      end

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

    context "with saved fixup commit" do
      let(:content) { "fixup! Added test file." }
      before { allow(commit).to receive(:is_a?).with(Git::Cop::Commits::Unsaved).and_return(false) }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with saved squash commit" do
      let(:content) { "squash! Added test file." }
      before { allow(commit).to receive(:is_a?).with(Git::Cop::Commits::Unsaved).and_return(false) }

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
