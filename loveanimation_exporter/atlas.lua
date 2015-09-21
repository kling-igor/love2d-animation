-- Created with TexturePacker (http://www.codeandweb.com/texturepacker)
-- Sprite sheet: {{texture.fullName}} ({{texture.size.width}} x {{texture.size.height}})

-- {{smartUpdateKey}}

return {
  atlas = {
    filename = '{{texture.fullName}}',
    size = { {{texture.size.width}}, {{texture.size.height}} }
  },
  frames = { {% for sprite in allSprites %} 
    ['{{sprite.trimmedName}}'] = {
      rect = { {{sprite.frameRect.x}}, {{sprite.frameRect.y}}, {{sprite.frameRect.width}}, {{sprite.frameRect.height}} },{% if sprite.trimmed %}
      trimmed = {{sprite.trimmed}},
      untrimmedSize = { {{sprite.untrimmedSize.width}}, {{sprite.untrimmedSize.height}} },
      cornerOffset = { {{sprite.cornerOffset.x}}, {{sprite.cornerOffset.y}} } {% endif %} 
    }{% if not forloop.last %}, {% endif %} {% endfor %}
  }
}


