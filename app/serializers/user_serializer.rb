class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :date_of_birth,
             :total_point,
             :tier,
             :rewards

end
