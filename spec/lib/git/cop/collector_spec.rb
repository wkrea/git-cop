# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Collector, :git_repo do
  subject(:collector) { described_class.new }

  let(:sha) { Dir.chdir(git_repo_dir) { `git log --pretty=format:%H -1` } }
  let(:commit) { Dir.chdir(git_repo_dir) { Git::Cop::Commits::Saved.new sha: sha } }

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
      collector.add valid_cop
      expect(collector.retrieve(commit)).to contain_exactly(valid_cop)
    end

    it "answers added cop" do
      expect(collector.add(valid_cop)).to eq(valid_cop)
    end
  end

  describe "#retrieve" do
    it "answers single cop for commit" do
      collector.add valid_cop
      expect(collector.retrieve(commit)).to contain_exactly(valid_cop)
    end

    it "answers multiple cops for commit" do
      collector.add valid_cop
      collector.add valid_cop

      expect(collector.retrieve(commit)).to contain_exactly(valid_cop, valid_cop)
    end
  end

  describe "#empty?" do
    it "answers true without data" do
      expect(collector.empty?).to eq(true)
    end

    it "answers false with data" do
      collector.add valid_cop
      expect(collector.empty?).to eq(false)
    end
  end

  describe "#warnings?" do
    it "answers true with invalid cops at warn severity" do
      collector.add valid_cop
      collector.add warn_cop
      collector.add error_cop

      expect(collector.warnings?).to eq(true)
    end

    it "answers false with no invalid cops at warn severity" do
      collector.add valid_cop
      collector.add error_cop

      expect(collector.warnings?).to eq(false)
    end
  end

  describe "#errors?" do
    it "answers true with invalid cops at error severity" do
      collector.add valid_cop
      collector.add warn_cop
      collector.add error_cop

      expect(collector.errors?).to eq(true)
    end

    it "answers false with no invalid cops at error severity" do
      collector.add valid_cop
      collector.add warn_cop

      expect(collector.errors?).to eq(false)
    end
  end

  describe "#issues?" do
    it "answers true with invalid cops" do
      collector.add valid_cop
      collector.add warn_cop
      collector.add error_cop

      expect(collector.issues?).to eq(true)
    end

    it "answers false with valid cops" do
      collector.add valid_cop
      expect(collector.issues?).to eq(false)
    end
  end

  describe "#total_warnings" do
    it "answers total warnings when invalid cops with warnings exist" do
      collector.add warn_cop
      expect(collector.total_warnings).to eq(1)
    end

    it "answers zero warnings when cops without warnings exist" do
      collector.add valid_cop
      collector.add error_cop

      expect(collector.total_warnings).to eq(0)
    end
  end

  describe "#total_errors" do
    it "answers total errors when invalid cops with errors exist" do
      collector.add error_cop
      expect(collector.total_errors).to eq(1)
    end

    it "answers zero errors when cops without errors exist" do
      collector.add valid_cop
      collector.add warn_cop

      expect(collector.total_errors).to eq(0)
    end
  end

  describe "#total_issues" do
    it "answers total issues when invalid cops exist" do
      collector.add valid_cop
      collector.add warn_cop
      collector.add error_cop

      expect(collector.total_issues).to eq(2)
    end

    it "answers zero issues when valid cops exist" do
      collector.add valid_cop
      expect(collector.total_issues).to eq(0)
    end

    it "answers zero issues when no cops exist" do
      expect(collector.total_issues).to eq(0)
    end
  end

  describe "#total_commits" do
    it "answers total commits" do
      collector.add valid_cop
      expect(collector.total_commits).to eq(1)
    end

    it "answers zero with no commits" do
      expect(collector.total_commits).to eq(0)
    end
  end

  describe "#to_h" do
    it "answers hash of commit and cops" do
      collector.add valid_cop
      expect(collector.to_h).to eq(commit => [valid_cop])
    end
  end
end
