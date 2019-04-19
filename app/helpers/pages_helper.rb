module PagesHelper
	def index_partial_path
	if user_signed_in?
      'pages/index/landing/signed_in_content'
    else
      'pages/index/landing/non_signed_in_content'
    end
  end  
end
