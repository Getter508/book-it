/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker');
import $ from "jquery";
import "foundation-sites";

$(document).ready(() => {
  $(document).foundation();
  $(".modal-form").on("submit", function(event) {
    event.preventDefault();
    let data = $(this).serializeArray();

    let request = $.ajax({
      method: "POST",
      async: true,
      data: data,
      url: '/api/v1/have_read_books.json'
    });

    request.done(function(response) {
      let button_div = $(`#buttons-${response.book_id}`);
      $(button_div).html("<p class='read-sign'>Already Read</p>");
      return response;
    }).then(function(response){
      $(`#modal-${response.book_id}`).foundation("close");
    });
  });
});
