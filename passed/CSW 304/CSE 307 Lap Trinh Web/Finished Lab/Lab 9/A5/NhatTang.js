let i = 1;
function Slider() {
    i = (i % 3) + 1;
    document.getElementById("background-header").src = `./images/slider-${i}.jpg`;
}
setInterval(Slider, 3000);

const btn = document.getElementById("button-up-down");

window.onscroll = function () {
    btn.style.display = window.scrollY > 100 ? "block" : "none";
};
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: "smooth",
    });
}
