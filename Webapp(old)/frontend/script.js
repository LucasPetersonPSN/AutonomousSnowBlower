const ws = new WebSocket("ws://10.42.0.1:8765");  // Replace with Jetson's IP if needed

ws.onopen = () => console.log("WebSocket connected");
ws.onerror = (error) => console.error("WebSocket error:", error);

// Function to send commands over WebSocket
function sendCommand(command) {
    if (ws.readyState === WebSocket.OPEN) {
        ws.send(command);
    }
}

// Show different mode screens
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

// Attach event listeners to control buttons
document.addEventListener("DOMContentLoaded", () => {

    // Mouse and Keyboard
    document.getElementById("forwardButton").addEventListener("mousedown", () => sendCommand("F"));
    document.getElementById("backwardsButton").addEventListener("mousedown", () => sendCommand("B"));
    document.getElementById("leftButton").addEventListener("mousedown", () => sendCommand("L"));
    document.getElementById("rightButton").addEventListener("mousedown", () => sendCommand("R"));
    document.getElementById("restartButton").addEventListener("mousedown", () => sendCommand("C"));
    document.getElementById("speed25").addEventListener("mousedown", () => sendCommand("25"));
    document.getElementById("speed50").addEventListener("mousedown", () => sendCommand("50"));
    document.getElementById("speed75").addEventListener("mousedown", () => sendCommand("75"));
    document.getElementById("speed100").addEventListener("mousedown", () => sendCommand("100"));
    document.addEventListener("mouseup", () => sendCommand("S"));

    // Touchscreen
    document.getElementById("forwardButton").addEventListener("touchstart", () => sendCommand("F"));
    document.getElementById("backwardsButton").addEventListener("touchstart", () => sendCommand("B"));
    document.getElementById("leftButton").addEventListener("touchstart", () => sendCommand("L"));
    document.getElementById("rightButton").addEventListener("touchstart", () => sendCommand("R"));
    document.getElementById("restartButton").addEventListener("touchstart", () => sendCommand("C"));
    document.getElementById("speed25").addEventListener("touchstart", () => sendCommand("25"));
    document.getElementById("speed50").addEventListener("touchstart", () => sendCommand("50"));
    document.getElementById("speed75").addEventListener("touchstart", () => sendCommand("75"));
    document.getElementById("speed100").addEventListener("touchstart", () => sendCommand("100"));
    document.addEventListener("touchend", () => sendCommand("S"));
});

// Debugging: log key presses
document.addEventListener("keydown", (e) => {
    console.log(e.key);
});

document.addEventListener("keyup", (e) => {
    console.log(e.key);
});

