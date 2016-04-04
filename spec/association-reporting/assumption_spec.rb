require 'association-reporter/assumption'
require 'factories/model-factories'

describe AssociationReporter::Assumption do
  before(:all) do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'spec/test.db'
    )
    ActiveRecord::Migration.verbose = false
    ModelFactories::CreateTestTables.migrate(:up)
  end

  after(:all) do
    ModelFactories::CreateTestTables.migrate(:down)
  end

  describe AssociationReporter::HasManyThroughAssociationAssumption do
    it "provides the through name" do
    end

    context "with a valid through reflection" do
      it "provides a through assumption" do
      end
    end

    context "with an invalid through reflection" do
      it "provides a nil through assumption" do
      end

      it "is invalid" do
      end
    end

    it "provides a source name" do
    end

    context "with a valid source reflection" do
      it "provides a source assumption" do
      end
    end

    context "with an invalid source reflection" do
      it "provides a nil source assumption" do
      end

      it "is invalid" do
      end
    end

    context "with a valid through and source reflection" do
      it "is valid" do
      end
    end
  end

  describe AssociationReporter::AssociationAssumption do
    before(:each) { ModelFactories.define_User_model }

    context "with a valid associated class" do
      before(:each) { ModelFactories.define_Article_with_valid_belongs_to }
      let(:assumption) { described_class.new(Article.reflect_on_association(:writer)) }

      it "provides the class" do
        expect(assumption.assoc_klass).to be(User)
      end

      it "provides the class name" do
        expect(assumption.assoc_klass_name).to eq("User")
      end

      it "provides a table name" do
        expect(assumption.assoc_table).to eq("users")
      end

      it "is valid" do
        expect(assumption).to be_valid
      end
    end

    context "with an invalid associated class" do
      before(:each) { ModelFactories.define_Article_with_good_fkey_bad_model }
      let(:assumption) { described_class.new(Article.reflect_on_association(:writer)) }

      it "provides nil for the class" do
        expect(assumption.assoc_klass).to be(nil)
      end

      it "provides the class name" do
        expect(assumption.assoc_klass_name).to eq("Writer")
      end

      it "guesses a table name" do
        expect(assumption.assoc_table).to eq("writers")
      end

      it "is invalid" do
        expect(assumption).to_not be_valid
      end
    end
  end

  describe AssociationReporter::OneToManyAssociationAssumption do
    it "picks the current table for the fkey in a belongs to" do
    end

    it "picks the other table for the fkey in a non-belongs-to" do
    end

    it "provides the foreign key column" do
    end

    it "validates if the fkey table exists" do
    end

    it "validates if the fkey column exists" do
    end

    it "is valid if the fkey table and column are present" do
    end

    it "is invalid if the fkey table is not present" do
    end

    it "is invalid if the fkey column is not present" do
    end
  end
end
