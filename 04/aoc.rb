lines = File.read('input.txt')

values = lines.split("\n").map do |line|    
    elf1, elf2 = line.split(',').map do |r|         
        Range.new(*r.scan(/\d+/))
    end
    overlap = elf1.to_a & elf2.to_a
    is_subset = [elf1.to_a, elf2.to_a].include?(overlap)
    puts "#{overlap} - #{is_subset}"
    is_subset
end.group_by{|v| v}.map{|k,v| [k, v.size]}.to_h

# # true is what we want
puts values

puts '**************'
puts '*** part 2 ***'
puts '**************'
puts

# any overlap is all is simpler, actually
values = lines.split("\n").map do |line|    
    elf1, elf2 = line.split(',').map do |r|         
        Range.new(*r.scan(/\d+/))
    end
    overlap = elf1.to_a & elf2.to_a    
    puts "#{overlap} - #{overlap.empty?}"    
    !overlap.empty?
end.group_by{|v| v}.map{|k,v| [k, v.size]}.to_h

# # true is what we want
puts values