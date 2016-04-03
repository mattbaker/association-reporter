require 'spec_helper'
require 'association-reporter/reporter'

describe AssociationReporter::Reporter do
  describe '::one_to_many_assumptions' do
    let(:reflection) { Article.reflect_on_association(:comments) }
    let(:assumptions) { Article.one_to_many_assumptions(reflection) }

    it 'guesses the class on the other end of the association' do
      expect(assumptions[:assoc_class].klass_guess).to be(Comment)
    end

    it 'guesses the table on the other end of the association' do
      expect(assumptions[:assoc_class].table_guess).to eq('comments')
    end

    it 'guesses the table where the foreign key resides' do
      expect(assumptions[:fkey_class].table_guess).to eq('comments')
    end

    it 'guesses the name of the foreign key column' do
      expect(assumptions[:fkey_column].guess).to eq('article_id')
    end
  end

  describe '::many_to_many_assumptions' do
    let(:reflection) { Article.reflect_on_association(:tags) }
    let(:assumptions) { Article.many_to_many_assumptions(reflection) }

    it 'validates the present of the through association' do
      expect(assumptions[:through_assoc].guess).to be(:taggings)
    end

    it 'guesses the class on the other end of the association' do
      expect(assumptions[:through_class].klass_guess).to eq(Tagging)
    end

    it 'guesses the name of the source assoc' do
      expect(assumptions[:source_assoc].guess).to eq('tag')
    end

    it 'guesses the class the source leads to' do
      expect(assumptions[:source_class].klass_guess).to eq(Tag)
    end

    it 'guesses the name of the table the source leads to' do
      expect(assumptions[:source_class].table_guess).to eq('tags')
    end
  end
end
