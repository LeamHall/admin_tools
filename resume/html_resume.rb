#!/usr/bin/env ruby
$VERBOSE = true

require 'erb'

class Job
  attr_accessor :title, :employer
end

job1 = Job.new
job1.title    = "Programmer"
job1.employer = "Contractor"
job2 = Job.new
job2.title    = "Author"
job2.employer = "Self"
@jobs = Array.new
@jobs << job1
@jobs << job2

template = ERB.new(File.read('views/resume_html_long.erb'))
puts output = template.result()
