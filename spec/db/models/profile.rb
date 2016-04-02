class Profile < ActiveRecord::Base
  extend AssociationReporter::Reporter
  belongs_to :user
end
