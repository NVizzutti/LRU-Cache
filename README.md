##LRU Cache

In this exercise I implemented an LRU Cache that utilizes a a custom-built `Hash Map`, and `Doubly-Linked-List` for optimal lookup time. The cached items are stored in the linked list while the hash map holds pointers to each cached item. The combination of these data structures allows for ejection, insertion, deletion, and selection all in constant `O(1)` time.  

### Hash Map

This implementation uses custom-built hashing functions for Strings, Arrays, and Hash Objects to create unique keys as references in the hash map. The hashed values are stored as pointers the objects in the doubly-linked-list. The buckets in the hash map are considered full when the average number of objects per bucket is greater than 1, at which point the number of buckets doubles and keys are reassigned so that values are distributed evenly and resizing is kept to a minimum. Based on the application of the hash map, alternative criteria for resizing may be optimal.

```Ruby
  def get(key)
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
end
```


### Linked-List

The linked list holds a `nil` value for the head node, as well as the tail node. This avoids having to re-assign `head` or `tail` and allows easy access to first and last nodes. Still, as lookup time is linear `O(n)`, the hash map is needed to optimize the cache.

```Ruby
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
    until current == @tail
      if current.key == key
        current.remove
        return current
      end
      current = current.next
    end

  end
  ```

### Putting it Together

The hash map is great for lookup, insertion, and deletion, all in constant time. The linked list is great for keeping order, and allowing for easy re-arrangement. The LRU cache keeps a `@store` instance of the `HashMap` class, and an `@map` instance of the `LinkedList` class. In the end we get a clean LRU cache with excellent time complexity for all major actions, with the occasional resize being triggered. 

```Ruby 
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
```

