# Check the status of the Red Spider Project #
##############################################

GithubApi = require 'github'
REPO = 'the-red-spider-project'
USER = 'the-xkcd-community'

api = new GithubApi version: '3.0.0'
rsp =
	help: ( callback, action ) ->
		callback unless action? and action in actions
			"Please specify an action: #{ actions.join ', ' }"
		else
			switch action
				when 'issues'
					'List information on issues: issues [count | titles | assigned-to <name>]'
				when 'help'
					'Display help: help'
		return
	issues: ( callback, action, args... ) ->
		api.issues.repoIssues
			user: USER
			repo: REPO
			state: 'open'
			sort: 'updated'
			( error, data ) ->
				if error?
					callback error
					return

				switch action
					when 'count'
						{ length } = data
						callback if length is 0
							'There are no issues. Hooray!'
						else if length is 1
							'There is one issue.'
						else
							"There are #{ length } issues."
					when 'titles'
						callback "Issues: #{( "'#{ title }'" for { title } in data ).join ', ' }"
					when 'assigned-to'
						name = args?.pop()
						unless name?
							callback 'You must specify a name.'
						else
							issues = ( title for { title, assignee } in data when \
								assignee?.login is name )
							callback if issues.length is 0
								"No issues assigned to #{ name }."
							else
								"Issues: #{ issues.join ', ' }"
					else
						callback \
							"Unknown action '#{ action }'. Try one of: #{ actions.join ', ' }"
				return

actions = ( k for own k, v of rsp )

module.exports = ( from, action, args... ) ->
	unless action in actions
		@say "Invalid action '#{ action }'."
		return

	rsp[action] @say, args...

	return
