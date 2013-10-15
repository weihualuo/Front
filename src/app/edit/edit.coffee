
angular.module('app.edit', [])

  .controller( 'EditCtrl', ($scope, Many, $routeParams, noRepeat, $timeout) ->

    model = Many('events')
#    $scope.$watch 'e', ->
#    if $scope.e
#      e = model.get $scope.e.id
#
    id = Number $routeParams.id
    $scope.isNew = if id then 1 else 0
    $scope.e = e = if id then model.get id else {}
  )

  .controller( 'formCtrl', ($scope, Many, $location, noRepeat) ->
    $scope.d = d = e = {}

    #Set default value
    imgsrc = "/m/img/noimage.gif"
    category = null
    $scope.$watch 'meta.ca', ->
      console.log "watch meta"
      d.category = category = $scope.meta.ca and $scope.meta.ca[0]

    $scope.$watchCollection 'e', ->
      # e = {}, or Restangular object or real object
      console.log "watch e"
      e = $scope.e or {}
      d.title = e.title
      d.category = e.category and _.find($scope.meta.ca, id:$scope.e.category) or category
      d.start_time = e.start_time and new Date(e.start_time).toLocaleString() or null
      d.end_time = e.end_time and new Date(e.end_time).toLocaleString() or null
      d.avenue = e.avenue
      d.description = e.description
      d.imgsrc = e.image and $scope.meta.imgbase + e.image.thumbnail2 or imgsrc

    $scope.onSubmit = ->
      if noRepeat('edit-submit',5000) and $scope.loginOrPopup()
        p = {}
        p.title = d.title
        p.category = d.category.id
        p.avenue = d.avenue
        p.description = d.description

        if e.id
          e.patch(p).then (ret)->
            _.extend e, ret
            $scope.goBack()
        else
          p.start_time = "2013-08-28T22:40:00Z"
          Many('events').new p, (ret)-> $location.path("/detail/"+ret.id)

  )