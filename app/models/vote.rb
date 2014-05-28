class Vote < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :publication_id, :user_id, :value

  # associations
  belongs_to :user
  belongs_to :publication

  # validations
  validates :publication_id, :presence => {:message => "Please specify the publication_id"}, :allow_blank => false
  validates_inclusion_of :value, :in => [true, false], :message => "Please specify true or false"
end
