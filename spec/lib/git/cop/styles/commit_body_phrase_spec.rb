# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyPhrase do
  let(:body_lines) { ["This is an example of a commit message body."] }
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell), body_lines: body_lines
  end

  let(:blacklist) { ["obviously", "of course"] }
  let(:settings) { {enabled: true, blacklist: blacklist} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_phrase)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Phrase")
    end
  end

  describe "#valid?" do
    it "answers true when valid" do
      expect(subject.valid?).to eq(true)
    end

    context "with blacklisted word (mixed case)" do
      let(:blacklist) { ["BasicaLLy"] }
      let(:body_lines) { ["This will fail, basically."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted phrase (mixed case)" do
      let(:blacklist) { ["OF CoursE"] }
      let(:body_lines) { ["This will fail, of course."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted phrase (regular expression)" do
      let(:blacklist) { ["(o|O)f (c|C)ourse"] }
      let(:body_lines) { ["This will fail, of course."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted word in body" do
      let(:body_lines) { ["This will fail, obviously."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted word in body (mixed case)" do
      let(:body_lines) { ["This will fail, Obviously."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted phrase in body" do
      let(:body_lines) { ["This will fail, of course."] }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with blacklisted phrase in body (mixed case)" do
      let(:body_lines) { ["This will fail, Of Course."] }

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
      let :body_lines do
        [
          "Obviously, this can't work.",
          "...and, of course, this won't work either."
        ]
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Avoid: /obviously/, /of course/.")
      end

      it "answers issue lines" do
        expect(issue[:lines]).to eq(
          [
            {number: 2, content: "Obviously, this can't work."},
            {number: 3, content: "...and, of course, this won't work either."}
          ]
        )
      end
    end
  end
end
