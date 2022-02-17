var lastPercent = 1
var containerElem = document.getElementById("container")
var thisLevelElem = document.getElementById("this");
var nextLevelElem = document.getElementById("next");
var xpElem = document.getElementById('xp');

console.log(containerElem)

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function moveUp(percent, didLevelUp, thisLevel, currentXP, nextRank_XP) {

    showBar()
    //console.log(event.data.nextRank_XP)

    var elem = document.getElementById("xpBar");
    var width = percent;

    if (percent < lastPercent || didLevelUp) {

      elem.style.width = 100 + "%";
      //console.log("Set to 100")

      sleep(1000).then(() => {
        updateLevels(thisLevel)

        elem.style.transition = 'all 0s';
        elem.style.width = 0 + "%";
        //console.log("Set to 0")

        sleep(100).then(() => {
          elem.style.transition = 'all 1s';
          elem.style.width = width + "%";
        });
      });

    } else {
        elem.style.width = width + "%";
    }

    updateXP(currentXP, nextRank_XP)
    lastPercent = percent;

    sleep(7000).then(() => {
      containerElem.style.opacity = 0 + '%';
    });
}

function moveDown(percent, didLevelUp, thisLevel, currentXP, nextRank_XP) {

    showBar()
    var elem = document.getElementById("xpBar");
    var width = percent;

    elem.style.backgroundColor = '#BA5F68';

    if (percent > lastPercent || didLevelUp) {

      elem.style.width = 0 + "%";
      //console.log("Set to 0")

      sleep(1000).then(() => {
        updateLevels(thisLevel)

        elem.style.transition = 'all 0s';
        elem.style.width = 100 + "%";
        //console.log("Set to 100")

        sleep(100).then(() => {
          elem.style.transition = 'all 1s';
          elem.style.width = width + "%";
        });
      });

    } else {
        elem.style.width = width + "%";
    }

    sleep(3000).then(() => {
      elem.style.backgroundColor = '#5F70B9';
    });

    updateXP(currentXP, nextRank_XP)
    lastPercent = percent;

    sleep(7000).then(() => {
      containerElem.style.opacity = 0 + '%';
    });
}

function updateLevels(thisLevel, nextLevel) {
  if (thisLevel === 100) {
    thisLevelElem.innerHTML = 100
    nextLevelElem.innerHTML = 100
  } else {
    thisLevelElem.innerHTML = thisLevel
    nextLevelElem.innerHTML = thisLevel + 1
  }
}

function updateXP(xp, nextRank_XP) {
  var xp_f = xp.toLocaleString('en-US')
  //console.log(xp_f)
  var nextRank_XP_f = nextRank_XP.toLocaleString('en-US')
  //console.log(nextRank_XP_f)
  xpElem.innerHTML = xp_f + ' / ' + nextRank_XP_f
}

function showBar() {
  containerElem.style.opacity = 100 + '%';
}

function hideBar() {
    containerElem.style.opacity = 0 + '%';
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'updateBar') {
      //console.log(event.data.dir)
      console.log(event.data.currentXP)
      //console.log(event.data.nextRank_XP)
      if (event.data.dir === 4) {
        moveUp(100, true, 100, 2008000, 2008000)
      } else if (event.data.dir === 3) {
        console.log('Moving down')
        moveDown(event.data.percent, event.data.didLevelUp, event.data.thisLevel, event.data.currentXP, event.data.nextRank_XP)
      } else {
        console.log('Moving up')
        moveUp(event.data.percent, event.data.didLevelUp, event.data.thisLevel, event.data.currentXP, event.data.nextRank_XP)
      }

    }
});

window.addEventListener('message', (event) => {
  if (event.data.type === 'showBar') {
    showBar()
  }
});

window.addEventListener('message', (event) => {
  if (event.data.type === 'hideBar') {
    hideBar()
  }
});

window.addEventListener('message', (event) => {
  if (event.data.type === 'initBar') {

  }
});
