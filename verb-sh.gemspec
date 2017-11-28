Gem::Specification.new do |s|
  s.name        = 'verb-sh'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime('%Y-%m-%e').to_s
  s.summary     = ''
  s.description = ''
  s.authors     = ['Sean Nieuwoudt']
  s.email       = 'hi@verb.sh'
  s.files       = `git ls-files -z`.split("\x0")
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/Craaft/verb-ruby'
  s.require_paths = ['lib']

  s.add_runtime_dependency 'minitest', '~> 5.7', '>= 5.7.0'
  s.add_runtime_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_runtime_dependency 'bundler', '~> 1.7'
  s.add_runtime_dependency 'rest-client', '~> 2.0.2'
end
