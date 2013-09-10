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
    .when( '/edit/:id'
      controller: 'EditCtrl'
      templateUrl: 'edit/edit.tpl.html'
      animation: 'page-slide'
    )
    .otherwise(
      redirectTo: '/'
    )

  )

  .run( ()->
    console.log 'app run'
  )

  .controller('AppCtrl', ($scope, $location, Single) ->

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


