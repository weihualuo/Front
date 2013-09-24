angular.module('app.home', ['myscroll', 'app.detail'])

  .config( () ->
  )

  .controller( 'HomeCtrl', ($scope, $timeout, $location, Many, $log) ->

    model = Many('events')
    $scope.$watchCollection 'meta', ->
      console.log 'watch meta'
      $scope.setTitle $scope.meta.user and $scope.meta.user.name

    $scope.$watch 'pullStatus', ->
      if $scope.pullStatus is 2
        $scope.objects = model.load -1, ->
          $scope.pullStatus=0
          $scope.moreStatus=3
        console.log 'pull refresh'

    $scope.onMore = ->
      $scope.moreStatus=2
      model.load 1, -> $scope.moreStatus=3

    $scope.onDetail = (e)->
      $location.path("/detail/"+e.id)

    $scope.$watchCollection 'objects', ->  console.log 'watch objs'
    $scope.$on '$destroy', -> console.log 'scope destroy'

  )
  .run(  -> console.log 'homerun'
  )
