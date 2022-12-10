cycle = 1

class CPU
  attr_accessor :x, :cycle

  def initialize
    self.x = 1
    self.cycle = 0
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
    self.cycle += 1
    #puts "CPU\tcycle: #{cycle}\tx: #{x}"
  end
end

c = CPU.new
signal_strengths_total = 0
File.read("input.txt").split("\n").each do |line|
  instruction, val = line.split(" ")
  c.send(instruction, val.to_i) do |x, cycle|
    if [20, 60, 100, 140, 180, 220].include?(cycle)
      puts "signal strength at #{cycle} is #{cycle * x} (#{x})"
      signal_strengths_total += (cycle * x)
    end
  end
end

puts "part 1: #{signal_strengths_total}"
