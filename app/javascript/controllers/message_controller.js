import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sendButton", "messageInput", "messages", "form"];

  connect(){
    this.scrollDown();

    this.messageInputTarget.addEventListener("change", () => {
      if (this.messageInputTarget.value.length > 500) {
        this.sendButtonTarget.disabled = true;
      } else {
        this.sendButtonTarget.disabled = false;
      }
    });

    const observer = new MutationObserver(() => {
      this.scrollDown();
    });

    const config = { attributes: true, childList: true, subtree: true };
    observer.observe(this.messagesTarget, config);
  }

  scrollDown(){
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }

  handleSubmit(event){
    event.preventDefault();
    this.formTarget.submit();
    this.messageInputTarget.value = "";
  }
}