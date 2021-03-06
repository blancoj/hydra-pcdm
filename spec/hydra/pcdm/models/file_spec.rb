require 'spec_helper'

describe Hydra::PCDM::File do

  let(:file) { Hydra::PCDM::File.new }
  let(:reloaded) { Hydra::PCDM::File.new(file.uri) }

  describe "when saving" do
    it "sets an RDF type" do
      file.content = 'stuff'
      expect(file.save).to be true
      expect(reloaded.metadata_node.query(predicate: RDF.type, object: RDFVocabularies::PCDMTerms.File).map(&:object)).to eq [RDFVocabularies::PCDMTerms.File]
    end
  end

  describe "#label" do
    it "saves a label" do
      file.content = 'stuff'
      file.label = 'foo'
      expect(file.label).to eq ['foo']
      expect(file.save).to be true
      expect(reloaded.label).to eq ['foo']
    end
  end

  describe "technical metadata" do
    let(:date_created) { Date.parse "Fri, 08 May 2015 08:00:00 -0400 (EDT)" }
    let(:date_modified) { Date.parse "Sat, 09 May 2015 09:00:00 -0400 (EDT)" }
    let(:content) { "hello world" }
    let(:file) { Hydra::PCDM::File.new.tap { |ds| ds.content = content } }
    it "saves technical metadata" do
      file.file_name = "picture.jpg"
      file.file_size = content.length.to_s
      file.date_created = date_created
      file.has_mime_type = "application/jpg"
      file.date_modified = date_modified
      file.byte_order = "little-endian"
      expect(file.save).to be true
      expect(reloaded.file_name).to eq ["picture.jpg"]
      expect(reloaded.file_size).to eq [content.length.to_s]
      expect(reloaded.has_mime_type).to eq ["application/jpg"]
      expect(reloaded.date_created).to eq [date_created]
      expect(reloaded.date_modified).to eq [date_modified]
      expect(reloaded.byte_order).to eq ["little-endian"]
    end

    it "does not save server managed properties" do
      # Currently we can't write this property because Fedora 
      # complains that it's a server managed property. This test 
      # is mostly to document this situation.
      file.file_hash = "the-hash"
      expect{file.save}.to raise_error(Ldp::BadRequest)
    end
  end

  describe "with a file that has no type" do
    subject { file.metadata_node.get_values(:type) }
    let(:pcdm_file)   { RDFVocabularies::PCDMTerms.File }
    let(:custom_type) { ::RDF::URI.new("http://example.com/MyType") }

    it "should add a type that already exists" do
      subject << pcdm_file
      expect(subject).to eq [pcdm_file]
    end

    it "should add a custom type" do
      subject << custom_type
      expect(subject).to include custom_type
    end
  end

end
