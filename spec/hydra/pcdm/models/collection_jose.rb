require 'spec_helper'

describe Hydra::PCDM::Collection do
  let(:collection1) { described_class.new }
  let(:collection2) { described_class.new }
  let(:collection3) { described_class.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }


  describe 'adding collections that are ancestors' do
    subject { described_class.new }
    let(:error_type)    { ArgumentError }
    let(:error_message) { 'Hydra::PCDM::Collection with ID:  failed to pass AncestorChecker validation' }

    context 'when the source collection is the same' do
      it 'raises an error' do
        expect { subject.child_collections << subject }.to raise_error(error_type, error_message)
      end
    end
    
    before do
      subject.child_collections << collection1
    end
    
    it 'raises and error' do
      expect { collection1.child_collections << subject }.to raise_error(error_type, error_message)
    end

    context 'with more ancestors' do
      before do
        collection1.child_collections << collection2
      end

      it 'raises an error' do
        expect { collection2.child_collections << subject }.to raise_error(error_type, error_message)
      end

      context 'with a more complicated example' do
        before do
          collection2.child_collections << collection3
        end

        it 'raises errors' do
          expect { collection3.child_collections << subject }.to raise_error(error_type, error_message)
          expect { collection3.child_collections << collection1 }.to raise_error(error_type, error_message)
        end
      end
    end
  end
end

