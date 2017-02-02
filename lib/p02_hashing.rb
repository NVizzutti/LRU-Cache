class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    return 0 if empty?
    num_array = self.map { |el| el.is_a?(String) ? el.ord : el }
    num_array.map!.with_index { |el, idx| el.hash * idx }
    total = num_array.inject(:+)
    total / num_array.length
  end
end

class String
  def hash
    nums = (self.ord * self.length) * (self[-1].ord - self[0].ord)
  end
end

class Hash
  def hash
    result = 0
    self.each do |key , val|
      num1 = key.hash unless key.is_a?(Hash)
      num2 = val.hash unless val.is_a?(Hash)
      result += (num1 + num2)
    end
    result
  end
end
