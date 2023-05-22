# frozen_string_literal: true

module LikesHelper
  def path_for_likeable(likeable)
    likeable.class.name.downcase + "_likes_path"
  end
end
