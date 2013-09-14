angular.module('app.detail', ['Service', 'app.edit'])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Many, $routeParams, noRepeat, $location) ->

    console.log 'DetailCtrl'
    model = Many('events')
    $scope.e = e = model.get Number $routeParams.id

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

  )
  .controller( 'CommentCtrl', ($scope, $timeout, noRepeat) ->

    console.log "comment ctrl"

    comment = ""
    $scope.wbChecked = true
    $scope.comment = comment

    $scope.$watch 'e', ->
      console.log "e changed"

    $scope.onComment = ->

      if $scope.comment is comment then return

      if noRepeat('comment',5000) and $scope.loginOrPopup()
        comment = $scope.comment
        $scope.e.post('comments', body:comment).then (d)->
          $scope.comment = ""
          $scope.e.comment_set.unshift(d)


    $scope.onCommentDel = (id)->
      $scope.e.one('comments', id).remove().then ->
        comment = ""
        $scope.e.comment_set.splice _.findIndex($scope.e.comment_set, id:id), 1

  )

  .run(  ->
    console.log 'detailrun'
  )
