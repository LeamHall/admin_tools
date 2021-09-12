#!/usr/bin/env ruby
$ERBOSE = true

# test/ts_resume.rb
# Runs all tests in the test_dir

$LOAD_PATH << File.expand_path('../lib', __dir__)
$LOAD_PATH << File.expand_path('../test', __dir__)

require 'test/unit'
require 'ftl_resume'

Dir.glob("test/tc_*").each { |file|
  require File.basename(file)
}

