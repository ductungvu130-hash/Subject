jQuery(document).ready(function($) {
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
});