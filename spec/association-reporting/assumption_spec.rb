require 'association-reporter/assumption'

describe AssociationReporter::Assumption do

  describe AssociationReporter::ColumnAssumption do
    it 'provides column as a guess' do
      col = described_class.new('articles', 'author_id')
      expect(col.guess).to eq('author_id')
    end

    it 'is valid for existing columns' do
      col = described_class.new('articles', 'author_id')
      expect(col).to be_valid
    end

    it 'is invalid for non-existent columns' do
      col = described_class.new('articles', 'foobar')
      expect(col).to_not be_valid
    end
  end

  describe AssociationReporter::AssociationAssumption do
    it 'provides the association name as a guess' do
      assoc = described_class.new(Article, :author)
      expect(assoc.guess).to eq(:author)
    end

    it 'is valid if the association is a method on the provided class' do
      assoc = described_class.new(Article, :author)
      expect(assoc).to be_valid
    end

    it 'is invalid if the association is not a method on the provided class' do
      assoc = described_class.new(Article, :foobar)
      expect(assoc).to_not be_valid
    end
  end

  describe AssociationReporter::ModelTableAssumption do
    it 'provides a table name as the guess' do
      table = described_class.new(Article)
      expect(table.guess).to eq('articles')
    end

    it 'is valid if the table exists' do
      table = described_class.new(Article)
      expect(table).to be_valid
    end

    it 'is invalid if the table does not exist' do
      NonExistent = Class.new
      table = described_class.new(NonExistent)
      expect(table).to_not be_valid
    end
  end

  describe AssociationReporter::ModelClassAssumption do
    it 'provides the class name as the guess' do
      model_class = described_class.new('Article')
      expect(model_class.guess).to eq('Article')
    end

    it 'provides the guessed class object if the class is defined' do
      model_class = described_class.new('Article')
      expect(model_class.klass_guess).to eq(Article)
    end

    it 'is valid if the class is defined' do
      model_class = described_class.new('Article')
      expect(model_class).to be_valid
    end

    it 'is invalid if the class is not defined' do
      model_class = described_class.new('FooBar')
      expect(model_class).to_not be_valid
    end
  end

end
