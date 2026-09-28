jQuery(document).ready(function ($) {

    $(window).on('scroll', function () {
        if ($(this).scrollTop() > 100) {
            $('#back-to-top').addClass('show');
        } else {
            $('#back-to-top').removeClass('show');
        }
    });

    $('#back-to-top').on('click', function (e) {
        e.preventDefault();
        $('html, body').animate({ scrollTop: 0 }, 500);
    });


    $('#hamburger-btn').on('click', function () {
        $('#mobile-menu').toggleClass('open');
        var icon = $(this).find('i');
        if ($('#mobile-menu').hasClass('open')) {
            icon.removeClass('fa-bars').addClass('fa-times');
        } else {
            icon.removeClass('fa-times').addClass('fa-bars');
        }
    });


    $('#mobile-menu a').on('click', function () {
        $('#mobile-menu').removeClass('open');
        $('#hamburger-btn i').removeClass('fa-times').addClass('fa-bars');
    });

});

var currentSlide = 0;
var slides = document.querySelectorAll('.hero-slide');
var dots = document.querySelectorAll('.dot');

function goToSlide(index) {
    slides[currentSlide].classList.remove('active');
    dots[currentSlide].classList.remove('active');
    currentSlide = index;
    slides[currentSlide].classList.add('active');
    dots[currentSlide].classList.add('active');
}

function nextSlide() {
    var next = (currentSlide + 1) % slides.length;
    goToSlide(next);
}


