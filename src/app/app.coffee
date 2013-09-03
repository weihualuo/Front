
angular.module( 'app', ['restangular',
                          'templates-app',
                          'templates-common',
                          'app.home',
                          'jqm'
                          'ngMobile'
])
  .config( (RestangularProvider, $routeProvider) ->
    $routeProvider.when( '/',
      controller: 'HomeCtrl'
      templateUrl: 'home/home.tpl.html'
      animation: 'page-slide-reverse'
    )
    .when( '/detail/:id'
      controller: 'DetailCtrl'
      templateUrl: 'detail/detail.tpl.html'
      animation: 'page-slide'
      )
    .otherwise(
      redirectTo: '/'
    )

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

  .factory('Model', (Restangular, $location, $timeout)->
    root = Restangular.all('events')
    all = []
    current = null
    Model = {}
    Model.all = -> all
#    Model.current = (e)->
#      current = e if e
#      current

    Model.load = (refresh, cb)->
      if all.length
        if refresh then p = first:all[0].id
        else p = last:all[all.length-1].id

      root.getList(p).then (data)->
        if refresh
          all = data.concat all
        else
          all = all.concat data
        #wait 1 sec to simulate network congestion
        #cb all
        $timeout (->cb all), 1000

    Model.get = (id)->
      #wait 1 sec to simulate network congestion
      #id = id or current.id
      current = (_.find all, id:Number(id)) or {}
      if !current.$d
        #root.one(id).get().then (data)->
        #  cb _.extend current, data, $d:true
        $timeout (->root.one(id).get().then (data)->
          _.extend current, data, $d:true
          ), 1000
      current
    Model
  )

  .factory('Meta', (Restangular, $location, $timeout)->
    root = Restangular.one('meta')
    meta = {}
    Meta = {}
    Meta.get = ->
      if !meta.$d
        root.get().then (data)->  _.extend meta, data, $d:true
      meta
    Meta
  )

  .controller('AppCtrl', ($scope, $location, Meta) ->
    $scope.meta = Meta.get()
    $scope.title = '集结号'
    $scope.setTitle = (title)-> $scope.title = title
    $scope.popupLogin = ->
      $scope.loginPopupShow = true
      $scope.path = $location.path()
    $scope.goBack = ->
      console.log "goback"
      $location.path "/"
  )


