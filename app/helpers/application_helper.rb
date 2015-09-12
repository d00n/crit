module ApplicationHelper

  def remote_function(options)
    ("$.ajax({url: '#{ url_for(options[:url]) }', type: '#{ options[:method] || 'GET' }', " +
        "data: #{ options[:with] ? options[:with] + '&amp;' : '' } + " +
        "'authenticity_token=' + encodeURIComponent('#{ form_authenticity_token }')" +
        (options[:data_type] ? ", dataType: '" + options[:data_type] + "'" : "") +
        (options[:success] ? ", success: function(response) {" + options[:success] + "}" : "") +
        (options[:before] ? ", beforeSend: function(data) {" + options[:before] + "}" : "") + "});").html_safe
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def li_tags_helper(tagged, number_to_show = nil)
    if number_to_show.blank?
      tagged.tags.collect{|t| link_to h(t.name), tag_url(u t.name) }.join(", ").html_safe
    else
      tagged.tags.first(number_to_show).collect{|t| link_to h(t.name), tag_url(u t.name) }.join(", ").html_safe
    end
  end

  def random_google_adwords_ad
    ads = %w(ga_square_text_black ga_square_text_grey ga_square_image_default ga_square_text_default ga_square_text_modern)
    #ads = %w(ga_square_image_default)
    ads.shuffle.last
  end

  def random_infrno_upgrade_ad
    #ads = %w(UncleTyrionWantsYou.jpg AdsAreComing_False.jpg AdsAreComing.jpg  AdsAreComing_TurnedThemOffByUpgrading.jpg  ArtThouAware.jpg WhatIfIToldYou_YouCouldTurnOffAds.jpg DoesntLikeAds_UpgradesAccount.jpg  khan_ads.jpg  OneDoesNotSimply_TolerateAds.jpg  PrepareYourselves_AdsAreComing.jpg)
    ads = %w(AdsAreComing_False.jpg AdsAreComing_TurnedThemOffByUpgrading.jpg  ArtThouAware.jpg WhatIfIToldYou_YouCouldTurnOffAds.jpg DoesntLikeAds_UpgradesAccount.jpg  khan_ads.jpg  OneDoesNotSimply_TolerateAds.jpg  PrepareYourselves_AdsAreComing.jpg)
    ads.shuffle.last
  end

  def infrno_auto_complete_result(entries, field, phrase = nil)
    return unless entries

    #items = entries.map { |entry| content_tag("li", phrase ? highlight(entry[field], phrase) : (entry[field]).html_safe ) }

    items = "".html_safe
    entries.each do |entry|
      items << content_tag('li', entry[field].html_safe)
    end
    content_tag(:ul, items)

    #content_tag(:ul, entries.map {|string| content_tag(:li, string)}.join.html_safe)
  end

  def seo_game_path(game)
    if game.products.any?
      return publisher_product_game_path(game.products.first.owner, game.products.first, game)
    else
      return game_path(game)
    end
  end
  def seo_character_path(character)
    if character.products.any?
      return publisher_product_character_path(character.products.first.owner, character.products.first, character)
    else
      return character_path(character)
    end
  end
end


module ActionView
  module Helpers
    class FormBuilder
      def date_select(method, options = {}, html_options = {})
        existing_date = @object.send(method)
        formatted_date = existing_date.to_date.strftime("%F") if existing_date.present?
        @template.content_tag(:div, :class => "input-group") do
          text_field(method, :value => formatted_date, :class => "form-control datepicker", :"data-date-format" => "YYYY-MM-DD") +
              @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-calendar") ,:class => "input-group-addon")
        end
      end

      def datetime_select(method, options = {}, html_options = {})
        existing_time = @object.send(method)
        formatted_time = existing_time.to_time.strftime("%F %I:%M %p") if existing_time.present?
        @template.content_tag(:div, :class => "input-group") do
          text_field(method, :value => formatted_time, :class => "form-control datetimepicker", :"data-date-format" => "YYYY-MM-DD hh:mm A") +
              @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-calendar") ,:class => "input-group-addon")
        end
      end
    end
  end
end
