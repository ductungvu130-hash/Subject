let mybutton = document.getElementById("goToTopBtn");

window.onscroll = function() { 
    if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
        mybutton.style.display = "block";
    } else {
        mybutton.style.display = "none";
    }
};

mybutton.onclick = function() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
};