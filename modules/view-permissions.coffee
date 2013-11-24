module.exports = ( from, user ) ->
	unless user?
		@say "Usage: view-permissions <user>"
		return

	allowed = ( key for key, list of @permissions when user in list )
	@say "#{ user } has permissions for: #{ allowed }..."
	return
