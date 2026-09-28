let i = 1;
function Slider() {
    i = (i % 3) + 1;
    document.getElementById(
        "background-header"
    ).src = `./images/slider-${i}.jpg`;
}
setInterval(Slider, 3000);

