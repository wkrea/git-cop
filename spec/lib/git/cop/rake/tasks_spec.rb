# frozen_string_literal: true

require "spec_helper"
require "git/cop/rake/tasks"

RSpec.describe Git::Cop::Rake::Tasks do
  subject(:tasks) { described_class.new cli: cli }

  let(:cli) { class_spy Git::Cop::CLI }

  before { Rake::Task.clear }

  describe ".setup" do
    let(:tasks) { instance_spy described_class }

    before { allow(described_class).to receive(:new).and_return(tasks) }

    it "installs rake tasks" do
      described_class.setup
      expect(tasks).to have_received(:install)
    end
  end

  describe "#install" do
    before { tasks.install }

    it "executes --police option via git_cop task" do
      Rake::Task["git_cop"].invoke
      expect(cli).to have_received(:start).with(["--police"])
    end
  end
end
