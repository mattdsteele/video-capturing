class AvsCreator
  def self.make(item)
source = <<EOL
AviSource("<%= item[:source] %>")
Trim(<%= item[:start] %>, <%= item[:end] %>, false)
ConvertToRGB32()
LoadVirtualDubPlugin("H:\\vdub\\plugins\\Smart.vdf", "SmartDeint", 1)
SmartDeint(0,3,8,100,0,0,0,0,1,2,1)
Crop(<%= item[:left] %>,<%= item[:top] %>,-<%= item[:right] %>,-<%= item[:bottom] %>)
LanczosResize(640,480)
ConvertToYV12()
EOL

ERB.new(source).result(binding)
  end
end

