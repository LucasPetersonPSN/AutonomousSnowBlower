const ws = new WebSocket("ws://10.42.0.1:8765");  // This IP must be the Jetsons IP. If this is changing, this means it is not a static IP, and must be fixed ASAP

//Confirm that the websocket connected
ws.onopen = () => console.log("WebSocket connected");
ws.onerror = (error) => console.error("WebSocket error:", error);

// This block sends commands over the WebSocket to the Jetson
function sendCommand(command) {
    if (ws.readyState === WebSocket.OPEN) {
        ws.send(command);
    }
}

// This code block performs the screen switching functionality
function showScreen(screenId) {
    const screens = ["manualModeScreen", "autoModeScreen", "mappingModeScreen"];
    screens.forEach(screen => {
        document.getElementById(screen).style.display = 'none';
    });
    document.getElementById(screenId).style.display = 'block';
}


function manualModeScreen() {
    showScreen("manualModeScreen");
}

function autoModeScreen() {
    showScreen("autoModeScreen");
}

function mappingModeScreen() {
    showScreen("mappingModeScreen");
}




//MODIFY CODE HERE FOR BUTTONS THAT SEND COMMANDS TO THE JETSON! getElementById is initated by giving the button you made an ID in the HTML.
//All buttons but the movement buttons should be MOUSEUP. This is to prevent accidential clicks. 
document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("forwardButton").addEventListener("mousedown", () => sendCommand("F"));
    document.getElementById("backwardsButton").addEventListener("mousedown", () => sendCommand("B"));
    document.getElementById("leftButton").addEventListener("mousedown", () => sendCommand("L"));
    document.getElementById("rightButton").addEventListener("mousedown", () => sendCommand("R"));
    document.getElementById("restartButton").addEventListener("mousedown", () => sendCommand("C"));
    document.addEventListener("mouseup", () => sendCommand("S"));
});

// Debugging: log key presses
document.addEventListener("keydown", (e) => {
    console.log(e.key);
});

document.addEventListener("keyup", (e) => {
    console.log(e.key);
});

