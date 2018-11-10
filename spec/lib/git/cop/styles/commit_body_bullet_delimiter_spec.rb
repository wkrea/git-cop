# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyBulletDelimiter do
  subject { described_class.new commit: commit }

  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell), body_lines: body_lines
  end

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_bullet_delimiter)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Bullet Delimiter")
    end
  end

  describe ".defaults" do
    it "answers defaults" do
      expect(described_class.defaults).to eq(
        enabled: true,
        severity: :error,
        includes: %w[\\-]
      )
    end
  end

  describe "#valid?" do
    context "with space after bullet" do
      let(:body_lines) { ["- Test bullet."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with indented bullet and trailing space" do
      let(:body_lines) { ["  - test bullet."] }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "without space after bullet" do
      let(:body_lines) { ["-Test bullet."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with indented bullet without trailing space" do
      let(:body_lines) { ["  -test bullet."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
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
      let(:body_lines) { ["A normal line.", "- A valid bullet line.", "-An invalid bullet line."] }

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Use space after bullet.")
      end

      it "answers issue affected lines" do
        expect(issue[:lines]).to contain_exactly(number: 4, content: "-An invalid bullet line.")
      end
    end
  end
end
