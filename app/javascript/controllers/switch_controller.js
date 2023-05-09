import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch"
export default class extends Controller {
  static targets = ["input","submit"];

  connect() {
    

   
    this.inputTarget.addEventListener("input", () => {
      this.doSomething();
    });
  }
  doSomething() {
    // This function will be called when the input field changes.
    this.element.classList.add('posted-on-webflow')
    this.submitTarget.submit();
  }

}
