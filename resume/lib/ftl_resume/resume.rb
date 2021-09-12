# resume.rb
$VERBOSE = true

module FTLResume

  class Resume
    require 'json'
    require 'ftl_resume/job'
    require 'erb'

    attr_reader 
    def initialize(options)
      @options  = options
      parse_jobs(@options[:job_file]) if @options[:job_file]
      parse_contact(@options[:contact_file]) if @options[:contact_file]
    end

    def parse_contact(file)
      contact_file  = File.read(file)
      @contact     = Contact.new(JSON.parse(contact_file, symbolize_names: true))
    end

    def write_contact(mode)
      if mode == "txt"
        write_contact_txt
      end
    end

    def write_contact_txt
      length  = 80
      name    = @contact.name
      @file.puts "#{name}"
    end

    def parse_jobs(file)
      job_file  = File.read(file)
      @jobs     = JSON.parse(job_file, symbolize_names: true)
    end

    def write_resume(mode, outfile, length)
      @file     = File.open(outfile, 'w')
      #write_contact(mode)
      write_jobs(mode, outfile, length)
    end

    def write_jobs(mode, outfile, length)
      @mode     = mode
      @length   = length
      @job_list = Array.new
      @jobs.keys.each { |k|
        j = Job.new(@jobs[k])
        @job_list << j
      }

      @job_list.each { |job|
        if @mode == "txt" 
          write_job_text(job)
        else
          write_job_html(job)
        end
      }
      @file.close
    end

    def write_job_text(job)
      @file.puts "#{job.title}  #{job.employer} (#{job.start_date} - #{job.end_date})\n"
      @file.puts "\n#{job.blurb}\n\n" if @length == "long"
    end

    def write_job_html(job)
      @file.puts "<br><b>#{job.title}</b>: #{job.employer} (#{job.start_date} - #{job.end_date})"
      @file.puts "<p>#{job.blurb}</p>" if @length == "long"
    end
  end

end
