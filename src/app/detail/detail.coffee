angular.module('app.detail', [])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Many, $routeParams) ->
    model = Many('events')
    $scope.e = model.get $routeParams.id

    $scope.$watch 'e.title', -> $scope.setTitle $scope.e.title
    $scope.$watchCollection 'e.attendees', ->
      $scope.IamIn = Number Boolean $scope.meta.user and _.find($scope.e.attendees, id:$scope.meta.user.id)
      console.log "IamIn :"+$scope.IamIn

#    $scope.$watchCollection 'e', ->
#
#      $scope.setTitle $scope.e.title
#      $scope.IamIn = Number Boolean $scope.meta.user and _.find($scope.e.attendees, id:$scope.meta.user.id)


    $scope.$on 'refresh', ->  model.get $scope.e.id, true

    $scope.onRegister = ->
      if $scope.loginOrPopup()
        if $scope.IamIn
          $scope.e.customDELETE('attendees').then (d)-> $scope.e.attendees = d
        else
          $scope.e.post('attendees').then (d)-> $scope.e.attendees = d
  )
  .run(  -> console.log 'detailrun'

  )
