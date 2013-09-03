angular.module('app.detail', [])

  .config( () ->
  )

  .controller( 'DetailCtrl', ($scope, Many, $routeParams) ->
    model = Many('events')
    id = $routeParams.id
    $scope.e = model.get id

    $scope.$watchCollection 'e', ->
      console.log "watch e"
      $scope.setTitle $scope.e.title
  )
  .run(  -> console.log 'detailrun'

  )
