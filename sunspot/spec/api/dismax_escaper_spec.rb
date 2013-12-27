require File.expand_path('spec_helper', File.dirname(__FILE__))

describe 'escaping queries' do
  it 'escapes colon' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo: Bar')
    escaped.should eql 'Foo\: Bar'
  end

  it 'doesnt escapes colon twice' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo\: Bar')
    escaped.should eql 'Foo\: Bar'
  end

  it 'escapes quotation marks' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo" Bar')
    escaped.should eql 'Foo\" Bar'
  end

  it 'doesnt escapes quotation marks twice' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo\" Bar')
    escaped.should eql 'Foo\" Bar'
  end

  it 'escapes left square brackets' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo[ Bar')
    escaped.should eql 'Foo\[ Bar'
  end

  it 'escapes right square brackets' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo] Bar')
    escaped.should eql 'Foo\] Bar'
  end

  it 'escapes left curly brackets' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo{ Bar')
    escaped.should eql 'Foo\{ Bar'
  end

  it 'escapes right curly brackets' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo} Bar')
    escaped.should eql 'Foo\} Bar'
  end

  it 'escapes left braces' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo( Bar')
    escaped.should eql 'Foo\( Bar'
  end

  it 'escapes right braces' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('Foo) Bar')
    escaped.should eql 'Foo\) Bar'
  end

  it 'escapes leading asterisk in keywords' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('*Foo*Bar')
    escaped.should eql '\*Foo*Bar'
  end

  it 'doesnt escape leading asterisk in keywords twice' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('\*Foo*Bar')
    escaped.should eql '\*Foo*Bar'
  end

  it 'escapes leading question mark in keywords' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('?Foo?Bar')
    escaped.should eql '\?Foo?Bar'
  end

  it 'doesnt escape leading question mark in keywords twice' do
    escaped = Sunspot::DismaxEscaper.escape_keywords('\?Foo?Bar')
    escaped.should eql '\?Foo?Bar'
  end
end

describe 'unescaping queries' do
  it 'unescapes colons' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\: Bar')
    escaped.should eql 'Foo: Bar'
  end

  it 'unescapes quotaion marks' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\" Bar')
    escaped.should eql 'Foo" Bar'
  end

  it 'unescapes left square brackets' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\[ Bar')
    escaped.should eql 'Foo[ Bar'
  end

  it 'unescapes right square brackets' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\] Bar')
    escaped.should eql 'Foo] Bar'
  end

  it 'unescapes left curly brackets' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\{ Bar')
    escaped.should eql 'Foo{ Bar'
  end

  it 'unescapes right curly brackets' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\} Bar')
    escaped.should eql 'Foo} Bar'
  end

  it 'unescapes left braces' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\( Bar')
    escaped.should eql 'Foo( Bar'
  end

  it 'unescapes right braces' do
    escaped = Sunspot::DismaxEscaper.unescape_term('Foo\) Bar')
    escaped.should eql 'Foo) Bar'
  end

  it 'unescapes leading asterisk' do
    escaped = Sunspot::DismaxEscaper.unescape_term("\\*foo*")
    escaped.should eql "*foo*"
  end

  it 'unescapes leading question mark' do
    escaped = Sunspot::DismaxEscaper.unescape_term("\\?foo?")
    escaped.should eql "?foo?"
  end

  it 'unescapes colon in suggestions' do
    escaped = Sunspot::DismaxEscaper.unescape_term("foo\\:")
    escaped.should eql "foo:"
  end

  it 'unescapes quotation mark in suggestions' do
    escaped = Sunspot::DismaxEscaper.unescape_term("foo\\\"")
    escaped.should eql "foo\""
  end
end
