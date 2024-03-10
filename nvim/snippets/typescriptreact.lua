local ls = require("luasnip") --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Typescript Snippets", { clear = true })
local file_pattern = "*.tsx"

local function cs(trigger, nodes, opts) --{{{
    local snippet = s(trigger, nodes)
    local target_table = snippets

    local pattern = file_pattern
    local keymaps = {}

    if opts ~= nil then
        -- check for custom pattern
        if opts.pattern then
            pattern = opts.pattern
        end

        -- if opts is a string
        if type(opts) == "string" then
            if opts == "auto" then
                target_table = autosnippets
            else
                table.insert(keymaps, { "i", opts })
            end
        end

        -- if opts is a table
        if opts ~= nil and type(opts) == "table" then
            for _, keymap in ipairs(opts) do
                if type(keymap) == "string" then
                    table.insert(keymaps, { "i", keymap })
                else
                    table.insert(keymaps, keymap)
                end
            end
        end

        -- set autocmd for each keymap
        if opts ~= "auto" then
            for _, keymap in ipairs(keymaps) do
                vim.api.nvim_create_autocmd("BufEnter", {
                    pattern = pattern,
                    group = group,
                    callback = function()
                        vim.keymap.set(keymap[1], keymap[2], function()
                            ls.snip_expand(snippet)
                        end, { noremap = true, silent = true, buffer = true })
                    end,
                })
            end
        end
    end

    table.insert(target_table, snippet) -- insert snippet into appropriate table
end                                     --}}}

-- Old Style --

local if_fmt_arg = { --{{{
    i(1, ""),
    c(2, { i(1, "LHS"), i(1, "10") }),
    c(3, { i(1, "==="), i(1, "<"), i(1, ">"), i(1, "<="), i(1, ">="), i(1, "!==") }),
    i(4, "RHS"),
    i(5, "//TODO:"),
}
local if_fmt_1 = fmt(
    [[
{}if ({} {} {}) {};
    ]],
    vim.deepcopy(if_fmt_arg)
)
local if_fmt_2 = fmt(
    [[
{}if ({} {} {}) {{
  {};
}}
    ]],
    vim.deepcopy(if_fmt_arg)
)

local if_snippet = s(
    { trig = "IF", regTrig = false, hidden = true },
    c(1, {
        if_fmt_1,
        if_fmt_2,
    })
)                         --}}}
local function_fmt = fmt( --{{{
    [[
function {}({}) {{
  {}
}}
    ]],
    {
        i(1, "myFunc"),
        c(2, { i(1, "arg"), i(1, "") }),
        i(3, "//TODO:"),
    }
)

local function_snippet = s({ trig = "f[un]?", regTrig = true, hidden = true }, function_fmt)
local function_snippet_func = s({ trig = "func" }, vim.deepcopy(function_fmt)) --}}}

local short_hand_if_fmt = fmt(                                                 --{{{
    [[
if ({}) {}
{}
    ]],
    {
        d(1, function(_, snip)
            -- return sn(1, i(1, snip.captures[1]))
            return sn(1, t(snip.captures[1]))
        end),
        d(2, function(_, snip)
            return sn(2, t(snip.captures[2]))
        end),
        i(3, ""),
    }
)
local short_hand_if_statement = s({ trig = "if[>%s](.+)>>(.+)\\", regTrig = true, hidden = true }, short_hand_if_fmt)

local short_hand_if_statement_return_shortcut = s({ trig = "(if[>%s].+>>)[r<]", regTrig = true, hidden = true }, {
    f(function(_, snip)
        return snip.captures[1]
    end),
    t("return "),
}) --}}}
table.insert(autosnippets, if_snippet)
table.insert(autosnippets, short_hand_if_statement)
table.insert(autosnippets, short_hand_if_statement_return_shortcut)
table.insert(snippets, function_snippet)
table.insert(snippets, function_snippet_func)

-- Begin Refactoring --

cs( -- for([%w_]+) JS For Loop snippet{{{
    { trig = "for([%w_]+)", regTrig = true, hidden = true },
    fmt(
        [[
for (let {} = 0; {} < {}; {}++) {{
  {}
}}

{}
   ]],
        {
            d(1, function(_, snip)
                return sn(1, i(1, snip.captures[1]))
            end),
            rep(1),
            c(2, { i(1, "num"), sn(1, { i(1, "arr"), t(".length") }) }),
            rep(1),
            i(3, "// TODO:"),
            i(4),
        }
    )
)   --}}}
cs( -- [while] JS While Loop snippet{{{
    "while",
    fmt(
        [[
while ({}) {{
  {}
}}
  ]],
        {
            i(1, ""),
            i(2, "// TODO:"),
        }
    )
)                                                                  --}}}
cs("cl", { t("console.log("), i(1, ""), t(")") }, { "jcl", "jj" }) -- console.log

cs("rfc",
    fmt([[
        export type {}Props = {{
            {}
        }}

        export function {}(props: {}Props) {{
            return (
                <div>
                    <p>VimMeUp</p>
                </div>
            )
        }}
    ]],
        {
            i(1, "MyComponent"),
            i(2, "// TODO:"),
            rep(1),
            rep(1),
        })
)

cs({ trig = "st([%w]+)", regTrig = true, hidden = true },
    fmt([[
        const [{}, set{}] = useState({})
    ]],
        {
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]:sub(1, 1):upper() .. snip.captures[1]:sub(2)
            end),
            i(3, "myState"),
        })
)

-- component testing snippet
cs({ trig = "tic([%w]+)", regTrig = true, hidden = true },
    fmt([[
import {{render, screen}} from '@testing-library/react'
import '@testing-library/jest-dom'
import {} from './{}'

test('{}', async () => {{
  // ARRANGE
  render(<{} />)

  // ACT

  // ASSERT
}})    ]],
        {
            f(function(_, snip)
                return snip.captures[1]
            end),

            f(function(_, snip)
                return snip.captures[1]:sub(1, 1):lower() .. snip.captures[1]:sub(2)
            end),

            i(3, "should render without crashing"),

            f(function(_, snip)
                return snip.captures[1]
            end),
        })
)

cs({ trig = "tc([%w]+)", regTrig = true, hidden = true },
    fmt([[
test('{}', async () => {{
  // ARRANGE
  render(<{} />)

  // ACT

  // ASSERT
}})    ]],
        {
            i(1, "should render without crashing"),

            f(function(_, snip)
                return snip.captures[1]
            end),
        })
)

cs({ trig = "sbt([%w]+)", regTrig = true, hidden = true },
    fmt([[
import type {{ Meta, StoryObj }} from '@storybook/react';
import {{ api }} from "~/utils/api";
import {{ {} }} from './{}';

const TRPC{} = api.withTRPC({});

const meta = {{
  component: TRPC{},
  tags: ['autodocs'],
  argTypes: {{}},
}} satisfies Meta<typeof TRPC{}>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {{
  parameters: {{
    design: {{
      type: 'figma',
      url: 'FIGMA',
    }},
  }},
  args: {{}}
}};
]],
        {
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
        })
)


cs({ trig = "sb([%w]+)", regTrig = true, hidden = true },
    fmt([[
import type {{ Meta, StoryObj }} from '@storybook/react';

import {{ {} }} from './{}';

const meta = {{
  component: {},
  tags: ['autodocs'],
  argTypes: {{}},
}} satisfies Meta<typeof {}>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {{
  parameters: {{
    design: {{
      type: 'figma',
      url: 'FIGMA',
    }},
  }},
  args: {{}},
}};
]],
        {
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
            f(function(_, snip)
                return snip.captures[1]
            end),
        })
)

-- End Refactoring --

return snippets, autosnippets
