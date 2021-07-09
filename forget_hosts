#!/usr/bin/env ruby

# Used to remove hosts from the .ssh/known_hosts file.
# Still needs work.

# forget_hosts host1 host2 host3

hosts = ARGV
abort("Need host names.") if hosts.empty?

require 'date'
require 'fileutils'

date_stamp  = Date.today.strftime("%Y%m%d")

known_hosts_file        = [Dir.home, '.ssh', 'known_hosts'].join('/')
known_hosts_file_backup = [known_hosts_file, date_stamp].join('.')

FileUtils.cp(known_hosts_file, known_hosts_file_backup)

File.open(known_hosts_file, 'w') { |out|
  File.open(known_hosts_file_backup, 'r').each { |line|
    line_array  = line.split()
    host        = line_array[0].split(',')[0]
    unless hosts.include?(host)
      out << line
    end
  }
}

File.chmod(0644, known_hosts_file, known_hosts_file_backup)
