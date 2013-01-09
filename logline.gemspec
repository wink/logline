
# -*- encoding: utf-8 -*-
$:.push('lib')
require "logline/version"

Gem::Specification.new do |s|
  s.name     = "logline"
  s.version  = Logline::VERSION.dup
  s.date     = "2012-12-27"
  s.summary  = "A Ruby library for reading the Final Draft FDX file format"
  s.email    = "winkelspecht@gmail.com"
  s.homepage = "http://github.com/wink/logline"
  s.authors  = ['Ben Sandofsky']
  
  s.description = <<-EOF
A Ruby library for reading the Final Draft FDX file format
EOF
  
  dependencies = [
    # Examples:
    [:runtime,     "nokogiri"],
    [:development, "rspec"],
  ]
  
  s.files         = Dir['**/*']
  s.test_files    = Dir['test/**/*'] + Dir['spec/**/*']
  s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "1.8.24"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version
  
  dependencies.each do |type, name, version|
    if s.respond_to?("add_#{type}_dependency")
      s.send("add_#{type}_dependency", name, version)
    else
      s.add_dependency(name, version)
    end
  end
end
