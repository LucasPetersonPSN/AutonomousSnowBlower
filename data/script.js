function showScreen(screenId) {
    // Hide all screens
    const screens = ["manualModeScreen", "autoModeScreen", "mappingModeScreen"];
    screens.forEach(screen => {
        document.getElementById(screen).style.display = 'none';
    });

    // Show the selected screen
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

document.addEventListener('keydown', (e)=>{
    console.log(e.key);
})

document.addEventListener('keyup', (e)=>{
    console.log(e.key);
})