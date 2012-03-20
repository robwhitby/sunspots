xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace s = "sunspots" at "../src/sunspots.xqy";

declare function convert-value-index-gridsize-into-point ()
{
  assert:equal( s:get-point(0,1,5), s:point(1,1,0) ),
  assert:equal( s:get-point(1,5,5), s:point(5,1,1) ),
  assert:equal( s:get-point(2,6,5), s:point(1,2,2) ),
  assert:equal( s:get-point(3,9,5), s:point(4,2,3) ),
  assert:equal( s:get-point(4,3,2), s:point(1,2,4) ),
  assert:equal( s:get-point(5,6,2), s:point(2,3,5) )
};


declare function calculate-area ()
{
  let $points := (
    s:point(1,1,0), s:point(2,1,0), s:point(3,1,0),
    s:point(1,2,0), s:point(2,2,0), s:point(3,2,0),
    s:point(1,3,0), s:point(2,3,0), s:point(3,3,0)
  )
  return (
    assert:equal(
      s:get-area(s:point(1,1,0), $points),
      (s:point(1,1,0), s:point(2,1,0), s:point(1,2,0), s:point(2,2,0))
    ),
    assert:equal(
      s:get-area(s:point(2,2,0), $points),
      $points
    ),
    assert:equal(
      s:get-area(s:point(2,3,0), $points),
      (s:point(1,2,0), s:point(2,2,0), s:point(3,2,0),s:point(1,3,0), s:point(2,3,0), s:point(3,3,0))
    )
  )
};


declare function calculate-scores ()
{
  assert:equal(
    s:process("1 3 4 2 3 2 2 1 3 2 1"),
    "(1,1 score:20)"
  ),
  assert:equal(
    s:process("1 3 1 1 1 1 2 1 1 1 1"),
    "(1,1 score:10)"
  ),
  assert:equal(
    s:process("1 5 5 3 1 2 0 4 1 1 3 2 2 3 2 4 3 0 2 3 3 2 1 0 2 4 3"),
    "(3,3 score:26)"
  ),
  assert:equal(
    s:process("3 4 2 3 2 1 4 4 2 0 3 4 1 1 2 3 4 4"),
    "(1,2 score:27)(1,1 score:25)(2,2 score:23)"
  )
};
