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
      ModelFactories.define_Article_with_valid_through_and_source
      assumption = described_class.new(Article.reflect_on_association(:hashtags))
      expect(assumption.through_name).to eq("taggings")
    end

    it "provides a source name" do
      ModelFactories.define_Article_with_valid_through_and_source
      assumption = described_class.new(Article.reflect_on_association(:hashtags))
      expect(assumption.source_name).to eq("tag")
    end

    context "with a valid through method" do
      before(:each) { ModelFactories.define_Article_with_valid_through_and_source }
      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "#valid_through_method? is true" do
        expect(assumption.valid_through_method?).to be(true)
      end
    end

    context "with an invalid through method" do
      before(:each) { ModelFactories.define_Article_with_invalid_through }
      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "#valid_through_method? is false" do
        expect(assumption.valid_through_method?).to be(false)
      end
    end

    context "with a valid through reflection" do
      before(:each) { ModelFactories.define_Article_with_valid_through_and_source }
      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "provides a through assumption" do
        expect(assumption.through_assumption).to be_a(AssociationReporter::AssociationAssumption)
      end
    end

    context "with an invalid through reflection" do
      before(:each) { ModelFactories.define_Article_with_invalid_through }
      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "provides a nil through assumption" do
        expect(assumption.through_assumption).to be(nil)
      end

      it "is invalid" do
        expect(assumption).to_not be_valid
      end
    end


    context "with a valid source reflection" do
      before(:each) { ModelFactories.define_Tagging_model }
      before(:each) { ModelFactories.define_Article_with_valid_through_and_source }

      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "provides a source assumption" do
        expect(assumption.source_assumption).to be_a(AssociationReporter::AssociationAssumption)
      end
    end

    context "with an invalid source reflection" do
      before(:each) { ModelFactories.define_Article_with_invalid_source }
      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "provides a nil source assumption" do
        expect(assumption.source_assumption).to be(nil)
      end

      it "is invalid" do
        expect(assumption).to_not be_valid
      end
    end

    context "with a valid through and source reflection" do
      before(:each) { ModelFactories.define_Tag_model }
      before(:each) { ModelFactories.define_Tagging_model }
      before(:each) { ModelFactories.define_Article_with_valid_through_and_source }

      let(:assumption) { described_class.new(Article.reflect_on_association(:hashtags)) }

      it "is valid" do
        expect(assumption).to be_valid
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

      describe "#valid_table?" do
        it "is false" do
          expect(assumption.valid_table?).to be(true)
        end
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

      describe "#valid_table?" do
        it "is false" do
          expect(assumption.valid_table?).to be(false)
        end
      end
    end
  end

  describe AssociationReporter::OneToManyAssociationAssumption do
    it "picks the current table for the fkey in a belongs to" do
      ModelFactories.define_Article_with_valid_belongs_to
      assumption = AssociationReporter::OneToManyAssociationAssumption
        .new(Article.reflect_on_association(:writer))

      expect(assumption.fkey_table).to eq("articles")
    end

    it "picks the other table for the fkey in a non-belongs-to" do
      ModelFactories.define_Article_with_has_many
      assumption = AssociationReporter::OneToManyAssociationAssumption
        .new(Article.reflect_on_association(:comments))

      expect(assumption.fkey_table).to eq("comments")
    end

    it "provides the foreign key column" do
      ModelFactories.define_Article_with_valid_belongs_to
      assumption = AssociationReporter::OneToManyAssociationAssumption
        .new(Article.reflect_on_association(:writer))

      expect(assumption.fkey_column).to eq(:author_id)
    end

    context "with a valid fkey table" do
      describe "#valid_fkey_table?" do
        it 'is true' do
          ModelFactories.define_Article_with_bad_fkey_good_model
          assumption = AssociationReporter::OneToManyAssociationAssumption
            .new(Article.reflect_on_association(:writer))

          expect(assumption.valid_fkey_table?).to be(true)
        end
      end
    end

    context "with an invalid fkey table" do
      before(:each) { ModelFactories.define_Article_with_bad_has_many_model }
      let(:assumption) do
        AssociationReporter::OneToManyAssociationAssumption
          .new(Article.reflect_on_association(:things_people_said))
      end

      describe "#valid_fkey_table?" do
        it 'is false' do
          expect(assumption.valid_fkey_table?).to be(false)
        end
      end

      it 'is invalid' do
        expect(assumption).to_not be_valid
      end
    end

    context "with a valid fkey column" do
      describe "#valid_fkey_column?" do
        it "is true" do
          ModelFactories.define_Article_with_good_fkey_bad_model
          assumption = AssociationReporter::OneToManyAssociationAssumption
            .new(Article.reflect_on_association(:writer))

          expect(assumption.valid_fkey_column?).to be(true)
        end
      end
    end

    context "with an invalid fkey column" do
      before(:each) { ModelFactories.define_Article_with_bad_fkey_good_model }
      let(:assumption) do
        AssociationReporter::OneToManyAssociationAssumption
            .new(Article.reflect_on_association(:writer))
      end

      describe "#valid_fkey_column?" do
        it "is false" do
          expect(assumption.valid_fkey_column?).to be(false)
        end
      end

      it 'is invalid' do
        expect(assumption).to_not be_valid
      end
    end

    context "with a valid association" do
      it "is valid" do
        ModelFactories.define_Article_with_valid_belongs_to
        assumption = AssociationReporter::OneToManyAssociationAssumption
          .new(Article.reflect_on_association(:writer))

        expect(assumption).to be_valid
      end
    end
  end
end
