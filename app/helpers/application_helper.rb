module ApplicationHelper
  FLASH_TYPE_CLASS_MAP = {
    'error' => 'danger',
    'notice' => 'success',
    'alert' => 'warning'
  }

  def nav_class(controller, action = :index)
    classes = %w[nav-link]

    classes << 'active' if controller.to_s == controller_name && action.to_s == action_name

    classes
  end

  def flash_class(type)
    "alert-#{FLASH_TYPE_CLASS_MAP[type] || 'primary'}"
  end
end
