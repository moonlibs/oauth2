package = "oauth2"
version = "scm-1"
source = {
	url = "git+https://github.com/moonlibs/oauth2"
}
description = {
	homepage = "https://github.com/moonlibs/oauth2",
	license = "Artistic",
}
dependencies = {
	"net-url ~> 0.9",
}
build = {
	type = "builtin",
	modules = {
		oauth2 = "oauth2.lua"
	}
}
