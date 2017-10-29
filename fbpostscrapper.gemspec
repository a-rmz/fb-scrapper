
app = File.expand_path("../app", __FILE__) 
$LOAD_PATH.unshift(app) unless $LOAD_PATH.include?(app)

Gem::Specification.new do |spec|
  spec.name          = "fbpostscrapper"
  spec.version       = "0.1.0"
  spec.authors       = ["Alejandro Ramirez"]
  spec.email         = ["armzprz@gmail.com"]

  spec.summary       = %q{Scrap posts, comments, and reactions on Facebook}
  spec.description   = %q{Scrap posts, comments, and reactions on Facebook}
  spec.homepage      = "http://a-rmz.io"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["app"]

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "koala",  "~> 3.0"
  spec.add_runtime_dependency "rethinkdb"
end
