var frisby = require('frisby');

var URL = 'http://api.mysite.com/';

frisby.globalSetup({ // globalSetup is for ALL requests
  request: {
    headers: {'version':'1.0' }
  }
});


frisby.create('Post topic')
    .post('http://api.mysite.com/topics', 
    {
        title:"post test",
        content:"what a wonderful world!",
        node_id:1,
    })
    .expectStatus(200)
    .expectJSON ({
        data:{
            kind:"topic",
            items:{
                title:"post test",
            }    
        }
    }) 
    .afterJSON(function(topic){
        console.log(topic); 
    })
.toss();

frisby.create('GET topic 11')
    .get(URL + '/topics/1')
    .expectStatus(200)
    .afterJSON(function(topic){
        console.log(topic); 
    })
.toss();

frisby.create('Put topic')
    .put('http://api.mysite.com/topics/1',
    {
        content:"put success",
        node_id:2
    })
    .expectStatus(200)
    .afterJSON(function(topic){
        console.log(topic); 
    })
.toss()

frisby.create('Delete topic')
    .delete('http://api.mysite.com/topics/0')
    .expectStatus(200)
    .afterJSON(function(topic){
        console.log(topic); 
    })
.toss()
