document.onkeypress = function (e){
    if(!e) e = window.event;

    if(e.keyCode == 13) {
        window.setTimeout( function() {
            let rowList = document.querySelector("game-app").shadowRoot. //
                    querySelector("game-theme-manager"). //
                    querySelector("#board").querySelectorAll("game-row");

            var ledString = '';
            for( let row = 0 ; row < 6 ; row++) {
                let aRow = rowList.item(row).shadowRoot.querySelectorAll("game-tile");
                for( let col = 0 ; col < 5 ; col++) {
                    let aLed = aRow.item(col);
                    switch(aLed.getAttribute('evaluation')) {
                        case 'correct':
                            ledString = ledString + 'G';
                            break;
                        case 'present':
                            ledString = ledString + 'Y';
                            break;
                        case 'absent':
                        default:
                            ledString = ledString + 'B';
                            break;
                    }
                }
            }

            console.log("board : ", ledString);
            browser.runtime.sendMessage({ board: ledString }).then((response) => {
                /* no response */
            });
        }, 2000 );
    }
};
