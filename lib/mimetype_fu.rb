require File.dirname(__FILE__) + '/extensions_const'
class File

  def self.mime_type?(file)
     if file.class == File
       unless RUBY_PLATFORM.include? 'mswin32'
         mime = `file -bir #{file.path}`.strip
       else
         mime = EXTENSIONS[File.extname(file.path).gsub('.','').downcase]
       end
     elsif file.class == String
       mime = EXTENSIONS[(file[file.rindex('.')+1, file.size]).downcase]
     elsif file.class == StringIO
       temp = File.open(Dir.tmpdir + '/upload_file.' + Process.pid.to_s, "wb")
       temp << file.string
       temp.close
       mime = `file -bir #{temp.path}`
       mime = mime.gsub(/^.*: */,"")
       mime = mime.gsub(/;.*$/,"")
       mime = mime.gsub(/,.*$/,"")
       File.delete(temp.path)
     end

     if mime
       return mime
     else
       'unknown/unknown'
     end
   end

  
  def self.extensions
    EXTENSIONS
  end
  
end