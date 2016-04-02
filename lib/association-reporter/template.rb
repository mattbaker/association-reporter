require 'association-reporter'
require 'ostruct'
require 'erb'

module AssociationReporter
  class Template < OpenStruct
    def render(template, template_directory=AssociationReporter::TEMPLATES)
      templ_string = File.read(File.join(template_directory, template))
      ERB.new(templ_string, 0, '-').result(binding)
    end

    def self.render(template, locals)
      Template.new(locals).render(template)
    end

    def association_name(reflection)
      case reflection
      when ActiveRecord::Reflection::HasManyReflection
        "has_many"
      when ActiveRecord::Reflection::BelongsToReflection
        "belongs_to"
      when ActiveRecord::Reflection::HasOneReflection
        "has_one"
      when ActiveRecord::Reflection::ThroughReflection
        "has_many :through"
      else
        ""
      end
    end
  end
end
