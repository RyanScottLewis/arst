require 'pathname'

Gem::Specification.new do |s|
  
  # Variables
  s.author      = 'Ryan Scott Lewis'
  s.email       = 'ryan@rynet.us'
  s.summary     = 'Abstract Ruby Syntax Tree (ARST) is a high-level language syntax denoting the object domain of a Ruby project.'
  s.license     = 'MIT'
  
  # Dependencies
  s.add_dependency 'active_support', '~> 3.0.0'
  s.add_dependency 'parslet',        '~> 1.5.0'
  s.add_dependency 'rake',           '~> 10.0.0'
  s.add_dependency 'version',        '~> 1.0.0'
  # s.add_dependency 'polyglot',       '~> 0.3.0'
  s.add_development_dependency 'awesome_print', '~> 1.1.0'
  s.add_development_dependency 'cocaine',       '~> 0.5.0'
  s.add_development_dependency 'guard-bundler', '~> 1.0.0'
  s.add_development_dependency 'guard-shell',   '~> 0.5.0'
  s.add_development_dependency 'rb-fsevent',    '~> 0.9.0'
  
  # Pragmatically set variables
  s.homepage      = "http://github.com/RyanScottLewis/#{s.name}"
  s.version       = Pathname.glob('VERSION*').first.read rescue '0.0.0'
  s.description   = s.summary
  s.name          = Pathname.new(__FILE__).basename('.gemspec').to_s
  s.require_paths = ['lib']
  s.files         = Dir['{{Rake,Gem}file{.lock,},README*,VERSION,LICENSE,*.gemspec,{lib,bin,examples,spec,test}/**/*']
  s.test_files    = Dir['{examples,spec,test}/**/*']
  
end
