
angular.module( 'front', ['restangular',
                          'templates-app',
                          'templates-common',
                          'front.home',
                          'ui.state',
                          'ui.route'])
  .config( ($stateProvider, $urlRouterProvider, RestangularProvider) ->
    $urlRouterProvider
      .otherwise( '/home' )
    RestangularProvider.setBaseUrl("/api/")
  )
  .factory('Event', (Restangular)->
    Restangular.all('events/')
  )
  .controller('AppCtrl', ($scope, Restangular, Event, $log) ->
    $scope.events = Event.customGET()

#    $log.log($scope.events)
  )


#ii = angular.injector(['front', 'ng'])