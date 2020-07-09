module Enumerable
  def my_each
    return enum_for(__method__) unless block_given?
    size.times { |i| yield to_a[i] }
    self
  end

  def my_each_with_index
    return enum_for(__method__) unless block_given?
    size.times { |i| yield to_a[i], i }
    self
  end

  def my_select
    return enum_for(__method__) unless block_given?

    array = []
    my_each { |n| array << n if yield n }
    array
  end

  def my_all?(arg = nil)
    puts "#{__FILE__}:#{__LINE__}: w: block not used" if arg && block_given?
    return my_all_extra_func(arg) if arg

    if !block_given?
      size.times { |n| return false if to_a[n] == false || to_a[n].nil? }
    else
      my_each { |n| return false unless yield n }
    end
    true
  end

  def my_all_extra_func(arg)
    if arg.is_a?(Regexp)
      my_each { |n| (n =~ arg).nil? ? false : 'Error' }
      true
    elsif arg
      my_each { |n| return false unless n.is_a? arg }
    end
  end

  def my_any?(arg = nil)
    if arg
      puts "#{__FILE__}:#{__LINE__}: w: block not used" if block_given?
      return my_any_extra_func(arg)
    elsif block_given?
      my_each { |n| return true if yield n }
    else
      my_each { |n| return true if n }
    end
    false
  end

  def my_any_extra_func(arg)
    if arg.is_a?(Regexp)
      my_each { |n| return false unless fun.match? n.to_s }
    elsif arg
      my_each { |n| return false unless arg === n }
    end
  end

  def my_none?(arg = nil)
    if arg
      puts "#{__FILE__}:#{__LINE__}: w: block not used" if block_given?
      !my_any?(arg)
    elsif block_given?
      !my_any?(&Proc.new)
    else
      !my_any?
    end
  end

  def my_count(arg = 0)
    counter = 0
    if block_given?
      my_each { |n| counter += 1 if yield n }
    elsif arg.zero?
      my_each { counter += 1 }
    else
      my_each { |n| counter += 1 if arg == n }
    end
    counter
  end
end
