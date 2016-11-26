class MaxIntSet
  def initialize(max)
    @store = Array.new(max) { false }
  end

  def insert(num)
    raise 'Out of bounds' unless is_valid?(num)
    @store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num]
  end

  private

  def is_valid?(num)
    num.is_a?(Integer) && num.between?(0, @store.length - 1)
  end

  def validate!(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = num_buckets
  end

  def insert(num)
    bucket = num % @count
    @store[bucket] << num
  end

  def remove(num)
    @store[num % @count].delete(num)
  end

  def include?(num)
    @store[num % @count].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count, :store

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @bucket_count = num_buckets
    @count = 0
  end

  def insert(num)
    self[num] << num
    @count += 1
    resize! if @count > @bucket_count
  end

  def remove(num)
    if include?(num)
      self[num].delete(num)
      @count -= 1
    end
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    @store[num % @bucket_count]
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_store = ResizingIntSet.new(@bucket_count * 2)
    @bucket_count *= 2
    @store.each do |bucket|
      bucket.each do |num|
        new_store.insert(num)
      end
    end
    @store = new_store.store
  end
end
