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
  let $points := for $value at $index in $values return get-point($value, $index, $n)
  for $point in $points
  let $area := get-area($point, $points)
  let $score := fn:sum(value($area))
  order by $score descending
  return fn:concat("(", x($point) - 1, ",", y($point) - 1, " score:", $score, ")")
};


declare function get-point($value as xs:integer, $index as xs:integer, $n as xs:integer) as element(point)
{
  let $y := fn:ceiling($index div $n)
  let $x := $index - ($y * $n) + $n
  return point($x, $y, $value)
};


declare function get-area($point as element(point), $points as element(point)+) as element(point)+
{
  let $x := x($point)
  let $y := y($point)
  return $points[@x = ($x - 1, $x, $x + 1) and @y = ($y - 1, $y, $y + 1)]
};


declare function point($x as xs:integer, $y as xs:integer, $value as xs:integer) {
  <point x="{$x}" y="{$y}" value="{$value}"/>
};

declare function x($point as element(point)) { xs:integer($point/@x) };

declare function y($point as element(point)) { xs:integer($point/@y) };

declare function value($point as element(point)) { xs:integer($point/@value) };
