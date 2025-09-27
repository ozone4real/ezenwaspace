import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('Rich text controller connected')
    
    // Wait for Trix to initialize before customizing
    this.element.addEventListener("trix-initialize", (event) => {
      console.log('Trix editor initialized', event.target)
      this.addHeadingButtons()
    })
  }

  addHeadingButtons() {
    const toolbar = this.element.querySelector("trix-toolbar")
    if (!toolbar) return

    // Find the heading button group
    const headingButton = toolbar.querySelector('[data-trix-attribute="heading1"]')
    if (!headingButton) return

    const buttonGroup = headingButton.closest('.trix-button-group')
    if (!buttonGroup) return

    // Add additional heading buttons after the H1 button
    const headingLevels = [2, 3, 4, 5, 6]
    
    headingLevels.forEach(level => {
      const button = document.createElement('button')
      button.type = 'button'
      button.className = `trix-button trix-button--icon trix-button--icon-heading-${level}`
      button.setAttribute('data-trix-attribute', `heading${level}`)
      button.setAttribute('title', `Heading ${level}`)
      button.setAttribute('tabindex', '-1')
      
      // Insert after the previous heading button
      headingButton.parentNode.insertBefore(button, headingButton.nextSibling)
    })
  }
}
