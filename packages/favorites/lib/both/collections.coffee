@Favorites = new Meteor.Collection 'favorites'

Schemas.Favorites = new SimpleSchema
  doc:
    type:String
    regEx: SimpleSchema.RegEx.Id

  category:
    type:String

  user:
    type: String
    regEx: SimpleSchema.RegEx.Id

  createdAt: 
    type: Date
    autoValue: ->
      if this.isInsert
        new Date()

Favorites.attachSchema(Schemas.Favorites)