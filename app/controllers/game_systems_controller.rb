class GameSystemsController < BaseController
  before_filter :admin_required, :except => [:search, :index]
  
  def search
    @game_systems = GameSystem.all(:conditions => ['lower(name) LIKE ?', "%#{params[:system_name]}%"])

    render :inline => "<%= infrno_auto_complete_result(@game_systems, 'name') %>"
  end
  
  def index
    @search = {}
    
    @game_systems = GameSystem.all(:conditions => "open_game_count > 0 and name != ''", :order => 'name')
    @game_system_count = GameSystem.count(:conditions => "open_game_count > 0 and name != ''")
    @open_game_count = Game.count(:conditions => ['status = "open"'])  

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def manage
    #@game_systems = GameSystem.find(:all, :order => :name, :page => {:current => params[:page], :size => 20})
    @game_systems = GameSystem.all(:order => :name)
  end

  def migrate
    game_system = GameSystem.find(params[:id])
    system_category = SystemCategory.find(params[:system_category_id])

    game_system.games.each do |game|
      system_category.products.each do |product|
        if !game.products.include?product
          game.products << product
        end

        game.characters.each do |character|
          character.associate_products_from_game(game)
        end
      end
    end

    redirect_to system_category.products.first
  end

  # GET /game_systems/1
  # GET /game_systems/1.xml
  def show
    @game_system = GameSystem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_system }
    end
  end

  # GET /game_systems/new
  # GET /game_systems/new.xml
  def new
    @game_system = GameSystem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_system }
    end
  end

  # GET /game_systems/1/edit
  def edit
    @game_system = GameSystem.find(params[:id])
  end

  # POST /game_systems
  # POST /game_systems.xml
  def create
    @game_system = GameSystem.new(params[:game_system])

    respond_to do |format|
      if @game_system.save
        flash[:notice] = 'GameSystem was successfully created.'
        format.html { redirect_to(@game_system) }
        format.xml  { render :xml => @game_system, :status => :created, :location => @game_system }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_systems/1
  # PUT /game_systems/1.xml
  def update
    @game_system = GameSystem.find(params[:id])

    respond_to do |format|
      if @game_system.update_attributes(params[:game_system])    
      
        duplicate_game_systems = GameSystem.all(:conditions => ['name = ? and id != ?', params[:game_system][:name], params[:id]] )
        if !duplicate_game_systems.empty?
          duplicate_game_systems.each do |dupe|
            games = Game.all(:conditions => ['game_system_id = ?', dupe.id] )
            games.each do |game|
              game.game_system_id = @game_system.id
              game.save
            end
            @game_system.open_game_count += dupe.open_game_count
            @game_system.total_game_count += dupe.total_game_count        
            dupe.destroy
          end
        end        
        @game_system.save

        flash[:notice] = 'GameSystem was successfully updated.'
        format.html { redirect_to(@game_system) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_systems/1
  # DELETE /game_systems/1.xml
  def destroy
    @game_system = GameSystem.find(params[:id])
    @game_system.destroy

    respond_to do |format|
      format.html { redirect_to(game_systems_url) }
      format.xml  { head :ok }
    end
  end
end
