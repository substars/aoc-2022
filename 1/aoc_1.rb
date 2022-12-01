elf_cal_counts = []

current_cal_count=0
File.open('input.txt').each_line do |line|
    line.strip!
    if line.empty?        
        elf_cal_counts << current_cal_count
        current_cal_count = 0
    else        
        current_cal_count += line.to_i
    end
end

puts "part 1: #{elf_cal_counts.rindex(elf_cal_counts.max)+1 } is carrying #{elf_cal_counts.max} cals"
puts "part 2: top three elves are carrying #{elf_cal_counts.sort.last(3).sum} cals"