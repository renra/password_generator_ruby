class PasswordGenerator
  NUMS = ('0'..'9').to_a
  LOWER_CASES = ('a'..'z').to_a
  UPPER_CASES = ('A'..'Z').to_a
  SPECIAL_CHARS = ['?', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '~', '.', ',', '<', '>', '[', ']']

  MIN_LENGTH = 4
  DEFAULT_LENGTH = 8

  def initialize(opts = {})
    @length = opts[:length] || DEFAULT_LENGTH
    raise "Length must be at least #{MIN_LENGTH}" if @length < MIN_LENGTH

    @pools = []
    @excluded = opts[:exclude] || []

    if opts[:pool]
      add_pool(opts[:pool])
      include_other_pools_by_default = false
    else
      include_other_pools_by_default = true
    end

    @include_nums = opts[:include_nums] || include_other_pools_by_default
    @include_lower_case = \
      opts[:include_lower_case] || include_other_pools_by_default

    @include_upper_case = \
      opts[:include_upper_case] || include_other_pools_by_default

    @include_special = \
      opts[:include_special] || include_other_pools_by_default


    add_pool(NUMS) if @include_nums
    add_pool(LOWER_CASES) if @include_lower_case
    add_pool(UPPER_CASES) if @include_upper_case
    add_pool(SPECIAL_CHARS) if @include_special

    if @pools.flatten.length == 0
      raise ArgumentError.new('Char pool is empty. Password cannot be generated')
    end
  end

  def generate
    password = ''

    remaining_chars = @length

    @pools.each do |pool|
      break if remaining_chars == 0

      password << pool.sample
      remaining_chars -= 1
    end

    remaining_chars.times do
      password << @pools.sample.sample
    end

    password.split("").shuffle.join
  end

  private
  def add_pool(pool)
    sanitized_pool = sanitize_pool(pool)
    @pools.push(sanitized_pool) unless sanitized_pool.empty?
  end

  def sanitize_pool(pool)
    pool - @excluded
  end
end
