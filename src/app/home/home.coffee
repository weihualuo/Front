angular.module('app.home', ['myscroll', 'app.detail'])

  .config( () ->
  )

  .controller( 'HomeCtrl', ($scope, $timeout, $location, Many, $log) ->

    model = Many('events')
    $scope.$watchCollection 'meta', ->
      console.log 'watch meta'
      $scope.setTitle $scope.meta.user and $scope.meta.user.name

    $scope.objects = model.load 0, -> $scope.pullStatus=0
    $scope.onMore = -> model.load 1
#    $scope.$on 'refresh', -> model.load(-1)
    $scope.onDetail = (e)->
      $location.path("/detail/"+e.id)

    $scope.$watch 'pullStatus', ->
      if $scope.pullStatus is 2
        model.load -1, -> $scope.pullStatus=0
        console.log 'pull refresh'

    $scope.$watchCollection 'objects', ->  console.log 'watch objs'
    $scope.$on '$destroy', -> console.log 'scope destroy'

  )
  .run(  -> console.log 'homerun'
  )
