angular.module('app.detail', ['Service'])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Many, $routeParams, noRepeat) ->
    model = Many('events')
    $scope.e = model.get $routeParams.id

    $scope.$watch 'e.title', -> $scope.setTitle $scope.e.title

    $scope.$watch 'e.starter', ->
      if $scope.meta.user and $scope.e.starter
        $scope.IamOwner = $scope.meta.user.id is $scope.e.starter.id
      console.log "IamOwner :"+$scope.IamOwner

    $scope.$watchCollection 'e.attendees', ->
      $scope.IamIn = Number Boolean $scope.meta.user and _.find($scope.e.attendees, id:$scope.meta.user.id)
      console.log "IamIn :"+$scope.IamIn

    $scope.$on 'refresh', ->  model.get $scope.e.id, true

    $scope.onRegister = ->
      if noRepeat('register') and $scope.loginOrPopup()
        if $scope.IamIn
          $scope.e.customDELETE('attendees').then (d)-> $scope.e.attendees = d
        else
          $scope.e.post('attendees').then (d)-> $scope.e.attendees = d

    $scope.onShare = ->
      no
    $scope.onUpload = ->
      no
    $scope.onEdit = ->
      no

    $scope.wbChecked = true
    $scope.comment = ""
    $scope.onComment = ->
      if noRepeat('comment',5000) and $scope.loginOrPopup()
        $scope.e.post('comments', body:$scope.comment).then (d)->
          $scope.e.comment_set.unshift(d)

    $scope.onCommentDel = (id)->
      $scope.e.one('comments', id).remove().then ->
        $scope.e.comment_set.splice _.findIndex($scope.e.comment_set, id:id), 1

  )
  .run(  ->
    console.log 'detailrun'
  )
