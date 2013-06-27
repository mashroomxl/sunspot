require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Sunspot::Search::SpellCheck do
  let(:subject_dummy) { Sunspot::Search::SpellCheck.new(nil, nil) }

  it 'unescapes suggestions' do
    subject_dummy.stub(:results).and_return({"suggestions"=>["foo\\:",{},"correctlySpelled",true]})
    subject_dummy.suggestions.should have_key "foo:"
  end
end
