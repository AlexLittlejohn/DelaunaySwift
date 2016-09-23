Pod::Spec.new do |spec|
  spec.name               = "DelaunaySwift"
  spec.version            = "0.1.0"
  spec.summary            = "A utility for doing Delaunay triangulations on a set of vertexes."
  spec.source             = { :git => "https://github.com/AlexLittlejohn/DelaunaySwift.git", :tag => spec.version.to_s }
  spec.requires_arc       = true
  spec.platform           = :ios, "10.0"
  spec.license            = "MIT"
  spec.source_files       = "DelaunayTriangulationSwift/**/*.{swift}"
  spec.homepage           = "https://github.com/AlexLittlejohn/DelaunaySwift"
  spec.author             = { "Alex Littlejohn" => "alexlittlejohn@me.com" }
end
