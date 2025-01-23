-- References:
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

local options = {

  -- main theme & interface settings.
  base46 = {
    theme = "chadracula",
  },

  -- telescope.
  telescope = {
    style = "bordered",
  },

  -- dashboard.
  nvdash = {
    load_on_startup = true,
    header = {
      "                                                    ",
      "                          .s.s.                     ",
      "                      , `'`Y8bso.                   ",
      "                    ,d88bso y'd8l                   ",
      "                    \"`,8K j8P?*?b.                  ",
      "                   ,bonsai_`o.o                     ",
      "              ,r.osbJ--','  e8b?Y..                 ",
      "             j*Y888P*{ `._.-'\" 888b                 ",
      "               `\"'``,.`'-. `\"*?*P\"                  ",
      "                db8sld-'., ,):5ls.                  ",
      "           <sd88P,-d888P'd888d8888Rdbc              ",
      "           `\"*J*CJ8*d8888l:'  ``88?bl.o             ",
      "           .o.sl.rsdP^*8bdbs.. *\"?**l888s.          ",
      "         ,`JYsd88P88ls?\\**\"`*`-. `  ` `\"`           ",
      "        dPJ88*J?P;Pd888D;=-.  -.l.s.                ",
      "      .'`\"*Y,.sbsdkC l.    ?(     ^.                ",
      "           .Y8*?8P*\"`       `)` .' :                ",
      "             `\"`         _.-'. ,   k.               ",
      "                        (    : '  ('                ",
      "               _______ ,'`-  )`.` `.l  ___          ",
      "           r========-==-==-=-=-=------------=7      ",
      "           `Y - --  ---- -- -   .          ,'       ",
      "             :                        '   :         ",
      "              \\-..  .. .. . . . . .     ,/          ",
      "           .-<=:`._____________________,'.:>-.      ",
      "           L______                        ___J      ",
      "                  ````````````````````````          ",
      "                 Powered by this tree.              ",
      "                                                     ",
    },
  },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
