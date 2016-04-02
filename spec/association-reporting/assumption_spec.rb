require 'association-reporter/assumption'

describe AssociationReporter::Assumption do

  describe AssociationReporter::ColumnAssumption do
    it 'provides column as a guess' do
    end

    it 'is valid for existing columns' do
    end

    it 'is invalid for non-existent columns' do
    end
  end

  describe AssociationReporter::AssociationAssumption do
    it 'provides the association name as a guess' do
    end

    it 'is valid if the association is a method on the provided class' do
    end

    it 'is invalid if the association is not a method on the provided class' do
    end
  end

  describe AssociationReporter::ModelTableAssumption do
    it 'provides a table name as the guess' do
    end

    it 'is valid if the table exists' do
    end

    it 'is invalid if the table does not exist' do
    end
  end

  describe AssociationReporter::ModelClassAssumption do
    it 'provides the class name as the guess' do
    end

    it 'provides the guessed class object if the class is defined' do
    end

    it 'is valid if the class is defined' do
    end

    it 'is invalid if the class is not defined' do
    end
  end

end
