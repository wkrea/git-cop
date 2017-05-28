# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporter do
  let(:id) { Git::Cop::Styles::CommitSubjectPrefix.id }
  let(:valid) { false }

  let :cop do
    instance_spy Git::Cop::Styles::CommitSubjectPrefix,
                 class: Git::Cop::Styles::CommitSubjectPrefix,
                 valid?: valid
  end

  describe "#add" do
    context "cop is valid" do
      let(:valid) { true }

      it "doesn't add cop" do
        subject.add cop
        expect(subject.cops).to be_empty
      end

      it "answers nil" do
        expect(subject.add(cop)).to eq(nil)
      end
    end

    context "when cop is invalid" do
      let(:valid) { false }

      it "adds cop" do
        subject.add cop
        expect(subject.retrieve(id)).to contain_exactly(cop)
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
        expect(subject.retrieve(id)).to contain_exactly(cop)
      end

      it "answers multiple cops for ID" do
        subject.add cop
        subject.add cop

        expect(subject.retrieve(id)).to contain_exactly(cop, cop)
      end
    end

    context "when cop is valid" do
      let(:valid) { true }

      it "answers empty array for ID" do
        subject.add cop
        expect(subject.retrieve(id)).to be_empty
      end
    end

    it "answers empty array for unknown key" do
      expect(subject.retrieve(:unknown)).to eq([])
    end
  end

  describe "#cops" do
    it "answers invalid cops" do
      subject.add cop
      expect(subject.cops).to contain_exactly(cop)
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
end
