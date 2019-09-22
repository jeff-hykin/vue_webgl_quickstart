import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

# a simple container used to display the App component
vueContainer = new Vue({ render: (h) => h(App) })

# create an element and attach the container to it
htmlElement = document.createElement("div")
document.body.appendChild(htmlElement)
vueContainer.$mount(htmlElement)
