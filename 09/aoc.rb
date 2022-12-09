require "set"

class RopeGrid
  GridMember = Struct.new(:x, :y, :visited) do
    def initialize
      self.x = 0
      self.y = 0
      self.visited = Set.new
      visit! # 0,0
    end

    def left!(visit = true)
      self.y -= 1
      visit! if visit
    end
    alias :l! :left!

    def right!(visit = true)
      self.y += 1
      visit! if visit
    end

    alias :r! :right!

    def up!(visit = true)
      self.x += 1
      visit! if visit
    end

    alias :u! :up!

    def down!(visit = true)
      self.x -= 1
      visit! if visit
    end

    # want to move diagonally? use this
    def batch_move
      yield self
      visit!
    end

    def visited?(x, y)
      visited.include?([x, y])
    end

    def grid_size
      [x, y].max
    end

    def visit!
      visited << [x, y]
    end

    alias :d! :down!
  end

  attr_accessor :head, :tail

  def initialize
    self.head = GridMember.new
    self.tail = GridMember.new
  end

  def grid_size
    [head, tail].map(&:grid_size).max
  end

  def move_head!(direction, steps)
    steps.times do
      head.send("#{direction.downcase}!")
      move_tail!
    end
  end

  def move_tail!
    # If the head is ever two steps directly up, down, left, or right from the tail,
    # the tail must also move one step in that direction so it remains close enough:

    if head.x == tail.x
      if head.y == tail.y + 2
        tail.right!
      elsif head.y == tail.y - 2
        tail.left!
      end
    elsif head.y == tail.y
      if head.x == tail.x + 2
        tail.up!
      elsif head.x == tail.x - 2
        tail.down!
      end
    elsif ((head.x - tail.x).abs + (head.y - tail.y).abs) > 2        
      # Otherwise, if the head and tail aren't touching and aren't in the same row or column,
      # the tail always moves one step diagonally to keep up:
      go_up = head.x > tail.x
      go_left = head.y < tail.y
      tail.batch_move do |t|
        go_up ? t.up!(false) : t.down!(false)
        go_left ? t.left!(false) : t.right!(false)
      end
    end
  end

  def to_s
    #puts head.inspect
    #puts tail.inspect
    str = ""
    (grid_size).downto(0) do |x|
      (grid_size+1).times do |y|
        str << case
        when head.x == x && head.y == y
          "H"
        when tail.x == x && tail.y == y
          "T"
        when x == 0 && y == 0
          "s"
        when tail.visited?(x, y)
          "#"
        else
          "."
        end
      end
      str << "\n"
    end
    str
  end
end

grid = RopeGrid.new

File.open("input.txt").each_line do |line|
  direction, steps = line.split(" ")
  puts
  puts "== #{line.strip} =="
  puts
  grid.move_head!(direction.downcase, steps.to_i)
  puts grid.to_s
end

puts "ANSWER = #{grid.tail.visited.length}"
