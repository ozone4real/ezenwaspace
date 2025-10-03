import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hiddenField", "tagContainer"]
  static values = { tags: Array }

  connect() {
    this.renderTags()
    this.updateHiddenField()
    this.inputTarget.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === 'Enter' || event.key === ',') {
      event.preventDefault()
      this.addTag()
    } else if (event.key === 'Backspace' && this.inputTarget.value === '') {
      this.removeLastTag()
    }
  }

  addTag() {
    const tagName = this.inputTarget.value.trim().toLowerCase()
    
    if (tagName && !this.tagsValue.includes(tagName)) {
      this.tagsValue = [...this.tagsValue, tagName]
      this.inputTarget.value = ''
      this.renderTags()
      this.updateHiddenField()
    }
  }

  removeTag(event) {
    const tagName = event.currentTarget.dataset.tagName
    this.tagsValue = this.tagsValue.filter(tag => tag !== tagName)
    this.renderTags()
    this.updateHiddenField()
  }

  removeLastTag() {
    if (this.tagsValue.length > 0) {
      this.tagsValue = this.tagsValue.slice(0, -1)
      this.renderTags()
      this.updateHiddenField()
    }
  }

  renderTags() {
    this.tagContainerTarget.innerHTML = ''
    
    this.tagsValue.forEach(tag => {
      const tagElement = document.createElement('span')
      tagElement.className = 'inline-flex items-center gap-1 px-3 py-1 bg-purple-100 text-purple-800 text-sm font-medium rounded-full transition-colors hover:bg-purple-200'
      tagElement.innerHTML = `
        #${tag}
        <button type="button" 
                data-action="click->tag-input#removeTag" 
                data-tag-name="${tag}"
                class="ml-1 text-purple-600 hover:text-purple-800 focus:outline-none hover:bg-purple-300 rounded-full p-0.5 transition-colors">
          <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      `
      this.tagContainerTarget.appendChild(tagElement)
    })
  }

  updateHiddenField() {
    this.hiddenFieldTarget.value = this.tagsValue.join(', ')
  }
}
