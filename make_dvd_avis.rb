#!/bin/ruby

require 'rubygems'
require 'lib/avs_creator'
require 'lib/ods_importer'

ffmpeg = "/cygdrive/h/ffmpeg-git-cbf914c-win32-static/bin/ffmpeg.exe"
video_path = "/cygdrive/i/capturing"
ods_path="/cygdrive/h/video-capturing/data/raw-videos.ods"
video_prefix="I:\\capturing"

videos = OdsImporter.generate(ods_path)
videos.each do |video|
  raise "boom #{video_path}/#{video[:source]}.avi" unless File.exists?("#{video_path}/#{video[:source]}.avi")
  avs_file = "#{video_prefix}/avs-dvd/#{video[:source]}.avs"
  File.open(avs_file, 'w') {|f| f.write(AvsCreator.make(video, video_prefix, :no_deinterlace)) }
end
puts "done"
