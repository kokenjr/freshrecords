require 'jitai'
require 'rails'

module Jitai
  class Railtie < Rails::Railtie

=begin
    Don't think I need this anymore~
    initializer "jitai.initialization" do |app|
      app.middleware.use Jitai::Middleware
    end
=end

    rake_tasks do
      namespace :jitai do
        desc "hack"
        task :refresh do
          font_manager = Jitai::FontManager.new
          font_manager.refresh
        end
      end
    end
  end
end
