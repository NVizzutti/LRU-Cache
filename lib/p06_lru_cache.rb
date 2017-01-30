require_relative 'p05_hash_map'
require_relative 'p04_linked_list'
require 'byebug'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.get(key).nil?
      new_val = @prc.call(key)
      new_link = @store.append(key, new_val)
      @map.set(key, new_link)
      eject! if count > @max
      new_val
    else
      link = @store.remove(key)
      update_link!(link)
      @map.get(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def update_link!(link)
    new_link = @store.append(link.key, link.val)
    @map.set(new_link.key, new_link)
  end

  def eject!
    link = @store.remove(@store.first.key)
    @map.delete(link.key)
  end
end
