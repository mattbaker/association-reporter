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
  end
end
