Gem::Specification.new do |s|
  s.name        = 'verb-rb'
  s.version     = '1.0.1'
  s.date        = Time.now.strftime('%Y-%m-%e').to_s
  s.summary     = 'A simple messaging API for web and mobile applications'
  s.description = 'Verb gives you a simple & consistent way to send messages from web and mobile applications using any backing services'
  s.authors     = ['Sean Nieuwoudt']
  s.email       = 'hi@verb.sh'
  s.files       = `git ls-files -z`.split("\x0")
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/apollo-black/verb-ruby'
  s.require_paths = ['lib']

  s.add_runtime_dependency 'minitest', '~> 5.7'
  s.add_runtime_dependency 'rake', '~> 10.4'
  s.add_runtime_dependency 'bundler', '~> 1.7'
  s.add_runtime_dependency 'rest-client', '~> 2.0'
end