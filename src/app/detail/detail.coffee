angular.module('front.detail', ['ui.state'])

  .config( ($stateProvider) ->
    $stateProvider.state 'detail' ,
      url : '/home/:id',
      views:
        "main":
          controller: 'DetailCtrl',
          templateUrl: 'detail/detail.tpl.html'

  )

  .controller( 'DetailCtrl', ($scope, Events, $timeout, $log) ->
    $scope.event = {}
    console.log 'detailctrl'
  )
  .run(  -> console.log 'detailrun'

  )
