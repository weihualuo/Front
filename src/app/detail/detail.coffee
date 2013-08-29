angular.module('front.detail', ['ui.state'])

  .config( ($stateProvider) ->
#    $stateProvider.state 'detail' ,
#      url : '/home/:id',
#      views:
#        "main":
#          controller: 'DetailCtrl',
#          templateUrl: 'detail/detail.tpl.html'

  )

  .controller( 'DetailCtrl', ($scope, Events, $routeParams, $timeout) ->
    id = $routeParams.id
    e = Events.one(id).get()
#    for e in Events.all()
#      break if e.id is id
    $scope.e = e
    console.log 'detailctrl'
  )
  .run(  -> console.log 'detailrun'

  )
