angular.module('front.home', ['ui.state', 'myscroll'])

  .config( ($stateProvider) ->
    $stateProvider.state 'home' ,
      url : '/home',
      views:
        "main":
          controller: 'HomeCtrl',
          templateUrl: 'home/home.tpl.html'

  )

  .controller( 'HomeCtrl', ($scope, Events, Scroll, $timeout, $log) ->
    $scope.events = []
    $scope.filterStatus = 0
    Scroll.init (latest)->
      if latest
        $log.log 'latest'
        if $scope.events.length
          p = {first: $scope.events[0].id}
        Events.getList(p)
        .then (data)->
          $scope.events = data.concat $scope.events
          $timeout (-> Scroll.refresh(data.length) ), 100
      else
        $log.log 'more'
        if $scope.events.length
          Events.getList(last:$scope.events[$scope.events.length-1].id)
          .then (data)->
            $scope.events = $scope.events.concat data
            $log.log $scope.events.length
            $log.log $scope.events
            $timeout (-> Scroll.refresh(data.length) ), 100
        else
          $timeout (-> Scroll.refresh(0) ), 0
  )
  .run(  -> console.log 'run'

  )
