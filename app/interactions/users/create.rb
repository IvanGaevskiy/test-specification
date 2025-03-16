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
  validates :surname, :name, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :email, uniqueness: true
  validates :age, inclusion: { in: 1..90 }
  validates :gender, inclusion: { in: ['male', 'female'] }
  
  def execute
    user = User.create!(
      surname: surname,
      name: name,
      patronymic: patronymic,
      email: email,
      age: age,
      nationality: nationality,
      country: country,
      gender: gender
    )
    
    # Привязка интересов
    interests.each do |interest_name|
      interest = Interest.find_or_create_by(name: interest_name)
      user.interests << interest
    end
    
    # Привязка навыков
    user_skills = skills.split(',').map { |skill_name| Skill.find_or_create_by(name: skill_name.strip) }
    user.skills << user_skills

    user
  end
end
