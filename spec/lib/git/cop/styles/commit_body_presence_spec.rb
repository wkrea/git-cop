# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyPresence do
  let(:body_lines) { ["Curabitur eleifend wisi iaculis ipsum."] }
  let(:commit) { object_double Git::Cop::Commits::Saved.new(sha: "1"), body_lines: body_lines }
  let(:minimum) { 1 }
  let(:settings) { {enabled: true, minimum: minimum} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_presence)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Presence")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when valid (custom minimum)" do
      let(:minimum) { 3 }
      let(:body_lines) { ["First line.", "Second line", "", "Third line."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when invalid (empty)" do
      let(:body_lines) { [""] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "when invalid (custom minimum & not enough non-empty lines)" do
      let(:minimum) { 3 }
      let(:body_lines) { ["First line.", "\r", "", "\t", "Second one here."] }

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
      let(:minimum) { 3 }
      let(:body_lines) { ["First line.", "\r", " ", "\t", "Second one here."] }
      let(:issue) { subject.issue }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid body.")
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Use a minimum of 3 lines (not empty).")
      end
    end
  end
end
