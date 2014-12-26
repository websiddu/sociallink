'use strict'

angular.module 'sociallinkApp'
.controller 'MainCtrl', ($scope, $http, socket) ->
  $scope.awesomeLinks = []

  $scope.userservices = []

  # $http.get('/api/links').success (awesomeLinks) ->
  #   $scope.awesomeLinks = awesomeLinks
  #   socket.syncUpdates 'link', $scope.awesomeLinks




  $scope.init = ->
    $http.get '/api/services'
      .success (services) ->
        $scope.userservices = services
        $http.get '/api/users/links'
          .success (links) ->
            $scope.userlinks = links
            _combineLinks()

  _combineLinks = ->
    slen = $scope.userservices.length
    i = 0;
    while i < slen
      findedlinks =  _.find($scope.userlinks, (lnk) ->
        return lnk.name is $scope.userservices[i].name
        )
      if (findedlinks)
        $scope.userservices[i] = findedlinks
        $scope.userservices[i].updateurl = "/api/links/u/#{findedlinks._id}"
      i++

  $scope.updateLink = (service) ->
    console.log service

    newService =
      name: service.name
      url: service.fullurl
      icon: service.icon
      _id: service._id

    console.log newService

    $http
      method: 'PUT'
      url: '/api/links/u/'
      data:
        data: newService
    .success (data, status) ->
      console.log data



  $scope.addThing = ->
    return if $scope.newThing is ''
    $http.post '/api/links',
      name: $scope.newThing
      link: "String"
      icon: "String"
      handle: "String"

    $scope.newThing = ''

  $scope.deleteThing = (link) ->
    $http.delete '/api/links/' + link._id

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'link'

  $scope.init()
