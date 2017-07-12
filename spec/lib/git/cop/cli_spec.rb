# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::CLI do
  let(:options) { [] }
  let(:command_line) { Array(command).concat options }
  let(:cli) { described_class.start command_line }

  shared_examples_for "a config command", :temp_dir do
    context "with no options" do
      it "prints help text" do
        result = -> { cli }
        expect(&result).to output(/Manage gem configuration./).to_stdout
      end
    end
  end

  shared_examples_for "a police command", :git_repo do
    context "with warnings" do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
          `printf "%s\n" "Test content." > one.txt`
          `git add --all .`
          `git commit --no-verify --message "Added test file."`
        end
      end

      it "prints program label" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            expect(&result).to output(/Running\sGit\sCop/).to_stdout
          end
        end
      end

      it "prints commit label" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            pattern = /[0-9a-f]{40}\s\(Testy\sTester\,\s\d\sseconds\sago\)\:\sAdded\stest\sfile/

            expect(&result).to output(pattern).to_stdout
          end
        end
      end

      it "prints warning" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            expect(&result).to output(/WARN\:\sCommit\sBody\sPresence.+/).to_stdout
          end
        end
      end

      it "prints stats" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            pattern = /1\scommit\sinspected\.\s.+1\sissue.+1\swarning.+0\serrors.+/

            expect(&result).to output(pattern).to_stdout
          end
        end
      end

      it "does not abort program" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            expect(&result).to_not raise_error
          end
        end
      end
    end

    context "with errors" do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
          `printf "%s\n" "Test content." > one.txt`
          `git add --all .`
          `git commit --no-verify --message "Made a test commit"`
        end
      end

      it "aborts program" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            expect(&result).to raise_error(SystemExit)
          end
        end
      end
    end

    context "with no commits" do
      it "prints zero issues for zero commits" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            text = "Running Git Cop...\n" \
                   "0 commits inspected. \e[32m0 issues\e[0m detected.\n"

            expect(&result).to output(text).to_stdout
          end
        end
      end

      it "does not abort program" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            expect(&result).to_not raise_error
          end
        end
      end
    end

    context "with no issues" do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
          `printf "%s\n" "Test content." > one.txt`
          `git add --all .`
          `git commit --no-verify --message "Added a test commit." --message "A test body."`
        end
      end

      it "prints zero issues for one commit" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            text = "Running Git Cop...\n" \
                   "1 commit inspected. \e[32m0 issues\e[0m detected.\n"

            expect(&result).to output(text).to_stdout
          end
        end
      end

      it "does not abort program" do
        ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
          Dir.chdir git_repo_dir do
            result = -> { cli }
            expect(&result).to_not raise_error
          end
        end
      end
    end

    it "prints error when gem error is rescued" do
      allow(Git::Cop::Reporters::Branch).to receive(:new).and_raise(
        Git::Cop::Errors::Base, "Test."
      )
      result = -> { cli }

      expect(&result).to output(/error\s+Test\./).to_stdout
    end
  end

  shared_examples_for "a version command" do
    it "prints version" do
      result = -> { cli }
      expect(&result).to output(/#{Git::Cop::Identity.version_label}\n/).to_stdout
    end
  end

  shared_examples_for "a help command" do
    it "prints usage" do
      result = -> { cli }
      expect(&result).to output(/#{Git::Cop::Identity.version_label}\scommands:\n/).to_stdout
    end
  end

  describe "--config" do
    let(:command) { "--config" }
    it_behaves_like "a config command"
  end

  describe "-c" do
    let(:command) { "-c" }
    it_behaves_like "a config command"
  end

  describe "--police" do
    let(:command) { "--police" }
    it_behaves_like "a police command"
  end

  describe "-p" do
    let(:command) { "-p" }
    it_behaves_like "a police command"
  end

  describe "--version" do
    let(:command) { "--version" }
    it_behaves_like "a version command"
  end

  describe "-v" do
    let(:command) { "-v" }
    it_behaves_like "a version command"
  end

  describe "--help" do
    let(:command) { "--help" }
    it_behaves_like "a help command"
  end

  describe "-h" do
    let(:command) { "-h" }
    it_behaves_like "a help command"
  end

  context "with no command" do
    let(:command) { nil }
    it_behaves_like "a help command"
  end
end
