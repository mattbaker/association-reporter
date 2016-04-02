require 'colorize'
require 'association-reporter'
require 'association-reporter/template'
require 'association-reporter/assumption'

module AssociationReporter
  module Reporter

    def describe(association)
      reflection = self.reflect_on_association(association)
      raise "Can't find an association #{self.name}##{association}" if reflection.nil?

      if reflection.is_a? ActiveRecord::Reflection::ThroughReflection
        puts describe_m2m(reflection)
      else
        puts describe_o2m(reflection)
      end
    end

    def describe_o2m(reflection)
      describe_assumptions('../templates/one_to_many.erb',
        reflection,
        one_to_many_assumptions(reflection))
    end

    def describe_m2m(reflection)
      describe_assumptions('../templates/many_to_many.erb',
        reflection,
        many_to_many_assumptions(reflection))
    end

    def describe_assumptions(template, reflection, assumptions)
      template_values = {
        model_class_name: self.to_s,
        reflection: reflection,
        valid_association: assumptions.values.all?(&:valid?)
      }

      AssociationReporter::Template.render(template, template_values.merge(assumptions))
    end

    def one_to_many_assumptions(reflection)
      assoc_class = AssociationReporter::ModelClassAssumption.new(reflection.class_name)
      assoc_table = AssociationReporter::ModelTableAssumption.new(reflection.class_name)
      fkey_table = AssociationReporter::ModelTableAssumption.new(one_to_many_fkey_model(reflection))
      fkey_column = AssociationReporter::ColumnAssumption.new(fkey_table.guess, reflection.foreign_key)

      {
        assoc_class: assoc_class,
        assoc_table: assoc_table,
        fkey_table: fkey_table,
        fkey_column: fkey_column
      }
    end

    def many_to_many_assumptions(reflection)
      through_assoc = AssociationReporter::AssociationAssumption.new(self, reflection.options[:through])
      through_class = AssociationReporter::ModelClassAssumption.new(reflection.through_reflection.try(:class_name))
      if through_class.valid?
        source_assoc = AssociationReporter::AssociationAssumption.new(through_class.klass_guess, source_name(reflection))
        if source_assoc.valid?
          source_class = AssociationReporter::ModelClassAssumption.new(reflection.class_name)
          source_table = AssociationReporter::ModelTableAssumption.new(reflection.class_name)
        end
      end

      {
        through_assoc: through_assoc,
        through_class: through_class,
        source_assoc: source_assoc || AssociationReporter::InvalidAssumption.instance,
        source_class: source_class || AssociationReporter::InvalidAssumption.instance,
        source_table: source_table || AssociationReporter::InvalidAssumption.instance
      }
    end

    def source_name(reflection)
      reflection.source_reflection_names.first.to_s
    end

    def one_to_many_fkey_model(reflection)
      if reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
        self.to_s
      else
        reflection.class_name
      end
    end
  end
end
