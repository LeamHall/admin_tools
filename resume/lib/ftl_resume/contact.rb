# Contact

module FTLResume
  class Contact

    attr_reader :name, :street, :phone, :email, :linkedin, :code_repo
    
    def initialize(data = {})
      @data = data
      parse_data
    end

    def parse_data
      @name       = @data.fetch(:name, nil)
      @street     = @data.fetch(:street, nil)
      @phone      = @data.fetch(:phone, nil)
      @email      = @data.fetch(:email, nil)
      @linkedin   = @data.fetch(:linkedin, nil)
      @code_repo  = @data.fetch(:code_repo, nil)  
    end

  end

end

