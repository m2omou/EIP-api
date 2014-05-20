class Vote < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :publication_id, :user_id, :value
  belongs_to :user
  belongs_to :publication

  def as_json(options={})
    hash = super(except)
    begin
      hash[:publication] = {:like => self.publication.votes.where(:value =>  true).count,
                            :dislike => self.publication.votes.where(:value =>  false).count}
    rescue
      hash[:publication] = {:like => 0, :dislike => 0}
    end

    hash
  end

  def except
    { :except=>  [] }
  end
end
