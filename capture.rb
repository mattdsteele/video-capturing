require 'rubygems'
require 'roo'
require 'yaml'

def get_frames(camera_name)
 frames = {
  :cam2  => {:left=>7,:right=>9,:top=>0,:bottom=>0},
  :small => {:left=>5,:right=>8,:top=>3,:bottom=>3},
  :big   => {:left=>7,:right=>3,:top=>0,:bottom=>5},
 }
 camera = frames[camera_name.to_sym]
 camera
end

def get_video_defs
  oo =Openoffice.new('raw-videos.ods')
  oo.default_sheet = oo.sheets.first
  video_defs = []
  2.upto(33) do |line|
    name = oo.cell(line,'A')
    first_date = oo.cell(line,'B')
    start_frame = oo.cell(line,'D').to_i
    end_frame = oo.cell(line,'E').to_i
    camera = oo.cell(line,'F')
    frames = get_frames camera
    alt_name = oo.cell(line,'F')
    video_defs << { :name => name, :first_date => first_date, :start_frame => start_frame, :end_frame => end_frame, :frames=>frames, :camera => camera, :alt_name => alt_name}
  end
  video_defs
end

def create_avs(video_def)
  frames = video_def[:frames]
  avs_file = ''
  avs_file << "AviSource(\"h:\\capturing\\raw\\#{video_def[:name]}.avi\")\n"
  avs_file << "Trim(#{video_def[:start_frame]}, #{video_def[:end_frame]}, false)\n"
  avs_file << "ConvertToRGB32()\n"
  avs_file << 'LoadVirtualDubPlugin("H:\\Documents and Settings\\matt\\Desktop\\vdub\\plugins\\Smart.vdf", "SmartDeint", 1)' << "\n"
  avs_file << "Crop(#{frames[:left]},#{frames[:top]},-#{frames[:right]},-#{frames[:bottom]})\n"
  avs_file << "SmartDeint(0,3,8,100,0,0,0,0,1,2,1)\n"
  avs_file << "LanczosResize(640,480)\n"
  avs_file << "ConvertToYV12()\n"
  f = File.new("scripts/#{video_def[:name]}.avs", "w+")
  f.puts avs_file
  f.close
end

#cleanup scripts
`del scripts/*`

get_video_defs.each do |video|
  create_avs video
end

puts "hi"

