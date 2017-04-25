module PanelsHelper
  def full_width_panel(title:, icon:)
    render layout: 'shared/full_width_panel', locals: { title: title, icon: icon } do
      yield
    end
  end
end
