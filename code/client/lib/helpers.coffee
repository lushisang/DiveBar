@qiniuImageInfo = (key, info, callback)->
  if info and key and Qiniu and qiniuConfig.DOMAIN
    info.src = Qiniu.getUrl(key)
    HTTP.get (info.src + '?imageInfo'), (error, result)->
      if error
        console.log error
      else if result.statusCode is 200
        info.w = result.data.width
        info.h = result.data.height
        callback and (callback info)

@subscribeMyFavorites = ->
  subsManager.subscribe 'favoritesByUser', myId()

@currentRoute = ->
  current = Router.current()
  current and current.route and current.route.getName() or ''

@currentRouteQuery = ->
  current = Router.current()
  current and current.getParams().query or {}

@currentLocation = -> Iron.Location.get()

@currentPath = -> currentLocation().path

@currentUrl = -> Meteor.absoluteUrl currentPath().slice(1)

@getListLimit = (selector)->
  sel = JSON.stringify selector
  category = sel.category
  if not getConfigs(category)["listLimit_#{sel}"]
    getConfigs(category)["listLimit_#{sel}"] = new ReactiveVar 10
  return getConfigs(category)["listLimit_#{sel}"]

@back = ->
  window.history.back();
  $('[data-nav-container]').addClass 'nav-view-direction-back'
  $('[data-navbar-container]').addClass 'nav-bar-direction-back'

@showPhotoSwipe = (container, index, imageInfos)->
  options = {index: index}
  gallery = new PhotoSwipe container, PhotoSwipeUI_Default, imageInfos, options
  gallery.init()

Template.registerHelper 'users', -> Users

Template.registerHelper 'isMe', (userId)-> isMe(userId or @user)

Template.registerHelper "absoluteUrl", (path)-> Meteor.absoluteUrl path

Template.registerHelper "currentRoute", -> currentRoute()

Template.registerHelper "currentRouteIs", (name)-> currentRoute() is name

Template.registerHelper "activeRoute", (name)-> (currentRoute() is name) and 'active' or ''

Template.registerHelper 'dateString', (date, format)-> (typeof format is 'string') and dateString(date, format) or dateString(date)

Template.registerHelper 'hasElement', (array)-> hasElement array

Template.registerHelper 'firstOne', (array)-> if hasElement array then array[0] else ''

Template.registerHelper 'userName', (userId)-> userName userId

Template.registerHelper 'userUrl', (userId)-> userUrl userId

Template.registerHelper 'avatarUrl', (userId)-> avatarUrl userId

Template.registerHelper 'imageUrl', (image)-> imageUrl image

Template.registerHelper 'mergeItemTemplate', (itemTemplate)-> _.extend @, {itemTemplate: itemTemplate}

Template.registerHelper 'userPrefix', (userId, showName, isFavorite)-> userPrefix(userId, showName, isFavorite)

Template.registerHelper 'postCategories', -> _.values PostCategory

Template.registerHelper 'postCategoryLabel', (category)-> postCategoryLabel category

Template.registerHelper 'commentCount', (doc)-> Counts.get getCommentCountName(doc)

