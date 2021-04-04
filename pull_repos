#!/usr/bin/env ruby

class Repo
  def initialize(line)
		@start_dir		= Dir.pwd
		@base_dir			= @start_dir
		@repo_dir  		= '/home/backup/leam/lang/git/'
    @line 				= line
		@line_array 	= line.split('/')
		@git_index  	= @line_array.index('.git')
		if @git_index > 1
			create_dir 
		end
		get_repo
	end

	def create_dir
		dir = @line_array[1...@git_index -1].join('/')
		if dir.length > 0 
			@base_dir = dir
			Dir.mkdir dir unless Dir.exist?(dir)
		end
	end

	def get_repo
		url = ''
		file_with_path = @repo_dir + @line
		File.open(file_with_path, 'r').each_line {|line|
			line = line.strip()   
			if line.start_with?('url = ')
				line_array = line.split()
				url = line_array[-1]
			end
		}
		Dir.chdir(@base_dir)
		config_file = "#{@base_dir}/.git/config"
		unless File.exist?(config_file)
			system "git clone #{url}"
		end
		Dir.chdir(@start_dir)
	end
end

####

repo_file  = 'repo.list'
File.open(repo_file, 'r').each_line {|line|
  line = line.strip()
  repo = Repo.new(line)
}

