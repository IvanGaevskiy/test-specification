class Users::Create < ActiveInteraction::Base
  # Декларативные параметры
  string :surname
  string :name
  string :patronymic
  string :email
  integer :age
  string :nationality
  string :country
  string :gender
  array :interests, default: []
  string :skills
  
  # Валидации
  validates :gender, inclusion: { in: ['male', 'female'] }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :non_empty_interests
  validate :non_empty_skills

  def execute
    user = User.new(user_params)
    
    unless user.save
      errors.merge!(user.errors)
      return
    end
    
    attach_interests(user)
    attach_skills(user)

    user
  end
  
  private

  def user_params
    {
      surname: surname,
      name: name,
      patronymic: patronymic,
      email: email,
      age: age,
      nationality: nationality,
      country: country,
      gender: gender
    }
  end
  
  # Проверка массива интересов на пустоту
  def non_empty_interests
    return if interests.any?(&:present?)
    errors.add(:interests, "must contain at least one interest")
  end

  # Проверка строки скилов на пустоту
  def non_empty_skills
    return if skills.split(',').any? { |s| s.strip.present? }
    errors.add(:skills, "must contain at least one skill")
  end

  # Привязка интересов
  def attach_interests(user)
    interests.each do |interest_name|
      next if interest_name.blank?
      interest = Interest.find_or_create_by!(name: interest_name.strip)
      user.interests << interest unless user.interests.include?(interest)
    end
  end

  # Привязка навыков
  def attach_skills(user)
    skills.split(',')
          .map(&:strip)
          .reject(&:empty?)
          .each do |skill_name|
            skill = Skill.find_or_create_by!(name: skill_name)
            user.skills << skill unless user.skills.include?(skill)
          end
  end
end
