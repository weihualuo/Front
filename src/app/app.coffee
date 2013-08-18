
angular.module( 'front', ['restangular',
                          'templates-app',
                          'templates-common',
                          'front.home',
                          'ui.bootstrap',
                          'ui.state',
                          'ui.route'])
  .config( ($stateProvider, $urlRouterProvider, RestangularProvider) ->
    $urlRouterProvider
      .otherwise( '/home' )
    RestangularProvider.setBaseUrl("/api/")
    RestangularProvider.setRequestSuffix('/')
    RestangularProvider.setResponseExtractor (response, operation, what, url)->
      if operation is 'getList'
        res = response.results
        res.metadata= response
      else
        res = response
      res
    RestangularProvider.addElementTransformer('events', false, (event) ->
      event
      )
    )
  .factory('Events', (Restangular)->
    Restangular.all('events')
  )
  .controller('AppCtrl', ($scope, Restangular, Events, $log) ->
    Events.getList().then (events)->
      $scope.events = events
    $scope.filterStatus = 0
#    $log.log($scope.events)
  )


