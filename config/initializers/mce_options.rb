configatron.default_mce_options = {
    :selector => 'textarea.rich_text_editor',
    :relative_urls => false,
    :convert_urls => false,
    :convert_fonts_to_spans => true,
    :menubar => false,
    :statusbar => false,
    :toolbar => 'code undo redo | bold italic | alignleft aligncenter alignright| bullist link unlink image media',
    :plugins => %w{media link image preview autosave emoticons paste autoresize code table autoresize},
    :extended_valid_elements => "img[class|src|flashvars|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name|obj|param|embed|scale|wmode|salign|style],embed[src|quality|scale|salign|wmode|bgcolor|width|height|name|align|type|pluginspage|flashvars],object[align<bottom?left?middle?right?top|archive|border|class|classid|codebase|codetype|data|declare|dir<ltr?rtl|height|hspace|id|lang|name|style|tabindex|title|type|usemap|vspace|width]",
    :media_strict => false
}

configatron.simple_mce_options = {
    :selector => 'textarea.rich_text_editor',
    :relative_urls => false,
    :convert_urls => false,
    :convert_fonts_to_spans => true,
    :menubar => false,
    :statusbar => false,
    :toolbar => 'bold italic| bullist | link unlink image',
    :plugins => %w{autosave link image emoticons autoresize },
}