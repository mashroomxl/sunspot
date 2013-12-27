require File.expand_path('spec_helper', File.dirname(__FILE__))

describe 'spell check query' do
  it 'escapes leading asterisk in keywords' do
    query = Sunspot::Query::SpellCheck.new('*Foo*Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql '\*Foo*Bar'
  end

  it 'doesnt escape leading asterisk in keywords twice' do
    query = Sunspot::Query::SpellCheck.new('\*Foo*Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql '\*Foo*Bar'
  end

  it 'escapes leading question mark in keywords' do
    query = Sunspot::Query::SpellCheck.new('?Foo?Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql '\?Foo?Bar'
  end

  it 'doesnt escape leading question mark in keywords twice' do
    query = Sunspot::Query::SpellCheck.new('\?Foo?Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql '\?Foo?Bar'
  end

  it 'escapes colon in keywords' do
    query = Sunspot::Query::SpellCheck.new('Foo: Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql 'Foo\: Bar'
  end

  it 'doesnt escape colon in keywords twice' do
    query = Sunspot::Query::SpellCheck.new('Foo\: Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql 'Foo\: Bar'
  end

  it 'escapes quotation mark in keywords' do
    query = Sunspot::Query::SpellCheck.new('Foo" Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql 'Foo\" Bar'
  end

  it 'doesnt escape quotation mark in keywords twice' do
    query = Sunspot::Query::SpellCheck.new('Foo\" Bar')
    query.should_receive(:escaped_keywords).and_call_original
    params = query.to_params
    params.should have_key :q
    params[:q].should eql 'Foo\" Bar'
  end
end