-- jfm-shgtest.lua: a minimal JFM for the tests of showhanmengrid.
-- Every character belongs to class 0, and the JFM puts 0.25zw between
-- two of them (shibu-aki by the JFM, with \kanjiskip left at 0pt).
-- The boundaries of boxes and paragraphs get their own classes, so that
-- no glue is put before the first or after the last character.
luatexja.jfont.define_jfm {
   version = 3,
   dir = 'yoko',
   zw = 1.0, zh = 1.0,
   kanjiskip =  { 0.0, 0.0, 0.0 },
   xkanjiskip = { 0.25, 0.0, 0.0 },
   [0] = {
      align = 'left', left = 0.0, down = 0.0,
      width = 1.0, height = 0.88, depth = 0.12, italic = 0.0,
      glue = {
         [0] = { 0.25, 0.0, 0.0 },
      },
   },
   [99] = { chars = { 'boxbdd', 'glue' } },
   [199] = { chars = { 'parbdd' } },
}
