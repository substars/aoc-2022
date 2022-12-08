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
        [
            trees[x].first(y),
            trees[x].last(width-y-1),
            (x-1).downto(0).map{|col| trees[col][y] },
            (x+1).upto(height-1).map{|col| trees[col][y] }
    ].map(&:max).any?{|max| max < trees[x][y]}
    
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
        zz = [
        trees[x].first(y).reverse, # left
        trees[x].last(width-y-1), # right
        (x-1).downto(0).map{|col| trees[col][y] }, # down
        (x+1).upto(height-1).map{|col| trees[col][y] } # up
        ].map do |list|
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
end

lines = File.read('input.txt').split("\n")

trees = TreeGrid.new(lines.length, lines.first.length)


lines.each_with_index do |line, x|    
    line.chars.each_with_index do |height, y|
        trees.place!(x,y,height.to_i)
    end    
end

puts trees.to_s
puts
puts trees.visible_count

puts
puts "*** PART 2 ***"
puts


max = 0
trees.height.times.map do |x|
    trees.width.times.map do |y|
        ss = trees.scenic_score(x,y)
        max=ss if ss>max        
    end    
end
puts
puts max


#  puts trees.trees[3][4]
#   puts trees.scenic_score(3,4)



