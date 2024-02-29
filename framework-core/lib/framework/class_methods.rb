module Framework
  module ClassMethods
    # Application root
    def root
      Bundler.root
    end

    # Default logger
    def logger
      Logger
    end
  end

  extend ClassMethods
end
