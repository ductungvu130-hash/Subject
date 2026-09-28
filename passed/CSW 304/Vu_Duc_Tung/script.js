$(document).ready(function () {

  let cartItems = [];


  $.get(
    'http://localhost/final-exam-q3.php',
    { property: 'all' },
    function (data) {
      cartItems = data;
      renderCart(cartItems);
    },
    'json'
  );

  function renderCart(items) {
    $('#list').empty();
    if (items.length === 0) {
      $('#cartList').html('<tr><td colspan="5">Gio hang trong</td></tr>');
      return;
    }
    for (let item of items) {
      $('#cartList').append(`
        <div class="col">
            <div class="border rounded p-4 h-100" id="${item.id}">
                <img src="${item.image}" width="100%" class="mb-3">
                <a href="#"><h5>${item.name}</h5></a>
                <p><b>Address: </b>${item.address}</p>
                <p><b>Area: </b> ${item.area}</p>
                <p><b>Region: </b>${item.region} </p>
                <p class = "price">${item.price}</p>
                <button type="button" id="btnDelete" class="btnDelete">Delete</button>
            </div>
        </div>
      `);
    }
  }

  $('body').on('click', '.btnDelete', function () {
    if (confirm('Are you sure?')) {
        let _id = $(this).attr('data-id');
        for (let i in cartItems) {
            if (cartItems[i].ID == _id) {
                cartItems.splice(i, 1); 
                break;
            }
        }
    }
});

});



