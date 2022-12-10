class CPU
  attr_accessor :x, :cycle

  def initialize
    self.x = 1
    self.cycle = 0
  end

  def noop(_ = nil, &block)
    cycle!(&block)
  end

  def addx(val = nil, &block)
    2.times { cycle!(&block) }
    self.x += val.to_i
  end

  # also draws stuff
  def cycle!
    pixel = if ((x - 1)..(x + 1)).include?(cycle % 40)
        "#"
      else
        "."
      end
    print pixel
    self.cycle += 1
    print "\n" if cycle % 40 == 0
    yield(self) if block_given?
  end

  def signal_strength
    if cycle % 40 == 20
      cycle * x
    else
      0
    end
  end
end

c = CPU.new
signal_strengths_total = 0
File.read("input.txt").split("\n").each do |line|
  c.send(*line.split(" ")) do |cpu|
    signal_strengths_total += cpu.signal_strength
  end
end

puts "part 1: #{signal_strengths_total}"

puts "part 2:"
puts

c = CPU.new

File.read("input.txt").split("\n").each do |line|
  c.send(*line.split(" "))
end
