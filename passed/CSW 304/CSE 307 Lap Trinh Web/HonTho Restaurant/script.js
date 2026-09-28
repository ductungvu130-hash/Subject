window.onscroll = function () {
    let btn = document.getElementById("go-to-top");
    if (window.scrollY > 200) {
        btn.style.display = "block";
    } else {
        btn.style.display = "none";
    }
};

function scrollToTop() {
    window.scrollTo({
        top: 0,
    });
}
