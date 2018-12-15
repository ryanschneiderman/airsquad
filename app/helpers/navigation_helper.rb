module NavigationHelper

  def collapsible_links_partial_path
    if user_signed_in?
      'pages/index/navigation/collapsible_elements/signed_in_links'
    else
      'pages/index/navigation/collapsible_elements/non_signed_in_links'
    end
  end
  
end