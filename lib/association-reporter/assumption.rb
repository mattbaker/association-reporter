require 'association-reporter'
require 'singleton'

module AssociationReporter
  class Assumption
    attr_reader :guess

    def label
      guess && guess.to_s.colorize(valid? ? :green : :red)
    end
  end

  class ColumnAssumption < Assumption
    def initialize(table_name, column)
      @table_name = table_name
      @column = column
      @guess = column
    end

    def valid?
      ActiveRecord::Base.connection.table_exists?(@table_name) &&
      ActiveRecord::Base.connection.column_exists?(@table_name, @column)
    end
  end

  class AssociationAssumption < Assumption
    def initialize(klass, association_name)
      @klass = klass
      @association_name = association_name
      @guess = association_name
    end

    def valid?
      @klass.method_defined?(@association_name)
    end
  end

  class ModelTableAssumption < Assumption
    def initialize(klass)
      @table = klass && klass.to_s.underscore.pluralize
      @guess = @table
    end

    def valid?
      @table && ActiveRecord::Base.connection.table_exists?(@table)
    end
  end

  class ModelClassAssumption < Assumption
    attr_reader :klass_guess

    def initialize(klass_name)
      @klass_name = klass_name
      @klass_guess = valid? ? Object.const_get(klass_name) : nil
      @guess = klass_name
    end

    def valid?
      @klass_name.present? && Object.const_defined?(@klass_name)
    end
  end

  class InvalidAssumption < Assumption
    include Singleton

    def valid?
      false
    end
  end

end
