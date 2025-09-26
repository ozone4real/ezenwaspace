# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "prismjs", to: "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/+esm"
pin "prismjs/components/prism-core", to: "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-core.min.js"
pin "prismjs/plugins/autoloader/prism-autoloader", to: "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/plugins/autoloader/prism-autoloader.min.js"
