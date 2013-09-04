angular.module('app.home', ['myscroll', 'app.detail'])

  .config( () ->
  )

  .controller( 'HomeCtrl', ($scope, $timeout, $location, Many, $log) ->

    model = Many('events')
    $scope.$watchCollection 'meta', ->
      console.log 'watch meta'
      $scope.setTitle $scope.meta.user and $scope.meta.user.name

    $scope.objects = model.load()
    $scope.onMore = -> model.load(1)
    $scope.$on 'refresh', -> $log.log 'home refresh'; model.load(-1)

    $scope.$watchCollection 'objects', ->
      console.log 'watch objs'
      $log.log $scope.objects


#    $scope.objects = Model.all()
#    $scope.filterStatus = 0
#    $scope.more = Scroll.more
#    $scope.$on '$viewContentLoaded', ->
#      console.log 'scroll init'
#      Scroll.init (refresh)->  $timeout ->
#        Model.load refresh, (all)->
#          $scope.objects = all
#          $timeout (->Scroll.refresh all), 100

    $scope.onDetail = (e)->
      $location.path("/detail/"+e.id)

    $scope.$on '$destroy', ->
      console.log 'scope destroy'
#      Scroll.destroy()
  )
  .run(  -> console.log 'homerun'
  )
