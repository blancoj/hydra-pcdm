require 'spec_helper'

describe Hydra::PCDM::Object do

 subject { described_class.new }

  describe "#ancestor?" do
    let(:object1) { described_class.new }
    let(:object2) { described_class.new } 

    #let(:record) { instance_double(Hydra::PCDM::Object) }
    #let(:member) { record }
    #let(:result) { subject.ancestor?(member) }

    context "when the member is the record itself" do
      it "is true" do
        expect(subject.ancestor?(subject)).to eq true
      end
    end
    context "when the member is not an ancestor" do
      it "is false" do
        expect(subject.ancestor?(object2)).to eq false
      end
    end
    context "when the member is an ancestor" do
      it "is true" do
        object1.child_objects << subject

        expect(subject.ancestor?(object1)).to eq true
      end
    end
  end
end
