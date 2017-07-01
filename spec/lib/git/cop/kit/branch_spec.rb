# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Kit::Branch, :git_repo do
  let(:branch) { "test" }
  subject { described_class.new }

  before do
    Dir.chdir git_repo_dir do
      `git checkout -b #{branch}`
      `printf "%s\n" "Test content." > test.txt`
      `git add --all .`
      `git commit --message "Updated test file."`
    end
  end

  describe "#name" do
    context "with default path" do
      it "answers local branch name" do
        Dir.chdir git_repo_dir do
          expect(subject.name).to eq(branch)
        end
      end
    end

    context "with custom path" do
      it "answers remote branch name" do
        ClimateControl.modify CI: "true" do
          Dir.chdir git_repo_dir do
            expect(subject.name).to eq("origin/test")
          end
        end
      end
    end
  end

  describe "#shas" do
    context "with default path" do
      it "answers feature branch commit SHAs" do
        Dir.chdir git_repo_dir do
          expect(subject.shas.count).to eq(1)
        end
      end
    end

    context "with custom path" do
      it "answers feature branch commit SHAs" do
        ClimateControl.modify CI: "true" do
          Dir.chdir git_repo_dir do
            expect(subject.shas.count).to eq(0) # Zero because dummy repo has invalid origin.
          end
        end
      end
    end
  end
end
