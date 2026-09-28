$(document).ready(function () {
    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('#goTopBtn').fadeIn();
        } else {
            $('#goTopBtn').fadeOut();
        }
    });

    $('#goTopBtn').click(function (e) {
        e.preventDefault();
        $('html, body').animate({ scrollTop: 0 }, 500);
    });
});