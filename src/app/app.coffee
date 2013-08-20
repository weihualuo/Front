
angular.module( 'front', ['restangular',
                          'templates-app',
                          'templates-common',
                          'front.home',
                          'ui.bootstrap',
                          'ui.state',
                          'ui.route'])
  .config( ($stateProvider, $urlRouterProvider, RestangularProvider) ->
#    $urlRouterProvider
#      .otherwise( '/' )
#    $stateProvider.state('init', {
#      url: '/',
#      views:
#        {}
#    })


    RestangularProvider.setBaseUrl '/api/'
    RestangularProvider.setRequestSuffix '/'
    RestangularProvider.setResponseExtractor (response, operation, what, url)->
      if operation is 'getList'
        res = response.results
        res.meta= response
      else
        res = response
      res
    RestangularProvider.addElementTransformer 'events', false, (event) ->
      event
    )

  .factory('Events', (Restangular, $location, $timeout)->
    me = Restangular.all('events').getList()
    me.then ->
      $timeout (-> $location.path '/home'), 1000
    me
  )

  .controller('AppCtrl', ($scope, Restangular, Events, $log) ->

  )


