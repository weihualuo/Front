
angular.module('app.edit', [])

  .config( () ->
  )

  .controller( 'EditCtrl', ($scope, Many, $routeParams, noRepeat) ->

    model = Many('events')
    id = Number $routeParams.id
    $scope.e = e = if id then model.get id else null
    console.log e

  )