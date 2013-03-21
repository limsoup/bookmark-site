# Be sure to restart your server when you modify this file.

BookmarkSite::Application.config.session_store :cookie_store, {
	key: '_pp5_session',
	:expire_after => 60*60*24*365,
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# BookmarkSite::Application.config.session_store :active_record_store
