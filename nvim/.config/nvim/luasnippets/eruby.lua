local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- <% ... %>  (scriptlet / control flow)
    s("erb", fmt("<% {} %>", { i(1) })),

    -- <%= ... %>  (output)
    s("erb=", fmt("<%= {} %>", { i(1) })),
}
