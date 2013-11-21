module.exports = ( times ) ->
	num = +times
	if isNaN num
		@say 'Quack!'
	else
		if num > 10
			@say "I'm not quacking #{ num } times..."
		else
			@say ( "quack" for i in [0...num] ).join ' '
