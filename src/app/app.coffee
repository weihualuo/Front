
angular.module( 'front', ['restangular',
                          'templates-app',
                          'templates-common',
                          'front.home',
#                          'jqm'
                          'ajoslin.mobile-navigate',
                          'ngMobile'
#                          'ui.bootstrap',
#                          'ui.state',
#                          'ui.route'
])
  .config( (RestangularProvider, $routeProvider) ->
    $routeProvider.when( '/',
      controller: 'HomeCtrl',
      templateUrl: 'home/home.tpl.html'
    )
    .when( '/events/:id'
      controller: 'DetailCtrl',
      templateUrl: 'detail/detail.tpl.html'
      )
    .otherwise(
      redirectTo: '/'
    )
#    $urlRouterProvider
#      .otherwise( '/home' )
#    $stateProvider.state('init', {
#      url: '/',
#      views:
#        {}
#    })


    RestangularProvider.setBaseUrl '/api/'
#    RestangularProvider.setRequestSuffix '/'
#    RestangularProvider.setResponseExtractor (response, operation, what, url)->
#      if operation is 'getList'
#        res = response.results
#        res.meta= response.meta
#      else
#        res = response
#      res
#    RestangularProvider.addElementTransformer 'events', false, (event) ->
#      event
    )

  .factory('Events', (Restangular, $location, $timeout)->
    E = Restangular.all('events')
    list = []
    Agent = {}
    Agent.all = -> list

    Agent.prev = (cb)->
      p = first:list[0].id if list.length
      E.getList(p).then (data)->
        list = data.concat list
        $timeout (-> cb list ), 0
    Agent.next = (cb)->
      p = last:list[list.length-1].id if list.length
      E.getList(p).then (data)->
        list = list.concat data
        cb list
    Agent.get = (id, cb)->
      E.one(id).get().then (data)->
        cb data
    Agent
  )

  .controller('AppCtrl', ($scope, $navigate) ->
    $scope.title = "集结号"
    $scope.setTitle = (title)-> $scope.title = title
    $scope.$nav = $navigate
  )


