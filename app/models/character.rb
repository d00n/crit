class Character < ActiveRecord::Base
  belongs_to :user
  has_many :pregenerated_character_offers, :dependent => :destroy  
  has_many :pregenerated_character_requests, :dependent => :destroy  
  has_many :character_registrations, :dependent => :destroy
  has_many :games, :through => :character_registrations
  has_many :posts, -> {order "published_at desc"}
  belongs_to  :avatar, :class_name => "Photo", :foreign_key => "avatar_id"

  has_many :unlocked_achievements, :dependent => :destroy

  has_many :character_products, :dependent => :destroy
  has_many :products, :through => :character_products

  acts_as_commentable  
  acts_as_taggable  
  acts_as_activity :user
  
  scope :recent, -> {order 'characters.updated_at DESC'}
  validates_presence_of :name
   
  has_many :c_carried_items, :dependent => :destroy
  accepts_nested_attributes_for :c_carried_items, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_special_items, :dependent => :destroy
  accepts_nested_attributes_for :c_special_items, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_languages, :dependent => :destroy
  accepts_nested_attributes_for :c_languages, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_wealths, :dependent => :destroy
  accepts_nested_attributes_for :c_wealths, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_physical_abilities, :dependent => :destroy
  accepts_nested_attributes_for :c_physical_abilities, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_senses, :dependent => :destroy
  accepts_nested_attributes_for :c_senses, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_previous_professions, :dependent => :destroy
  accepts_nested_attributes_for :c_previous_professions, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_previous_classes, :dependent => :destroy
  accepts_nested_attributes_for :c_previous_classes, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_armors, :dependent => :destroy
  accepts_nested_attributes_for :c_armors, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_attributes, :dependent => :destroy
  accepts_nested_attributes_for :c_attributes, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_healings, :dependent => :destroy
  accepts_nested_attributes_for :c_healings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_maxwounds, :dependent => :destroy
  accepts_nested_attributes_for :c_maxwounds, :allow_destroy => true, :reject_if => proc { |attrs| attrs['score'].blank? }
  
  has_many :c_movements, :dependent => :destroy
  accepts_nested_attributes_for :c_movements, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_possessions, :dependent => :destroy
  accepts_nested_attributes_for :c_possessions, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_powers, :dependent => :destroy
  accepts_nested_attributes_for :c_powers, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_combats, :dependent => :destroy
  accepts_nested_attributes_for :c_combats, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_damages, :dependent => :destroy
  accepts_nested_attributes_for :c_damages, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_qualities, :dependent => :destroy
  accepts_nested_attributes_for :c_qualities, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_racial_abilities, :dependent => :destroy
  accepts_nested_attributes_for :c_racial_abilities, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_skills, :dependent => :destroy
  accepts_nested_attributes_for :c_skills, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_skill_specializations, :dependent => :destroy
  accepts_nested_attributes_for :c_skill_specializations, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_special_abilities, :dependent => :destroy
  accepts_nested_attributes_for :c_special_abilities, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_special_attributes, :dependent => :destroy
  accepts_nested_attributes_for :c_special_attributes, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_defenses, :dependent => :destroy
  accepts_nested_attributes_for :c_defenses, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_weapons, :dependent => :destroy
  accepts_nested_attributes_for :c_weapons, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_wound_levels, :dependent => :destroy
  accepts_nested_attributes_for :c_wound_levels, :allow_destroy => true, :reject_if => proc { |attrs| attrs['level'].blank? }
  
  has_many :c_distinguishing_features, :dependent => :destroy
  accepts_nested_attributes_for :c_distinguishing_features, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  has_many :c_mannerisms, :dependent => :destroy
  accepts_nested_attributes_for :c_mannerisms, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_virtues, :dependent => :destroy
  accepts_nested_attributes_for :c_virtues, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_flaws, :dependent => :destroy
  accepts_nested_attributes_for :c_flaws, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_educations, :dependent => :destroy
  accepts_nested_attributes_for :c_educations, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_trainings, :dependent => :destroy
  accepts_nested_attributes_for :c_trainings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_interests, :dependent => :destroy
  accepts_nested_attributes_for :c_interests, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_hobbies, :dependent => :destroy
  accepts_nested_attributes_for :c_hobbies, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }
  
  has_many :c_goals, :dependent => :destroy
  accepts_nested_attributes_for :c_goals, :allow_destroy => true, :reject_if => proc { |attrs| attrs['name'].blank? }

  #  friendly_id :name, :use => [:slugged, :finders]

  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
 
  def owner
    self.user
  end
    
  def avatar_photo_url(size = nil)
    if avatar
      avatar.photo.url(size)
    else
      case size
        when :thumb
          configatron.photo.missing_thumb.to_s
        else
          configatron.photo.missing_medium.to_s
      end
    end
  end
  
  # Search, pagination code - START  
  def self.search_conditions(params)
    search = prepare_params_for_search(params)
    
    characters = build_conditions_for_search(search)
    return characters, search
  end   
 
  def self.prepare_params_for_search(params)
    search = {}.merge(params)
    search['user_id'] = params[:user_id] || nil
    search
  end
      
    
  def self.build_conditions_for_search(search)
    character = Character.arel_table
    characters = Character.recent
    characters = characters.where(:is_private => false)

    #cond.append ['activated_at IS NOT NULL ']
    if search['name']    
      characters = characters.where("name like ?", "%#{search['name']}%")
    end
    if search['property']    
      characters = characters.where("property like ?", "%#{search['property']}%")
    end
    if search['genre']    
      characters = characters.where("genre like ?", "%#{search['genre']}%")
    end
    if search['description']
      characters = characters.where("description like ?", "%#{search['description']}%")
    end    
    characters
  end 
  # Search, pagination code - END    


  def showCareerBox()
    if !current_profession.blank? or 
      !c_previous_professions.blank? or 
      !current_class.blank? or 
      !c_previous_classes.blank? or 
      !paragon_path.blank? or 
      !epic_destiny.blank? or
      !level.blank? or
      !server.blank? or
      !guild.blank?

      return true
    else
      return false
    end
  end

  def showPersonalDetailsBox()
    if !gender.blank? or
      !race.blank? or
      !ethnicity.blank? or
      !alignment.blank? or
      !skin_color.blank? or
      !age.blank? or
      !birthday.blank? or
      !astrological_sign.blank? or
      !height.blank? or
      !weight.blank? or
      !eye_color.blank? or
      !hair_color.blank? or
      !c_distinguishing_features.blank?  or
      !fashion_sense.blank? or
      !c_mannerisms.blank?  or
      !c_virtues.blank?  or
      !c_flaws.blank?  or
      !place_of_birth.blank? or
      !current_residence.blank? or
      !relationship_status.blank? or
      !c_educations.blank?  or
      !c_trainings.blank?  or
      !c_interests.blank?  or
      !c_hobbies.blank?  or
      !c_goals.blank? or
      !weapon_of_choice.blank?

      return true
    else
      return false
    end
  end
  
  def compatriots  
    compatriots = []
    
    self.games.each do |game|
      game.characters.each do |compatriot|    
        if self != compatriot
          compatriots << compatriot
        end
      end
    end
            
    return compatriots.uniq            
  end
  
  def get_clone(new_owner)
    @character= Character.new
    @character.user_id = new_owner.id

    @character.name = self.name
    @character.created_at = Time.now
    @character.updated_at = Time.now
    @character.description = self.description
    @character.property = self.property
    @character.genre = self.genre
    @character.about = self.about
    @character.background = self.background
    @character.party_description = self.party_description
    @character.gender = self.gender
    @character.race = self.race
    @character.eye_color = self.eye_color
    @character.hair_color = self.hair_color
    @character.fashion_sense = self.fashion_sense
    @character.place_of_birth = self.place_of_birth
    @character.current_residence = self.current_residence
    @character.relationship_status = self.relationship_status
    @character.weapon_of_choice = self.weapon_of_choice
    @character.ethnicity = self.ethnicity
    @character.birthday = self.birthday
    @character.astrological_sign = self.astrological_sign
    @character.age = self.age
    @character.skin_color = self.skin_color
    @character.height = self.height
    @character.weight = self.weight
    @character.level = self.level
    @character.guild = self.guild
    @character.server = self.server
    @character.current_profession = self.current_profession
    @character.current_class = self.current_class
    @character.paragon_path = self.paragon_path
    @character.epic_destiny = self.epic_destiny
    @character.xp_name = self.xp_name
    @character.xp_earned = self.xp_earned
    @character.xp_spent = self.xp_spent
    @character.view_count = self.view_count
    @character.character_relationships = self.character_relationships
    @character.alignment = self.alignment
    @character.xp_unspent = self.xp_unspent
    @character.owner_notepad = self.owner_notepad
    @character.public_notepad = self.public_notepad
    @character.pregenerated_character_request_id = self.pregenerated_character_request_id

    self.products.each do |product|
      @character.products << product
    end
    
    # If the original char author changes the avatar, children are affected
    # I can live with that
    @character.avatar_id = self.avatar_id

    @character.tag_list = self.tag_list

    @character.save
    new_owner.characters << @character

    for a in (0 .. self.c_carried_items.count-1)
      @character.c_carried_items.build(self.c_carried_items[a].attributes)
      @character.c_carried_items[a].character_id = @character.id
      @character.c_carried_items[a].id = '';
    end

    for b in (0 .. self.c_special_items.count-1)
      @character.c_special_items.build(self.c_special_items[b].attributes)
      @character.c_special_items[b].character_id = @character.id
      @character.c_special_items[b].id = '';
    end

    for c in (0 .. self.c_languages.count-1)
      @character.c_languages.build(self.c_languages[c].attributes)
      @character.c_languages[c].character_id = @character.id
      @character.c_languages[c].id = '';
    end

    for i in (0 .. self.c_wealths.count-1)
      @character.c_wealths.build(self.c_wealths[i].attributes)
      @character.c_wealths[i].character_id = @character.id
      @character.c_wealths[i].id = '';
    end

    for i in (0 .. self.c_physical_abilities.count-1)
      @character.c_physical_abilities.build(self.c_physical_abilities[i].attributes)
      @character.c_physical_abilities[i].character_id = @character.id
      @character.c_physical_abilities[i].id = '';
    end

    for i in (0 .. self.c_senses.count-1)
      @character.c_senses.build(self.c_senses[i].attributes)
      @character.c_senses[i].character_id = @character.id
      @character.c_senses[i].id = '';
    end

    for i in (0 .. self.c_previous_professions.count-1)
      @character.c_previous_professions.build(self.c_previous_professions[i].attributes)
      @character.c_previous_professions[i].character_id = @character.id
      @character.c_previous_professions[i].id = '';
    end

    for i in (0 .. self.c_previous_classes.count-1)
      @character.c_previous_classes.build(self.c_previous_classes[i].attributes)
      @character.c_previous_classes[i].character_id = @character.id
      @character.c_previous_classes[i].id = '';
    end

    for i in (0 .. self.c_armors.count-1)
      @character.c_armors.build(self.c_armors[i].attributes)
      @character.c_armors[i].character_id = @character.id
      @character.c_armors[i].id = '';
    end

    for i in (0 .. self.c_attributes.count-1)
      @character.c_attributes.build(self.c_attributes[i].attributes)
      @character.c_attributes[i].character_id = @character.id
      @character.c_attributes[i].id = '';
    end

    for i in (0 .. self.c_healings.count-1)
      @character.c_healings.build(self.c_healings[i].attributes)
      @character.c_healings[i].character_id = @character.id
      @character.c_healings[i].id = '';
    end

    for i in (0 .. self.c_maxwounds.count-1)
      @character.c_maxwounds.build(self.c_maxwounds[i].attributes)
      @character.c_maxwounds[i].character_id = @character.id
      @character.c_maxwounds[i].id = '';
    end

    for i in (0 .. self.c_movements.count-1)
      @character.c_movements.build(self.c_movements[i].attributes)
      @character.c_movements[i].character_id = @character.id
      @character.c_movements[i].id = '';
    end

    for i in (0 .. self.c_possessions.count-1)
      @character.c_possessions.build(self.c_possessions[i].attributes)
      @character.c_possessions[i].character_id = @character.id
      @character.c_possessions[i].id = '';
    end

    for i in (0 .. self.c_powers.count-1)
      @character.c_powers.build(self.c_powers[i].attributes)
      @character.c_powers[i].character_id = @character.id
      @character.c_powers[i].id = '';
    end

    for i in (0 .. self.c_combats.count-1)
      @character.c_combats.build(self.c_combats[i].attributes)
      @character.c_combats[i].character_id = @character.id
      @character.c_combats[i].id = '';
    end

    for i in (0 .. self.c_damages.count-1)
      @character.c_damages.build(self.c_damages[i].attributes)
      @character.c_damages[i].character_id = @character.id
      @character.c_damages[i].id = '';
    end

    for i in (0 .. self.c_qualities.count-1)
      @character.c_qualities.build(self.c_qualities[i].attributes)
      @character.c_qualities[i].character_id = @character.id
      @character.c_qualities[i].id = '';
    end

    for i in (0 .. self.c_racial_abilities.count-1)
      @character.c_racial_abilities.build(self.c_racial_abilities[i].attributes)
      @character.c_racial_abilities[i].character_id = @character.id
      @character.c_racial_abilities[i].id = '';
    end

    for i in (0 .. self.c_skills.count-1)
      @character.c_skills.build(self.c_skills[i].attributes)
      @character.c_skills[i].character_id = @character.id
      @character.c_skills[i].id = '';
    end

    for i in (0 .. self.c_skill_specializations.count-1)
      @character.c_skill_specializations.build(self.c_skill_specializations[i].attributes)
      @character.c_skill_specializations[i].character_id = @character.id
      @character.c_skill_specializations[i].id = '';
    end

    for i in (0 .. self.c_special_abilities.count-1)
      @character.c_special_abilities.build(self.c_special_abilities[i].attributes)
      @character.c_special_abilities[i].character_id = @character.id
      @character.c_special_abilities[i].id = '';
    end

    for i in (0 .. self.c_special_attributes.count-1)
      @character.c_special_attributes.build(self.c_special_attributes[i].attributes)
      @character.c_special_attributes[i].character_id = @character.id
      @character.c_special_attributes[i].id = '';
    end

    for i in (0 .. self.c_defenses.count-1)
      @character.c_defenses.build(self.c_defenses[i].attributes)
      @character.c_defenses[i].character_id = @character.id
      @character.c_defenses[i].id = '';
    end

    for i in (0 .. self.c_weapons.count-1)
      @character.c_weapons.build(self.c_weapons[i].attributes)
      @character.c_weapons[i].character_id = @character.id
      @character.c_weapons[i].id = '';
    end

    for i in (0 .. self.c_wound_levels.count-1)
      @character.c_wound_levels.build(self.c_wound_levels[i].attributes)
      @character.c_wound_levels[i].character_id = @character.id
      @character.c_wound_levels[i].id = '';
    end

    for i in (0 .. self.c_distinguishing_features.count-1)
      @character.c_distinguishing_features.build(self.c_distinguishing_features[i].attributes)
      @character.c_distinguishing_features[i].character_id = @character.id
      @character.c_distinguishing_features[i].id = '';
    end

    for i in (0 .. self.c_mannerisms.count-1)
      @character.c_mannerisms.build(self.c_mannerisms[i].attributes)
      @character.c_mannerisms[i].character_id = @character.id
      @character.c_mannerisms[i].id = '';
    end

    for i in (0 .. self.c_virtues.count-1)
      @character.c_virtues.build(self.c_virtues[i].attributes)
      @character.c_virtues[i].character_id = @character.id
      @character.c_virtues[i].id = '';
    end

    for i in (0 .. self.c_flaws.count-1)
      @character.c_flaws.build(self.c_flaws[i].attributes)
      @character.c_flaws[i].character_id = @character.id
      @character.c_flaws[i].id = '';
    end

    for i in (0 .. self.c_educations.count-1)
      @character.c_educations.build(self.c_educations[i].attributes)
      @character.c_educations[i].character_id = @character.id
      @character.c_educations[i].id = '';
    end

    for i in (0 .. self.c_trainings.count-1)
      @character.c_trainings.build(self.c_trainings[i].attributes)
      @character.c_trainings[i].character_id = @character.id
      @character.c_trainings[i].id = '';
    end

    for i in (0 .. self.c_interests.count-1)
      @character.c_interests.build(self.c_interests[i].attributes)
      @character.c_interests[i].character_id = @character.id
      @character.c_interests[i].id = '';
    end

    for i in (0 .. self.c_hobbies.count-1)
      @character.c_hobbies.build(self.c_hobbies[i].attributes)
      @character.c_hobbies[i].character_id = @character.id
      @character.c_hobbies[i].id = '';
    end

    for i in (0 .. self.c_goals.count-1)
      @character.c_goals.build(self.c_goals[i].attributes)
      @character.c_goals[i].character_id = @character.id
      @character.c_goals[i].id = '';
    end

    # @character.owner = new_owner
    @character.user = new_owner
    @character.save

    return @character
  end



  def has_access(user)  
    if !self.is_private
      return true
    end
    
    if user.nil?
      return false
    end
    
    if (user == self.owner) || user.admin?
      return true
    end

    if self.is_compatriot_or_gm(user)
      return true
    end

    return false
  end

  def is_compatriot_or_gm(user)
    self.games.each do |game|
      if ((game.owner == user) || (game.active_players.include?user))
        return true
      end
    end

    return false
  end

  def pending_achievements
    return self.unlocked_achievements.where(:accepted => false)
  end

  def accepted_achievements
    return self.unlocked_achievements.where(:accepted => true)
  end

  def associate_products_from_game(game)
    game.products.each do |product|
      self.add_product(product)
    end
  end

  def add_product(product)
    if !self.products.include?product
      self.products << product
    end
  end

end

  
