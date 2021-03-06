Template.registerHelper 'Favorites', (collection) ->
  # TODO 改进
  if typeof window['Favorites'] != 'undefined'
    Favorites = []
    favorites = window['Favorites'].find({user: Meteor.userId()},{sort: {createdAt: -1}}).fetch()
    collection = window[collection]

    _.each favorites, (favorite)->
      Favorites.push(collection.findOne({_id:favorite.doc})) if collection.findOne({_id:favorite.doc})
    Favorites

Template.registerHelper 'favoriteCount', (_id)->
  if typeof window['Favorites'] != 'undefined'
    Favorites.find({doc:_id}).fetch().length

Template.registerHelper 'isFavoriteByMe', (_id)->
  if (typeof window['Favorites'] != 'undefined') and Meteor.userId()
    return Favorites.find({doc: _id, user: Meteor.userId()}).count() > 0
  return false

Template.registerHelper 'highlightIfFavoriteByMe', (_id)->
  if (typeof window['Favorites'] != 'undefined') and Meteor.userId()
    return Favorites.find({doc: _id, user: Meteor.userId()}).count() > 0 and 'highlight' or ''
  return ''

Template.registerHelper 'orderByFavorites', (docs)->
  if typeof window['Favorites'] != 'undefined' and typeof docs != 'undefined'
    _.sortBy docs, (doc) ->
      -1 * Favorites.find({doc:doc._id}).fetch().length