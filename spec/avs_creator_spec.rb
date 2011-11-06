require 'erb'
require 'avs_creator'

item = {:source => "hello", :start => 24, :end => 42, :top => 10, :bottom => 2, :left => 5, :right => 7 }
result = AvsCreator.make(item, "C:\\test")

describe "SynthScripter" do
  it "can make an output file" do
    result.should_not be_empty
  end

  it "contains the source I want" do
    result.should include 'AviSource("C:\\test\\hello.avi")'
  end

  it "has the right start and end" do
    result.should include "Trim(24, 42, false)"
  end

  it "converts to rgb and back to yv12" do
    result.should include "ConvertToRGB32()"
    result.should include "ConvertToYV12()"
  end

  it "crops appropriately" do
    result.should include "Crop(5,10,-7,-2)"
  end

  it "does a deinterlace" do
    result.should include "SmartDeint"
  end

  it "resizes to 640x480" do
    result.should include "LanczosResize(640,480)"
  end

  it "should deinterlace before cropping" do
    result.index("SmartDeint(").should be < result.index("Crop")
  end

  it "should not deinterlace if the right flag is set" do
  result = AvsCreator.make(item, "C:\\test", :no_deinterlace)
  result.should_not include "SmartDeint"
  end
end
