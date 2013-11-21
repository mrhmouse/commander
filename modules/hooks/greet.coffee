greetings = []

module.exports =
	init: ->
		@_client.on 'join', ( channel, nick ) =>
			return unless nick in greetings
			@say "Welcome, #{ nick }!"
			return
		return

	add: ( names... ) ->
		greetings.push name for name in names when name not in greetings
		@say "I'll greet #{ names.join ', ' }..."
		return

	remove: ( names... ) ->
		greetings = ( n for n in greetings when n not in names )
		@say "I won't greet #{ names.join ', ' }..."
		return
