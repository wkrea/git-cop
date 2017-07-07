# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Collector, :git_repo do
  let(:sha) { Dir.chdir(git_repo_dir) { `git log --pretty=format:%H -1` } }
  let(:commit) { Dir.chdir(git_repo_dir) { Git::Cop::Kit::Commit.new sha: sha } }

  let :valid_cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 commit: commit,
                 invalid?: false,
                 warning?: false,
                 error?: false
  end

  let :warn_cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 commit: commit,
                 invalid?: true,
                 warning?: true,
                 error?: false
  end

  let :error_cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 commit: commit,
                 invalid?: true,
                 warning?: false,
                 error?: true
  end

  describe "#add" do
    it "adds cop" do
      subject.add valid_cop
      expect(subject.retrieve(commit)).to contain_exactly(valid_cop)
    end

    it "answers added cop" do
      expect(subject.add(valid_cop)).to eq(valid_cop)
    end
  end

  describe "#retrieve" do
    it "answers single cop for commit" do
      subject.add valid_cop
      expect(subject.retrieve(commit)).to contain_exactly(valid_cop)
    end

    it "answers multiple cops for commit" do
      subject.add valid_cop
      subject.add valid_cop

      expect(subject.retrieve(commit)).to contain_exactly(valid_cop, valid_cop)
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
      subject.add valid_cop
      expect(subject.empty?).to eq(false)
    end
  end

  describe "#warnings?" do
    it "answers true with invalid cops at warn severity" do
      subject.add valid_cop
      subject.add warn_cop
      subject.add error_cop

      expect(subject.warnings?).to eq(true)
    end

    it "answers false with no invalid cops at warn severity" do
      subject.add valid_cop
      subject.add error_cop

      expect(subject.warnings?).to eq(false)
    end
  end

  describe "#errors?" do
    it "answers true with invalid cops at error severity" do
      subject.add valid_cop
      subject.add warn_cop
      subject.add error_cop

      expect(subject.errors?).to eq(true)
    end

    it "answers false with no invalid cops at error severity" do
      subject.add valid_cop
      subject.add warn_cop

      expect(subject.errors?).to eq(false)
    end
  end

  describe "#issues?" do
    it "answers true with invalid cops" do
      subject.add valid_cop
      subject.add warn_cop
      subject.add error_cop

      expect(subject.issues?).to eq(true)
    end

    it "answers false with valid cops" do
      subject.add valid_cop
      expect(subject.issues?).to eq(false)
    end
  end

  describe "#total_warnings" do
    it "answers total warnings when invalid cops with warnings exist" do
      subject.add warn_cop
      expect(subject.total_warnings).to eq(1)
    end

    it "answers zero warnings when cops without warnings exist" do
      subject.add valid_cop
      subject.add error_cop

      expect(subject.total_warnings).to eq(0)
    end
  end

  describe "#total_errors" do
    it "answers total errors when invalid cops with errors exist" do
      subject.add error_cop
      expect(subject.total_errors).to eq(1)
    end

    it "answers zero errors when cops without errors exist" do
      subject.add valid_cop
      subject.add warn_cop

      expect(subject.total_errors).to eq(0)
    end
  end

  describe "#total_issues" do
    it "answers total issues when invalid cops exist" do
      subject.add valid_cop
      subject.add warn_cop
      subject.add error_cop

      expect(subject.total_issues).to eq(2)
    end

    it "answers zero issues when valid cops exist" do
      subject.add valid_cop
      expect(subject.total_issues).to eq(0)
    end

    it "answers zero issues when no cops exist" do
      expect(subject.total_issues).to eq(0)
    end
  end

  describe "#total_commits" do
    it "answers total commits" do
      subject.add valid_cop
      expect(subject.total_commits).to eq(1)
    end

    it "answers zero with no commits" do
      expect(subject.total_commits).to eq(0)
    end
  end

  describe "#to_h" do
    it "answers hash of commit and cops" do
      subject.add valid_cop
      expect(subject.to_h).to eq(commit => [valid_cop])
    end
  end
end
