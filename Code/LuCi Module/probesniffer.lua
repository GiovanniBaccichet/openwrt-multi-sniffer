module("luci.controller.probesniffer", package.seeall)

function index()
    entry({"admin", "status", "probesniffer"}, template("admin_status/probesniffer"), _("Probe Sniffer"), 99).dependent=false
end

function probe_view()
    local json_file = "/root/captures/probe_requests.json.json"  -- Replace this with your JSON file path
    local json_string = nixio.fs.readfile(json_file) -- Reads file content
    local json_data
    if json_string then
        json_data = luci.jsonc.parse(json_string)  -- Parses JSON string into Lua table
    end

    if json_data then
        luci.template.render("probesniffer", {data = json_data})
    else
        luci.template.render("probesniffer", {data = {}})
    end
end
