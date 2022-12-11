monkey_chunks = File.read("input.txt").split("\n\n")

class Monkey
  attr_accessor :items, :name, :inspected

  def initialize(chunk)
    @inspected=0
    @bits = chunk.split("\n")
    @name = @bits.first
    @items = @bits[1].scan(/\d+/).map(&:to_i)
    @operation = @bits[2].split("=").last.strip
    @test_divisor = @bits[3].scan(/\d+/).first.to_i
  end

  def inspect_items
    @items.map do |old|
      @inspected+=1
      updated = (eval(@operation) / 3).to_i
      to_monkey = if updated % @test_divisor == 0
        @bits[4]
      else
        @bits[5]
      end.scan(/\d+/).first.to_i
      yield updated, to_monkey if block_given?      
    end
    @items.clear
  end

  def to_s
    puts "name: #{@name}"
    puts "items: #{@items}"
    puts "op: #{@operation}"
    puts "test: #{@test_divisor}"
  end
end

monkeys = monkey_chunks.map do |chunk|
  Monkey.new(chunk)
end

20.times do |i|
  monkeys.each do |monkey|   
     monkey.inspect_items do |item, new_monkey|
       puts "moving item #{item} from #{monkey.name} to #{new_monkey}"
       monkeys[new_monkey].items << item
     end
  end
  puts "** ROUND #{i+1}"
  monkeys.each_with_index do |m, i|
    puts "#{m.name}: #{m.items.join(", ")} #{m.inspected}"
end
end

puts monkeys.map(&:inspected).sort.last(2).inject(&:*)
