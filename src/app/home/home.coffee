angular.module('app.home', ['myscroll', 'mywidget', 'app.detail'])

  .config( () ->
  )

  .controller( 'HomeCtrl', ($scope, $timeout, $location, Many, $log) ->

    model = Many('events')
    $scope.$watchCollection 'meta', ->
      console.log 'watch meta'
      $scope.setTitle $scope.meta.user and $scope.meta.user.name

    $scope.onRefresh = (cb)->
      $scope.objects = model.load -1, cb

    $scope.onMore = (cb)->
      model.load 1, cb

    $scope.onDetail = (e)->
      $scope.e = e
      $scope.layer = 2

    $scope.onBack = (from)->
      $scope.layer = 1

    $scope.$watchCollection 'objects', ->  console.log 'watch objs'
    $scope.$on '$destroy', -> console.log 'scope destroy'

  )
  .run(  -> console.log 'homerun'
  )
