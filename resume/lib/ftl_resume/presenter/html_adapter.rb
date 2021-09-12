# html_adapter.rb
#

require 'erb'
module FTLResume
  module Presenter
    class Html

      def write_resumes(resume)
        @resume = resume
        open_files
        write_files
        close_files
      end

      def open_files
        @user = @resume.contact.name.downcase.gsub(/ /, '_')
        output_dir  = 'output'
        @long_file  = File.open(File.join(output_dir, "#{@user}_long.html"), 'w')
        @short_file = File.open(File.join(output_dir, "#{@user}_short.html"), 'w')
      end

      def write_files
        template = ERB.new(File.read('views/resume_html.erb'), trim_mode: '>')
        [ @long_file, @short_file ].each do |file|
          length = file.path.end_with?('_long.html') ? 'long' : 'short'
          file.puts template.result(binding)
        end
      end

      def close_files
        [ @long_file, @short_file ].each do |file|
          file.close()
        end
      end

    end

  end
end
