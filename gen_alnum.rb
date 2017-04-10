require_relative './lib/password_generator'

puts PasswordGenerator.generate(PasswordGenerator.opts_for(:alnum, 12))
