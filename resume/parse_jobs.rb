#!/usr/bin/env ruby
#
# Notes from havenwood
# 1. DONE Can shorten line 4 a bit now that there's __dir__: 
#     $LOAD_PATH << File.expand_path('../lib/', __dir__)
# 2. DONE Not that it matters here, since the process ending closes the file 
#     descriptor, but the block form of File.open auto-closes on end.
# 3. NO DO it's faster to parse Array literal `[]` instead of Array.new.
#     My reply was that I use grep to find how I did things, and grep 
#     chokes on [].
# 4. DONE Normally I'd suggest extracting your Regexp to a constant. 
#     Creating it in a method causes object churn.
# 5. DONE I'd recommend replacing `return start_date, end_date` with: 
#     [start_date, end_date]
# 6. DONE (?) I'd probably one-line the if statements, like: return date if dates[0] == "present"
# 7. DONE #size to me signals a lazily calculated size, where #count often actually iterates to count.
# 8. [Leam: Not sure I understand this] you can put `year =` outside the if statement, and only do it once
# 9. OBE  I like: data.positive?

$VERBOSE = true

$LOAD_PATH << File.expand_path('../lib', __dir__)
require 'ftl_resume'

jobs        = Array.new
current_job = nil
in_job      = false
Date_re     = %r{\(\s*(.*) - (.*)\s*\)}

def set_dates(dates)
  d           = Date_re.match(dates)
  start_date  = long_years(d[1])
  end_date    = long_years(d[2]) 
  [ start_date, end_date ]
end

def long_years(date)
  dates = date.split(' ')
  return date if dates[0] == "present"
  if dates.size == 1
    year = dates[0].to_i
  else
    year  = dates[1].to_i
  end
  if year > 70 and year < 1900
    year += 1900
  elsif year < 70
    year += 2000
  end
  if dates.size == 1
    date = "#{year}"
  else
    date = "#{dates[0]} #{year}"
  end
end

data = Hash.new
jobs_file = 'input/leamhall_jobs.txt'
File.foreach(jobs_file) { |line|
  line.chomp!.strip!
  next if line.empty?
  if line.end_with?(')')
    data.clear
    header_array  = line.split(',')
    title         = header_array.shift
    dates         = header_array.pop
    start_date, end_date = set_dates(dates)
    employer      = header_array.join(' ').strip!
    data = {  start_date: start_date, end_date: end_date, 
              title: title, employer: employer }
    current_job   = FTLResume::Job.new(data)
    jobs << current_job
  elsif current_job.blurb.nil?
    line.gsub!(/  /, " ")
    current_job.blurb = line
  elsif current_job.tech.nil?
    current_job.tech  = line
  else
    current_job.extra = line
  end
}

# Storage
def get_year(date)
  year = date.split(/ /)[-1]
  year = 3000 if year == 'present'
  year
end

require 'json'
job_data = Hash.new
jobs.each { |j|
  key = get_year(j.start_date).to_s + get_year(j.end_date).to_s
  job_data[key] = j.to_h
}

job_file_json = File.open('input/jobs.json', 'w')
job_file_json.puts JSON.pretty_generate(job_data)
job_file_json.close()


