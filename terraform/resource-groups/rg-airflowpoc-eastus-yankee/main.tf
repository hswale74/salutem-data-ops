resource "azurerm_resource_group" "res-0" {
  location = "eastus"
  name     = "rg-airflowpoc-eastus-yankee"
}
resource "azurerm_postgresql_server" "res-1" {
  auto_grow_enabled                = false
  location                         = "eastus"
  name                             = "airflow-qe232qydwkol4pgserver"
  resource_group_name              = "rg-airflowpoc-eastus-yankee"
  sku_name                         = "GP_Gen5_2"
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
  version                          = "9.6"
  threat_detection_policy {
    enabled = true
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_postgresql_configuration" "res-2" {
  name                = "array_nulls"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-3" {
  name                = "autovacuum"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-4" {
  name                = "autovacuum_analyze_scale_factor"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.05"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-5" {
  name                = "autovacuum_analyze_threshold"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "50"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-6" {
  name                = "autovacuum_freeze_max_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "200000000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-7" {
  name                = "autovacuum_max_workers"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "3"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-8" {
  name                = "autovacuum_multixact_freeze_max_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "400000000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-9" {
  name                = "autovacuum_naptime"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "15"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-10" {
  name                = "autovacuum_vacuum_cost_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "20"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-11" {
  name                = "autovacuum_vacuum_cost_limit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "-1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-12" {
  name                = "autovacuum_vacuum_scale_factor"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.05"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-13" {
  name                = "autovacuum_vacuum_threshold"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "50"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-14" {
  name                = "autovacuum_work_mem"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "-1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-15" {
  name                = "azure.replication_support"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "REPLICA"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-16" {
  name                = "backend_flush_after"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-17" {
  name                = "backslash_quote"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "safe_encoding"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-18" {
  name                = "bgwriter_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "20"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-19" {
  name                = "bgwriter_flush_after"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "64"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-20" {
  name                = "bgwriter_lru_maxpages"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "100"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-21" {
  name                = "bgwriter_lru_multiplier"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "2"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-22" {
  name                = "bytea_output"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "hex"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-23" {
  name                = "check_function_bodies"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-24" {
  name                = "checkpoint_completion_target"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.9"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-25" {
  name                = "checkpoint_warning"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "30"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-26" {
  name                = "client_encoding"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "sql_ascii"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-27" {
  name                = "client_min_messages"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "notice"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-28" {
  name                = "commit_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-29" {
  name                = "commit_siblings"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "5"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-30" {
  name                = "connection_throttling"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-31" {
  name                = "constraint_exclusion"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "partition"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-32" {
  name                = "cpu_index_tuple_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.005"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-33" {
  name                = "cpu_operator_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.0025"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-34" {
  name                = "cpu_tuple_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.01"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-35" {
  name                = "cursor_tuple_fraction"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-36" {
  name                = "datestyle"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "iso, mdy"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-37" {
  name                = "deadlock_timeout"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-38" {
  name                = "debug_print_plan"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-39" {
  name                = "debug_print_rewritten"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-40" {
  name                = "default_statistics_target"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "100"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-41" {
  name                = "default_text_search_config"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "pg_catalog.english"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-42" {
  name                = "default_transaction_deferrable"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-43" {
  name                = "default_transaction_isolation"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "read committed"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-44" {
  name                = "default_transaction_read_only"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-45" {
  name                = "default_with_oids"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-46" {
  name                = "effective_cache_size"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "655360"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-47" {
  name                = "enable_bitmapscan"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-48" {
  name                = "enable_hashagg"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-49" {
  name                = "enable_hashjoin"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-50" {
  name                = "enable_indexonlyscan"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-51" {
  name                = "enable_indexscan"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-52" {
  name                = "enable_material"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-53" {
  name                = "enable_mergejoin"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-54" {
  name                = "enable_nestloop"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-55" {
  name                = "enable_seqscan"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-56" {
  name                = "enable_sort"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-57" {
  name                = "enable_tidscan"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-58" {
  name                = "escape_string_warning"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-59" {
  name                = "exit_on_error"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-60" {
  name                = "extra_float_digits"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-61" {
  name                = "force_parallel_mode"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-62" {
  name                = "from_collapse_limit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "8"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-63" {
  name                = "geqo"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-64" {
  name                = "geqo_effort"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "5"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-65" {
  name                = "geqo_generations"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-66" {
  name                = "geqo_pool_size"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-67" {
  name                = "geqo_seed"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-68" {
  name                = "geqo_selection_bias"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "2.0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-69" {
  name                = "geqo_threshold"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "12"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-70" {
  name                = "gin_fuzzy_search_limit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-71" {
  name                = "gin_pending_list_limit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "4096"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-72" {
  name                = "hot_standby_feedback"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-73" {
  name                = "idle_in_transaction_session_timeout"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-74" {
  name                = "intervalstyle"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "postgres"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-75" {
  name                = "join_collapse_limit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "8"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-76" {
  name                = "lc_monetary"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "English_United States.1252"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-77" {
  name                = "lc_numeric"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "English_United States.1252"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-78" {
  name                = "lo_compat_privileges"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-79" {
  name                = "lock_timeout"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-80" {
  name                = "log_autovacuum_min_duration"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "-1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-81" {
  name                = "log_checkpoints"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-82" {
  name                = "log_connections"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-83" {
  name                = "log_disconnections"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-84" {
  name                = "log_duration"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-85" {
  name                = "log_error_verbosity"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "default"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-86" {
  name                = "log_line_prefix"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "%t-%c-"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-87" {
  name                = "log_lock_waits"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-88" {
  name                = "log_min_duration_statement"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "-1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-89" {
  name                = "log_min_error_statement"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "error"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-90" {
  name                = "log_min_messages"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "warning"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-91" {
  name                = "log_replication_commands"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-92" {
  name                = "log_retention_days"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "3"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-93" {
  name                = "log_statement"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "none"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-94" {
  name                = "log_statement_stats"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-95" {
  name                = "log_temp_files"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "-1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-96" {
  name                = "logging_collector"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-97" {
  name                = "maintenance_work_mem"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "131072"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-98" {
  name                = "max_locks_per_transaction"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "64"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-99" {
  name                = "max_parallel_workers_per_gather"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-100" {
  name                = "max_prepared_transactions"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-101" {
  name                = "max_replication_slots"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "10"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-102" {
  name                = "max_standby_archive_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "30000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-103" {
  name                = "max_standby_streaming_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "30000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-104" {
  name                = "max_wal_senders"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "10"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-105" {
  name                = "max_wal_size"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1024"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-106" {
  name                = "min_parallel_relation_size"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "8388608"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-107" {
  name                = "min_wal_size"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "256"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-108" {
  name                = "old_snapshot_threshold"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "-1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-109" {
  name                = "operator_precedence_warning"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-110" {
  name                = "parallel_setup_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-111" {
  name                = "parallel_tuple_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0.1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-112" {
  name                = "pg_qs.interval_length_minutes"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "15"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-113" {
  name                = "pg_qs.max_query_text_length"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "6000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-114" {
  name                = "pg_qs.query_capture_mode"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "none"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-115" {
  name                = "pg_qs.replace_parameter_placeholders"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-116" {
  name                = "pg_qs.retention_period_in_days"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "7"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-117" {
  name                = "pg_qs.track_utility"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-118" {
  name                = "pg_stat_statements.max"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "5000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-119" {
  name                = "pg_stat_statements.save"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-120" {
  name                = "pg_stat_statements.track"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "none"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-121" {
  name                = "pg_stat_statements.track_utility"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-122" {
  name                = "pgms_wait_sampling.history_period"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "100"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-123" {
  name                = "pgms_wait_sampling.query_capture_mode"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "none"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-124" {
  name                = "postgis.gdal_enabled_drivers"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "DISABLE_ALL"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-125" {
  name                = "quote_all_identifiers"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-126" {
  name                = "random_page_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "4.0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-127" {
  name                = "replacement_sort_tuples"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "150000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-128" {
  name                = "row_security"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-129" {
  name                = "search_path"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "\"$user\", public"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-130" {
  name                = "seq_page_cost"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1.0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-131" {
  name                = "session_replication_role"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "origin"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-132" {
  name                = "shared_preload_libraries"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = ""
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-133" {
  name                = "sql_inheritance"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-134" {
  name                = "statement_timeout"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-135" {
  name                = "synchronize_seqscans"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-136" {
  name                = "synchronous_commit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-137" {
  name                = "tcp_keepalives_count"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-138" {
  name                = "tcp_keepalives_idle"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-139" {
  name                = "tcp_keepalives_interval"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-140" {
  name                = "temp_buffers"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1024"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-141" {
  name                = "timezone"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "UTC"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-142" {
  name                = "track_activities"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-143" {
  name                = "track_activity_query_size"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1024"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-144" {
  name                = "track_commit_timestamp"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-145" {
  name                = "track_counts"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-146" {
  name                = "track_functions"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "none"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-147" {
  name                = "track_io_timing"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "on"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-148" {
  name                = "transform_null_equals"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "off"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-149" {
  name                = "vacuum_cost_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-150" {
  name                = "vacuum_cost_limit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "200"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-151" {
  name                = "vacuum_cost_page_dirty"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "20"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-152" {
  name                = "vacuum_cost_page_hit"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "1"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-153" {
  name                = "vacuum_cost_page_miss"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "10"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-154" {
  name                = "vacuum_defer_cleanup_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-155" {
  name                = "vacuum_freeze_min_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "50000000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-156" {
  name                = "vacuum_freeze_table_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "150000000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-157" {
  name                = "vacuum_multixact_freeze_min_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "5000000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-158" {
  name                = "vacuum_multixact_freeze_table_age"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "150000000"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-159" {
  name                = "wal_buffers"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "8192"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-160" {
  name                = "wal_receiver_status_interval"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "10"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-161" {
  name                = "wal_writer_delay"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "200"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-162" {
  name                = "wal_writer_flush_after"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "128"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-163" {
  name                = "work_mem"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "4096"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-164" {
  name                = "xmlbinary"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "base64"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_configuration" "res-165" {
  name                = "xmloption"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  value               = "content"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_database" "res-166" {
  charset             = "UTF8"
  collation           = "English_United States.1252"
  name                = "airflowdb"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_database" "res-167" {
  charset             = "UTF8"
  collation           = "English_United States.1252"
  name                = "azure_maintenance"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_database" "res-168" {
  charset             = "UTF8"
  collation           = "English_United States.1252"
  name                = "azure_sys"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_database" "res-169" {
  charset             = "UTF8"
  collation           = "English_United States.1252"
  name                = "postgres"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_postgresql_firewall_rule" "res-170" {
  end_ip_address      = "255.255.255.255"
  name                = "airflow-qe232qydwkol4pgserverfirewall"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  server_name         = "airflow-qe232qydwkol4pgserver"
  start_ip_address    = "0.0.0.0"
  depends_on = [
    azurerm_postgresql_server.res-1,
  ]
}
resource "azurerm_service_plan" "res-172" {
  location            = "eastus"
  name                = "airflow-qe232qydwkol4serviceplan"
  os_type             = "Linux"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  sku_name            = "S1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_linux_web_app" "res-173" {
  app_settings = {
    AIRFLOW__CORE__LOAD_EXAMPLES        = "true"
    AIRFLOW__CORE__SQL_ALCHEMY_CONN     = "postgresql://airflowdbadmin@airflow-qe232qydwkol4pgserver:'zp0v.\\sISTMsyL@airflow-qe232qydwkol4pgserver.postgres.database.azure.com:5432/airflowdb"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
  }
  client_affinity_enabled = true
  location                = "eastus"
  name                    = "airflow-qe232qydwkol4"
  resource_group_name     = "rg-airflowpoc-eastus-yankee"
  service_plan_id         = "/subscriptions/c60516fb-b6f2-454c-9b7b-83fec7efa4c7/resourceGroups/rg-airflowpoc-eastus-yankee/providers/Microsoft.Web/serverfarms/airflow-qe232qydwkol4serviceplan"
  site_config {
    always_on  = false
    ftps_state = "FtpsOnly"
  }
  depends_on = [
    azurerm_service_plan.res-172,
  ]
}
resource "azurerm_app_service_custom_hostname_binding" "res-177" {
  app_service_name    = "airflow-qe232qydwkol4"
  hostname            = "airflow-qe232qydwkol4.azurewebsites.net"
  resource_group_name = "rg-airflowpoc-eastus-yankee"
  depends_on = [
    azurerm_linux_web_app.res-173,
  ]
}
