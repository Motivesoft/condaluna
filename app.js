const toggleButton = document.getElementsByClassName('toggle-button')[0]
const navbarLinks = document.getElementsByClassName('navbar-links')[0]

toggleButton.addEventListener('click', () => {
  navbarLinks.classList.toggle('active')
})

function copySourceUrl(e) {
  var caller = e.target || e.srcElement;

  showSnackbar("copyMessage");

  console.log( "Trying to write source URL to clipboard: " + caller.src );
  navigator.clipboard.writeText( caller.src );
}

function showSnackbar(id) {
  var x = document.getElementById( id );

  x.className = "show";

  setTimeout( function() { 
    x.className = x.className.replace( "show", "" ); 
  }, 2500 );
}
