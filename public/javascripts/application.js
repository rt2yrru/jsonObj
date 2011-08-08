$(document).ready(function(){
	$("#loadMore a").click(function (){
    nextArticle();
  });
  
});

function nextArticle(){
  $.getJSON('articles/load_more.js', function(data) {
    getArticle(data, $(".article").size());
  });
}

function getArticle(data, elNo){
  if(data[elNo]){
    var items = [];
    items.push(
      '<div id="' + elNo + '" class="article"><span class="title">' + data[elNo].article.title + '</span><p>' + data[elNo].article.body + '</p><span class="author">' + data[elNo].article.author + '</span><hr/></div>'
    );
    $('<div/>', {
      html: items.join('')
    }).appendTo('#articleContainer');
  }else{
    $('#loadMore').html('No more articles to show.');
  }
}