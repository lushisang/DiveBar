Template.userJourneyItem.events
  'click .right-box': ->
    Router.go "/post/detail?category=#{@category}&id=#{@_id}"