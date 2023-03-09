# Trying to make a basic tokenizer in BQN.

# Here is BQN tokenizer function from BQN compiler by Marshall Lochbaum.



# Source to ⟨tokens, roles, number of identifiers, literals⟩
# Identifiers then literal tokens are numbered starting at vi

Tokenize←{System‿vars←𝕨
  # Resolve comments and strings
  c←𝕩='#'⋄s←/0‿0⊸«⊸∧sm←𝕩='''⋄d←/dm←𝕩='"'
  g←⍋q←∾⟨  s⋄¯1↓d⋄/c⟩ ⋄q↩g⊏q                # Open indices
  e← g⊏∾⟨2+s⋄ 1↓d⋄-⟜»∘⊏⟜(0∾+`c)⊸//(𝕩∊lf)∾1⟩ # Matching close indices
  Se←≠(>/⊢)∾⟜≠{(⊏˜𝕨)𝕊⍟(≠○(¯1⊸⊑))𝕩∾𝕩⊏𝕨}⟨0⟩˙  # Find reachable openings
  St←(≠𝕩)↑·/⁼(Se q⍋e)⊸⊏                     # All indices → reached mask
  a←St q⋄b←St e⋄f←1≠`ab←a∨b                 # Open/close masks; filter
  {!⟨⊑/𝕩,"Unclosed quote"⟩}⍟(∨´)(sm∨dm)∧b<f

  # Extract character and string literals
  u←f∧𝕩='@'⋄ci←/u∨»a∧sm
  chr←(⊏⟜𝕩-('@'-@)×⊏⟜u)ci                   # Characters (indices ci)
  f>↩qe←dm∧«a∧↩dm                           # Quote Escape ""
  str←𝕩⊔˜1-˜(si←a>»qe)(⊣+`⊸×○(∾⟜1)<)≠`dm∧ab # Strings (indices /si)

  # Extract words: identifiers and numbers
  ie←/f⋄is←ie≠⊸↑/1»f                        # Token start and end
  is-↩is(-×⊏⟜c)ie                           # Comment → ending newline only
  t←CharCode ie⊏𝕩
  nd←(t=⊑bN)>«t M bD⋄rr←t=bR                # Namespace dot; 𝕣
  w←»⊸<l←rr∨nd<t M bN(⊣⋈-˜)○⊑bW             # Word chars l, start w
  us←t=¯1++´bA⋄sy←t=⊑bW                     # Underscore, system dot
  {!⟨is/˜us∧w+`⊸⊏0∾𝕩,"Words can't only have underscores"⟩}⍟(∨´)w(/<1(⊢/«)(∨/⊣))l>us
  wk←(¬w/rr)×na⌊∘÷˜(⊑bA)-˜w/t               # Kind of word from first char
  t-↩na×l∧t≥na+⊑bA                          # Case-insensitive
  {!⟨𝕩/is,"System dot with no name"⟩}⍟(∨´)sy>«l
  w≠↩»⊸∨sy                                  # Start system word at dot
  wi←0<wt←(2×wk≥0)(×⟜¬+⊢)w/sy               # Type: 0 number, 1 system, 2 identifier
  i←l>n←l∧(+`w)⊏0∾¬wi                       # Identifier/Number masks
  num←is ReadNums○(((0∾us)<∨⟜«0∾n)/0⊸∾) t×l # Numbers
  ir←(us/˜«⊸<i)(⊢+∧⟜(2⊸=))wi/wk             # Identifier role
  if←(»⌈`)⊸<ig←(i>us)×+`w>n                 # Identifier groups and first character
  fr←(1=wi/wt)<if/rr                        # Identifier is 𝕣-based
  w↩if∨n∧w0←w⋄ws←1=0⊸<⊸/wt/˜↩¬w/rr          # Don't produce an identifier for 𝕣
  {!⟨𝕩/is,"𝕣 can't be used with other word characters"⟩}⍟(∨´)(i>us)∧(rr⊸≠∨if⊸<)ig⊏0∾fr
  {!⟨is⊏˜𝕩/𝕨,"Numbers can't start with underscores"⟩}⍟(∨´⊢)⟜(ws<(⊑bA)>⊏⟜t)/rr<if
  ig⊏↩1-˜0∾+`⊸×¬fr
  id←vars⊸∾⌾⊑(ws∾2)⊔ig⊔t⊏charSet            # ⟨Identifiers, system values⟩

  # Deduplicate literals and identifiers; other cleanup
  ki←(wt⍒⊸⊏/w>rr)∾(ci∾/si)⊏+`»f             # Indices in t
  k←id∾num‿chr‿str⋄k(⊢>¯1»⌈`)⊸/¨˜↩j←⊐¨k     # IDs j into uniques k
  k↩System⌾(1⊸⊑)k                           # System value lookup
  wf←¬l∨t M bW⋄is/˜↩wf∨w0⋄ie/˜↩wf∨>⟜«l      # Index management for...
  t↩(w∨wf)/(vars≠⊸↓∾j++`vd»kk←≠¨k)⌾(ki⊸⊏)t  # Add IDs; remove words/whitespace
  t-↩t(M×-⟜⊑)bS                             # Separators are equivalent
  p←≠`1¨sb←¯1↓1↓/1(∾≠∾˜)t=sep               # Separator group boundaries (excludes leading and trailing)
  eb←3‿5‿7+⊑bB                              # End brackets that allow separators
  sk←sb/˜p>∨⟜«(M⟜bH∨eb∊˜p⊸+)(sb-p)⊏t        # Keep the first of each group that's not just inside a bracket
  t{is/˜↩𝕨⋄ie/˜↩𝕨⋄𝕨/𝕩}˜↩1¨⌾(sk⊸⊏)t≠sep      # Remove the rest
  im←(t=bR)∨t M vd⋈+´2↑kk                   # Identifier (or 𝕣) mask
  r←ir⌾(im⊸/)(vd⌊t)⊏charRole∾0              # Role
  t+↩(⊑bX)((⊢M⋈⟜5)×5+3⊸+⊸≤)t                # Case-insensitive special names
  t-↩vi(<+10×=)t                            # Shift . to bX and variables back one
  ⟨t,r,k,is,ie⟩
}
