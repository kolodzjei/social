import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect(){
    const event = new CustomEvent("messageReceived", { detail: { message: this.element } });
    document.dispatchEvent(event);
  }

}
