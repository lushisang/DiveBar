
@initPostSchema = ->

  Schemas.post = new SimpleSchema

    category:
      type: String
      label: '分类'
      defaultValue: 'post'

    user:
      type: String
      label: '作者'
      regEx: SimpleSchema.RegEx.Id
      autoValue: ->
        if @isInsert
          myId()
      autoform:
        options: ->
          _.map Users.find().fetch(), (user)->
            label: user.emails[0].address
            value: user._id

    createdAt:
      type: Date
      autoValue: ->
        if @isInsert
          new Date()

    updatedAt:
      type: Date
      optional:true
      autoValue: ->
        if @isUpdate
          new Date()

    title:
      type: String
      label: '标题'
      max: 20
      autoform:
        placeholder: '标题...'

    content:
      type: String
      label: '内容'
      optional: true
      max: 1000
      autoform:
        rows: 6
        placeholder: '这一刻想发表什么...'

    images:
      type: [String]
      label: '图片集（七牛云图片key）'
      optional: true
      defaultValue: []

    viewCount:
      type: Number
      label: '阅读数'
      defaultValue: 0
      optional: true