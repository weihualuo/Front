angular.module('app.detail', ['Service', 'app.edit'])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Many, $routeParams, noRepeat, $location) ->

    console.log 'DetailCtrl'
    model = Many('events')
    $scope.e = e = model.get $routeParams.id

    $scope.$watch 'e.title', -> $scope.setTitle e.title

    $scope.$watch 'e.starter', ->
      if $scope.meta.user and e.starter
        $scope.IamOwner = $scope.meta.user.id is e.starter.id
      console.log "IamOwner :"+$scope.IamOwner

    $scope.$watchCollection 'e.attendees', ->
      $scope.IamIn = Number Boolean $scope.meta.user and _.find(e.attendees, id:$scope.meta.user.id)
      console.log "IamIn :"+$scope.IamIn

    $scope.$on 'refresh', ->  model.get e.id, true

    $scope.onRegister = ->
      if noRepeat('register') and $scope.loginOrPopup()
        if $scope.IamIn
          e.customDELETE('attendees').then (d)-> e.attendees = d
        else
          e.post('attendees').then (d)-> e.attendees = d

    $scope.onShare = ->
      no
    $scope.onUpload = ->
      no
    $scope.onEdit = ->
      $location.path("/edit/"+e.id)

    comment = ""
    $scope.form = wbChecked:true, comment:comment

    $scope.onComment = ->

      if $scope.form.comment is comment then return

      if noRepeat('comment',5000) and $scope.loginOrPopup()
        comment = $scope.form.comment
        e.post('comments', body:comment).then (d)->
          e.comment_set.unshift(d)
          $scope.form.comment = ""

    $scope.onCommentDel = (id)->
      e.one('comments', id).remove().then ->
        comment = ""
        e.comment_set.splice _.findIndex(e.comment_set, id:id), 1

  )


  .run(  ->
    console.log 'detailrun'
  )
