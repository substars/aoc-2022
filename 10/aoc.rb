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

strengths_sum = File.read("input.txt").split("\n").inject({cpu: CPU.new, strengths: 0}) do |hsh, line|
  hsh[:cpu].send(*line.split(" ")) do |cpu|
    hsh[:strengths] += cpu.signal_strength
  end
  hsh
end[:strengths]

puts
puts "part 1 answer: #{strengths_sum}"