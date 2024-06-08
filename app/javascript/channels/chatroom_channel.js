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
    const newMessage = document.getElementById(`chat_${data['chat_id']}`);
      if (newMessage) {
        newMessage.scrollIntoView({ block: "center", behavior: 'smooth' });
    }
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
      if (postInput.value.trim() === '') {
        event.preventDefault();
        alert('チャット内容を入力してください。');
      } else {
      event.preventDefault();
      appRoom.speak(postInput.value);
      postInput.value = '';
      }
    });

    postInput.addEventListener('keydown', function(event) {
      
      if (event.key === 'Enter' && !event.shiftKey) {
        if (postInput.value.trim() === '') {
          event.preventDefault();
          alert('チャット内容を入力してください。');
        }else{
        event.preventDefault();
        appRoom.speak(postInput.value);
        postInput.value = '';
        }
      }
    });
  }
  
}


// Turbo Drive でページ読み込みが完了した後にチャットルームを初期化する
document.addEventListener('turbo:load', initializeChat);

