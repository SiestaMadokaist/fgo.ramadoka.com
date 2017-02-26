module ERR

  class << self
    # @param options [Hash]
    # @option fpath [String]
    # path to error-code json file
    def config!(options = {})
      @options = options
    end

    def error_definitions
      @error_definitions ||= _error_definitions
    end

    def fpath
      @options[:fpath]
    end

    def configured?
      not @options.nil?
    end

    def _error_definitions
      errors = YAML.load_file(@options[:fpath])
      error_pairs = errors.map{|error| [error["name"], error]}

      Hashie::Mash[Hash[error_pairs]]
    end
  end
  class CustomError < StandardError

    def self.inherited(subclass)
      if(ERR.configured?)
        sname = subclass.name
        if(ERR.error_definitions[sname].nil?)
          fpath = ERR.fpath
          message = "#{subclass.name} isn`t defined in standard yml at `#{fpath}`"
          raise CustomError, message
        end
      end
    end

    def self.definition
      ERR.error_definitions[name]
    end

    def definition
      self.class.definition
    end

    def self.code
      definition[:code]
    end

    def code
      self.class.code
    end

    def self.desc
      [http_code, name, ERR::Presenter]
    end

    def desc
      self.class.desc
    end

    def self.http_code
      code / 1000
    end

    def http_code
      self.class.code
    end

    # TODO
    def self.message
      self.name
    end

  end

  class ServerError503 < CustomError;end

  class Forbidden403 < CustomError; end

  class NoAuthorization401 < CustomError; end

  class NotFound404 < CustomError; end
end

require File.expand_path("../entity", __FILE__)
