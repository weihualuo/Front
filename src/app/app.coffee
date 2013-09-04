angular.module( 'app', ['restangular',
                          'templates-app',
                          'templates-common',
                          'Model',
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

  .run( ()->
    console.log 'app run'
  )

  .controller('AppCtrl', ($scope, $location, Single) ->
#    $scope.m1 = Single('meta1').get()
#    $scope.m3 = Single('meta1').get()
#    $scope.m2 = Single('meta2', abc:'abcd').get()
#    $scope.$watchCollection 'm1', ->
#      console.log 'watch m1'
#      console.log $scope.m1
#    $scope.$watchCollection 'm2', ->
#      console.log 'watch m2'
#      console.log $scope.m2


    appTitle = '集结号'
    popupLogin = ->
      $scope.loginPopupShow = true
      $scope.path = $location.path()
      false

    $scope.meta = Single('meta').get()
    $scope.setTitle = (title)-> $scope.title = title or appTitle

    $scope.isLogin = -> Boolean $scope.meta.user
    $scope.loginOrPopup = -> Boolean $scope.meta.user or popupLogin()

    $scope.onOption = (option)-> $scope.$broadcast option
    $scope.goBack = ->
      console.log "goback"
      $location.path "/"
  )


