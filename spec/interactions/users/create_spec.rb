require 'rails_helper'

RSpec.describe Users::Create do
  let(:valid_params) do
    {
      surname: 'Иванов',
      name: 'Иван',
      patronymic: 'Иванович',
      email: 'ivan@example.com',
      age: 25,
      nationality: 'Russian',
      country: 'Russia',
      gender: 'male',
      interests: ['программирование', 'спорт'],
      skills: 'Ruby, Rails, SQL'
    }
  end

  describe 'валидации' do
    context 'обязательные параметры' do
      %i[surname name patronymic email age nationality country gender].each do |param|
        it "ошибка при отсутствии #{param}" do
          result = described_class.run(valid_params.except(param))
          expect(result.errors[param]).to include('is required')
        end
      end
    end

    context 'email' do
      it 'ошибка при неверном формате' do
        result = described_class.run(valid_params.merge(email: 'invalid_email'))
        expect(result.errors[:email]).to include('is invalid')
      end

      it 'ошибка при дубликате email' do
        FactoryBot.create(:user, email: 'ivan@example.com')
        result = described_class.run(valid_params)
        expect(result.errors[:email]).to include('has already been taken')
      end
    end

    context 'age' do
      it 'ошибка при возрасте меньше 1' do
        result = described_class.run(valid_params.merge(age: 0))
        expect(result.errors[:age]).to include('is not included in the list')
      end

      it 'ошибка при возрасте больше 90' do
        result = described_class.run(valid_params.merge(age: 91))
        expect(result.errors[:age]).to include('is not included in the list')
      end
    end

    context 'gender' do
      it 'ошибка при недопустимом значении' do
        result = described_class.run(valid_params.merge(gender: 'other'))
        expect(result.errors[:gender]).to include('is not included in the list')
      end
    end

    context 'interests' do
      it 'ошибка при пустом массиве' do
        result = described_class.run(valid_params.merge(interests: []))
        expect(result.errors[:interests]).to include('must contain at least one interest')
      end

      it 'ошибка при пустых строках в массиве' do
        result = described_class.run(valid_params.merge(interests: ['', ' ']))
        expect(result.errors[:interests]).to include('must contain at least one interest')
      end
    end

    context 'skills' do
      it 'ошибка при пустой строке' do
        result = described_class.run(valid_params.merge(skills: ''))
        expect(result.errors[:skills]).to include('must contain at least one skill')
      end

      it 'ошибка при пробелах вместо навыков' do
        result = described_class.run(valid_params.merge(skills: '  ,, '))
        expect(result.errors[:skills]).to include('must contain at least one skill')
      end
    end
  end

  describe 'создание пользователя' do
    it 'успешно создает пользователя с корректными данными' do
      expect { described_class.run!(valid_params) }.to change(User, :count).by(1)
    end

    it 'привязывает интересы' do
      user = described_class.run!(valid_params)
      expect(user.interests.pluck(:name)).to match_array(['программирование', 'спорт'])
    end

    it 'привязывает навыки' do
      user = described_class.run!(valid_params)
      expect(user.skills.pluck(:name)).to match_array(['Ruby', 'Rails', 'SQL'])
    end

    it 'не создает дубликаты интересов' do
      FactoryBot.create(:interest, name: 'спорт')
      expect { described_class.run!(valid_params) }.to change(Interest, :count).by(1)
    end

    it 'не создает дубликаты навыков' do
      FactoryBot.create(:skill, name: 'Ruby')
      expect { described_class.run!(valid_params) }.to change(Skill, :count).by(2)
    end
  end

  describe 'обработка ошибок' do
    it 'возвращает ошибки модели User' do
      FactoryBot.create(:user, email: 'ivan@example.com')
      result = described_class.run(valid_params)
      expect(result.errors[:email]).to include('has already been taken')
    end
  end
end