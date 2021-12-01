import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import Buzzer from "./buzzer"

let socket = new Socket("/socket", {})

let channel = socket.channel("buzzer", {})

channel.on("sound", _payload => {
  Buzzer.sound()
})

channel.join()
  .receive("ok", resp => { })
  .receive("error", resp => { console.log("Unable to join", resp) })

socket.connect()

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()

export default socket
