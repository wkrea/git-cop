# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporter do
  let(:sha) { "23a857160cce81b0e8adb19cb78256fcd1901d2f" }
  let(:valid) { false }

  let :cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 sha: sha,
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
        expect(subject.retrieve(sha)).to contain_exactly(cop)
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
        expect(subject.retrieve(sha)).to contain_exactly(cop)
      end

      it "answers multiple cops for ID" do
        subject.add cop
        subject.add cop

        expect(subject.retrieve(sha)).to contain_exactly(cop, cop)
      end
    end

    context "when cop is valid" do
      let(:valid) { true }

      it "answers empty array for ID" do
        subject.add cop
        expect(subject.retrieve(sha)).to be_empty
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
      expect(subject.to_h).to eq(sha => [cop])
    end
  end

  describe "#to_s" do
    it "answers empty string with no issues" do
      expect(subject.to_s).to eq("")
    end

    it "answers summary with detected issues" do
      allow(cop).to receive(:error).and_return("This is an error.")
      subject.add cop

      expect(subject.to_s).to eq(
        "Commit #{sha}:\n" \
        "  commit_subject_prefix: This is an error.\n\n"
      )
    end
  end
end
