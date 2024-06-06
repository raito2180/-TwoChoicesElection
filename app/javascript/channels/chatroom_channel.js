import consumer from "./consumer"

const appRoom = consumer.subscriptions.create("ChatroomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const messages = document.getElementById('messages');
  messages.insertAdjacentHTML('beforeend', data['message']);
  },

  speak: function(message) {
    return this.perform('speak', {message: message, post_id: window.postData.id});
  }
});

document.addEventListener('DOMContentLoaded',
function () {
  const post = document.getElementById('post').value
  console.log(post);
});

document.addEventListener('DOMContentLoaded', function() {
  const postInput = document.getElementById('post_input');
  const submitButton = document.getElementById('submit_button');

  if (postInput && submitButton) {
    submitButton.addEventListener('click', function() {
      appRoom.speak(postInput.value);
      postInput.value = '';
    });

    postInput.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        event.preventDefault();
        appRoom.speak(postInput.value);
        postInput.value = '';
      }
    });
  }
});
