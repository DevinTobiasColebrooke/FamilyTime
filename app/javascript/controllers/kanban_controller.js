import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Connects to data-controller="kanban"
export default class extends Controller {
  static targets = ["column"]

  connect() {
    this.columnTargets.forEach((column) => {
      new Sortable(column, {
        group: 'kanban', // set both lists to same group
        animation: 150,
        ghostClass: "bg-gray-200",
        dragClass: "opacity-50",
        forceFallback: true,
        onEnd: this.end.bind(this)
      })
    })
  }

  end(event) {
    const itemEl = event.item
    const newStatus = event.to.dataset.status
    const eventId = itemEl.dataset.id
    const newIndex = event.newIndex

    // Update the status via AJAX
    fetch(`/events/${eventId}/update_status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ status: newStatus, position: newIndex })
    })
    .then(response => {
      if (!response.ok) {
        // If update fails, move the item back
        // (In a real app, you might show an error message)
        console.error("Failed to update status")
      }
    })
  }
}
