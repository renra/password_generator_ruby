class PasswordGenerator
  NUMS = ('0'..'9').to_a
  LOWER_CASES = ('a'..'z').to_a
  UPPER_CASES = ('A'..'Z').to_a
  SPECIAL_CHARS = ['?', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '~', '.', ',', '<', '>', '[', ']']

  MIN_LENGTH = 1
  DEFAULT_LENGTH = 8

  def self.generate(*opts)
    opts = [{}] if opts.empty?

    opts.inject("") do |password, generator_opts|
      password << self.new(generator_opts).generate
    end
  end

  def self.opts_for(type, length = DEFAULT_LENGTH)
    case type
      when :numeric
        {
          length: length,
          include_nums: true,
          include_lower_case: false,
          include_upper_case: false,
          include_special: false
        }
      when :lower
        {
          length: length,
          include_nums: false,
          include_lower_case: true,
          include_upper_case: false,
          include_special: false
        }
      when :upper
        {
          length: length,
          include_nums: false,
          include_lower_case: false,
          include_upper_case: true,
          include_special: false
        }
      when :special
        {
          length: length,
          include_nums: false,
          include_lower_case: false,
          include_upper_case: false,
          include_special: true
        }
      when :alpha
        {
          length: length,
          include_nums: false,
          include_lower_case: true,
          include_upper_case: true,
          include_special: false
        }
      when :alnum
        {
          length: length,
          include_nums: true,
          include_lower_case: true,
          include_upper_case: true,
          include_special: false
        }
      when :all
        {
          length: length,
          include_nums: true,
          include_lower_case: true,
          include_upper_case: true,
          include_special: true
        }
      else
        {
          length: length
        }
    end
  end


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

    @include_nums = opts[:include_nums]
    @include_nums = include_other_pools_by_default if @include_nums.nil?

    @include_lower_case = opts[:include_lower_case]
    @include_lower_case = include_other_pools_by_default \
      if @include_lower_case.nil?

    @include_upper_case = opts[:include_upper_case]
    @include_upper_case = include_other_pools_by_default \
      if @include_upper_case.nil?

    @include_special = opts[:include_special]
    @include_special = include_other_pools_by_default if @include_special.nil?

    add_pool(NUMS) if @include_nums
    add_pool(LOWER_CASES) if @include_lower_case
    add_pool(UPPER_CASES) if @include_upper_case
    add_pool(SPECIAL_CHARS) if @include_special

    if @pools.empty?
      raise ArgumentError.new('Char pool is empty. Password cannot be generated')
    end
  end

  def generate
    password = ''

    remaining_chars = @length

    if remaining_chars >= @pools.length
      @pools.each do |pool|
        password << pool.sample
        remaining_chars -= 1
      end
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
