angular.module('app.home', ['myscroll', 'mywidget', 'app.detail', 'ngIscroll'])

  .config( () ->
  )

  .controller( 'HomeCtrl', ($scope, $timeout, $location, Many, $log) ->
    console.log 'HomeCtrl'
    model = Many('events')
    $scope.$watch 'meta.user.name', (value)->  $scope.title = value if value

    $scope.onRefresh = (cb)-> $scope.objects = model.load -1, cb

    $scope.onMore = (cb)->  model.load 1, cb

    $scope.onDetail = (e)->  $location.path("/detail/" + e.id)

    $scope.onEdit = (e)->  $location.path("/edit/0")

    $scope.$watchCollection 'objects', ->  console.log 'watch objs'
    $scope.$on '$destroy', -> console.log 'scope destroy'

  )

