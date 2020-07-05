module SettingsHelper
	def settings_permission_path(permission)
		if permission
	      'settings/settings'
	    else
	      'settings/not_permitted'
	    end
	end
end
