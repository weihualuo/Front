angular.module('front.home', ['ui.state', 'myscroll', 'front.detail'])

  .config( ($stateProvider) ->
#    $stateProvider.state 'homepage' ,
#      url : '/home',
#      views:
#        "main":
#          controller: 'HomeCtrl',
#          templateUrl: 'home/home.tpl.html'

  )

  .controller( 'HomeCtrl', ($scope, Events, Scroll, $navigate, $timeout) ->
    $scope.events = Events.all()
    load = (list)->
      $scope.events = list
      $timeout (->Scroll.refresh list ), 100

    $scope.filterStatus = 0
    $scope.more = Scroll.more
    $scope.$on '$viewContentLoaded', ->
      console.log 'scroll init'
      refresh = $scope.events.length is 0
      Scroll.init refresh, (action)->
        if action is 'refresh'
          Events.prev(load)
        else if action is 'more'
          Events.next(load)

    $scope.onDetail = (e)->
      $navigate.go('/events/'+e.id, 'slide')

    $scope.$on '$destroy', ->
      console.log 'scope destroy'
      Scroll.destroy()

  )
  .run(  -> console.log 'homerun'

  )
