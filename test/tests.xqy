xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace s = "sunspots" at "../src/sunspots.xqy";

declare function convert-index-and-grid-size-into-point ()
{
  assert:equal( s:get-point(1, 5), s:point(1,1) ),
  assert:equal( s:get-point(5, 5), s:point(5,1) ),
  assert:equal( s:get-point(6, 5), s:point(1,2) ),
  assert:equal( s:get-point(9, 5), s:point(4,2) ),
  assert:equal( s:get-point(3, 2), s:point(1,2) ),
  assert:equal( s:get-point(6, 2), s:point(2,3) )
};


declare function convert-point-to-value ()
{
  assert:equal( s:get-value(s:point(1,1), 2, (1 to 4)), 1 ),
  assert:equal( s:get-value(s:point(5,2), 5, (1 to 25)), 10 ),
  assert:equal( s:get-value(s:point(1,2), 3, (1 to 9)), 4 ),
  assert:equal( s:get-value(s:point(4,2), 5, (1 to 25)), 9 ),
  assert:equal( s:get-value(s:point(1,2), 2, (1 to 4)), 3 ),
  assert:equal( s:get-value(s:point(2,3), 2, (1 to 9)), 6 )
};


declare function calculate-area ()
{
  assert:equal(
    s:get-area(s:point(1,1), 5),
    (s:point(1,1), s:point(2,1), s:point(1,2), s:point(2,2))
  ),
  assert:equal(
    s:get-area(s:point(3,3), 5),
    (
      s:point(2,2), s:point(3,2), s:point(4,2),
      s:point(2,3), s:point(3,3), s:point(4,3),
      s:point(2,4), s:point(3,4), s:point(4,4)
    )
  ),
  assert:equal(
    s:get-area(s:point(5,5), 5),
    (s:point(4,4), s:point(5,4), s:point(4,5), s:point(5,5))
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
