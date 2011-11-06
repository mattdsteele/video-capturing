require 'erb'

class AvsCreator
  def self.make(item, file_prefix = nil, deinterlace = :deinterlace)
    file_name = "#{file_prefix}\\#{item[:source]}" unless file_prefix.nil?
    source = <<EOL
AviSource("<%= file_name %>.avi")
Trim(<%= item[:start] %>, <%= item[:end] %>, false)
ConvertToRGB32()
<% if deinterlace == :deinterlace then %>
LoadVirtualDubPlugin("H:\\vdub\\plugins\\Smart.vdf", "SmartDeint", 1)
SmartDeint(0,3,8,100,0,0,0,0,1,2,1)
<% end %>
Crop(<%= item[:left] %>,<%= item[:top] %>,-<%= item[:right] %>,-<%= item[:bottom] %>)
LanczosResize(640,480)
ConvertToYV12()
EOL

    ERB.new(source).result(binding)
  end
end

