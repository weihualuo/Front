
angular.module('app.edit', [])

  .config( () ->
  )

  .controller( 'EditCtrl', ($scope, Many, $routeParams, noRepeat) ->

    model = Many('events')
    $scope.e = model.get $routeParams.id

  )