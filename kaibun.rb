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
  kana = reading(params['text'])
  @message = "#{kana}: #{kaibun?(kana) ? '回文' : '違う'}"
  haml :index
end

get "/check/:text" do
  kaibun?(reading(text))
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
