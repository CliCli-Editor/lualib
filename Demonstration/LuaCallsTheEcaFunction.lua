--Need to install "CliCli Developer Assistant" plug-in (version >=1.1.0)

---@diagnostic disable: param-type-mismatch, redundant-parameter

--Suppose a custom event is registered in the map: "Add", the parameter is 2 integers,
--You can invoke the custom event directly with the following code

clicli.eca.call('addition', 100, 200)
