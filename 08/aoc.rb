class TreeGrid
    attr_accessor :trees, :width, :height
    
    def initialize(height, width)
        self.trees = Array.new(height) {Array.new(width, 0)}
        self.width = width
        self.height = height
    end
    
    def place!(x,y,height)
        trees[x][y] = height
    end

    def visible?(x, y)
        return true if [x,y].include?(0) || x==height-1 || y==width-1
        trees_in_every_direction(x,y).map(&:max).any?{|max| max < trees[x][y]}
    
    end
    
    def visible_count
        height.times.map do |x|
            width.times.map do |y|
                visible?(x,y)
            end
        end.flatten.count(true)
    end

    def scenic_score(x,y)        
        th = trees[x][y]                
        trees_in_every_direction(x,y).map do |list|
            index = list.index{|oth| oth >= th }
            case 
            when list.empty?
                0
            when index.nil?
                list.length
            else
                index+1              
            end 
        end.inject(&:*)
    end
    
    def to_s
        height.times.map do |x|
            width.times.map do |y|
                print trees[x][y]
            end            
            print "\n"
        end 
        print "\n"
    end

    private
    
    def trees_in_every_direction(x,y)
        [
            trees[x].first(y).reverse, # trees to the left (from view of x,y, i.e. reversed)
            trees[x].last(width-y-1), # to the right
            (x-1).downto(0).map{|col| trees[col][y] }, # up (from view of x,y, i.e. reversed)
            (x+1).upto(height-1).map{|col| trees[col][y] } # down 
        ]
    end
end

lines = File.read('input.txt').split("\n")

trees = TreeGrid.new(lines.length, lines.first.length)

puts "Parsed tree:"
puts trees.to_s

lines.each_with_index do |line, x|    
    line.chars.each_with_index do |height, y|
        trees.place!(x,y,height.to_i)
    end    
end

puts
puts "*** PART 1: # visible trees ***"
puts

puts trees.visible_count

puts
puts "*** PART 2: highest scenic score ***"
puts


puts "max scenic score: " + (trees.height.times.map do |x|
    trees.width.times.map do |y|
        trees.scenic_score(x,y)        
    end    
end.flatten.max.to_s)




