#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'json'
require 'optparse'
require 'ftl_resume'

options = Hash.new
options[:contact_file]  = 'input/contact.json'
options[:job_file]      = 'input/jobs.json'

parser  = OptionParser.new do |opts|
  program_name  = File.basename($PROGRAM_NAME)
  opts.banner   = "Build your resume files."
  opts.on( '-j', '--jobs <job file>', 'Job file. Defaults to input/jobs.json') do |j|
    options[:job_file]      = j
  end
  opts.on( '-c', '--contact <contact file>', 'Contact information file. Defaults to input/contact.json') do |c|
    options[:contact_file]  = c
  end
end
parser.parse!

job_file              = File.read(options[:job_file])
contact_file          = File.read(options[:contact_file])
resume_data           = Hash.new
resume_data[:jobs]    = JSON.parse(job_file, symbolize_names: true)
resume_data[:contact] = JSON.parse(contact_file, symbolize_names: true)

resume_builder        = FTLResume::Builder.new(resume_data)
text_presenter        = FTLResume::Presenter.adapter_for(:text)
text_presenter.write_resumes(resume_builder)

html_presenter        = FTLResume::Presenter.adapter_for(:html)
html_presenter.write_resumes(resume_builder)
