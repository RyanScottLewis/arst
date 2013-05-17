require 'cocaine'

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'shell' do
  
  watch(%r{examples/.*\.rb}) do |m|
    line = Cocaine::CommandLine.new('bundle', 'exec ruby :path')
    
    line.run( path: m[0] ) rescue nil
  end
  
end
