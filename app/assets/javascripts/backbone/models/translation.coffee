class Analytics.Models.Translation extends Backbone.Model

  urlRoot: () ->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + "/translations"
    else
      "/template/translations"

  toJSON: () ->
    json = {translation: @attributes}
    delete json.translation["created_at"]
    delete json.translation["updated_at"]
    json