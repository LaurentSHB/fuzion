#encoding: utf-8
module StudiohbHelper



  #
  #
  def text_field_sthb form, attribute, text, div_class="optional", size = 41, lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  <label for="#{form.object_name}_#{attribute}">#{text} :</label>
  #{form.text_field attribute, :class => 'text', :size => size }
</div>
HOHOHO
    html.html_safe
  end

  def image_sthb f, attribute, text, format='thumb', div_class="optional", lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  <label >#{text} :</label>
  <div>
    #{image_tag url_for_file_column(f.object_name, attribute, format) }
    #{check_box_tag 'delete_'+attribute, '1' }&nbsp;effacer l'image à la sauvegarde
  </div>
</div>
HOHOHO
    html.html_safe
  end

  def file_column_sthb f, attribute, text, div_class="optional", lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  #{f.label attribute, text+' :'}
  <div>
    #{file_column_field f.object_name, attribute, :size => 23  }
  </div>
</div>
HOHOHO
    html.html_safe
  end

  def select_sthb form, attribute, text, colection, blank_text="choisissez", div_class="optional", lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  <label for="#{form.object_name}_#{attribute}">#{text} :</label>
  <div>
    #{ form.select(attribute, colection, :include_blank => blank_text ) }
  </div>
</div>
HOHOHO
    html.html_safe
  end




  def text_area_sthb f, attribute, text, div_class="optional", rows = 5, cols = 47, lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  <label for="#{f.object_name}_#{attribute}">#{text} :</label>
    #{f.text_area(attribute, :rows => rows, :cols => cols, :class => 'textInput') }
</div>
HOHOHO
    html.html_safe
  end

  def fckeditor_textarea_sthb f, attribute, text, div_class="optional", lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  <label >#{text} :</label>
  <div>
  #{fckeditor_textarea(f.object_name, attribute, :toolbarSet => 'Basic', :height => '200px',:rows => '5', :cols => '40', :class => 'textInput')}
  </div>
</div>
HOHOHO
    html.html_safe
  end

  # bouton submit pour les fin de formulaire
  #
  def submit_sthb f, button_name, div_class="optional", lang = :no
    html =<<"HOHOHO"
<div class="#{div_class}">
  <label>&nbsp;</label>
  #{ f.submit button_name, :class => 'submit' }
</div>
HOHOHO
    html.html_safe
  end

  def td_edit_link text, path, lang = :no
    text = 'éditer ' + text
    html =<<"HOHOHO"
<td align="center">
  #{ link_to( image_tag('admin/edit.png', :border => 0, :alt => text, :title => text), path ) }
</td>
HOHOHO
    html.html_safe
  end

  def td_delete_link text, path, lang = :no
    text = 'supprimer ' + text
    html =<<"HOHOHO"
<td align="center">
#{link_to(image_tag('admin/delete.png', :border => 0, :alt => text, :title => text), path, :confirm => 'Etes-vous sûr ?', :method => :delete)}
</td>
HOHOHO
    html.html_safe
  end

  # link_to image_tag
  #
  #utilisé surtout pour les visuel client
  #
  def link_img_obj object, attribut, format, alt, lien
    "#{link_to(image_tag( url_for_file_column(object, attribut, format), :alt => alt), lien) unless object.send(attribut).blank?}"
  end

  def link_img img_path, alt, lien, id = nil
    "#{link_to(image_tag( img_path, :alt => alt), lien, :id => id)}"
  end

  def link_img_delete img_path, text, path, id = nil, lang = :no
    "#{link_to(image_tag(img_path, :border => 0, :alt => text, :id => id, :title => text),
      path, :confirm => 'Etes-vous sûr ?', :method => :delete)}"
  end
end


def navigation
    @you_are_here ||= []
    current = @you_are_here.pop
    html = '<div class="breadcrumb"><span  class="breadcrumb_bkgd">'
    html << link_to(' ', root_path)
    html << '</span>'
    @you_are_here.each do |here|
      html << link_to( here[0], here[1] )
    end
    html << content_tag(:span, current[0], :class => "active") if current
    html << "</div>"
end