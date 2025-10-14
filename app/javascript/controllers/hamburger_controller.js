import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hamburger", "close", "overlay", "menu" ]

  toggle() {
    this.hamburgerTarget.classList.toggle("hidden");
    this.closeTarget.classList.toggle("hidden");
    this.overlayTarget.classList.toggle("hidden");
    this.menuTarget.classList.toggle("hidden");
  }
}
