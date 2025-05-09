let eStopToggled = false;
let socket;

document.addEventListener('DOMContentLoaded', () => {
    socket = new WebSocket('ws://' + window.location.hostname + ':8765');

    const eStopButton = document.getElementById('eStop');
    const bladeToggle = document.getElementById('bladeToggle');

    eStopButton.addEventListener('click', () => {
        if (!eStopToggled) {
            socket.send("Estop");
            eStopButton.textContent = "Clear E-STOP";
            eStopToggled = true;
        } else {
            socket.send("JetAllClear");
            eStopButton.textContent = "E-STOP";
            eStopToggled = false;
        }
    });

    bladeToggle.addEventListener('change', () => {
        socket.send(bladeToggle.checked ? "BLADES_ON" : "BLADES_OFF");
    });

    addPressRelease('forwardButton', "F");
    addPressRelease('leftButton', "L");
    addPressRelease('rightButton', "R");
    addPressRelease('backwardsButton', "B");

    document.getElementById('speed25').addEventListener('click', () => socket.send("25"));
    document.getElementById('speed50').addEventListener('click', () => socket.send("50"));
    document.getElementById('speed75').addEventListener('click', () => socket.send("75"));
    document.getElementById('speed100').addEventListener('click', () => socket.send("100"));

    socket.onmessage = function (event) {
        if (event.data.startsWith("data:image/jpeg;base64,")) {
            const videoElement = document.getElementById('videoStream');
            if (videoElement) {
                videoElement.src = event.data;
            }
        } else if (event.data.startsWith("battery_data:")) {
    const parts = event.data.replace("battery_data:", "").split(",");
    if (parts.length === 2) {
        const per40 = parts[0];
        const per12 = parts[1];
        updateBannerBattery(per40, per12);
    } else {
        console.warn("Invalid battery data format:", event.data);
    }
}
    };
});

function addPressRelease(buttonId, command) {
    const button = document.getElementById(buttonId);
    if (!button) return;

    button.addEventListener('mousedown', () => socket.send(command));
    button.addEventListener('mouseup', () => socket.send("S"));
    button.addEventListener('touchstart', (e) => {
        e.preventDefault();
        socket.send(command);
    });
    button.addEventListener('touchend', (e) => {
        e.preventDefault();
        socket.send("S");
    });
}

function updateBannerBattery(per40, per12) {
    const banner = document.querySelector('.monitoring');
    if (banner) {
        banner.textContent = `40V: ${per40}% | 12V: ${per12}%`;
    }
}

function manualModeScreen() {
    hideAllScreens();
    document.getElementById('manualModeScreen').style.display = 'block';
}

function autoModeScreen() {
    hideAllScreens();
    document.getElementById('autoModeScreen').style.display = 'block';
}

function mappingModeScreen() {
    hideAllScreens();
    document.getElementById('mappingModeScreen').style.display = 'block';
}

function hideAllScreens() {
    document.getElementById('manualModeScreen').style.display = 'none';
    document.getElementById('autoModeScreen').style.display = 'none';
    document.getElementById('mappingModeScreen').style.display = 'none';
}

