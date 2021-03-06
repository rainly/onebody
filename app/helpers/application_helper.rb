# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  include PicturesHelper
  include PhotosHelper
  include ToursHelper

  def banner_message
    if Setting.get(:features, :banner_message).to_s.any?
      CGI.escapeHTML(Setting.get(:features, :banner_message))
    end
  end

  def heading
    if (logo = Setting.get(:appearance, :logo)).to_s.any?
      img = image_tag("/assets/site#{Site.current.id}/#{logo}", :alt => Setting.get(:name, :site), :class => 'no-border', :style => 'float:left;margin-right:10px;')
	    link_to(img, '/')
	  elsif !@page or @page.for_members?
	    link_to(h(Setting.get(:name, :site)), people_path)
	  else
	    link_to(h(Setting.get(:name, :community)), '/')
    end
  end

  def subheading
    if !@page or @page.for_members?
      html = simple_url(Setting.get(:url, :site))
    else
      html = simple_url(Setting.get(:url, :visitor))
    end
    if Setting.get(:name, :slogan).to_s.any?
      html << " | #{h Setting.get(:name, :slogan)}"
    end
    html
  end

  def tab_link(title, url, active=false)
    link_to(title, url, :class => active ? 'active' : nil)
  end

  def nav_links
    html = ''
    if Setting.get(:features, :content_management_system)
      html << "<li>#{tab_link I18n.t("nav.pages"), '/', params[:controller] == 'pages' && @page && @page.home?}</li>"
    end
    html << "<li>#{tab_link I18n.t("nav.home"), stream_path, params[:controller] == 'streams'}</li>"
    profile_link = @logged_in ? person_path(@logged_in, :tour => params[:tour]) : people_path
    html << "<li>#{tab_link I18n.t("nav.profile"), profile_link, params[:controller] == 'people' && me?}</li>"
    if Setting.get(:features, :groups) and (Site.current.max_groups.nil? or Site.current.max_groups > 0)
      html << "<li>#{ tab_link I18n.t("nav.groups"), groups_path, params[:controller] == 'groups'}</li>"
    end
    html << "<li>#{tab_link I18n.t("nav.directory"), new_search_path, %w(searches printable_directories).include?(params[:controller])}</li>"
    if Setting.get(:services, :sermondrop_url).to_s.any?
      html << "<li>#{tab_link I18n.t("nav.podcasts"), podcasts_path, params[:controller] == 'podcasts'}</li>"
    end
    #html << "<li>#{tab_link I18n.t("nav.bible"), bible_path, params[:controller] == 'bibles'}</li>"
    html
  end

  def notice
    if flash[:warning] or flash[:notice]
      <<-HTML
        <div id="notice" #{flash[:warning] ? 'class="warning"' : nil}>#{flash[:warning] || flash[:notice]}</div>
        <script type="text/javascript">
          setTimeout("new Effect.Fade('notice');", 15000)
        </script>
      HTML
    end
  end

  def personal_nav_links
    html = ''
    if @logged_in
      html << "<li class=\"personal\">"
      html << link_to(image_tag('door_in.png', :alt => I18n.t('session.sign_out'), :class => 'icon') + ' ' + I18n.t('session.sign_out'), session_path, :method => 'delete')
      html << "</li>"
      html << "<li class=\"personal\">"
      if session[:touring]
        html << link_to(image_tag('car.png', :alt => I18n.t('session.tour'), :class => 'icon') + ' ' + I18n.t('session.tour'), tour_path(:stop => true), :class => 'active')
      else
        html << link_to(image_tag('car.png', :alt => I18n.t('session.tour'), :class => 'icon') + ' ' + I18n.t('session.tour'), tour_path(:start => true), :id => 'tour_link')
      end
      html << "</li>"
      if @logged_in.admin?
        html << "<li class=\"personal\">"
        html << link_to(image_tag('cog.png', :alt => I18n.t('admin.admin'), :class => 'icon') + ' ' + I18n.t('admin.admin'), admin_path, :class => params[:controller] =~ /^admin/ ? 'active' : nil)
        html << "</li>"
      end
    else
      html << "<li class=\"personal\">"
      html << link_to(image_tag('door.png', :alt => I18n.t('session.sign_in'), :class => 'icon') + ' ' + I18n.t('session.sign_in'), new_session_path)
      html << "</li>"
    end
    html
  end

  def news_js
    nil # not used any more
  end

  def analytics_js
    if Rails.env.production?
      Setting.get(:services, :analytics)
    end
  end

  def preserve_breaks(text, make_safe=true)
    text = h(text.to_s) if make_safe
    text.gsub(/\n/, '<br/>')
  end

  def remove_excess_breaks(text)
    text.gsub(/(\n\s*){3,}/, "\n\n")
  end

  def hide_contact_details(text)
    if Setting.get(:privacy, :hide_contact_details_in_messages)
      text.gsub(/\(?\d\d\d\)?[\s\-\.]?\d\d\d[\s\-\.]\d\d\d\d/, '[phone number protected]').gsub(/[a-z\-_\.0-9]+@[a-z\-0-9\.]+\.[a-z]{2,4}/, '[email address protected]')
    else
      text
    end
  end

  def image_tag(location, options)
    options[:title] = options[:alt] if options[:alt]
    super(location, options)
  end

  def simple_url(url)
    url.sub(/^https?:\/\//, '').sub(/\/$/, '')
  end

  def me?
    @logged_in and @person and @logged_in == @person
  end

  def help_path(name=nil)
    page_for_public_path("help/#{name}")
  end

  def system_path(name=nil)
    page_for_public_path("system/#{name}")
  end

  def render_page_content(path)
    Page.find_by_path_and_published(path, true).body rescue nil
  end

  def format_phone(phone, mobile=false)
    format = Setting.get(:formats, mobile ? :mobile_phone : :phone)
    return phone if format.blank?
    groupings = format.scan(/d+/).map { |g| g.length }
    groupings = [3, 3, 4] unless groupings.length == 3
    ActionController::Base.helpers.number_to_phone(
      phone,
      :area_code => format.index('(') ? true : false,
      :groupings => groupings,
      :delimiter => format.reverse.match(/[^d]/).to_s
    )
  end

  def custom_field_name(index)
    n = Setting.get(:features, :custom_person_fields)[index]
    n ? n.sub(/\*/, '') : nil
  end

  def white_list_with_removal(html)
    return nil unless html
    html.gsub!(/<script.+?<\/script>/mi, '')
    html.gsub!(/<style.+?<\/style>/mi, '')
    white_list(html) { |node, bad| node.to_s.gsub(/<[^>]+>/, '').gsub(/</, '&lt;') }
  end

  def domain_name_from_url(url)
    url =~ /^https?:\/\/([^\/]+)/
    $1
  end

  def render_plugin_hook(name)
    if hooks = PLUGIN_HOOKS[name]
      hooks.map do |hook|
        render :partial => hook
      end.join("\n")
    end
  end

  def bar_chart_url(data, options={})
    options.symbolize_keys!
    options.reverse_merge!(:set_count => 1, :set_labels => nil, :width => 400, :height => 200, :title => '', :colors => ['4F9EC9', '79B933', 'FF9933'])
    labels = data.map { |p| p[0] }
    counts = []
    (0...options[:set_count]).each do |set|
      counts[set] = data.map { |p| p[set+1] }
    end
    max = data.map { |p| p[1..-1].sum }.max
    "http://chart.apis.google.com/chart?chtt=#{options[:title]}&cht=bvs&chxt=x,y&chxr=1,0,#{max}#{options[:interval] && ','+options[:interval].to_s}&chds=0,#{max}&chd=t:#{counts.map { |c| c.join(',') }.join('|')}&chs=#{options[:width]}x#{options[:height]}&chl=#{labels.join('|')}&chbh=a&chco=#{options[:colors].join(',')}" + (options[:set_labels] ? "&chdl=#{options[:set_labels].join('|')}" : '')
  end

  def pie_chart_url(data, options={})
    options.symbolize_keys!
    options.reverse_merge!(:width => 350, :height => 200, :title => '', :colors => ['4F9EC9', '79B933', 'FF9933'])
    labels = data.keys
    counts = labels.inject([]) { |a, l| a << data[l]; a }
    labels.map! { |l| l.to_s.gsub('_', ' ') }
    "http://chart.apis.google.com/chart?chtt=#{options[:title]}&cht=p&chd=t:#{counts.join(',')}&chs=#{options[:width]}x#{options[:height]}&chl=#{labels.join('|')}&chco=#{options[:colors].join(',')}"
  end

  def iphone_back_button(url=nil, label='Back')
    if url
      "<a class=\"button backButton\" rel=\"external\" href=\"#{url}\">#{label}</a>"
    elsif params[:iphoneAjax]
      "<a class=\"back\" href=\"#home\">#{label}</a>"
    else
      "<a class=\"button backButton\" rel=\"external\" href=\"/stream\">#{label}</a>"
    end
  end

  def iphone?
    controller.iphone?
  end

  def params_without_action
    controller.params_without_action
  end

  class << self
    include ApplicationHelper
  end
end

module ActionView
  module Helpers
    module FormHelper
      def phone_field(object_name, method, options = {})
        options[:value] = format_phone(options[:object][method], mobile=(method.to_s =~ /mobile/))
        options[:size] ||= 15
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options)
      end
      def date_field(object_name, method, options = {})
        options[:value] = options[:object][method].to_s(:date) rescue ''
        options[:size] ||= 12
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options)
      end
    end
    class FormBuilder
      def phone_field(method, options = {})
        @template.phone_field(@object_name, method, options.merge(:object => @object))
      end
      def date_field(method, options = {})
        options = {:time => false, :size => 15, :buttons => false, :year_range => 100}.merge(options)
        calendar_date_select(method, options)
      end
    end
    module FormTagHelper
      def date_field_tag(name, value = nil, options = {})
        options = {:time => false, :size => 15, :buttons => false, :year_range => 100}.merge(options)
        calendar_date_select_tag(name, value, options)
      end
    end
  end
end
