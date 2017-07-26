# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyBulletCapitalization do
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell), body_lines: body_lines
  end

  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_bullet_capitalization)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Bullet Capitalization")
    end
  end

  describe "#valid?" do
    context "with uppercase bullet" do
      let(:body_lines) { ["- Test bullet."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with no bullet lines" do
      let(:body_lines) { ["a test line."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with empty lines" do
      let(:body_lines) { [] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with lowercase bullet (no trailing space)" do
      let(:body_lines) { ["-test bullet."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with lowercase bullet" do
      let(:body_lines) { ["- test bullet."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with lowercase bullet (indented)" do
      let(:body_lines) { ["  - test bullet."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    let(:issue) { subject.issue }

    context "when valid" do
      let(:body_lines) { [] }

      it "answers empty hash" do
        expect(issue).to eq({})
      end
    end

    context "when invalid" do
      let(:body_lines) { ["Examples:", "- a bullet.", "- Another bullet."] }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid capitalization.")
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Capitalize first word.")
      end

      it "answers issue affected lines" do
        expect(issue[:lines]).to contain_exactly(number: 2, content: "- a bullet.")
      end
    end
  end
end
