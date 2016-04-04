require 'association-reporter'
require 'singleton'

module AssociationReporter
  class Assumption
    def initialize(reflection)
      @reflection = reflection
    end

    private
    attr_reader :reflection

    def labelize(str, cond)
      str && str.to_s.colorize(cond ? :green : :red)
    end
  end


  class HasManyThroughAssociationAssumption < Assumption
    def through_name
      reflection.options[:through]
    end

    def through_name_label
      valid = reflection.active_record.method_defined?(through_name)
      labelize(reflection.options[:through], valid)
    end

    def through_assumption
      reflection.through_reflection &&
      AssociationAssumption.new(reflection.through_reflection)
    end

    def source_name
      reflection.source_reflection_names.first.to_s
    end

    def source_label
      labelize(source_name, reflection.source_reflection)
    end

    def source_assumption
      reflection.source_reflection &&
      AssociationAssumption.new(reflection.source_reflection)
    end

    def valid?
      through_assumption.try(:valid?) && source_assumption.try(:valid?)
    end
  end

  class AssociationAssumption < Assumption
    def assoc_klass_name
      reflection.class_name
    end

    def assoc_klass
      begin
        return reflection.klass
      rescue NameError => e
        raise e if assoc_klass_name && !e.name.include?(assoc_klass_name)
      end
      nil
    end

    def assoc_klass_label
      labelize(assoc_klass_name, assoc_klass)
    end

    def assoc_table
      assoc_klass.try(:table_name) || assoc_klass_name.underscore.downcase.pluralize
    end

    def assoc_table_label
      labelize(assoc_table, valid_table?)
    end

    def valid_table?
      ActiveRecord::Base.connection.table_exists?(assoc_table)
    end

    def valid?
      valid_table? && assoc_klass
    end

    private
    attr_reader :reflection
  end

  class OneToManyAssociationAssumption < AssociationAssumption
    def fkey_table
      if reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
        table_name = reflection.active_record.table_name
      else
        table_name = assoc_table
      end
    end

    def fkey_table_label
      labelize(fkey_table, valid_fkey_table?)
    end

    def fkey_column
      reflection.foreign_key
    end

    def fkey_column_label
      labelize(fkey_column, valid_fkey_table? && valid_fkey_column?)
    end

    def valid_fkey_table?
      ActiveRecord::Base.connection.table_exists?(fkey_table)
    end

    def valid_fkey_column?
      ActiveRecord::Base.connection.column_exists?(fkey_table, fkey_column)
    end

    def valid?
      super && valid_fkey_table? && valid_fkey_column?
    end
  end
end
