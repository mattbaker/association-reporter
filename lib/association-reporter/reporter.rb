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
        puts many_to_many_description(reflection)
      else
        puts one_to_many_description(reflection)
      end
    end

    def many_to_many_description(reflection)
      template_vars = {
        reflection: reflection,
        assumption: AssociationReporter::HasManyThroughAssociationAssumption.new(reflection)
      }
      AssociationReporter::Template.render('many_to_many.erb', template_vars)
    end

    def one_to_many_description(reflection)
      template_vars = {
        reflection: reflection,
        assumption: AssociationReporter::OneToManyAssociationAssumption.new(reflection)
      }

      AssociationReporter::Template.render('one_to_many.erb', template_vars)
    end

  end
end
