# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitAuthorNameParts do
  subject(:cop) { described_class.new commit: commit, settings: settings }

  let(:name) { "Example Tester" }
  let(:status) { instance_double Process::Status, success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell), author_name: name
  end

  let(:minimum) { 2 }
  let(:settings) { {enabled: true, minimum: minimum} }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_author_name_parts)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Author Name Parts")
    end
  end

  describe ".defaults" do
    it "answers defaults" do
      expect(described_class.defaults).to eq(
        enabled: true,
        severity: :error,
        minimum: 2
      )
    end
  end

  describe "#valid?" do
    context "with valid name" do
      let(:name) { "Test Example" }

      it "answers true" do
        expect(cop.valid?).to eq(true)
      end
    end

    context "with custom minimum" do
      let(:name) { "Example" }
      let(:minimum) { 1 }

      it "answers true" do
        expect(cop.valid?).to eq(true)
      end
    end

    context "with invalid name" do
      let(:name) { "Invalid" }

      it "answers false" do
        expect(cop.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    let(:issue) { cop.issue }

    context "when valid" do
      it "answers empty hash" do
        expect(issue).to eq({})
      end
    end

    context "when invalid" do
      let(:name) { "Invalid" }

      it "answers issue hint" do
        hint = "Author name must consist of 2 parts (minimum)."
        expect(issue[:hint]).to eq(hint)
      end
    end
  end
end
