require 'bundler'
require './lib/password_generator'

task :gen do
  puts PasswordGenerator.generate(length: 12)
end

task :gen_alnum do
  puts PasswordGenerator.generate(PasswordGenerator.opts_for(:alnum))
end
