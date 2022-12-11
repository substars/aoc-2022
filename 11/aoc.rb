monkey_chunks = File.read("input.txt").split("\n\n")

class Monkey
  attr_accessor :items, :name, :inspected, :test_divisor

  def initialize(chunk)
    @inspected = 0
    @bits = chunk.split("\n")
    @name = @bits.first
    @items = @bits[1].scan(/\d+/).map(&:to_i)
    @operation = @bits[2].split("=").last.strip
    @test_divisor = @bits[3].scan(/\d+/).first.to_i
  end

  def inspect_items
    @items.map do |old|
      @inspected += 1
      updated = operation(old)
      to_monkey = if updated % @test_divisor == 0
        @bits[4]
      else
        @bits[5]
      end.scan(/\d+/).first.to_i
      yield updated, to_monkey if block_given?
    end
    @items.clear
  end

  def operation(old)
    (eval(@operation) / 3).to_i
  end

  def to_s
    puts "name: #{@name}"
    puts "items: #{@items}"
    puts "op: #{@operation}"
    puts "test: #{@test_divisor}"
  end
end

class BigMonkey < Monkey # for part 2
  attr_accessor :modulo

  def initialize(chunk)
    super(chunk)
    @modulo = 1
  end

  def operation(old)
    (eval(@operation) % modulo).to_i
  end
end

def sling_stuff(monkeys, rounds)
  rounds.times do |i|
    monkeys.each do |monkey|
      monkey.inspect_items do |item, new_monkey|
        monkeys[new_monkey].items << item
      end
    end
  end
end

monkeys = monkey_chunks.map { |chunk| Monkey.new(chunk) }
sling_stuff(monkeys, 20)
puts "Part 1 solution: #{monkeys.map(&:inspected).sort.last(2).inject(&:*)}"

puts "### PART 2 ###"

modulo = 1
monkeys = monkey_chunks.map do |chunk|
  BigMonkey.new(chunk).tap do |m|
    modulo *= m.test_divisor
  end
end

monkeys.each { |m| m.modulo = modulo }
sling_stuff(monkeys, 10_000)
puts "Part 2 solution: #{monkeys.map(&:inspected).sort.last(2).inject(&:*)}"
