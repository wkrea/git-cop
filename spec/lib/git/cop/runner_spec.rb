# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Runner, :temp_dir, :git_repo do
  let :defaults do
    {
      commit_body_leading_line: {enabled: true, severity: :error},
      commit_subject_length: {enabled: true, severity: :error, length: 50},
      commit_subject_prefix: {enabled: true, severity: :error, whitelist: %w[Fixed Added]},
      commit_subject_suffix: {enabled: true, severity: :error, whitelist: ["."]}
    }
  end

  let :configuration do
    Runcom::Configuration.new project_name: Git::Cop::Identity.name, defaults: defaults
  end

  let(:branch) { "test" }
  subject { described_class.new configuration: configuration.to_h }

  before do
    Dir.chdir git_repo_dir do
      `git checkout -b test`
      `printf "%s\n" "Test content." > one.txt`
      `git add --all .`
    end
  end

  describe "#run" do
    context "with valid commits" do
      it "reports no issues" do
        Dir.chdir git_repo_dir do
          `git commit --no-verify --message "Added one.txt." --message "- For testing purposes."`
          collector = subject.run

          expect(collector.issues?).to eq(false)
        end
      end
    end

    context "with invalid commits" do
      it "reports issues" do
        Dir.chdir git_repo_dir do
          `git commit --no-verify --message "Add one.txt." --message "- A test bullet."`
          collector = subject.run

          expect(collector.issues?).to eq(true)
        end
      end
    end

    context "with disabled cop" do
      let(:defaults) { {commit_subject_prefix: {enabled: false, whitelist: %w[Added]}} }

      it "reports no issues" do
        Dir.chdir git_repo_dir do
          `git commit --no-verify --message "Bogus commit message"`
          collector = subject.run

          expect(collector.issues?).to eq(false)
        end
      end
    end

    context "with invalid cop ID" do
      let(:defaults) { {invalid_cop_id: true} }

      it "fails with errors" do
        Dir.chdir git_repo_dir do
          `git commit --no-verify --message "Updated one.txt." --message "- A test bullet."`
          result = -> { subject.run }

          expect(&result).to raise_error(
            Git::Cop::Errors::Base,
            /Invalid\scop\:\sinvalid_cop_id.+/
          )
        end
      end
    end

    context "with single commit" do
      it "processes commit" do
        Dir.chdir git_repo_dir do
          `git commit --no-verify --message "Add one.txt"`
          commit = Git::Cop::Commits::Saved.new sha: `git log --pretty=format:%H -1`
          collector = subject.run commits: commit

          expect(collector.issues?).to eq(true)
        end
      end
    end
  end
end
