class GreetingMessage extends HTMLElement {
  constructor() {
    super();
    console.log("element constructed", this);
  }
  connectedCallback() {
    console.log("element connected", this);
  }
  disconnectedCallback() {
    console.log("element disconnected", this);
  }
}

if ("customElements" in window) {
  console.log("customElements supported");
  customElements.define("greeting-message", GreetingMessage);
} else {
  console.log("not supported!");
}
