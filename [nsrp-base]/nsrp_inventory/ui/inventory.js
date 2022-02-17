var inventory = document.getElementById("inventory");
var capacity_text = document.getElementById("capacity");
var name_text = document.getElementById("name_text");

var firearms_box = document.getElementById("firearms");
var weapons_box = document.getElementById("weapons");
var weed_box = document.getElementById("weed");
var weed2_box = document.getElementById("weed2");
var meth_box = document.getElementById("meth");
var meth2_box = document.getElementById("meth2");
var moneybags_box =document.getElementById("moneybags");

var firearms_num = document.getElementById("firearms_count");
var weapons_num = document.getElementById("weapons_count");
var weed_num = document.getElementById("weed_count");
var weed2_num = document.getElementById("weed2_count");
var meth_num = document.getElementById("meth_count");
var meth2_num = document.getElementById("meth2_count");
var moneybags_num = document.getElementById("moneybags_count");

window.addEventListener('message', (event) => {
  var item = event.data.item;
  var amount = event.data.amount;
    if (event.data.type === 'updateItem') {
      console.log('Update Item Recieved')
      console.log(event.data.item)
      console.log(event.data.amount)
      if (item === 'iFirearms') {
        firearms_num.innerHTML = amount
      } else if (item === 'iWeapons') {
        weapons_num.innerHTML = amount;
      } else if (item === 'iWeed') {
        weed_num.innerHTML = amount;
      } else if (item === 'iWeed2') {
        weed2_num.innerHTML = amount;
      } else if (item === 'iMeth') {
        meth_num.innerHTML = amount;
      } else if (item === 'iMeth2') {
        meth2_num.innerHTML = amount;
      } else if (item === 'iMoneyBags') {
        moneybags_num.innerHTML = amount;
      }
    } else if (event.data.type === 'showItem') {
      console.log('Show Item Recieved')
      if (item === 'iFirearms') {
        firearms_box.style.display = "flex";
      } else if (item === 'iWeapons') {
        weapons_box.style.display = "flex";
      } else if (item === 'iWeed') {
        weed_box.style.display = "flex";
      } else if (item === 'iWeed2') {
        weed2_box.style.display = "flex";
      } else if (item === 'iMeth') {
        meth_box.style.display = "flex";
      } else if (item === 'iMeth2') {
        meth2_box.style.display = "flex";
      } else if (item === 'iMoneyBags') {
        moneybags_box.style.display = "flex";
      }
    } else if (event.data.type === 'hideItem') {
      console.log('Hide Item Recieved')
      if (item === 'iFirearms') {
        firearms_box.style.display = "none";
      } else if (item === 'iWeapons') {
        weapons_box.style.display = "none";
      } else if (item === 'iWeed') {
        weed_box.style.display = "none";
      } else if (item === 'iWeed2') {
        weed2_box.style.display = "none";
      } else if (item === 'iMeth') {
        meth_box.style.display = "none";
      } else if (item === 'iMeth2') {
        meth2_box.style.display = "none";
      } else if (item === 'iMoneyBags') {
        moneybags_box.style.display = "none";
      }
    }
});

window.addEventListener('message', (event) => {
  if (event.data.type === 'showInv') {
    inventory.style.opacity = 1.0;
  } else if (event.data.type === 'hideInv') {
    inventory.style.opacity = 0.0;
  }
});

// this needs testing : )
window.addEventListener('message', (event) => {
  if (event.data.type === 'updateCapacity') {
    console.log('Update Capacity Recieved')
    console.log('Capacity: ' + event.data.capacity)
    capacity_text.innerHTML = event.data.capacity + '/200';
  }
});

window.addEventListener('message', (event) => {
  if (event.data.type === 'setName') {
    console.log(event.data.name)
    name_text.innerHTML = event.data.name;
  }
});
