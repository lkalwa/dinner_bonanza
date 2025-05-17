import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["chip", "input"]

    remove() {
        this.chipTarget.remove()
        this.inputTarget.remove()
        const form = document.getElementById('ingredients-form')
        if (form) {
            const searchField = form.querySelector('input[type="search"]')
            if (searchField) {
                searchField.disabled = true
            }

            form.requestSubmit()
            if (searchField) {
                searchField.disabled = false
            }
        }
    }
}