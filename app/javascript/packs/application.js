// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("trix")
require("@rails/actiontext")

document.addEventListener("turbolinks:load", () => {
  for (const form of document.querySelectorAll("form:not([novalidate])")) {
    for (const input of form.elements) {
      input.addEventListener("invalid", (event) => {
        const input = event.target
        const form = input.form
        const validationMessageId = [form.id, input.id, "validation_message"].join("_")
        const validationMessageTemplate = form.querySelector(`[data-validation-message-template="${form.id}"]`)
        const validationMessageTemplateElement = validationMessageTemplate?.content.children[0].cloneNode()
        const validationMessageElement = document.getElementById(validationMessageId) || validationMessageTemplateElement

        if (validationMessageElement) {
          const validationMessages = JSON.parse(validationMessageTemplate?.dataset.validationMessages || "{}")
          const [ _, validationMessage ] = Object.entries(validationMessages).find(([ key ]) => input.validity[key]) || [ null, input.validationMessage ]

          validationMessageElement.id = validationMessageId
          validationMessageElement.innerHTML = validationMessage

          input.setAttribute("aria-describedby", validationMessageElement.id)
          input.setAttribute("aria-invalid", "true")

          if (!validationMessageElement.parentElement) {
            input.parentElement.append(validationMessageElement)
          }

          event.preventDefault()
        }
      })

      const { validationMessage, willValidate } = input.dataset

      if (validationMessage) {
        input.setCustomValidity(validationMessage)
        input.reportValidity()
      } else if (willValidate) {
        const ariaDescribedby = input.getAttribute("aria-describedby") || ""
        const describedByIds = ariaDescribedby.split(" ").filter(id => id)
        const validationMessageElements = describedByIds.length ?
          document.querySelectorAll(describedByIds.map(id => "#" + id).join(",")) :
          []
        const validationMessage = Array.from(validationMessageElements).
          map(element => element.textContent).join(" ")

        input.setCustomValidity(validationMessage)
        input.reportValidity()
      }
    }
  }
})

document.addEventListener("input", ({ target }) => {
  if (target.matches("[data-validation-message]")) {
    target.setCustomValidity("")
  }
})
