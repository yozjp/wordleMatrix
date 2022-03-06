browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Background.js Received request: ", request);

    browser.runtime.sendNativeMessage("application.id", {message: request.board}, function(response) {
        const obj = JSON.parse(response);
        /* do nothing */
    });

    return true;
});

