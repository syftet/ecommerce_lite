(function ($) {

    $.fn.rateit = function (options) {

        return this.each(function () {
            var element = $(this);
            var rating = element.attr('data-rating');
            if (typeof rating != 'NaN') {
                rating = parseInt(rating);
            }
            else {
                rating = 0;
            }
            element.html(_getHtml(element, rating));
        });

        function _getHtml(element, rate) {
            html = '';
            html += '<div class="rate">';
            for (i = 1; i <= rate; i++) {
                html += '<div class="rate-item active"> <i class="fa fa-star icon icon-star"></i> </div>';
            }

            for (i = (rate + 1); i <= 5; i++) {
                html += '<div class="rate-item"><i class="fa fa-star-o icon icon-star"></i></div>';
            }
            html += '</div>';
            return html;
        }
    };
}(jQuery));