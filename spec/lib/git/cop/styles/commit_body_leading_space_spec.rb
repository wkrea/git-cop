# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyLeadingSpace do
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell)
  end

  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_leading_space)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Leading Space")
    end
  end

  describe "#severity" do
    it "answers warn" do
      expect(subject.severity).to eq(:warn)
    end
  end

  describe "#valid?" do
    it "answers false" do
      expect(subject.valid?).to eq(false)
    end
  end

  describe "#issue" do
    let(:issue) { subject.issue }

    it "answers issue label" do
      expect(issue[:label]).to eq("Deprecated (will be removed in next major release).")
    end

    it "answers issue hint" do
      expect(issue[:hint]).to eq("Use Commit Body Leading Line instead.")
    end
  end
end
