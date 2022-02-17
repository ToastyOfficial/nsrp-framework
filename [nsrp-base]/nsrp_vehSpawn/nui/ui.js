
var saveButtons = {}
var playerLevel = 30

$( function(){

  window.addEventListener('message', (event) => {
  	let data = event.data
    let name = data.name
    // Create button with name as text
  	if(data.action == 'popSaves') {
  		console.log(`Saves: ${data.name}`)

      $("#sub_saved").prepend("<button class='menuoption' onclick='sendSaveVeh($( this ).text())'>" + name + "</button>");

      // Set it to have action?

      // $( button ).click( function() {
      //     sendData( "SaveClick", name);
      // } )

  	}
  })
})

// Recieve level from client
$( function(){
  window.addEventListener('message', (event) => {
    if(event.data.type == 'updateLevel') {
      playerLevel = event.data.level
      //console.log(playerLevel)
      updateLocked()
    }
  })
})


var sendSaveVeh = function(name){
  //console.log(`Test functionality`) // will print Hello world! in the console (F8)
  console.log(name)
  sendData( "SaveClick", name);
}


/*--------------------------------------------------------------------------

    ActionMenu - v1.0.1
    Created by WolfKnight
    Additional help from lowheartrate, TheStonedTurtle, and Briglair.

--------------------------------------------------------------------------*/

$( function() {
    // Adds all of the correct button actions
    init();

    // Gets the actionmenu div container
    var actionContainer = $( "#actionmenu" );

    // Listens for NUI messages from Lua
    window.addEventListener( 'message', function( event ) {
        var item = event.data;

        // Show the menu
        if ( item.showmenu ) {
            ResetMenu()
            actionContainer.show();
        }

        // Hide the menu
        if ( item.hidemenu ) {
            actionContainer.hide();
            $('.menuoption[onclick]').each(function(){
              $( this ).remove();
            });
        }
    } );

    // Pressing the ESC key with the menu open closes it
    document.onkeyup = function ( data ) {
        if ( data.which == 27 ) { // Escape key
            if ( actionContainer.is( ":visible" ) ) {
                sendData( "ButtonClick", "exit" )
            }
        }
    };
} )

// Hides all div elements that contain a data-parent, in
// other words, hide all buttons in submenus.
function ResetMenu() {
    $( "div" ).each( function( i, obj ) {
        var element = $( this );

        if ( element.attr( "data-parent" ) ) {
            element.hide();
        } else {
            element.show();
        }
    } );
}

function updateLocked() {
  // Loops through every button that has the class of "menuoption"
  $( ".menuoption" ).each( function( i, obj ) {
    if ( $( this ).attr( "data-veh" ) ) {
      // I should try to add data-level here to change button style based on level, would need to have lua tell this script the players level when the menu is opened.
      var level = $( this ).data( "level" );

      if (level > playerLevel) {
        this.style.opacity = 30 + '%'
      } else {
        this.style.opacity = 100 + '%'
      }
    }
  } );
}

// Configures every button click to use its data-action, or data-sub
// to open a submenu.
function init() {

    // Loops through every button that has the class of "menuoption"
    $( ".menuoption" ).each( function( i, obj ) {

        // If the button has a data-action, then we set it up so when it is
        // pressed, we send the data to the lua side.
        if ( $( this ).attr( "data-action" ) ) {
          // what button will do when clicked
          $( this ).click( function() {
              var data = $( this ).data( "action" );


              // sends data to lua when button is clicked I think?
              sendData( "ButtonClick", data );
          } )
        }
        // If the button has data-veh then set it up to trigger vehicle spawn function
        // BY FLOH

        if ( $( this ).attr( "data-veh" ) ) {
          // I should try to add data-level here to change button style based on level, would need to have lua tell this script the players level when the menu is opened.
          var level = $( this ).data( "level" );
          var curText = this.innerHTML
          this.innerHTML = curText + '<span class = "level">' + level + '</span>'
            $( this ).click( function() {
                var name = $( this ).data( "veh" );

                var data = [name, level]
                sendData( "VehClick", data);
            } )
        }

        // If the button has data-extra then set it up to trigger extra change
        // BY FLOH

        if ( $( this ).attr( "data-extra" ) ) {
            $( this ).click( function() {
                var data = $( this ).data( "extra" );
                sendData( "ExtraClick", data);
            } )
        }

        // if ( $( this ).attr( "data-save" ) ) {
        //     $( this ).click( function() {
        //         var data = $( this ).data( "save" );
        //         sendData( "SaveClick", data);
        //     } )
        // }

        // If the button has a data-sub, then we set it up so when it is
        // pressed, we show the submenu buttons, and hide all of the others.
        if ( $( this ).attr( "data-sub" ) ) {
            var menu = $( this ).data( "sub" );
            var element = $( "#" + menu );

            $( this ).click( function() {
                element.show();
                $( this ).parent().hide();
            } )

            $( this ).hover(
                function() {
                    $( this ).append( $( "<span> >></span>" ) );
                }, function() {
                    $( this ).find( "span:last" ).remove();
                }
            );

            // This small section auto generates a back button for every
            // submenu.
            var backBtn = $( '<button/>', { text: 'Back', class: 'back' } );

            backBtn.click( function() {
                element.hide();
                $( "#" + element.data( "parent" ) ).show();
            } );

            element.append( backBtn );
        }
    } );

    $( "#actionmenu" ).children( "div" ).each( function( i, obj ) {
        var exitBtn = $( '<button/>', { text: 'Exit', class: 'back' } );
        exitBtn.click( function() {
            sendData( "ButtonClick", "exit" );
        } );

        $( this ).append( exitBtn );
    } );
}

// Send data to lua for processing.
function sendData( name, data ) {
    $.post( "http://nsrp_vehSpawn/" + name, JSON.stringify( data ), function( datab ) {
        if ( datab != "ok" ) {
            //console.log( datab );
        }
    } );
}
