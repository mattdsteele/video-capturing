require 'roo'
class OdsImporter
  def self.generate(file = "spec/example.ods")
    values = []
    oo = Openoffice.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
    source = oo.cell(line,'A')
    first_date = oo.cell(line,'B')
    start_frame = oo.cell(line,'D').to_i
    end_frame = oo.cell(line,'E').to_i
    camera = oo.cell(line,'F')
    #frames = get_frames camera
    alt_name = oo.cell(line,'F')
    values << {
      :source => source, 
      :start => start_frame,
      :end => end_frame,
      :top => nil,
      :bottom=> nil,
      :left => nil,
      :right => nil
    } unless source.nil?
    end
    values
  end
end

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
  end
end
