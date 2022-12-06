lines = File.read('example.txt').split("\n")

def get_start_of_seq(line, num_chars)
    line.each_char.with_index.inject([]) do |last_few, (char, i)|
        if i <= num_chars-1
            last_few << char
        else
            last_few.push(char)
            last_few.shift
        end    
        if last_few.uniq.length == num_chars
            return i+1
        end
        last_few
    end    
end

lines.each do |line|
    puts "line #{line} has SoP # #{get_start_of_seq(line, 4)}"
end

puts
puts "PART 2"
puts

lines.each do |line|
    puts "line #{line} has SoM # #{get_start_of_seq(line, 14)}"
end