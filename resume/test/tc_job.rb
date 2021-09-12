# test/tc_job.rb

$LOAD_PATH << File.expand_path('../lib', __dir__)

require "test/unit"
require "ftl_resume/job"

module FTLResume

  class TestJob < Test::Unit::TestCase
    
    def test_empty_data
      @job    = Job.new
      assert(@job.start_date  == 1961)
      assert(@job.end_date    == 2071)
      assert(@job.title       == 'Great guy')
      assert(@job.employer    == 'God')
      assert(@job.blurb       == nil)
      assert(@job.tech        == nil)
      assert(@job.extra       == nil)
    end

    def test_full_data
      data = {
        start_date: 1966,
        end_date:   'present',
        title:      'Adventurer',
        employer:   'Abba',
        blurb:      'Wandered the earth, doing my best.',
        tech:       'Whatever was at hand.',
        extra:      'Learned a lot.',
      }
      @job    = Job.new(data)
      assert(@job.start_date  == 1966) 
      assert(@job.end_date    == 'present')
      assert(@job.title       == 'Adventurer')
      assert(@job.employer    == 'Abba')
      assert(@job.blurb       == 'Wandered the earth, doing my best.')
      assert(@job.tech        == 'Whatever was at hand.')
      assert(@job.extra       == 'Learned a lot.')
    end
  end
end

