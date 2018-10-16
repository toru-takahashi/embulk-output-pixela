
Gem::Specification.new do |spec|
  spec.name          = "embulk-output-pixela"
  spec.version       = "0.0.1"
  spec.authors       = ["Toru Takahashi"]
  spec.summary       = "Pixela output plugin for Embulk"
  spec.description   = "Dumps records to Pixela."
  spec.email         = ["torutakahashi.ayashi@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.homepage      = "https://github.com/toru-takahashi/embulk-output-pixela"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'embulk', ['>= 0.9.8']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_dependency 'pixela', ['>=0.1.0']
end
