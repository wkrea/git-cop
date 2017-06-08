# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyBullet do
  let(:body_lines) { ["- Test message."] }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), body_lines: body_lines }
  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_bullet)
    end
  end

  describe "#valid?" do
    it "answers true when valid" do
      expect(subject.valid?).to eq(true)
    end

    context "without bullet" do
      let(:body) { "Test message." }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with empty lines" do
      let(:body_lines) { ["", " ", "\n"] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with blacklisted bullet" do
      let(:body_lines) { ["* Test message."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted bullet followed by multiple spaces" do
      let(:body_lines) { ["•   Test message."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted, indented bullet" do
      let(:body_lines) { ["  • Test message."] }

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
      let :body_lines do
        [
          "* Invalid bullet.",
          "- Valid bullet.",
          "• Invalid bullet."
        ]
      end

      it "answers error message" do
        expect(subject.error).to eq(
          "Invalid bullet. Avoid: \"*\", \"•\". Affected lines:\n" \
          "    Line 1: * Invalid bullet.\n" \
          "    Line 3: • Invalid bullet.\n"
        )
      end
    end
  end
end
