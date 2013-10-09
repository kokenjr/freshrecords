module Jitai
  require 'jitai/railtie.rb' if defined?(Rails)

  class FontManager
    attr_accessor :css_path, :cwd
    
    def initialize(path= "public")
      @css_path = "#{path}/stylesheets/fonts.css"
      @cwd = "public/fonts/"
    end

    def refresh
      Dir.mkdir(@cwd) if !(File.directory? @cwd)
      Dir.foreach(@cwd) do |font_file|
        if !(File.directory?(font_file))

          # Search for two different formats                                                                                                                           
          conversion_type = (File.extname(font_file).downcase.eql? ".ttf")? ".eot" : ".ttf"
          other_basename = font_file.split(".")[0] + conversion_type
          other_file = "./#{@cwd}#{other_basename}"
          file = "./#{@cwd}#{font_file}"
          
          # TODO edit ttf2eot so that it's actually installed in the system
          if !File.exists?(other_file)
            puts "===== #{conversion_type.upcase} format not found for #{font_file}.  Attempting to convert... ====="

            # TODO Raise error
            %x{cd #{ttf2eot_dir} && ttf2eot < #{curr_dir + @cwd + font_file} > #{curr_dir + @cwd + font_file.split(".")[0] + conversion_type} && cd #{curr_dir}}
          end
          
          # Rename files, account for conventions.                                                                                                                   
          %x{mv #{other_file} #{other_file.downcase}} if !(File.exists?(other_file.downcase))
          %x{mv #{file} #{file.downcase}} if !(File.exists?(file.downcase))
          
          font = Jitai::Font.new(font_file)
          font.to_css
        end
      end
    end
  end

  class Font
    attr_accessor :name, :path

    def initialize(path)
      @name = path.downcase.split(".")[0]
      @path = path
    end

    def to_css
      # TODO WOFF url('/fonts/#{@name}.woff') format('woff'), /* Modern Browsers */
      # TODO SVG  url('/fonts/#{@name}.svg#svgFontName') format('svg'); /* Legacy iOS */
      
      css = "@font-face {
               font-family: '#{@name}';
               src: url('/fonts/#{@name}.eot'); /* IE9 Compat Modes */
               src: url('/fonts/#{@name}.eot?iefix') format('eot'), /* IE6-IE8 */
               url('/fonts/#{@name}.ttf')  format('truetype'), /* Safari, Android, iOS */
            }"

      # TODO make configurable for sinatra apps, etc
      manager = Jitai::FontManager.new
      find_font(manager.css_path, css)
    end

    def find_font(file, search_font)
      File.open(file, "w") if !File.exists?(file) # touch file

      in_file = false
      File.open(file) do |font|
        test = font.gets
        if !test.nil?
          return (in_file = true) if search_font.eql? test.strip
        end
      end

      unless in_file
        File.open(file, "a") do |f|
          f.puts search_font
          puts search_font
          puts "Was added to #{file}"
        end
      end
    end
  end
end
