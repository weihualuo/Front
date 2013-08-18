angular.module('front.home', ['ui.state'])

  .config( ($stateProvider) ->
    $stateProvider.state( 'home' ,{
      url : '/home',
      views:
        "main":
          controller: 'HomeCtrl',
          templateUrl: 'home/home.tpl.html'
    })
  )

  .controller( 'HomeCtrl', ($scope, Events) ->
#    $scope.event = Events.get(0)
#    $scope.events = Event.get()

  )
