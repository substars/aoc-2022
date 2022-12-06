lines = File.read('input.txt').split("\n")

lines.each do |line|
    #puts "processing #{line}"
    last_four = [] 
    line.each_char.with_index do |char, i|
        if i <= 3
            last_four << char
        else
            last_four.push(char)
            last_four.shift
        end         
        if last_four.uniq.length == 4
            puts "line #{line} has SoP # #{i+1}"
            break
        end
    end
    puts
end

puts
puts "PART 2"
puts

lines.each do |line|
    #puts "processing #{line}"
    last_fourteen = [] 
    line.each_char.with_index do |char, i|
        if i <= 13
            last_fourteen << char
        else
            last_fourteen.push(char)
            last_fourteen.shift
        end         
        if last_fourteen.uniq.length == 14
            puts "line #{line} has SoM # #{i+1}"
            break
        end
    end
    puts
end