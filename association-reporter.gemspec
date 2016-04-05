Gem::Specification.new do |spec|
  spec.name        = 'association-reporter'
  spec.version     = '0.0.1'
  spec.date        = '2016-04-01'
  spec.summary     = "Tell me about your has_many"
  spec.description = "Detailed reports for Active Record Associations"
  spec.authors     = ["Matt Baker"]
  spec.email       = 'mbaker.pdx@gmail.com'
  spec.files       = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^spec|repl})
  end
  spec.homepage    = 'https://github.com/mattbaker/association-reporter'
  spec.license     = 'MIT'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~>10.5'
  spec.add_development_dependency 'rspec', '~>3.4'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord','~>4.2'
  spec.add_runtime_dependency 'colorize', '~> 0.7'
end
