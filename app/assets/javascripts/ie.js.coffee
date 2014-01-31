if navigator.userAgent.match(/IEMobile\/10\.0/)
  msViewportStyle = document.createElement("style")
  msViewportStyle.appendChild document.createTextNode("@-ms-viewport{width:auto!important}")
  document.querySelector("head").appendChild msViewportStyle