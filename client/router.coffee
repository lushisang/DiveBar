Router.route '/', ->
  if Meteor.userId()
    @redirect '/note/list'
  else
    @redirect '/login'

Router.route '/login'

Router.route '/user/:id',
  name: 'user.detail'

Router.route '/note/list',
  name: 'note.list'
  controller: 'NoteListController'

Router.route '/note/detail/:id',
  name: 'note.detail'
  controller: 'NoteDetailController'

Router.route '/journey/list', ->
  @redirect '/journey/list/official'

Router.route '/journey/list/:category',
  name: 'journey.list.category'
  controller: 'JourneyListController'

Router.route '/journey/detail/:id',
  name: 'journey.detail'

Router.route '/product/list'

Router.route '/say/list'
