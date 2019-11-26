# Portfolio notes

Efficiency issues present. Things attempted to mitigate:

- Use less items for equality check
    - Biggest improvement; makes formula imperfect

- Ignore turn number (turn into Best First)
    - Helps, but drastically changes behavior (often for the worst?)
    - Should test this directly against A\*

- Checking if we need to go around snake body somewhere
    - Ideally would push the algorithm in a better direction sooner
    - Hard to implement without even further searches
    - In most cases, just makes things worse
    - When food is surrounded by snake body (worst case!), doesn't change anything

- Hashing the snake body instead of checking directly
    - Initially thought it would improve since checking each snake body part is O(n), but checking a hash is O(1)
    - Did not realize that the hash would need to be updated on every move, keeping it O(n)
    - May still work

Other ideas for a better AI output

- Define goal state as a place where food is eaten AND tail is reachable
- Better heuristic with boundary number detection

