var w = new Worker('scripts/worker.js');

var userNameInput = document.querySelector('#user-name');
var messageInput = document.querySelector('#chat-entry');
var messagesContainer = document.querySelector('.messages-container');

var messageTemplate = document.querySelector('.message-container');

w.postMessage({
  'type': 'initialize'
});

addEventListener('keydown', function(e){
  if(e.which === 13){
    var userName = userNameInput.innerText;
    var message = messageInput.innerText;
    w.postMessage({
      type: 'chat',
      userName: userName,
      message: message
    });
    messageInput.innerText = "";
  }
});

w.onmessage = function(e){
  var data = e.data;

  var newMessage = messageTemplate.cloneNode(true);
  var user = newMessage.querySelector('.user');
  var message = newMessage.querySelector('.message');

  newMessage.classList.add(data.class);
  newMessage.style.display = '';
  user.innerText = data.userName;
  message.innerText = data.message;

  messagesContainer.appendChild(newMessage);

  messagesContainer.scrollTop = messagesContainer.scrollHeight - messagesContainer.offsetHeight;
};

onunload = function(){
  w.postMessage({
    'type': 'close'
  });
};
