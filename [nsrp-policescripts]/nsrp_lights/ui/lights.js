var hud = document.getElementById("lights_hud");
var button1 = document.getElementById("button1");
var button2 = document.getElementById("button2");
var button3 = document.getElementById("button3");
var button4 = document.getElementById("button4");
var button5 = document.getElementById("button5");
var indicator = document.getElementById("indicator");

var helper1 = document.getElementById("helper1");
var helper2 = document.getElementById("helper2");
var helper3 = document.getElementById("helper3");
var helper4 = document.getElementById("helper4");
var helper5 = document.getElementById("helper5");


// console.log(hud);
// console.log(button1);
// console.log(button2);
// console.log(button3);
// console.log(button4);
// console.log(button5);


window.addEventListener('message', (event) => {
  var data = event.data
  if (data.type === 'clearButtons') {
    console.log('Clear buttons triggered')
    hud.style.opacity = 0 + '%'
    button1.style.display = 'none';
    button2.style.display = 'none';
    button3.style.display = 'none';
    button4.style.display = 'none';
    button5.style.display = 'none';

    helper1.style.display = 'none';
    helper2.style.display = 'none';
    helper3.style.display = 'none';
    helper4.style.display = 'none';
    helper5.style.display = 'none';

    button1.setAttribute("data-on", "false");
    button2.setAttribute("data-on", "false");
    button3.setAttribute("data-on", "false");
    button4.setAttribute("data-on", "false");
    button5.setAttribute("data-on", "false");

  } else if (data.type === 'addButton') {
    // num 5
    if (data.key === 126) {
      button1.innerHTML = data.label
      button1.style.display = 'inline-block';
      helper1.style.display = 'inline-block';
      if (data.state === 1) {
        button1.setAttribute("data-on","true");
      }
    // num 6
    } else if (data.key === 125) {
        button2.innerHTML = data.label
      button2.style.display = 'inline-block';
      helper2.style.display = 'inline-block';
      if (data.state === 1) {
        button2.setAttribute("data-on","true");
      }
    //  num 7
    } else if (data.key === 117) {
      button3.innerHTML = data.label
      button3.style.display = 'inline-block';
      helper3.style.display = 'inline-block';
      if (data.state === 1) {
        button3.setAttribute("data-on","true");
      }
    // num 8
    } else if (data.key === 127) {
      button4.innerHTML = data.label
      button4.style.display = 'inline-block';
      helper4.style.display = 'inline-block';
      if (data.state === 1) {
        button4.setAttribute("data-on","true");
      }
    // num 9
    } else if (data.key === 118) {
      button5.innerHTML = data.label
      button5.style.display = 'inline-block';
      helper5.style.display = 'inline-block';
      if (data.state === 1) {
        button5.setAttribute("data-on","true");
      }
    }
  } else if (data.type === 'showLightsHUD') {
    hud.style.opacity = 80 + '%'
  } else if (data.type === 'hideLightsHUD') {
    hud.style.opacity = 0 + '%'
  }
});


window.addEventListener('message', (event) => {
  var data = event.data
  if (data.type === 'toggleButton') {
    // console.log(data.key)
    // console.log(data.state)
    // num 5
    if (data.key === 126) {
      if (data.state === true) {
        // console.log('hi')
        button1.setAttribute("data-on","true");
      } else {
        button1.setAttribute("data-on","false");
      }
    // num 6
    } else if (data.key === 125) {
      if (data.state === true) {
        // console.log('hi')
        button2.setAttribute("data-on","true");
      } else {
        button2.setAttribute("data-on","false");
      }
    //  num 7
    } else if (data.key === 117) {
      if (data.state === true) {
        // console.log('hi')
        button3.setAttribute("data-on","true");
      } else {
        button3.setAttribute("data-on","false");
      }
    // num 8
    } else if (data.key === 127) {
      if (data.state === true) {
        // console.log('hi')
        button4.setAttribute("data-on","true");
      } else {
        button4.setAttribute("data-on","false");
      }
    // num 9
    } else if (data.key === 118) {
      if (data.state === true) {
        // console.log('hi')
        button5.setAttribute("data-on","true");
      } else {
        button5.setAttribute("data-on","false");
      }
    }
  }
});

window.addEventListener('message', (event) => {
  var data = event.data
  if (data.type === 'toggleIndicator') {
    if (data.state === true) {
      // console.log('hi')
      indicator.style.backgroundColor = 'var(--col-1)';
    } else {
      indicator.style.backgroundColor = 'var(--bg-col-1)';
    }
  }
});

window.addEventListener('message', (event) => {
  var data = event.data
  if (data.type === 'hideHelpers') {
    helper1.style.display = 'none';
    helper2.style.display = 'none';
    helper3.style.display = 'none';
    helper4.style.display = 'none';
    helper5.style.display = 'none';
  }
});
