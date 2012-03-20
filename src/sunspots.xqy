xquery version "1.0-ml";
module namespace sunspots = "sunspots";

declare function process($input as xs:string) as xs:string
{
  let $tokens := for $i in fn:tokenize($input, " ") return xs:integer($i)
  let $t := $tokens[1]
  let $n := $tokens[2]
  let $values := fn:subsequence($tokens, 3)   
  return fn:string-join(process($n, $values)[1 to $t], "")
};


declare function process($n as xs:integer, $values as xs:integer+) as xs:string+
{
  for $value at $index in $values
  let $point := get-point($index, $n)
  let $area := get-area($point, $n)
  let $score := fn:sum(get-value($area, $n, $values))
  order by $score descending
  return fn:concat("(", x($point) - 1, ",", y($point) - 1, " score:", $score, ")")
};


declare function get-point($index as xs:integer, $n as xs:integer) as element(point)
{
  let $y := fn:ceiling($index div $n)
  let $x := $index - ($y * $n) + $n
  return point($x, $y)
};


declare function get-area($point as element(point), $n as xs:integer) as element(point)+
{
  let $x := x($point)
  let $y := y($point)
  for $yy in ($y - 1, $y, $y + 1)[. ge 1 and . le $n],
      $xx in ($x - 1, $x, $x + 1)[. ge 1 and . le $n]     
  return point($xx, $yy)
};


declare function get-value($point as element(point), $n as xs:integer, $values as xs:integer+) as xs:integer
{
  $values[xs:integer((y($point) * $n) - $n + x($point))]
};


declare function point($x as xs:integer, $y as xs:integer) { <point x="{$x}" y="{$y}"/> };
declare function x($point as element(point)) { xs:integer($point/@x) };
declare function y($point as element(point)) { xs:integer($point/@y) };
