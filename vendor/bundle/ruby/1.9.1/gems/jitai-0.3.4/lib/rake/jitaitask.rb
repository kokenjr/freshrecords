#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'
require 'lib/jitai.rb'

module Jitai
  module Rake
    class JitaiTask < ::Rake::TaskLib
      attr_accessor :name
      attr_accessor :cwd

      def initialize(name = :kana)
        @name = name
        @cwd = "public/fonts/"
        
        yield self if block_given?
        define
      end

      def new
        initialize
      end
      
      def define
        desc "Sets the font directory for Jitai to operate."
        task "jitai:set" do
          # TODO kana should accept a directory argument
          @cwd = "public/fonts/"
        end

        desc "Refreshes the CSS files in the font directory"
        task "jitai:refresh" do
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
                puts "===== #{conversion_type.upcase} format not found.  Attempting to convert... ====="
                %x{cd lib/ttf2eot && ./ttf2eot < #{'../../' + @cwd + font_file} > #{'../../' + @cwd + font_file.split(".")[0] + conversion_type}}
              end
              
              # Rename files, account for conventions.
              %x{mv #{other_file} #{other_file.downcase}} if !(File.exists?(other_file.downcase))
              %x{mv #{file} #{file.downcase}} if !(File.exists?(file.downcase))

              font = Jitai::Font.new(font_file)
              font.to_css
            end
          end
        end
        
        self
      end
    end
  end
end
