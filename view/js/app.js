var server_domain = "api.mysite.com"

angular.module('myapp', ['ngRoute', 'ui.bootstrap']).

controller('topicCtrl',function ($http, $scope, $modal) { 
  //controller for topics list.
  //todo: cache all topics        
  $scope.topics = {};
  $scope.offset = 0;
  //fetch topics by $http
  $scope.getToptics = function (offset){
    $http.get('http://'+server_domain+'/topics?offset='+offset).
    success(function(data, status, headers, config) {
      $scope.topics = data.data.items;                  
    }).
    error(function(data, status, headers, config) {
      alert(status);
    });
  }
  //fetch next page's topics
  $scope.next = function(){
    $scope.offset += 15;
    $scope.getToptics($scope.offset);
  }
  //fetch pre page's topics
  $scope.pre = function(){
    if($scope.offset >= 15 ){
      $scope.offset -= 15;
      $scope.getToptics($scope.offset);
    }
  }
  //button for create new topic
  $scope.open = function (size) {
    var topicModal = $modal.open({
      templateUrl: 'topic-new.html',
      controller: $scope.topicModalCtrl,
      size: size,
    });
    //a promise that is resolved when a modal is closed and rejected when a modal is dismissed
    topicModal.result.then(function (success) {
      if(success){$scope.getToptics(0);}
    }, function () {
      $log.info('Modal dismissed at: ' + new Date());
    });
  }
  //modal controller for create topic
  $scope.topicModalCtrl = function ($scope, $http, $modalInstance) {
    $scope._title = "";
    $scope._content = "";
     
    $scope.ok = function(title, content) {
      $http({
        url: 'http://'+server_domain+'/topics',
        method: 'POST',
        data: "title="+title+"&content="+content,
      }).
      success(function (data, status) {
        $scope.res = data;
        if(data.data) {
          $modalInstance.close('success');
        } else {
          alert("try again!");
        }
      })
    }
    $scope.cancel = function () {
      $modalInstance.dismiss("cancel");
    }
  }
  $scope.getToptics(0); 
}).


controller("topicDetailCtrl", function ($http, $scope, $routeParams, $modal){
  $scope.tid = $routeParams.id;
  //fetch topic by id;
  $scope.init = function () {
    $http.get('http://'+server_domain+'/topics/'+$scope.tid).
      success(function (data,status) {
        if(data.data){
          $scope.topic = data.data.items[0];
        } else {
          alert(data.error.message);
        }});
    //fetch reply list
    $http.get('http://'+server_domain+'/replys?topic_id='+$scope.tid).
    success(function (data, status){
      if(data.data){
        $scope.replys = data.data.items;
      } else {alert(data.error.message);}
    })
  }
  //button for open reply modal
  $scope.reply = function () {
    $modal.open({
      templateUrl: "reply-new.html",
      controller: $scope.replyModalCtrl,
      size: "md",
      //resolve :members that will be resolved and passed to the controller as locals;
      resolve: {
        topic_id: function(){return $scope.tid},
      }
    }).result.then( 
      //a promise that is resolved when a modal is closed and rejected when a modal is dismissed
      function (success) {
        if(success){$scope.init();}
      })
  }
  $scope.replyModalCtrl = function ($scope, $http, $modalInstance, topic_id) {
      $scope.content = "";
      $scope.ok = function (content) {
        $http.post('http://'+server_domain+'/replys',"content="+content+"&topic_id="+topic_id).
        success(function (data, status) {
          if (data.data) {
            $modalInstance.close("success");
          }
        });
      }
      $scope.cancel = function () {
        $modalInstance.dismiss("cancel");
      }
  }
  $scope.init();
}).


config(function ($routeProvider, $locationProvider) {
  $routeProvider.
  when('/', {
    controller: 'topicCtrl',
    templateUrl: 'topic-list.html'
  }).
  when('/topics/:id', {
    controller: 'topicDetailCtrl',
    templateUrl: 'topic-detail.html'
  }).
  when('/404', {
    templateUrl: '404.html'
  }).
  otherwise({
    redirectTo: '/404'
  });
});



