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
    return this.perform('speak', {message: message});
  }
});

window.document.onkeydown = function(event) {
  if(event.key == 'Enter') {
    event.preventDefault();
    appRoom.speak(event.target.value);
    console.log('ログ', event.target.value);
    event.target.value = '';
  }
}