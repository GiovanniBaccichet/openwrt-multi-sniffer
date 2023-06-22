module("luci.controller.probesniffer", package.seeall)

function index()
    entry({"admin", "status", "probesniffer"}, template("admin_status/probesniffer"), _("Probe Sniffer"), 99).dependent=false
end

function action_probes()
    local json = require "luci.json"
    local f = io.open("/tmp/probe_data.json", "r")
    local probe_data = f:read("*all")
    f:close()
    local probes = json.decode(probe_data)

    luci.template.render("admin_status/probesniffer", {probes = probes})
end
