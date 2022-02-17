var containerElem = document.getElementById("container")

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'tutorial') {

      console.log(event.data.name)
      if (true) {

      }
    }
});
