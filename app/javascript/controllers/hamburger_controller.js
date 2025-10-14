import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hamburger","close" ]
  toggle() {
    this.hamburgerTarget.classList.toggle("hidden");
    this.closeTarget.classList.toggle("hidden");
  }
}
