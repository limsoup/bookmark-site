class BookmarkUrl < ActiveRecord::Base
  attr_accessible :url
  has_many :user_bookmarks
  has_many :playlists, :through => :user_bookmarks
end