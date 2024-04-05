document.addEventListener('DOMContentLoaded', () => {
  const button = document.getElementById('cart_item.id');

  function disableButton() {
    button.disabled = true;
  }

  function enableButton() {
    button.disabled = false;
  }

  function updateButtonStatus() {
    fetch('/check_product_quantity', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({})
    })
    .then(response => response.json())
    .then(data => {
      if (data.condition) {
        disableButton();
      } else {
        enableButton();
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }

  setInterval(updateButtonStatus, 1000); // Refresh button status every second
});
