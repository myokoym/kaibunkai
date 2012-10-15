# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'MeCab'
require 'mecab-modern'

get "/" do
  haml :index
end

post "/check" do
  @text = params['text']
  @kana = reading(@text)
  @message = kaibun?(@kana) ? '回文' : '違う'
  haml :index
end

private
def reading(text)
  kanas = ""
  MeCab::Tagger.new.parseToNode(text).each do |node|
    next if node.surface.empty?
    kana = node.feature.split(/,/)[8]
    if kana
      kanas << kana
    else
      kanas << node.surface
    end
  end
  hiragana(kanas)
end

def hiragana(text)
  text.tr("ァ-ヴ", "ぁ-ゔ").gsub(/[^ぁ-ゔ]/, '')
end

def kaibun?(text)
  text == text.reverse
end
