class EventsController < BaseController
  include Viewable

  require 'htmlentities'
  caches_page :ical
  cache_sweeper :event_sweeper, :only => []

  #before_filter :login_required, :except => [:index, :show, :publisher_products]
  before_filter :event_admin_required, :only => [:new, :edit, :create, :update, :open_game_registration_desks, :close_game_registration_desks, :grant_gm_achievements, :grant_player_achievements, :select_achievements]
  before_filter :admin_required, :only => []

  cache_sweeper :taggable_sweeper, :only => [:activate, :update, :destroy]
  protect_from_forgery :only => [:create, :update, :destroy]

  uses_tiny_mce do 
    {:only => [:new, :create, :update, :edit],
    :options => configatron.default_mce_options }
  end

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end


  def event_admin_required
    current_user && current_user.event_admin? ? true : access_denied
  end


  def open
    event = Event.find(params[:id])
    if current_user == event.owner
      event.save

      flash[:notice] = 'The registration desk has been opened.'
    else
      flash[:error] = 'You may not edit events you do not own.'
    end
    redirect_to :action => "show", :id => params[:id]
  end

  def close
    event = Event.find(params[:id])
    if current_user == event.owner
      event.save

      flash[:notice] = 'The registration desk has been closed.'
    else
      flash[:error] = 'You may not edit events you do not own.'
    end
    redirect_to :action => "show", :id => params[:id]
  end

  #These two methods make it easy to use helpers in the controller.
  #This could be put in application_controller.rb if we want to use
  #helpers in many controllers
  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::SanitizeHelper
    extend ActionView::Helpers::SanitizeHelper::ClassMethods
  end

  def ical
    @calendar = RiCal.Calendar
    @calendar.add_x_property 'X-WR-CALNAME', configatron.community_name
    @calendar.add_x_property 'X-WR-CALDESC', "#{configatron.community_name} #{:events.l}"
    Event.find(:all).each do |ce_event|
      rical_event = RiCal.Event do |event|
        event.dtstart = ce_event.start_time
        event.dtend = ce_event.end_time
        event.summary = ce_event.name + (ce_event.metro_area.blank? ? '' : " (#{ce_event.metro_area})")
        coder = HTMLEntities.new
        event.description = (ce_event.description.blank? ? '' : coder.decode(help.strip_tags(ce_event.description).to_s) + "\n\n") + event_url(ce_event)
        event.location = ce_event.location unless ce_event.location.blank?
      end
      @calendar.add_subcomponent rical_event
    end
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.export_to, :layout => false
  end

  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end


  def show
    @event = Event.find(params[:id])
    @comments = @event.comments.order('created_at').limit(100)


    @show_game_reg_links = false
    if params[:show_game_reg_links] == '1' || @event.show_game_reg_links_on_event_profile
      @show_game_reg_links = true
    end

#    cond = Caboose::EZ::Condition.new
#    cond.event_id == @event.id
#    order = (params[:popular] ? "view_count #{params[:popular]}": "published_at DESC")
#    @posts = Post.find :all, :page => {:current => params[:page]}, :order => order, :conditions => cond.to_sql, :include => :tags

    #@popular_posts = @category.posts.find(:all, :limit => 10, :order => "view_count DESC")
    #@popular_polls = Poll.find_popular_in_category(@category)
    #@rss_title = "#{configatron.community_name}: #{@category.name} "+:posts.l
    #@rss_url = category_path(@category, :format => :rss)

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @event = Event.new
    3.times { @event.slots.build }

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @product }
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
    render :layout => 'application'
  end

  def create
    attributes = {}
    if event_params
      attributes = event_params.permit!
    end
    @event = current_user.events.new(attributes)
    @event.tag_list = params[:event][:name]  + ", " + params[:tag_list]

    if params[:add_slot]
      @event.slots.build
    elsif params[:remove_slot]
      # nested model with _destroy=1 should get automatically deleted

    end

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    @event.tag_list = params[:tag_list]

    if params[:add_slot]
      unless params[:event][:slots_attributes].blank?
        for attribute in params[:event][:slots_attributes]
          @event.slots.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      @event.slots.build
    elsif params[:remove_slot]
      removed_slots = params[:event][:slots_attributes].collect { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1)}
      Slot.delete(removed_slots)
      flash[:notice] = "Slots removed."

      for attribute in params[:event][:slots_attributes]
        @event.slots.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else
      attributes = {}
      if event_params
        attributes = event_params.permit!
      end

      if @event.update_attributes(attributes)
        flash[:notice] = 'Event was successfully updated.'
        redirect_to action: 'show', id: @event.id
      else
        redirect_to :action => "edit"
      end
      return
    end

    render :action => 'edit'
    return
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  def update_views
    if logged_in?
      @event = Event.find(params[:id])
      updated = update_view_count(@event)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end


  def change_profile_photo
    @event = current_user.events.find(params[:id])

    # TODO make this a before_filter
    if current_user != @event.owner
      flash[:error] = "You can not edit this event."
      redirect_to event_path(@event)
      return
    end

    @photo  = Photo.find(params[:photo_id])
    @event.avatar = @photo

    if @event.save!
      flash[:notice] = 'Event was successfully updated.'
      redirect_to event_path(@event)
    else
      format.html { render :action => "edit", :layout => 'application' }
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def pick_profile_photo
    @event = current_user.events.find(params[:id])

    # TODO make this a before_filter
    if current_user != @event.owner
      flash[:error] = "You can not edit this event."
      redirect_to event_path(@event)
      return
    end

    @user = @event.owner

    @photos = @user.photos.recent.page(params[:page]).per(100)

    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end

  def remove_profile_photo
    @event = current_user.events.find(params[:id])
    @event.avatar = nil
    @event.save
    redirect_to(@event)
  end

  def new_slot
    @slot = Slot.new

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @product }
    end
  end


  def open_game_registration_desks
    @event = current_user.events.find(params[:id])

    @event.slots.each do |slot|
      slot.games.each do |game|
        game.status = 'open'
        game.save

        if game.game_system
          game.game_system.update_game_counts
        end
      end
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def close_game_registration_desks
    @event = current_user.events.find(params[:id])

    @event.slots.each do |slot|
      slot.games.each do |game|
        game.status = 'closed'
        game.save

        if game.game_system
          game.game_system.update_game_counts
        end
      end
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def select_achievements
    @event = current_user.events.find(params[:id])
  end

  def grant_player_achievements
    @event = current_user.events.find(params[:id])
    @achievement = Achievement.find(params[:achievement_id])

    num_granted = 0;

    @event.slots.each do |slot|
      slot.games.each do |game|
        if (grant_achievement(game.owner, @achievement))
          num_granted += 1
        end
        
        game.active_players.each do |player|
          if (grant_achievement(player, @achievement))
            num_granted += 1
          end
        end
      end
    end

    flash[:notice] = num_granted.to_s + ' player achievements granted.'
    redirect_to(@achievement)
  end

  def grant_gm_achievements
    @event = current_user.events.find(params[:id])
    @achievement = Achievement.find(params[:achievement_id])

    num_granted = 0;

    @event.slots.each do |slot|
      slot.games.each do |game|
        if (grant_achievement(game.owner, @achievement))
          num_granted += 1
        end
      end
    end

    flash[:notice] = num_granted.to_s + ' GM achievements granted.'
    redirect_to(@achievement)
  end


  def calendar
    @event = Event.find(params[:id])

    game_ids = []
    @event.slots.each do |slot|
      slot.games.each do |game|
        game_ids << game.id
      end
    end

    calendar_conditions = Game.where("id in (?)", game_ids)

    if calendar_conditions.where_sql.blank? # No search criteria
      calendar_conditions = '1'
    else
      calendar_conditions = calendar_conditions.where_sql.sub(/^WHERE/i,'')
    end


    @month = params[:month].to_i
    @year = params[:year].to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Game.event_strips_for_month(@shown_month, :conditions => calendar_conditions )
  end

  private
  def event_params
    params.require(:event).permit(:name,
                          :start_time,
                          :end_time,
                          :description,
                          :metro_area,
                          :location,
                          :allow_rsvp,
                          :summary,
                          :is_registering_games,
                          :is_registering_regular_players,
                          :is_registering_premium_players,
                          :show_game_reg_links_on_event_profile,
                          :is_primary_home_page_promo,
                          :is_secondary_home_page_promo,
                          :tag_list,
                          :slots_attributes => [:id, :name, :start_time, :end_time, :_destroy]
                        )
  end
end
