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
    return this.perform('speak', {message: message, post_id: window.postData.id,  profile_id: window.profileData.id });
  }
});

function initializeChat() {
  const postInput = document.getElementById('post_input');
  const submitButton = document.getElementById('submit_button');
  const postElement = document.getElementById('post');
  const profileElement = document.getElementById('profile');

  if (postElement) {
    window.postData = {
      id: postElement.value,
    };
  }

  if (profileElement) {
    window.profileData = {
      id: profileElement.value,
    };
  }

  if (postInput && submitButton) {
    submitButton.addEventListener('click', function(event) {
      event.preventDefault();
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
  
}


// Turbo Drive でページ読み込みが完了した後にチャットルームを初期化する
document.addEventListener('turbo:load', initializeChat);

