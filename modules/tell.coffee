messages = {}
hooked = no

elapsedSince = do ->
	second = 1000
	minute = second * 60
	hour = minute * 60
	day = hour * 24
	week = day * 7
	( date ) ->
		diff = ( new Date ) - date
		[ unit, div ] = switch
			when diff >= week then [ 'weeks', week ]
			when diff >= day then [ 'days', day ]
			when diff >= hour then [ 'hours', hour ]
			when diff >= minute then [ 'minutes', minute ]
			else [ 'seconds', second ]
		diff /= div
		"#{ diff.toFixed 1 } #{ unit }"

module.exports = ( from, name, message... ) ->
	# If the user is already online, there's no
	# need to tell them.
	if @names[name]?
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
		@_client.on 'join', ( channel, nick ) =>
			for m in messages[nick]
				@say "#{ nick }: Message from #{ m.from } " +
				"about #{ elapsedSince m.time } ago: #{ m.message }"
			messages[nick] = []
			return

	@say 'Consider it noted.'

	return
