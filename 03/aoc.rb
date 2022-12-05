require 'set'

lines = File.read('input.txt')

# part 1
total = lines.split("\n").map do |line|
    compartment1, compartment2 = line.split('').each_slice(line.length/2.0).to_a.map(&:to_set)
    same_items = compartment1 & compartment2

    puts "same items: #{same_items.to_a}"
    total = same_items.each.map do |char|        
            case
            when char.upcase == char
                char.ord - 64 + 26 #  'A'.ord == 65
            else
                char.ord - 96 #  'a'.sum == 97
            end        
    end.sum
    puts "line #{line}\t\t\tsame items:#{same_items}\t\tpriority is #{total}"
    total
    
end.sum
puts "total is #{total}"

# part 2
puts '**************'
puts '*** part 2 ***'
puts '**************'
puts
total = lines.split("\n").each_slice(3).map do |group|      
    elf1, elf2, elf3 = group.map{|e| e.split('').to_set}
    same_items = elf1 & elf2 & elf3

    puts "same items: #{same_items.to_a}"
    pri = same_items.each.map do |char|        
            case
            when char.upcase == char
                char.ord - 64 + 26 #  'A'.ord == 65
            else
                char.ord - 96 #  'a'.sum == 97
            end        
    end.sum
    puts "group #{group}\t\t\tbadge:#{same_items.to_a}\t\tpriority is #{pri}"
    pri    
end.sum
puts "total is #{total}"