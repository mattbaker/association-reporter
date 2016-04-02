require 'spec_helper'
require 'association-reporter/template'

describe AssociationReporter::Template do
  let(:test_template_dir) { File.join(AssociationReporter::PROJECT_ROOT, 'spec', 'templates') }

  describe '::renders' do
    it "renders templates with variables" do
      data = {person: "world", location: "chicago"}
      expect(AssociationReporter::Template.new(data)
        .render('test.erb', test_template_dir)).to eq("Hello world! Welcome to chicago.\n")
    end
  end
end
