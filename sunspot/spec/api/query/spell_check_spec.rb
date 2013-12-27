require File.expand_path('spec_helper', File.dirname(__FILE__))

describe 'spell check query' do
  it 'uses DismaxEscaper to escape keywords in to_params' do
      query = Sunspot::Query::SpellCheck.new("*foo[bar]")

    Sunspot::DismaxEscaper.should_receive(:escape_keywords).with("*foo[bar]").and_call_original

    params = query.to_params
  end
end
