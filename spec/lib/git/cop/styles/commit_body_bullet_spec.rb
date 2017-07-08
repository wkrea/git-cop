# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyBullet do
  let(:body_lines) { ["- Test message."] }
  let(:commit) { object_double Git::Cop::Kit::Commit.new(sha: "1"), body_lines: body_lines }
  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_bullet)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Bullet")
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

  describe "#issue" do
    context "when valid" do
      it "answers empty hash" do
        expect(subject.issue).to eq({})
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
      let(:issue) { subject.issue }

      it "answers issue label" do
        expect(subject.issue[:label]).to eq("Invalid bullet.")
      end

      it "answers issue hint" do
        expect(subject.issue[:hint]).to eq(%(Avoid: "\\*", "•".))
      end

      it "answers issue lines" do
        expect(subject.issue[:lines]).to eq(
          [
            {number: 1, content: "* Invalid bullet."},
            {number: 3, content: "• Invalid bullet."}
          ]
        )
      end
    end
  end
end
