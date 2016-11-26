require_relative 'p02_hashing'
require_relative 'p04_linked_list'
require 'byebug'

class HashMap
  include Enumerable
  attr_reader :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store[key.hash % num_buckets].include?(key)
  end

  def delete(key)
    if @store[key.hash % num_buckets].include?(key)
      @store[key.hash % num_buckets].remove(key)
      @count -= 1
    end
  end

  def each
    @store.each do |list|
      list.each do |node|
        yield(node.key, node.val)
      end
    end
  end


  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  def get(key)
    # debugger
    hash_key = key.hash % num_buckets
    @store[hash_key].get(key)
  end

  def set(key, val)
    hash_key = key.hash % num_buckets
    if @store[hash_key].include?(key)
      @store[hash_key].update(key, val)
    else
      @store[hash_key].append(key, val)
      @count += 1
    end
    resize! if @count > num_buckets
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_store = HashMap.new(num_buckets * 2)
    self.each do |key, val|
      new_store.set(key, val)
    end
    @store = new_store.store
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
  end
end
