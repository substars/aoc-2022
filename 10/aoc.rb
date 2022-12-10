class CPU
  attr_accessor :x, :cycle, :buffer

  def initialize
    self.x = 1
    self.cycle = 0
    self.buffer = ""
  end

  def noop(_)
    cycle!
    yield x, cycle if block_given?
  end

  def addx(val)
    cycle!
    yield(x, cycle) if block_given?
    cycle!
    yield(x, cycle) if block_given?
    self.x += val
  end

  def cycle!
    self.buffer << if ((x - 1)..(x + 1)).include?(cycle % 40)
      "#"
    else
      "."
    end
    self.cycle += 1
  end

  def draw!
    retval = self.buffer
    self.buffer = ""
    return retval
  end
end

c = CPU.new
signal_strengths_total = 0
File.read("input.txt").split("\n").each do |line|
  instruction, val = line.split(" ")
  c.send(instruction, val.to_i) do |x, cycle|
    if [20, 60, 100, 140, 180, 220].include?(cycle)
      #puts "signal strength at #{cycle} is #{cycle * x} (#{x})"
      signal_strengths_total += (cycle * x)
    end
  end
end

puts "part 1: #{signal_strengths_total}"

puts "part 2:"
puts

c = CPU.new

File.read("input.txt").split("\n").each do |line|
  instruction, val = line.split(" ")
  c.send(instruction, val.to_i) do |x, cycle|
    if cycle % 40 == 0
      puts c.draw!
    end
  end
end
