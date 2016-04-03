require 'association-reporter/assumption'

describe AssociationReporter::Assumption do

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
    it "provides the associated class name" do
    end

    context "with a valid associated class" do
      it "provides the class" do
      end

      it "provides a table name" do
      end
    end

    context "with an invalid associated class" do
      it "provides nil for the class" do

      end

      it "guesses a table name" do
      end

      it "is invalid" do
      end
    end

    context "with an invalid table" do
      it "is invalid" do
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
