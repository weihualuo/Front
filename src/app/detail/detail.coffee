angular.module('app.detail', [])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Model, $routeParams, $timeout) ->
    id = $routeParams.id
    $scope.e = Model.current()
    $scope.setTitle($scope.e.title) if $scope.e
    Model.get id, (data)-> $scope.e = data

  )
  .run(  -> console.log 'detailrun'

  )
