# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyLineLength do
  let(:body_lines) { ["Curabitur eleifend wisi iaculis ipsum."] }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), body_lines: body_lines }
  let(:length) { 72 }
  let(:settings) { {enabled: true, length: length} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_line_length)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Line Length")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when invalid (single line)" do
      let :body_lines do
        ["Pellentque morbi-trist sentus et netus et malesuada fames ac turpis egest."]
      end

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "when invalid (multiple lines)" do
      let :body_lines do
        [
          "- Curabitur eleifend wisi iaculis ipsum.",
          "- Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante.",
          "- Donec eu_libero sit amet quam egestas semper. Aenean ultricies mi vitae est."
        ]
      end

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

    context "when invalid (single line)" do
      let :body_lines do
        ["Pellentque morbi-trist sentus et netus et malesuada fames ac turpis egest."]
      end

      it "answers empty string" do
        expect(subject.error).to eq(
          "Invalid line length. Use 72 characters or less per line. Affected lines:\n" \
          "    Line 1: Pellentque morbi-trist sentus et netus et malesuada fames ac turpis egest.\n"
        )
      end
    end

    context "when invalid (multiple lines)" do
      let(:length) { 60 }
      let :body_lines do
        [
          "- Curabitur eleifend wisi iaculis ipsum.",
          "- Vestibulum tortor quam, feugiat vitae, ultricies eget bon apt.",
          "- Donec eu_libero sit amet quam egestas semper. Aenean ultricies."
        ]
      end

      it "answers empty string" do
        expect(subject.error).to eq(
          "Invalid line length. Use 60 characters or less per line. Affected lines:\n" \
          "    Line 2: - Vestibulum tortor quam, feugiat vitae, ultricies eget bon apt.\n" \
          "    Line 3: - Donec eu_libero sit amet quam egestas semper. Aenean ultricies.\n"
        )
      end
    end
  end
end
