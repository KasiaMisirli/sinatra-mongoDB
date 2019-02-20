class RatingQuestion
    include Mongoid::Document
    include Mongoid::Timestamps
    field :title, :type => String
    field :tag, :type => String
  end