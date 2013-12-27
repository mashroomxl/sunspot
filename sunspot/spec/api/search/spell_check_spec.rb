# -*- encoding : utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Sunspot::Search::SpellCheck do
  let(:query_dummy) { Sunspot::Query::SpellCheck.new(nil, nil) }
  let(:subject_dummy) { Sunspot::Search::SpellCheck.new(nil, query_dummy) }

  it 'unescapes leading asterisk' do
    subject_dummy.stub(:results).and_return({"suggestions"=>["\\*foo*",{},"correctlySpelled",true]})
    subject_dummy.suggestions.should have_key "*foo*"
  end

  it 'unescapes leading question mark' do
    subject_dummy.stub(:results).and_return({"suggestions"=>["\\?foo?",{},"correctlySpelled",true]})
    subject_dummy.suggestions.should have_key "?foo?"
  end

  it 'unescapes colon in suggestions' do
    subject_dummy.stub(:results).and_return({"suggestions"=>["foo\\:",{},"correctlySpelled",true]})
    subject_dummy.suggestions.should have_key "foo:"
  end

  it 'unescapes quotation mark in suggestions' do
    subject_dummy.stub(:results).and_return({"suggestions"=>["foo\\\"",{},"correctlySpelled",true]})
    subject_dummy.suggestions.should have_key "foo\""
  end

  it 'returns collation correctly with Umlauten' do
    query_dummy.stub(:keywords).and_return("Ümit Kosan")
    subject_dummy.stub(:results).and_return({"suggestions"=>["ümit",{"origFreq"=>0,"suggestion"=>[{"word"=>"mit","freq"=>70}]},"kosan",{"origFreq"=>0,"suggestion"=>[{"word"=>"kostka","freq"=>5}]},"correctlySpelled",false]})
    subject_dummy.suggestions.should have_key "ümit"
    subject_dummy.suggestions.should have_key "kosan"

    expect {
      subject_dummy.collation{ |keywords| keywords.downcase }
    }.to_not raise_error

    subject_dummy.collation{ |keywords| keywords.downcase }.should eql "mit kostka"
  end
end
