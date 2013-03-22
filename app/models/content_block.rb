class ContentBlock < ActiveRecord::Base
	attr_accessible :type, :content
  serialize :content
	belongs_to :page
end