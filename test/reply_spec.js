var frisby = require('frisby');

var URL = 'http://api.mysite.com/';

frisby.globalSetup({ // globalSetup is for ALL requests
  request: {
    headers: {'version':'1.0' }
  }
});


frisby.create('Post reply')
    .post('http://api.mysite.com/replys', 
    {
        content:"what a wonderful world!",
        topic_id:13
    })
    .expectStatus(200)
    .expectJSON ({
        data:{
            kind:"reply",
        }
    }) 
    .afterJSON(function(reply){
        console.log(reply); 
    })
.toss();

frisby.create('Delete reply')
    .delete('http://api.mysite.com/replys/6')
    .expectStatus(200)
    .expectJSON({
        data:{
            message:"deleted"
        }
    })
    .afterJSON(function(reply){
        console.log(reply); 
    })
.toss()

frisby.create('Get reply list')
    .get('http://api.mysite.com/replys?topic_id=13')
    .expectJSON({
        data:{
        }
    })
    .afterJSON(function(reply){
        console.log(reply); 
    })
.toss()
