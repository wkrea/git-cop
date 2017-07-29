# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyLineLength do
  let(:body_lines) { ["Curabitur eleifend wisi iaculis ipsum."] }
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell), body_lines: body_lines
  end

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

  describe "#issue" do
    let(:issue) { subject.issue }

    context "when valid" do
      it "answers empty hash" do
        expect(issue).to eq({})
      end
    end

    context "when invalid" do
      let(:length) { 55 }
      let :body_lines do
        [
          "- Curabitur eleifend wisi iaculis ipsum.",
          "- Vestibulum tortor quam, feugiat vitae, ultricies eget bon.",
          "- Donec eu_libero sit amet quam egestas semper. Aenean ultr."
        ]
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Use #{length} characters or less per line.")
      end

      it "answers issue lines" do
        expect(issue[:lines]).to eq(
          [
            {number: 3, content: "- Vestibulum tortor quam, feugiat vitae, ultricies eget bon."},
            {number: 4, content: "- Donec eu_libero sit amet quam egestas semper. Aenean ultr."}
          ]
        )
      end
    end
  end
end
