# frozen_string_literal: true

RSpec.shared_examples_for "a fixup commit" do
  it "answers true when subject includes fixup! prefix" do
    allow(subject).to receive(:subject).and_return("fixup! Added test file.")
    expect(subject.fixup?).to eq(true)
  end

  it "answers false when subject excludes fixup! prefix" do
    allow(subject).to receive(:subject).and_return("Added test file.")
    expect(subject.fixup?).to eq(false)
  end
end
