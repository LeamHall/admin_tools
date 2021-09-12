# tc_contact.rb
#
$VERBOSE = true
$LOAD_PATH << File.expand_path('../lib', __dir__)

require 'test/unit'
require 'ftl_resume'

module FTLResume
  class TestContact < Test::Unit::TestCase

    def test_empty_data
      @contact = Contact.new
      assert(@contact.name      == nil)
      assert(@contact.street    == nil)
      assert(@contact.phone     == nil)
      assert(@contact.email     == nil)
      assert(@contact.linkedin  == nil)
      assert(@contact.code_repo == nil)
    end

    def test_full_data
      data = {
        name: 'Fred Flintstone',
        street: '123 Some Dirt Road',
        phone:  '555',
        email:  'fred@compuserve.com',
        linkedin: 'linkedin.com/fred',
        code_repo: 'github.com/fred',
      }
      @contact = Contact.new(data)
      assert(@contact.name      == 'Fred Flintstone')
      assert(@contact.street    == '123 Some Dirt Road')
      assert(@contact.phone     == '555')
      assert(@contact.email     == 'fred@compuserve.com')
      assert(@contact.linkedin  == 'linkedin.com/fred')
      assert(@contact.code_repo == 'github.com/fred')
    end

  end
end
