// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

const celebrate = () => {
  const colors = ["#febf8b", "#555742", "#b45836"]
  confetti({particleCount: 100, angle: 60, spread: 55, origin: {x:0}, colors,})
  confetti({particleCount: 100, angle: 120, spread: 55, origin: {x:1}, colors,})
}

window.addEventListener("phx:gameover", (e) => {
  const { win } = e.detail
  if (win) {
    celebrate()
  }
})

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}

var localStream
async function initStream() {
    try {
      // Gets our local media from the browser and stores it as a const, stream.
      const stream = await navigator.mediaDevices.getUserMedia({audio: true, video: true, width: "1280"})
      // Stores our stream in the global constant, localStream.
      localStream = stream
      // Sets our local video element to stream from the user's webcam (stream).
      document.getElementById("attendee-video").srcObject = stream
    } catch (e) {
      console.log(e)
    }
}

Hooks.JoinCall = {
    mounted() {
      initStream()
    }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())
window.addEventListener("phx:page-loading-start", info => NProgress.start())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

