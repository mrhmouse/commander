second = 1000
minute = second * 60
hour = minute * 60
day = hour * 24
week = day * 7

module.exports = ( date ) ->
	diff = ( new Date ) - date
	[ unit, div ] = switch
		when diff >= week then [ 'weeks', week ]
		when diff >= day then [ 'days', day ]
		when diff >= hour then [ 'hours', hour ]
		when diff >= minute then [ 'minutes', minute ]
		else [ 'seconds', second ]
	diff /= div
	"#{ diff.toFixed 1 } #{ unit }"
