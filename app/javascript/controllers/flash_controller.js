import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss after 4 seconds
    setTimeout(() => {
      this.dismiss()
    }, 4000)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-y-[-20px]", "transition-all", "duration-300")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
