class Playlist < ActiveRecord::Base
  attr_accessible :playlist_name, :user_id, :user_bookmarks_attributes, :bookmark_urls_attributes
  has_many :user_bookmarks
  has_many :bookmark_urls, :through => :user_bookmarks
  validates_existence_of :user
  belongs_to :user, :dependent => :destroy
  accepts_nested_attributes_for :user_bookmarks, :allow_destroy => :true
  accepts_nested_attributes_for :bookmark_urls
end
