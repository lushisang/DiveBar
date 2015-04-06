@UserListController = ContentController.extend
  onAfterAction: ->
    selector = pq(@)
    selector.category = 'user'
    subManager.subscribe "userList", selector, getListLimit(selector).get(), -> gbl()["loadingMore"].set false
    subscribeMyFavorites()
  data: ->
    selector = pq(@)
    data = _.clone selector
    selector.category = 'user'
    selector = selectFavorites(selector)
    selector = _.omit selector, 'category'
    data.list = Users.find selector
    data.itemTemplate = 'userListItem'
    return noTransition data