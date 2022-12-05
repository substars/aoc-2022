class CrateStack
    attr_accessor :stacks
    def initialize(stacks)
        self.stacks = Array.new(stacks){ [] }
    end

    def parse_move!(move_text)
        # e.g. "move 1 from 2 to 1"
        count, from, to = move_text.scan(/\d+/).map(&:to_i)        
        move!(count, from-1, to-1)
    end

    def place!(container_id, stack)    
        #puts "placing #{container_id} on stack #{stack}"
        stacks[stack-1].push(container_id)        
    end

    def move!(count, from, to)    
        count.times do             
            val = stacks[from].pop            
            stacks[to].push(val)
        end
    end

    def to_s        
        # start at top                    
        max = stacks.max{|s| s.length}.length      
        str = max.downto(0).map do |row|            
            row_string(row)
        end.join("\n")       
        str << "\n"
        str << stacks.length.times.map{|i| " #{i+1} "}.join(' ')       
        str
    end

    def top_of_each_stack
        stacks.map(&:last).join
    end


    def row_string(row)        
        return '' if row<0
        stacks.map do |stack|            
            if stack[row].nil?
                '   '
            else
                "[#{stack[row]}]"
            end
        end.join(' ')        
    end
end

class CrateStack9001 < CrateStack

    # new create mover preserves order when moving crates
    def move!(count, from, to)                  
        val = stacks[from].pop(count)
        stacks[to].concat(val)
    end

end


content = File.read("input.txt")
stack_text, moves = content.split("\n\n")
stack_input = stack_text.split("\n").reverse

# Use CrateStack for part 1, CreateStack9001 for part 2
stack = CrateStack9001.new(stack_input.shift.split.last.to_i)

stack_input.each do |row|    
    #TODO this won't work        
    row.scan(/.{1,4}/).each_with_index do |slice, index|                        
        letter = slice.scan(/\w/).first
        unless letter.nil?            
            stack.place!(letter, index+1)
        end
    end
end

puts "*** initial state ***"
puts stack.to_s

moves.split("\n").each do |move|
    stack.parse_move!(move)
end

puts "*** final state ***"
puts stack.to_s

puts "top of each stack:"
puts stack.top_of_each_stack










