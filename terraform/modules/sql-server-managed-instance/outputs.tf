output administrator_login {
    value  = azurerm_mssql_managed_instance.main.administrator_login
}

output administrator_login_password {
    value = azurerm_mssql_managed_instance.main.administrator_login_password
}