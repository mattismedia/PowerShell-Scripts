# Delete APPV Packages
# - Matt Balzan April 2015
Stop-AppvClientPackage -all | Unpublish-AppvClientPackage | Remove-AppvClientPackage 