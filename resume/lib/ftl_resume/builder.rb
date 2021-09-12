# builder.rb
#
module FTLResume
  class Builder

    attr_reader :contact, :jobs

    def initialize( data = nil )
      @data     = data if data
      @contact  = FTLResume::Contact.new(@data[:contact]) 
      @job_info = @data[:jobs]
      sort_jobs
    end

    def sort_jobs
      @jobs = Hash.new
      @job_info.keys.each do |job|
        @jobs[job] = Job.new(@job_info[job])
      end
      @jobs
    end

  end
end

