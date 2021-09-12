# text_adapter.rb
#
module FTLResume
  module Presenter
    class Text

      def write_resumes(resume)
        @resume = resume
        open_files
        write_contact
        write_jobs
      end
     
      def open_files
        @user       = @resume.contact.name.downcase.gsub(/ /, '_')
        output_dir  = 'output'
        @long_file  = File.open(File.join(output_dir, "#{@user}_long.txt"), "w")
        @short_file = File.open(File.join(output_dir, "#{@user}_short.txt"), "w")
      end 

      def write_contact
        #[@long_file, @short_file].each do |file|
        #  file.print ("%-20s %40s\n"  %  [@resume.contact.name, @resume.contact.email])
        #  file.print (" %60s\n"       %  [@resume.contact.code_repo] )
        #  file.print ("%-20s %40s\n"  %  [@resume.contact.phone, @resume.contact.linkedin] )
        #  file.puts  
        #  file.puts  
        #end
      end

      def write_jobs
        [@long_file, @short_file].each do |file|
          length = file.path.end_with?('_long.txt') ?  'long' : 'short'
          @resume.jobs.keys.each do |key|
            file.print ( "%s, %s (%s - %s) " % [
              @resume.jobs[key].title,
              @resume.jobs[key].employer,
              @resume.jobs[key].start_date,
              @resume.jobs[key].end_date,   ] )
            file.puts
            file.puts
            file.puts @resume.jobs[key].blurb if length == 'long'
            file.puts if length == 'long'
          end
        end
      end

      def close_files
        [@long_file, @short_file].each do |file|
          file.close()
        end
      end

    end
  end
end
