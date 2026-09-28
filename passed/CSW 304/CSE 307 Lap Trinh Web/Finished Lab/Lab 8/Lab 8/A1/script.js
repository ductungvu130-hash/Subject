function openMenu() {
    let overlay = document.querySelector(".overlay");
    overlay.style.display = "block";
    let closeMenu = document.querySelector(".close-menu");
    closeMenu.style.display = "block";
}

function closeMenu() {
    let overlay = document.querySelector(".overlay");
    overlay.style.display = "none";
}
