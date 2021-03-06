require 'jekyll'
require 'objective_elements'

require_relative 'jekyll_picture_tag/generated_image'
require_relative 'jekyll_picture_tag/instructions'
require_relative 'jekyll_picture_tag/output_formats'
require_relative 'jekyll_picture_tag/source_image'
require_relative 'jekyll_picture_tag/srcsets'
require_relative 'jekyll_picture_tag/utils'
require_relative 'jekyll_picture_tag/img_uri'
require_relative 'jekyll_picture_tag/router'

# Title: Jekyll Picture Tag
# Authors: Rob Wierzbowski   : @robwierzbowski
#          Justin Reese      : @justinxreese
#          Welch Canavan     : @xiwcx
#          Robert Buchberger : @celeritas_5k
#
# Description: Easy responsive images for Jekyll.
#
# Download: https://github.com/rbuchberger/jekyll_picture_tag
# Documentation: https://github.com/rbuchberger/jekyll_picture_tag/readme.md
# Issues: https://github.com/rbuchberger/jekyll_picture_tag/issues
#
# Syntax:
# {% picture [preset] img.jpg [media_query: alt-img.jpg] [attributes] %}
#
# Examples:
#
#   {% picture poster.jpg --alt The strange case of responsive images %}
#
#   {% picture
#      gallery
#      poster.jpg
#      source_small: poster_closeus.jpg
#      --alt The strange case of responsive images
#      --img class="gal-img"
#   %}
#
# See the documentation for full configuration and usage instructions.
module PictureTag
  extend Router
  ROOT_PATH = __dir__

  # This is the actual liquid tag, which provides the interface with Jekyll.
  class Picture < Liquid::Tag
    def initialize(tag_name, raw_params, tokens)
      @raw_params = raw_params
      super
    end

    def render(context)
      # Jekyll passes in a mostly undocumented context object, which appears to
      # hold the entire site, including configuration and the _data dir.
      PictureTag.context = context

      # The instruction set depends on both the context and the tag parameters:
      PictureTag.instructions = Instructions::Set.new(@raw_params)

      # We need to explicitly prevent jekyll from overwriting our generated
      # files:
      Utils.keep_files

      # Return a string:
      PictureTag.output_class.new.to_s
    end
  end
end

Liquid::Template.register_tag('picture', PictureTag::Picture)
