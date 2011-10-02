require 'ods_importer'

describe "OdsImporter" do
  before :each do
    @imported_data = OdsImporter.generate("spec/example.ods")
  end
  it "creates an array of hashes" do
    @imported_data.should be_an Array
    @imported_data.each {|d| d.should be_a Hash }
  end

  it "can load an example ods file in the format i want" do
    @imported_data.should have(2).items
  end

  it "includes the keys i want" do
    @imported_data.each {|d| d.keys.should include(
    :source, :start, :end, :top, :bottom, :left, :right ) }
  end

  it "gets the values i want" do
    k = @imported_data[0]
    k[:source].should == "Test 1"
    k[:start].should == 61
    k[:end].should == 209045
    k[:top].should == 5
    k[:bottom].should == 3
    k[:left].should == 2
    k[:right].should == 4
  end
end
