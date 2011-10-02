require 'roo'
class OdsImporter
  def self.get_cameras(oo)
    cameras = {}
    oo.default_sheet = oo.sheets[1]
    2.upto(oo.last_row) do |line|
      name = oo.cell(line, 'A')
      top = oo.cell(line, 'B').to_i
      bottom = oo.cell(line, 'C').to_i
      left = oo.cell(line, 'D').to_i
      right = oo.cell(line, 'E').to_i
      cameras[name] = {
        :top => top,
	:bottom => bottom,
	:left => left,
	:right => right
      } unless name.nil?
    end
    cameras
  end

  def self.generate(file = "spec/example.ods")
    values = []
    oo = Openoffice.new(file)
    cameras = get_cameras(oo)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      source = oo.cell(line,'A')
      first_date = oo.cell(line,'B')
      start_frame = oo.cell(line,'D').to_i
      end_frame = oo.cell(line,'E').to_i
      camera = oo.cell(line,'F')
      alt_name = oo.cell(line,'G')
      entry = {
        :source => source, 
	:start => start_frame,
	:end => end_frame,
      }
      cam = cameras[camera]
      values << entry.merge(cam) unless cam.nil?
    end
    values
  end
end

