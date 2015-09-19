
// form_helper.js
// // Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
replace_ids = function(s){
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

//var myrules = {
//  '.remove': function(e){
//    el = Event.findElement(e);
//    target = el.href.replace(/.*#/, '.')
//    el.up(target).hide();
//    if(hidden_input = el.previous("input[type=hidden]")) hidden_input.value = '1'
//  },
//  '.add_nested_item': function(e){
//    el = Event.findElement(e);
//    template = eval(el.href.replace(/.*#/, ''))
//    $(el.rel).insert({
//      bottom: replace_ids(template)
//    });
//  },
//  '.add_nested_item_lvl2': function(e){
//    el = Event.findElement(e);
//    elements = el.rel.match(/(\w+)/g)
//    parent = '.'+elements[0]
//    child = '.'+elements[1]
//
//    child_container = el.up(parent).down(child)
//    parent_object_id = el.up(parent).down('input').name.match(/.*\[(\d+)\]/)[1]
//
//    template = eval(el.href.replace(/.*#/, ''))
//
//    template = template.replace(/(attributes[_\]\[]+)\d+/g, "$1"+parent_object_id)
//
//   // console.log(template)
//    child_container.insert({
//      bottom: replace_ids(template)
//     });
//  }
//};

//Event.observe(window, 'load', function(){
//  $('container').delegate('click', myrules);
//});


//function remove_fields(link) {
//  $(link).previous("input[type=hidden]").value = "1";
//  $(link).up(".fields").hide();
//}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  var chunk =  content.replace(regexp, new_id);
  $(link).parent().after(chunk);
}

$(document).ready(function() {
    var ani = $('.add_nested_item');
    for (var i=0; i<ani.length; i++){
        $(ani[i]).on('click', function(e){
            console.log("ani click: e= " + e);
            var current_section = $('#' + e.currentTarget.attributes[2].nodeValue);
            var template = window[e.currentTarget.attributes[1].nodeValue.substring(1,e.currentTarget.attributes[1].nodeValue.length)];
            current_section.append(replace_ids(template));
        })
    }

    var rni = $('.remove');
    for (var i=0; i<rni.length; i++){
        $(rni[i]).on('click', function(e){
            $(e.currentTarget).prev().attr('value', 1);
            var current_row = e.currentTarget.parentNode.parentNode.parentNode;
            current_row.hidden = true;
            console.log("rni click");
        })
    }
});

