# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Branches::Environments::CircleCI do
  subject(:circle_ci) { described_class.new shell: shell }

  let(:shell) { class_spy Open3 }

  describe "#name" do
    it "answers Git branch name" do
      command = "git rev-parse --abbrev-ref HEAD | tr -d '\n'"
      allow(shell).to receive(:capture2e).with(command).and_return(["test", true])

      expect(circle_ci.name).to eq("origin/test")
    end
  end

  describe "#shas" do
    it "answers Git commit SHAs" do
      shas_command = %(git log --pretty=format:"%H" origin/master..origin/test)
      name_command = "git rev-parse --abbrev-ref HEAD | tr -d '\n'"
      allow(shell).to receive(:capture2e).with(name_command).and_return("test")
      allow(shell).to receive(:capture2e).with(shas_command).and_return(["abc\ndef", true])

      expect(circle_ci.shas).to contain_exactly("abc", "def")
    end
  end
end
