import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy"
export default class extends Controller {
  static targets = [ "ref" ]
  connect() {
    console.log('test')
  }

  copy(){
     console.log(this.refTarget.href)
     let elementText= this.refTarget.href
     navigator.clipboard.writeText(elementText);
  }
}
