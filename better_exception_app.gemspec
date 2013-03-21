Gem::Specification.new do |s|
  s.name = 'better_exception_app'
  s.version = '0.1.0'
  s.homepage = 'https://github.com/eric1234/better_exception_app'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'rails', '>= 3.2'
  s.add_development_dependency 'test_engine'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'debugger'
  s.files = Dir['**/*.rb'] + Dir['**/*.yml']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'Render HTTP errors in your layout.'
  s.description = <<-DESCRIPTION
    Tries to get rid of the static files and make it easy to render
    HTTP errors in your layout. Built on the exception_app functionality
    added in Rails 3.2.
  DESCRIPTION
end
