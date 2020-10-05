require Logger
Logger.error("
====================================
YOU *CAN* INGORE ALL TEST ERROR LOGS
====================================
")

ExUnit.configure exclude: [integration: true]
Awelix.Pact.start_link()
ExUnit.start()
