# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyParagraphCapitalization do
  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1"), body_paragraphs: body_paragraphs
  end

  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_paragraph_capitalization)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Paragraph Capitalization")
    end
  end

  describe "#valid?" do
    context "with uppercase paragraph" do
      let(:body_paragraphs) { ["A test paragraph."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with empty paragraphs" do
      let(:body_paragraphs) { [] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with lowercase paragraph" do
      let(:body_paragraphs) { ["a test paragraph."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    let(:issue) { subject.issue }

    context "when valid" do
      let(:body_paragraphs) { [] }

      it "answers empty hash" do
        expect(issue).to eq({})
      end
    end

    context "when invalid" do
      let(:body_paragraphs) { ["an invalid paragraph.\nwhich has\nmultiple lines."] }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid capitalization.")
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Capitalize first word.")
      end

      it "answers issue affected lines" do
        expect(issue[:lines]).to contain_exactly(
          number: 1, content: "an invalid paragraph.\nwhich has\nmultiple lines."
        )
      end
    end
  end
end
