# ______      _            ______ _            _         ______ _____ _    _
# | ___ \    | |           | ___ \ |          | |        |  ___|_   _| |  | |
# | |_/ /   _| |__  _   _  | |_/ / | ___   ___| | _____  | |_    | | | |  | |
# |    / | | | '_ \| | | | | ___ \ |/ _ \ / __| |/ / __| |  _|   | | | |/\| |
# | |\ \ |_| | |_) | |_| | | |_/ / | (_) | (__|   <\__ \ | |     | | \  /\  /
# \_| \_\__,_|_.__/ \__, | \____/|_|\___/ \___|_|\_\___/ \_|     \_/  \/  \/
#                    __/ |
#                   |___/
#
# By Tom Smyth, Worker/Owner @ Sassafras Tech Collective (sassafras.coop)

result = []
for word in %w(apple banana aardvark cumquat peach) do
  result << word unless word[0] == 'a'
end
result

# A block is basically a short 'anonymous' method that you define 'inline'.
# A block is passed as an argument to a method and can be invoked by that method.

# Maybe the most famous block-accepting method: each.
[1,2,3].each{ |n| puts "This is line #{n}" }

# NOTE: THAT BLOCK TAKES AN ARGUMENT. CAN TAKE MULTIPLE.

{a: 1, b: 2, c: 3}.each{ |k,v| puts "The value of #{k} is #{v}" }

# OR CAN TAKE NONE

3.times{ puts "Beetlejuice!" }

# Returning to our example:
%w(apple banana aardvark cumquat peach).reject{|w| w[0] == 'a'}

# NOW SAY WE WANTED TO SORT BASED ON THE LENGTH OF THE REMAINING WORDS
# HOW WOULD YOU EVEN DO THAT WITH A FOR/WHILE LOOP?

# Blocks _can_ allow succinct but readable code.
%w(apple banana aardvark cumquat peach).reject{|w| w[0] == 'a'}.sort_by{|w| w.size}

# Or even succinct-er! (in more recent rubies)
%w(apple banana aardvark cumquat peach).reject{|w| w[0] == 'a'}.sort_by(&:size)

# NOTE: IT'S USUALLY OK TO USE ONE LETTER VARS IN BLOCKS

# Block can also be optional.
%w(a b c d e).sort
%w(a b c d e).sort{ |x,y| x <=> y }
%w(a b c d e).sort{ |x,y| y <=> x }

# Multiline blocks are also possible.
(1900..2000).each do |year|
  if year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    puts "#{year} is a leap year!"
  else
    puts "#{year} is a plain old year."
  end
end

# Some great block-accepting functions
[-40, 0, 37, 100].map{|t| t * 1.8 + 32}

[1,5,7].inject{|sum, i| sum += i}

# NOTE: BLOCKS CAN TAKE MORE THAN ONE ARG

longest = %w(cat sheep bear).inject do |longest_so_far, word|
  longest_so_far.length > word.length ? longest_so_far : word
end

assert_raise(TypeError){ 4 + 'foo' }

%w(john michael eric graham terry terry).each_with_index{ |n, i| puts "#{i+1}. #{n}" }

# Enumerators
%w(john michael eric graham terry terry).map{ |n| FunnyPerson.new(:name => p)}

# NOTE: NO METHOD CALLED MAP_WITH_INDEX

%w(john michael eric graham terry terry).each_with_index

require 'ostruct'
%w(john michael eric graham terry terry).each_with_index.map{ |n, i| OpenStruct.new(:name => n, :rank => i) }

# NOTE: LOTS OF OTHER ENUMERATORS. e.g.

%w(john michael eric graham terry terry).map.with_index{ |n, i| OpenStruct.new(:name => n, :rank => i) }

# Defining a method that accepts a block.
class MyList
  def initialize(arr)
    @arr = arr
  end
  def sum_by
    @arr.inject{ |sum, el| sum += yield(el) }
  end
end
MyList.new([1,4,7]).sum_by{ |x| x * x }

# Can add stuff to Array! Use with caution!
class Array
  def sum_by
    self.inject{ |sum, el| sum += yield(el) }
  end
end
[1,4,7].sum_by{ |x| x * x }

# Alternative to yield
class MyList
  def initialize(arr)
    @arr = arr
  end
  def sum_by(&block)
    @arr.inject{ |sum, el| sum += block.call(el) }
  end
end
MyList.new([1,4,7]).sum_by{ |x| x * x }

# Where alternative is useful.
class MyList
  def initialize(arr)
    @arr = arr
  end
  def sum_by(&block)
    @arr.inject{ |sum, el| sum += block.call(el) }
  end
  def sum_odds_by(&block)
    @arr.reject(&even?).sum_by(&block)
  end
end
MyList.new([1,4,7]).sum_odds_by{ |x| x * x }

# block_given?
def foo
  puts block_given? ? "Block says: #{yield}" : "No block :("
end
foo
foo { 'Hello!' }

# Blocks very popular in Rails.
<% @people.each do |p| %> <%= p.first_name %> <%= p.last_name %> <% end %>
