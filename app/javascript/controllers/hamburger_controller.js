import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hamburger","overlay", "menu" ]

  toggle() {
    this.hamburgerTarget.classList.toggle("open");
    this.overlayTarget.classList.toggle("hidden");
    this.menuTarget.classList.toggle("hidden");
  }
}
