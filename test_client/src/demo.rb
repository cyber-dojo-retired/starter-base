require_relative 'starter_service'

class Demo

  def call(_env)
    inner_call
  end

  private

  def inner_call
    starter = StarterService.new
    html = [
      pre('ready?()') {
        starter.ready?
      },
      pre('sha()') {
        starter.sha
      },
      pre('language_start_points()') {
        starter.language_start_points
      },
      pre('language_manifest("C#, NUnit", "Tiny_Maze")') {
        starter.language_manifest('C#, NUnit', 'Tiny_Maze')
      },
      pre('custom_start_points()') {
        starter.custom_start_points
      },
      pre('custom_manifest("Yahtzee refactoring, Java JUnit")') {
        starter.custom_manifest('Yahtzee refactoring, Java JUnit')
      },
      pre('wibble()') {
        starter.wibble
      }
    ].join
    [ 200, { 'Content-Type' => 'text/html' }, [ html ] ]
  end

  # - - - - - - - - - - - - - - - - -

  def timed
    started = Time.now
    result = yield
    finished = Time.now
    duration = '%.4f' % (finished - started)
    [result,duration]
  end

  # - - - - - - - - - - - - - - - - -

  def pre(name, &block)
    result,duration = *timed {
      begin
        block.call
      rescue => error
        JSON.parse(error.message)
      end
    }
    [
      "<pre>/#{name}[#{duration}s]</pre>",
      "<pre style='#{style}'>",
        "#{JSON.pretty_unparse(result)}",
      '</pre>'
    ].join
  end

  def style
    [whitespace,margin,border,padding,background].join
  end

  def border
    'border: 1px solid black;'
  end

  def padding
    'padding: 10px;'
  end

  def margin
    'margin-left: 30px; margin-right: 30px;'
  end

  def background
    'background: white;'
  end

  def whitespace
    'white-space: pre-wrap;'
  end

end