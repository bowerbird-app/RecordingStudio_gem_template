module ApplicationHelper
  def dummy_page_nav(title:, back_url: nil, back_label: "Home")
    recording_studio_page_nav(
      title: title,
      page_nav_back_url: back_url,
      page_nav_back_label: back_label
    )

    recording_studio_page_nav_right do
      concat dummy_root_switch_dropdown
      concat render(
        FlatPack::Button::Component.new(
          text: "Sign out",
          style: :ghost,
          size: :md,
          url: main_app.destroy_user_session_path,
          data: { turbo_method: :delete }
        )
      )
    end
  end

  # Root Switchable 0.10.0's dropdown template calls button_attributes.
  # FlatPack 0.1.319 removed that method, so draw the same rows on the current dropdown.
  def dummy_root_switch_dropdown
    menu_rows = recording_studio_root_switch_menu_rows
    return if menu_rows.blank?

    dropdown = FlatPack::Button::Dropdown::Component.new(
      text: menu_rows.current_label,
      disabled: menu_rows.switch_rows.empty?,
      style: :ghost,
      size: :md
    )
    dropdown.menu_html(
      render(RecordingStudioRootSwitchable::RootSwitch::RowsComponent.new(menu_rows: menu_rows))
    )
    render(dropdown)
  end
end
