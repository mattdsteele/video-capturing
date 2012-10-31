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
  avs_file = "#{video_prefix}/avs/#{video[:source]}.avs"
  File.open(avs_file, 'w') {|f| f.write(AvsCreator.make(video, video_prefix)) }
  command = "#{ffmpeg} -i \"#{avs_file}\" -vcodec libx264 -crf 20 -acodec libmp3lame -ab 160k -threads 0 \"#{video_prefix}\\completed\\#{video[:source]}.mp4\""
  puts "executing: #{command}"
  `#{command}`
end
puts "done"
