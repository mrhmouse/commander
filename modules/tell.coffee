messages = {}
hooked = no

elapsedSince = ( date ) ->
	unit = 'seconds'
	diff = (( new Date ) - date ) / 1000
	if diff > ( 4 * 60 )
		diff /= 60
		unit = 'minutes'

	if diff > ( 4 * 60 )
		diff /= 60
		unit = 'hours'

	if diff > ( 2 * 24 )
		diff /= 24
		unit = 'days'

	if diff > ( 2 * 7 )
		diff /= 7
		unit = 'weeks'

	return "about #{ diff.toFixed 1 } #{ unit }"

module.exports = ( from, name, message... ) ->
	# If the user is already online, there's no
	# need to tell them.
	if name in @names
		@say "#{ name } is already here! Tell them yourself!"
		return

	message =
		time: new Date
		from: from
		message: message.join ' '

	messages[name] ?= []
	messages[name].push message

	unless hooked
		hooked = yes
		@_client.on 'join', ( channel, nick ) ->
			return unless messages[nick]?.length
			for m in messages[nick]
				@say "#{ nick }: Message from #{ m.from } at " +
				"#{ elapsedSince m.time }: #{ m.message }"
			messages[nick] = []
			return

	@say 'Consider it noted.'

	return
