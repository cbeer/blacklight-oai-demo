# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oai-demo_session',
  :secret      => '975c5479bf10355940b84a07a7a8382c0e0d87097b933ad3e334495bea0a31f2378cb8a5beaf8bf52dc11420ff9ec57ac3872f161391d3201aca5d7bec54e761'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
