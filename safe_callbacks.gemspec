require 'date'

Gem::Specification.new do |s|
  s.name        = 'safe_callbacks'
  s.version     = '0.0.2'
  s.date        = Date.today.to_s
  s.summary     = "Default active model callbacks to always return true"
  s.description = "Default active model callbacks to always return true"
  s.authors     = ["Scott Taylor"]
  s.email       = 'scott@railsnewbie.com'
  s.files       = Dir.glob("lib/**/**.rb")
  s.homepage    =
    'http://github.com/GoLearnup/safe_callbacks'
  s.license       = 'MIT'
end