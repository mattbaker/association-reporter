require 'association-reporter/assumption'

describe AssociationReporter::Assumption do

  describe AssociationReporter::HasManyThroughAssociationAssumption do
  end

  describe AssociationReporter::AssociationAssumption do
    it 'provides the associated class name' do
    end

    context "with a valid associated class" do
      it "provides the class" do
      end
    end

    context "with an invalid associated class" do
      it "provides nil for the class" do

      end
    end
  end

  describe AssociationReporter::OneToManyAssociationAssumption do
  end

end
