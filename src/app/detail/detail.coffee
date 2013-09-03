angular.module('app.detail', [])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Model, $routeParams, $timeout) ->
    id = $routeParams.id
    $scope.e = Model.get id, (data)-> $scope.e = data
    $scope.$watchCollection 'e', ->
      console.log "watch e"
      $scope.setTitle $scope.e.title if $scope.e.title
  )
  .run(  -> console.log 'detailrun'

  )
