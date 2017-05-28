# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyLeadingSpace do
  let(:content) { "Added documentation.\n\n- Necessary for testing purposes.\n" }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), raw_body: content }
  let(:settings) { {enabled: true} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_leading_space)
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with subject only" do
      let(:content) { "A commit message." }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with no space between subject and body" do
      let(:content) { "Subject\nBody\n" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with subject, space, and no body" do
      let(:content) { "Subject\n\n" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with no content" do
      let(:content) { "" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
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
      let(:content) { "A commit message." }

      it "answers error message" do
        message = "Missing leading space. Use space between subject and body."
        expect(subject.error).to eq(message)
      end
    end
  end
end
