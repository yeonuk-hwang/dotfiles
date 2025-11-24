local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("markdown", {
  s("tfmod", {
    t("### {"),
    i(1, "Module"),
    t({ "}", "" }),
    t({ "#### Resources", "" }),
    i(2),
    t({ "", "#### Variables", "" }),
    i(3),
    t({ "", "#### Outputs", "" }),
    i(0),
  }),
})
