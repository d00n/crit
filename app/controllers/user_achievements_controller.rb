#class UserAchievementsController < BaseController
#  # GET /user_achievements
#  # GET /user_achievements.xml
#  def index
#    @user_achievements = UnlockedAchievement.all
#
#    respond_to do |format|
#      format.html { render :layout => 'application' }
#      format.xml  { render :xml => @user_achievements }
#    end
#  end
#
#  # GET /user_achievements/1
#  # GET /user_achievements/1.xml
#  def show
#    @user_achievements = UnlockedAchievement.find(params[:id])
#
#    respond_to do |format|
#      format.html { render :layout => 'application' }
#      format.xml  { render :xml => @user_achievements }
#    end
#  end
#
#  # GET /user_achievements/new
#  # GET /user_achievements/new.xml
#  def new
#    @user_achievements = UnlockedAchievement.new
#
#    respond_to do |format|
#      format.html { render :layout => 'application' }
#      format.xml  { render :xml => @user_achievements }
#    end
#  end
#
#  # GET /user_achievements/1/edit
#  def edit
#    @user_achievements = UnlockedAchievement.find(params[:id])
#  end
#
#  # POST /user_achievements
#  # POST /user_achievements.xml
#  def create
#    @user_achievements = UnlockedAchievement.new(params[:user_achievements])
#
#    respond_to do |format|
#      if @user_achievements.save
#        flash[:notice] = 'UserAchievement was successfully created.'
#        format.html { redirect_to(@user_achievements) }
#        format.xml  { render :xml => @user_achievements, :status => :created, :location => @user_achievements }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @user_achievements.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /user_achievements/1
#  # PUT /user_achievements/1.xml
#  def update
#    @user_achievements = UnlockedAchievement.find(params[:id])
#
#    respond_to do |format|
#      if @user_achievements.update_attributes(params[:user_achievements])
#        flash[:notice] = 'UserAchievement was successfully updated.'
#        format.html { redirect_to(@user_achievements) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @user_achievements.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /user_achievements/1
#  # DELETE /user_achievements/1.xml
#  def destroy
#    @user_achievements = UnlockedAchievement.find(params[:id])
#    @user_achievements.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(user_achievements_url) }
#      format.xml  { head :ok }
#    end
#  end
#end
