FileObject = Struct.new(:name, :size)    

class Dir
    attr_accessor :name, :files, :dirs, :parent
    def size        
        (dirs.map(&:size) + files.map(&:size)).sum
    end

    def initialize(name, parent=nil)
        self.name = name
        self.parent = parent
        self.dirs = []
        self.files = []
    end

    def get_child(dirname)
        dirs.detect{|d| d.name == dirname} # || Dir.new(dirname, self)
    end

    def mkdir(dir)        
        #puts "making dir #{dir}"
        dirs << Dir.new(dir, self)
        dir
    end    

    def touch!(filename, size)
        files << FileObject.new(filename, size)
    end

    def root
        d = self
        while !d.parent.nil?
            d = d.parent
        end
        return d
    end

    def full_name
        parent_names = []
        p = self.parent
        while !p.nil?
            parent_names << p.name
            p = p.parent
        end
        parent_names.pop
        (parent_names.reverse + [name]).join('/')
    end
    

    def dir_sizes
        return {self.full_name => self.size}.tap do |v|
            dirs.map(&:dir_sizes).each{|ds| v.merge!(ds)}            
        end
    end
    
end


# if it's a cd, build out the filesystem

current_dir=nil
File.open('input.txt').each_line do |line|
    if line.start_with?('$')
        # new command
        params = line.split(' ')
        params.shift # remove the $
        if params[0] == 'cd'
            case params[1]
            when '..'
                current_dir= current_dir.parent      
            when '/'
                if current_dir.nil?
                    current_dir = Dir.new(params[1])
                else
                    current_dir = current_dir.root
                end                                    
            else
                current_dir = current_dir.get_child(params[1])
            end
        end
    elsif (line =~ /^\d+/) == 0
        #file
        tokens = line.split(' ')
        current_dir.touch!(tokens.last, tokens.first.to_i)
    elsif line.start_with?('dir')
        #dir
        tokens = line.split(' ')
        current_dir.mkdir(tokens.last)
    else
        puts "OOOPS #{line}"
    end
end

root = current_dir.root
sizes = root.dir_sizes
sorted_sizes = sizes.values.sort

puts "*** PART 1 ***"
puts sorted_sizes.select{|d| d<100000}.sum
puts


# part 2

puts "*** PART 2 ***"
total_size = root.size # 46552309
needed_space = 30000000 - (70000000 - total_size)
files_that_could_be_deleted = root.dir_sizes.select do |path, dsize|        
    dsize>needed_space
end
puts files_that_could_be_deleted.values.min








