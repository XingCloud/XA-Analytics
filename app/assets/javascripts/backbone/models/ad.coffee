
class Analytics.Models.Ad extends Backbone.Model

  initialize: (options) ->

  urlRoot: () ->
    "/projects/"+Instances.Models.project.id+'/ads'