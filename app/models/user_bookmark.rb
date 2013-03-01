class UserBookmark < ActiveRecord::Base
  attr_accessible :playlist_name, :bookmark_name, :playlist_id, :bookmark_url_id, :bookmark_urls_attributes
  # validates_existence_of :bookmark_url
  # validates_existence_of :playlist
	belongs_to :bookmark_url
	belongs_to :playlist
  accepts_nested_attributes_for :bookmark_url
end
