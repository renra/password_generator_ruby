#! /home/renra/.rvm/rubies/ruby-2.1.1/bin/ruby

require_relative './lib/password_generator'

puts PasswordGenerator.generate(length: 12)
