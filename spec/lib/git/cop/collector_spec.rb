# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Collector, :git_repo do
  let(:sha) { Dir.chdir(git_repo_dir) { `git log --pretty=format:%H -1` } }
  let(:commit) { Dir.chdir(git_repo_dir) { Git::Cop::Kit::Commit.new sha: sha } }
  let(:valid) { false }

  let :cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 commit: commit,
                 valid?: valid
  end

  describe "#add" do
    context "cop is valid" do
      let(:valid) { true }

      it "doesn't add cop" do
        subject.add cop
        expect(subject.to_h).to be_empty
      end

      it "answers nil" do
        expect(subject.add(cop)).to eq(nil)
      end
    end

    context "when cop is invalid" do
      let(:valid) { false }

      it "adds cop" do
        subject.add cop
        expect(subject.retrieve(commit)).to contain_exactly(cop)
      end

      it "answers added cop" do
        expect(subject.add(cop)).to eq(cop)
      end
    end
  end

  describe "#retrieve" do
    context "when cop is invalid" do
      let(:valid) { false }

      it "answers single cop for ID" do
        subject.add cop
        expect(subject.retrieve(commit)).to contain_exactly(cop)
      end

      it "answers multiple cops for ID" do
        subject.add cop
        subject.add cop

        expect(subject.retrieve(commit)).to contain_exactly(cop, cop)
      end
    end

    context "when cop is valid" do
      let(:valid) { true }

      it "answers empty array for ID" do
        subject.add cop
        expect(subject.retrieve(commit)).to be_empty
      end
    end

    it "answers empty array for unknown key" do
      expect(subject.retrieve(:unknown)).to eq([])
    end
  end

  describe "#empty?" do
    it "answers true with valid cops" do
      expect(subject.empty?).to eq(true)
    end

    it "answers false with invalid cops" do
      subject.add cop
      expect(subject.empty?).to eq(false)
    end
  end

  describe "#total" do
    it "answers zero with no detected issues" do
      expect(subject.total).to eq(0)
    end

    it "answers count of detected issues" do
      subject.add cop
      subject.add cop

      expect(subject.total).to eq(2)
    end
  end

  describe "#to_h" do
    it "answers hash of invalid cops" do
      subject.add cop
      expect(subject.to_h).to eq(commit => [cop])
    end
  end
end
