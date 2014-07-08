Gem::Specification.new do |spec|
  spec.name = "custom_password_generator"
  spec.version = "1.0.0"
  spec.files = ["lib/password_generator.rb"]
  spec.authors = ["Jan Renra Gloser"]
  spec.email = ["jan.renra.gloser@gmail.com"]
  spec.summary = 'Configurable strong-password generator'
  spec.homepage = "https://github.com/renra/password_generator_ruby"
  spec.license = "MIT"

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", '~> 0'
  spec.add_development_dependency "minitest", '~> 0'
end
