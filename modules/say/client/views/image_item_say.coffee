Template.imageItemSay.helpers
  firstPicture: -> imageUrl @images?[0], {mode: 2, w: screen.width, h: screen.width * 0.8, q: 100}
  secondPicture: -> imageUrl @images?[1], {mode: 2, w: screen.width, h: screen.width * 0.8, q: 100}
Template.imageItemSay.events
  'click .item-say': -> Router.go "/post/detail?category=#{@category}&id=#{@_id}"
  'click .item-say .user': (event)->
    event.stopImmediatePropagation()
    Router.go userUrl(@user)