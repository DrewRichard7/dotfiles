return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff00dd96,
  transblue = 0xbfb9f3fb,
  blue = 0xffb9f3fb,
  bluealt = 0xdf00E8F3,
  darkblue = 0xff001423,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xbf7f8490,
  transparent = 0x00000000,

  bar = {
    bg = 0x00000000,
    border = 0xbf2c2e34,
  },
  popup = {
    bg = 0xbf2c2e34,
    border = 0xbf7f8490
  },
  bg1 = 0xbf363944,
  -- bg2 = 0xff414550,
  bg2 = 0xbf001423,

  with_alpha = function(color, alpha)
    -- Clamp alpha between 0.0 and 1.0
    local clamped_alpha = math.max(0.0, math.min(1.0, alpha))
    -- Calculate the alpha byte (0-255)
    local alpha_byte = math.floor(clamped_alpha * 255.0)
    -- Isolate RGB, shift alpha byte to the correct position, and combine
    return (color & 0x00ffffff) | (alpha_byte << 24)
  end,
}
