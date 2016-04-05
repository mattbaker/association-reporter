require 'spec_helper'
require 'association-reporter/reporter'

describe AssociationReporter::Reporter do
  before(:all) do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'spec/test.db'
    )
    ActiveRecord::Migration.verbose = false
    ModelFactories::CreateTestTables.migrate(:up)
    ModelFactories.define_all_models
  end

  after(:all) do
    ModelFactories::CreateTestTables.migrate(:down)
  end

  describe '::one_to_many_description' do
    let(:reflection) { Article.reflect_on_association(:comments) }

    it "renders a report" do
      expect(Article.one_to_many_description(reflection)).to be_a(String)
    end
  end

  describe '::many_to_many_assumptions' do
    let(:reflection) { Article.reflect_on_association(:hashtags) }

    it "renders a report" do
      expect(Article.many_to_many_description(reflection)).to be_a(String)
    end
  end
end
