function messageDiv (message, config) {
  config = config || {}
  var e = document.createElement('div')
  e.innerHTML = ((config.title
                  ? (message.template.title
                     ? (('[' + message.template.title + ']') + ' ')
                     : '')
                  : '')
                 + (message.template.author
                    ? (message.template.author + ': ')
                    : '')
                 +  message.expansion.text)
  if (config.style)
    e.setAttribute('style',config.style)
  return e
}

var textdefsElement = document.getElementById('textdefs')
var tempdefsElement = document.getElementById('tempdefs')
var threadElement = document.getElementById('thread')
var resetElement = document.getElementById('reset')

function update() {
  try {
    var defs = {}
    if (textdefsElement.value.match(/\S/)) {
      try {
        defs = JSON.parse (textdefsElement.value)
      } catch (e) {
        defs = bracery.ParseTree.parseTextDefs (textdefsElement.value)
      }
    }

    var templates = []
    if (tempdefsElement.value.match(/\S/)) {
      try {
        templates = JSON.parse (tempdefsElement.value)
      } catch (e) {
        templates = bracery.Template.parseTemplateDefs (tempdefsElement.value)
      }
    }

    var b = new bracery.Bracery (defs)
    var markovConfig = {
      bracery: b,
      templates: templates,
      vars: {},
      accept: function (message, thread, resolve) {
        threadElement.innerHTML = ""
        if (thread)
          thread.forEach (function (threadMessage) {
            threadElement.appendChild (messageDiv (threadMessage, { style: 'background-color: #ddd;' }))
          })
        threadElement.appendChild (messageDiv (message, { title: true, style: 'font-style: italic; background-color: #bbb;' }))
        var acceptElement = document.createElement('a')
        var rejectElement = document.createElement('a')
        var span = document.createElement('span')
        acceptElement.innerText = 'Accept'
        rejectElement.innerText = 'Reject'
        span.innerText = ' / '
        acceptElement.setAttribute ('href', '#')
        rejectElement.setAttribute ('href', '#')
        threadElement.appendChild (acceptElement)
        threadElement.appendChild (span)
        threadElement.appendChild (rejectElement)
        acceptElement.addEventListener ('click', function(e) {
          e.preventDefault()
          resolve (true)
        })
        rejectElement.addEventListener ('click', function(e) {
          e.preventDefault()
          resolve (false)
        })
      }
    }

    currentAccept = currentReject = null
    bracery.Template.promiseMessageList (markovConfig)
      .then (function (thread) {
        threadElement.innerHTML = ""
        if (thread)
          thread.forEach (function (threadMessage) {
            threadElement.appendChild (messageDiv (threadMessage, { title: true }))
          })
      })
    
  } catch (e) {
    threadElement.innerText = e
  }
}
textdefsElement.addEventListener ('keyup', update)
tempdefsElement.addEventListener ('keyup', update)
resetElement.addEventListener ('click', update)

var symbolsUrl = window.location.href + "symbols.bracery"
var markovUrl = window.location.href + "templates.bracery"

var defsReq = new XMLHttpRequest();
defsReq.addEventListener("load", function() {
  textdefsElement.value = this.responseText

  var tempReq = new XMLHttpRequest();
  tempReq.addEventListener("load", function() {
    tempdefsElement.value = this.responseText
    update()
  })
  console.warn ('loading ' + markovUrl)
  tempReq.open("GET", markovUrl);
  tempReq.send()
});
console.warn ('loading ' + symbolsUrl)
defsReq.open("GET", symbolsUrl);
defsReq.send()
