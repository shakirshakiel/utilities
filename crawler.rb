require 'fileutils'

def require_line?(line)
  line.include?("require(\".") or line.include?("require('.)")
end

def import_line?(line)
  line.include?("import") and (line.include?("from '") or line.include?("from \""))
end

def readFile(filename, visited, result)
  full_path = File.expand_path(filename)
  full_path += ".js" unless full_path.end_with? ".js"
  result << full_path

  File.readlines(full_path).each do |line|
    if require_line?(line) or import_line?(line)
        matchdata = nil
        
        if require_line?(line)
          matchdata = /require\(.(.*).\)/.match(line)          
        end
        
        if import_line?(line)
          matchdata = /from\s+['|"](.*)['|"]/.match(line)          
        end
        
        match = matchdata[1]
        cwd = Dir.pwd
        filename = match.split("/")[-1]
        directory_to_go = match.split("/")[0..-2].join("/")        
        if(!visited.include?(filename)) 
          Dir.chdir(File.expand_path(directory_to_go))
          visited << filename
          readFile(filename, visited, result)                 
          Dir.chdir(cwd)           
        end
    end
  end
  result
end

final = readFile(ARGV[0], [], []).sort
SOURCE_DIRECTORY = ARGV[1]
DESTINATION_DIRECTORY = ARGV[2]

result = {}
final.each do |l|
  relative_path = l.split("/")[7..-1].join("/")
  splits = relative_path.split("/")
  filename = splits[-1]
  directory = splits[0..-2].join("/")
  result[directory] ||= []
  result[directory] << filename
end
p result

result.keys.sort.each do |key|
  dir_path = File.join(DESTINATION_DIRECTORY, key)
  Dir.mkdir(dir_path) unless Dir.exists?(dir_path)
  files = result[key].uniq
  files.each do |file|
    source_file_path = File.join(SOURCE_DIRECTORY, key, file)
    destination_file_path = File.join(DESTINATION_DIRECTORY, key, file)
    p source_file_path
    p destination_file_path
    FileUtils.cp(source_file_path, destination_file_path)
  end
end


