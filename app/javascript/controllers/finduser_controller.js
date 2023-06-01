import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["params"];

  search() {
    const value = this.paramsTarget.value

    if (value.length < 3) {
      return
    }

    fetch(`/conversations/search?search=${value}`, {
      contentType: 'application/json',
    })
    .then((response) => response.text())
    .then(res => {
      const results = document.getElementById('users-results');
      results.textContent = "";
      results.insertAdjacentHTML('beforeend', res);
    })
  }

}