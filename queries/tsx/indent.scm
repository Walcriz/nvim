;; inherits: tsx
;; extends

; Indent children of JSX elements
((jsx_opening_element) @indent.begin)
((jsx_self_closing_element) @indent.end)

; Prevent weird extra indentation inside props
((jsx_attribute
  (property_identifier) @indent.ignore))
