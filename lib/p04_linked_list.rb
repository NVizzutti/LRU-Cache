require 'byebug'
class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    @prev.next = @next
    @next.prev = @prev
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList
  include Enumerable
  def initialize
    @head = Link.new
    @tail = Link.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    return true if @head.next == @tail
    return false
  end

  def get(key)
    current = @head
    until current == @tail
      return current.val if key == current.key
      current = current.next
    end
    nil
  end

  def include?(key)
    ! get(key).nil?
  end

  def append(key, val)
    new_link = Link.new(key, val)
    new_link.next = @tail
    new_link.prev = @tail.prev
    temp = @tail.prev
    @tail.prev = new_link
    temp.next = new_link
    new_link
  end

  def update(key, val)
    current = @head
    until current == @tail
      if key == current.key
        current.val = val
        break
      end
      current = current.next
    end
  end

  def remove(key)
    current = @head
    # debugger
    until current == @tail
      # debugger
      if current.key == key
        current.remove
        return current
      end
      current = current.next
    end

  end

  def each(&prc)
    raise 'No block given' unless block_given?
    current = @head.next
    until current == @tail
      prc.call(current)
      current = current.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
     inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
