module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar.default_size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "#{Settings.urls.gravatar}#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def gender_options
    User.genders.map do |key, _value|
      [t("users.gender.#{key}"), key]
    end
  end

  def can_delete_user? user
    current_user.admin? && !current_user?(user)
  end
end
