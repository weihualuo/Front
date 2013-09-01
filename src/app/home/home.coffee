angular.module('app.home', ['myscroll', 'app.detail'])

  .config( () ->
  )

  .controller( 'HomeCtrl', ($scope, Model, Scroll, $timeout, $location) ->
    $scope.setTitle "集结号"
    $scope.objects = Model.all()
    $scope.filterStatus = 0
    $scope.more = Scroll.more
    $scope.$on '$viewContentLoaded', ->
      console.log 'scroll init'
      Scroll.init (refresh)->  $timeout ->
        Model.load refresh, (all)->
          $scope.objects = all
          $timeout (->Scroll.refresh all), 100

    $scope.onDetail = (e)->
      Model.current(e)
      $location.path("/detail/"+e.id)

    $scope.$on '$destroy', ->
      console.log 'scope destroy'
#      Scroll.destroy()
  )
  .run(  -> console.log 'homerun'
  )
