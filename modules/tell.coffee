module.exports = ( from, name, message... ) ->
	# If the user is already online, there's no
	# need to tell them.
	if name in @names
		@say "#{ name } is already here! Tell them yourself!"
		return

	cb = ( channel, nick ) =>
		return unless nick is name
		@say "#{ name }: Message from #{ from }: #{ message.join ' ' }"
		@_client.off 'join', cb

	@_client.on 'join', cb

	@say 'Consider it noted.'

	return
