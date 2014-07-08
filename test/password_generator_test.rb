require 'minitest/autorun'
require 'pry'
require_relative '../lib/password_generator'

class PasswordGeneratorTest < Minitest::Test
  def test_with_defaults
    generator = PasswordGenerator.new
    password = generator.generate

    assert_equal password.length, PasswordGenerator::DEFAULT_LENGTH

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & PasswordGenerator::LOWER_CASES, []
    refute_equal password.split("") & PasswordGenerator::UPPER_CASES, []
    refute_equal password.split("") & PasswordGenerator::SPECIAL_CHARS, []

    refute_equal password, generator.generate
  end

  def test_with_custom_length
    length = 5
    generator = PasswordGenerator.new(length: length)
    password = generator.generate

    assert_equal password.length, length

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & PasswordGenerator::LOWER_CASES, []
    refute_equal password.split("") & PasswordGenerator::UPPER_CASES, []
    refute_equal password.split("") & PasswordGenerator::SPECIAL_CHARS, []

    refute_equal password, generator.generate
  end

  def test_with_custom_pool
    char = 'c'
    generator = PasswordGenerator.new(pool: [char])
    password = generator.generate

    assert_equal password, char*PasswordGenerator::DEFAULT_LENGTH
  end

  def test_with_custom_and_default_pool_combination
    char = 'c'
    generator = PasswordGenerator.new(pool: [char], include_nums: true)
    password = generator.generate

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & [char], []
  end

  def test_number_of_pools_greater_than_password_length
    char = 'c'
    length = 4

    generator = PasswordGenerator.new(
      pool: [char],
      include_nums: true,
      include_lower_case: true,
      include_upper_case: true,
      include_special: true,
      length: length
    )

    password = generator.generate

    assert_equal password.length, length
    refute_equal password.split("") & [char], []
  end

  def test_exclude_characters
    generator = PasswordGenerator.new(pool: ['a', 'b'], exclude: ['b'])
    password = generator.generate

    assert_equal password, 'a'*PasswordGenerator::DEFAULT_LENGTH
  end

  def test_pool_too_restrictive
    assert_raises(ArgumentError) do
      PasswordGenerator.new(pool: [])
    end
  end

  def test_pool_too_restrictive_after_exclusion
    assert_raises(ArgumentError) do
      PasswordGenerator.new(pool: ['a'], exclude: ['a'])
    end
  end
end
