# encoding: utf-8
require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "kaibun-web" do
  context "root" do
    it "last response ok?" do
      get '/'
      last_response.ok? == true
    end
  end

  context "check" do
    it "竹藪焼けた" do
      post '/check', {"text" => "竹藪焼けた"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /竹藪焼けた（たけやぶやけた）: 回文/
    end

    it "竹藪、焼けた？" do
      post '/check', {"text" => "竹藪、焼けた？"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /竹藪、焼けた？（たけやぶやけた）: 回文/
    end

    it "タケヤブヤケタ" do
      post '/check', {"text" => "タケヤブヤケタ"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /タケヤブヤケタ（たけやぶやけた）: 回文/
    end

    it "竹藪焼けない" do
      post '/check', {"text" => "竹藪焼けない"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /竹藪焼けない（たけやぶやけない）: 違う/
    end
  end
end

