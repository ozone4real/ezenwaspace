import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.highlightCode()
  }

  highlightCode() {
    // Load Prism.js dynamically
    import("prismjs").then((Prism) => {
      // Load autoloader plugin
      import("prismjs/plugins/autoloader/prism-autoloader").then(() => {
        // Configure autoloader
        Prism.plugins.autoloader.languages_path = 'https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/'
        
        // Highlight all code blocks
        Prism.highlightAll()
      })
    })
  }
}
