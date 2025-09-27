// Configure Trix with additional heading levels
// Wait for Trix to be available before configuring
window.addEventListener('trix-initialize', () => {
  console.log('Trix initialized')
  
  // Only configure if Trix is available and hasn't been configured yet
  if (typeof Trix !== 'undefined' && !window.trixConfigured) {
    try {
      const headingConfig = Trix.config.blockAttributes.heading1
      
      // Register heading levels 2-6 if they don't exist
      for (let i = 2; i <= 6; i++) {
        const headingKey = `heading${i}`
        if (!Trix.config.blockAttributes[headingKey]) {
          Trix.config.blockAttributes[headingKey] = {
            tagName: `h${i}`,
            terminal: true,
            breakOnReturn: true,
            group: false
          }
        }
      }
      
      window.trixConfigured = true
      console.log('Trix configuration applied')
    } catch (error) {
      console.error('Error configuring Trix:', error)
    }
  }
})

// Export for potential use elsewhere
export default function configureTrix() {
  console.log('Trix config loaded')
}
