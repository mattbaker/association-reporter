require 'spec_helper'
require 'association-reporter/reporter'

describe AssociationReporter::Reporter do
  describe '::one_to_many_description' do
    let(:reflection) { Article.reflect_on_association(:comments) }

    it "renders a report" do
      expect(Article.one_to_many_description(reflection)).to be_a(String)
    end
  end

  describe '::many_to_many_assumptions' do
    let(:reflection) { Article.reflect_on_association(:tags) }

    it "renders a report" do
      expect(Article.many_to_many_description(reflection)).to be_a(String)
    end
  end
end
