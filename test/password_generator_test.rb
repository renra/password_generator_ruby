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

    # Not necessarily true
    #refute_equal password.split("") & [char], []
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

  def test_class_with_defaults
    password = PasswordGenerator.generate

    assert_equal password.length, PasswordGenerator::DEFAULT_LENGTH

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & PasswordGenerator::LOWER_CASES, []
    refute_equal password.split("") & PasswordGenerator::UPPER_CASES, []
    refute_equal password.split("") & PasswordGenerator::SPECIAL_CHARS, []

    refute_equal password, PasswordGenerator.generate
  end

  def test_class_with_custom_length
    length = 5
    password = PasswordGenerator.generate(length: length)

    assert_equal password.length, length

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & PasswordGenerator::LOWER_CASES, []
    refute_equal password.split("") & PasswordGenerator::UPPER_CASES, []
    refute_equal password.split("") & PasswordGenerator::SPECIAL_CHARS, []

    refute_equal password, PasswordGenerator.generate
  end

  def test_class_with_custom_pool
    char = 'c'
    password = PasswordGenerator.generate(pool: [char])

    assert_equal password, char*PasswordGenerator::DEFAULT_LENGTH
  end

  def test_class_with_custom_and_default_pool_combination
    char = 'c'
    password = PasswordGenerator.generate(pool: [char], include_nums: true)

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & [char], []
  end

  def test_class_number_of_pools_greater_than_password_length
    char = 'c'
    length = 4

    password = PasswordGenerator.generate(
      pool: [char],
      include_nums: true,
      include_lower_case: true,
      include_upper_case: true,
      include_special: true,
      length: length
    )

    assert_equal password.length, length

    # Not necessarily true
    #refute_equal password.split("") & [char], []
  end

  def test_class_exclude_characters
    password = PasswordGenerator.generate(pool: ['a', 'b'], exclude: ['b'])

    assert_equal password, 'a'*PasswordGenerator::DEFAULT_LENGTH
  end

  def test_class_pool_too_restrictive
    assert_raises(ArgumentError) do
      PasswordGenerator.generate(pool: [])
    end
  end

  def test_class_pool_too_restrictive_after_exclusion
    assert_raises(ArgumentError) do
      PasswordGenerator.generate(pool: ['a'], exclude: ['a'])
    end
  end

  def test_composite_password
    pool = ('a'..'d').to_a

    password = PasswordGenerator.generate(
      {
        length: 2,
        pool: pool
      },
      {
        length: 6
      }
    )


    assert_equal password.length, 8

    assert_equal pool.include?(password[0]), true
    assert_equal pool.include?(password[1]), true

    refute_equal password.split("") & PasswordGenerator::NUMS, []
    refute_equal password.split("") & PasswordGenerator::LOWER_CASES, []
    refute_equal password.split("") & PasswordGenerator::UPPER_CASES, []
    refute_equal password.split("") & PasswordGenerator::SPECIAL_CHARS, []
  end

  def test_opts_for_numeric
    opts = PasswordGenerator.opts_for(:numeric)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: true,
      include_lower_case: false,
      include_upper_case: false,
      include_special: false
    }
  end

  def test_opts_for_lower
    opts = PasswordGenerator.opts_for(:lower)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: false,
      include_lower_case: true,
      include_upper_case: false,
      include_special: false
    }
  end

  def test_opts_for_upper
    opts = PasswordGenerator.opts_for(:upper)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: false,
      include_lower_case: false,
      include_upper_case: true,
      include_special: false
    }
  end

  def test_opts_for_special
    opts = PasswordGenerator.opts_for(:special)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: false,
      include_lower_case: false,
      include_upper_case: false,
      include_special: true
    }
  end

  def test_opts_for_alpha
    opts = PasswordGenerator.opts_for(:alpha)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: false,
      include_lower_case: true,
      include_upper_case: true,
      include_special: false
    }
  end

  def test_opts_for_alnum
    opts = PasswordGenerator.opts_for(:alnum)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: true,
      include_lower_case: true,
      include_upper_case: true,
      include_special: false
    }
  end

  def test_opts_for_all
    opts = PasswordGenerator.opts_for(:all)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH,
      include_nums: true,
      include_lower_case: true,
      include_upper_case: true,
      include_special: true
    }
  end

  def test_opts_for_all_with_length
    opts = PasswordGenerator.opts_for(:all, 10)

    assert_equal opts, {
      length: 10,
      include_nums: true,
      include_lower_case: true,
      include_upper_case: true,
      include_special: true
    }
  end

  def test_opts_for_nonsense
    opts = PasswordGenerator.opts_for(:nonsense)

    assert_equal opts, {
      length: PasswordGenerator::DEFAULT_LENGTH
    }
  end
end
