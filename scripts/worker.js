var s;
var userName = '';

onmessage = function(e){

  var type = e.data.type;

  switch(type){
    case 'initialize':
      initializeSocket();
      break;
    case 'close':
      closeSocket();
      break;
    case 'chat':
      sendChat(e);
      break;
  }
};

function initializeSocket(){
  s = new WebSocket("ws://localhost:4567");
  s.onmessage = function(e){
    var data = JSON.parse(e.data);
    if (userName === data.userName){
      data.class = 'mine';
    }
    postMessage(data);
  };
}

function closeSocket(){
  if(s){
    // var data = {
    //   type:'close',
    //   userName: userName
    // };
    // s.send(JSON.stringify(data));
    s.close(1000, 'REASONFORCLOSE');
  }
}

function sendChat(e){
  userName = e.data.userName;
  s.send(JSON.stringify(e.data));
}

