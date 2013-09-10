
angular.module('app.edit', [])

  .config( () ->
  )

  .controller( 'EditCtrl', ($scope, Many, $routeParams, noRepeat, $timeout) ->

    if !$scope.e
      console.log "no e"
    console.log "editCtrl"
    model = Many('events')
    id = Number $routeParams.id
    $scope.e = e = if id then model.get id else null
    console.log e

    $scope.test ?= 0
    console.log "EditCtrl", ++$scope.test
    $timeout (-> $scope.test++),1000

    $scope.onClick = (sub)->
      console.log "click main #{sub} : "+ e.id


  )

  .controller( 'subCtrl', ($scope, $timeout) ->
    $scope.testsub ?= 0
    console.log "subCtrl", ++$scope.testsub
    $timeout (-> $scope.testsub++),1000

    $scope.onClick = ()->
      console.log 'click : '+ $scope.e.id
      $scope.testsub++
      $scope.$parent.onClick($scope.testsub)

  )