import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sendButton", "messageInput", "messages", "form"];

  connect(){
    document.addEventListener("messageReceived", (event) => {
      const message = event.detail.message;
      this.scrollDownIntoView(message);
    });

    this.messageInputTarget.addEventListener("change", () => {
      if (this.messageInputTarget.value.length > 500) {
        this.sendButtonTarget.disabled = true;
      } else {
        this.sendButtonTarget.disabled = false;
      }
    });
  }

  disconnect(){
    document.removeEventListener("messageReceived", (event) => {
      const message = event.detail.message;
      this.scrollDownIntoView(message);
    });
  }

  scrollDownIntoView(message){
      message.scrollIntoView({ block: 'start' })
  }

  handleSubmit(event){
    event.preventDefault();
    this.formTarget.submit();

    const observer = new MutationObserver(() => {
      this.messageInputTarget.value = "";
      observer.disconnect();
    });

    const config = { attributes: true, childList: true, subtree: true };

    observer.observe(this.messagesTarget, config);
  }
}