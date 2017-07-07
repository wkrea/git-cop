# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Collector, :git_repo do
  let(:sha) { Dir.chdir(git_repo_dir) { `git log --pretty=format:%H -1` } }
  let(:commit) { Dir.chdir(git_repo_dir) { Git::Cop::Kit::Commit.new sha: sha } }

  let :cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 commit: commit,
                 valid?: false
  end

  describe "#add" do
    it "adds cop" do
      subject.add cop
      expect(subject.retrieve(commit)).to contain_exactly(cop)
    end

    it "answers added cop" do
      expect(subject.add(cop)).to eq(cop)
    end
  end

  describe "#retrieve" do
    it "answers single cop for commit" do
      subject.add cop
      expect(subject.retrieve(commit)).to contain_exactly(cop)
    end

    it "answers multiple cops for commit" do
      subject.add cop
      subject.add cop

      expect(subject.retrieve(commit)).to contain_exactly(cop, cop)
    end

    it "answers empty array for unknown commit" do
      unknown = Git::Cop::Kit::Commit.new sha: "abc"
      expect(subject.retrieve(unknown)).to eq([])
    end
  end

  describe "#empty?" do
    it "answers true without data" do
      expect(subject.empty?).to eq(true)
    end

    it "answers false with data" do
      subject.add cop
      expect(subject.empty?).to eq(false)
    end
  end

  describe "#to_h" do
    it "answers hash of commit and cops" do
      subject.add cop
      expect(subject.to_h).to eq(commit => [cop])
    end
  end
end
