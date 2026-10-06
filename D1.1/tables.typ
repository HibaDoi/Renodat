// Table helpers for D1.1, adapted from the "Initiatives comparison" thesis tables.
// All tables are generated from data/Initiatives comparison_14.xlsx (one sheet per module part).
// Sheet layout: col 0 = feature, then one ✔/✗ column per initiative, then Total, Percentage,
// BRP Relevance, BRP Reason and the CityGML / Energy ADE mapping (Namespace, Module, Class, Attribute, Type).
// Columns are located by their header name, so initiatives can be added without changing this file.
#import "@preview/spreet:0.2.0"

#let workbook = spreet.decode(read("data/Initiatives comparison_14.xlsx", encoding: none))

// Sheets grouped per module (modules 3, 11 and 12 are split over several sheets)
#let modules = (
  (no: 1, layer: 1, sheets: ("M1",)),
  (no: 2, layer: 1, sheets: ("M2",)),
  (no: 3, layer: 1, sheets: ("M3.1", "M3.2")),
  (no: 4, layer: 1, sheets: ("M4",)),
  (no: 5, layer: 1, sheets: ("M5",)),
  (no: 6, layer: 1, sheets: ("M6",)),
  (no: 7, layer: 1, sheets: ("M7",)),
  (no: 8, layer: 1, sheets: ("M8",)),
  (no: 9, layer: 1, sheets: ("M9",)),
  (no: 10, layer: 2, sheets: ("M10",)),
  (no: 11, layer: 2, sheets: ("M11.1", "M11.2", "M11.3", "M11.4", "M11.5", "M11.6")),
  (no: 12, layer: 2, sheets: ("M12.1", "M12.2")),
  (no: 13, layer: 3, sheets: ("M13",)),
)

// ---------- column layout (read from the header of the first sheet) ----------
#let cell-str(c) = if c == none { "" } else { str(c) }
#let head = workbook.at("M1").first().map(c => cell-str(c).trim())
#let col = (
  total: head.position(h => h == "Total"),
  pct: head.position(h => h == "Percentage"),
  rel: head.position(h => h == "BRP Relevance"),
  reason: head.position(h => h == "BRP Reason"),
  ns: head.position(h => h == "Namespace"),
)
#let n-cols = calc.max(head.len(), col.ns + 5)
#let initiatives = head.slice(1, col.total)
#let n-init = initiatives.len()

// Catalogue fields (columns after "Type"); missing columns read as empty, so older workbooks still compile
#let field(r, name) = {
  let i = head.position(h => h == name)
  if i == none or i >= r.len() { "" } else { r.at(i).trim() }
}

// ---------- helpers ----------
#let pad(row, n) = row + ("",) * calc.max(0, n - row.len())
#let sheet-rows(name) = workbook.at(name).map(r => pad(r.map(cell-str), n-cols).slice(0, n-cols))
#let header(name) = sheet-rows(name).first()
#let body(name) = sheet-rows(name).slice(1).filter(r => r.any(c => c != ""))

#let is-feature(r) = r.at(0) != "" and r.at(col.total) != ""
// Category rows have a name but no initiative scores (they may still carry a relevance or mapping)
#let is-category(r) = r.at(0) != "" and r.slice(1, col.pct + 1).all(c => c == "")
// The ✗ / N/A markers sit in the Namespace or Module column
#let mapping-status(r) = {
  let marks = r.slice(col.ns, col.ns + 2).map(str.trim)
  if marks.first() in ("core", "nrg") { "mapped" } else if "✗" in marks { "gap" } else { "n/a" }
}
#let is-relevant(r) = r.at(col.rel).trim() == "Yes"
#let features(sheets) = sheets.map(body).join().filter(is-feature)

// Five-way mapping class: the "Mapping status" column if filled in, otherwise derived from the ✗ markers
#let mapping-classes = ("Native", "Workaround", "Extension needed", "Out of scope", "N/A")
#let mapping-class(r) = {
  let s = field(r, "Mapping status")
  if s != "" { s } else {
    let st = mapping-status(r)
    if st == "mapped" { "Native" } else if st == "gap" { if is-relevant(r) { "Extension needed" } else { "Out of scope" } } else { "N/A" }
  }
}
// Priority: the "Priority" column if filled in; BRP-relevant rows without a decision are "Undecided"
#let priorities = ("Mandatory", "Optional", "Undecided", "Out of scope", "N/A")
#let priority(r) = {
  let p = field(r, "Priority")
  if p != "" { p } else if is-relevant(r) { "Undecided" } else if r.at(col.rel).trim() == "No" { "Out of scope" } else { "N/A" }
}
#let in-scope(r) = priority(r) in ("Mandatory", "Optional", "Undecided")

#let pct(v) = {
  let s = cell-str(v)
  if s.match(regex("^-?[0-9]*\.?[0-9]+$")) != none { str(calc.round(float(s) * 100)) + "%" } else { s }
}
#let module-title(m) = {
  let t = header(m.sheets.first()).at(0)
  t.replace(regex("^Module \d+:\s*"), "").replace(regex(",\s*Part [IVX]+.*$"), "")
}

#let rule-top = (top: 1.2pt, bottom: 0.8pt)
#let category-cell(r, idx, span) = table.cell(colspan: span, stroke: (top: if idx == 0 { 0.8pt } else { 0.1pt }))[*#r.at(0)*]

// Key of the initiative numbers used as column headers
#let initiative-key() = initiatives.enumerate(start: 1).map(((i, n)) => [*#i*: #n]).join([; ])

// ---------- Requirement table: which initiatives include which feature, and its BRP relevance ----------
#let feature-table(sheet, caption: none, label: none) = {
  // continuation rows only carry extra mapping attributes, so they are skipped here
  let rows = body(sheet).filter(r => r.at(0) != "")
  let last = rows.len() - 1
  let n = n-init + 5
  let fig = figure(
    {
      set text(size: 6.5pt)
      table(
        columns: (2.6fr,) + (0.2fr,) * n-init + (0.36fr, 0.36fr, 0.3fr, 1.5fr),
        align: (left,) + (center,) * (n-init + 3) + (left,),
        stroke: none,
        inset: (x: 1pt, y: 3.5pt),
        table.header(
          ..(([*Feature*],) + range(1, n-init + 1).map(i => [*#i*]) + ([*Total*], [*%*], [*BRP*], [*BRP reason*]))
            .map(c => table.cell(stroke: rule-top, c)),
        ),
        ..rows.enumerate().map(((idx, r)) => {
          let s = if idx == last { (bottom: 1.2pt) }
          if is-category(r) {
            (category-cell(r, idx, n),)
          } else {
            (
              (table.cell(stroke: s, r.at(0)),)
                + r.slice(1, n-init + 1).map(c => table.cell(stroke: s, if c == "✗" { "" } else { c }))
                + (r.at(col.total), pct(r.at(col.pct)), r.at(col.rel), r.at(col.reason)).map(c => table.cell(stroke: s, c))
            )
          }
        }).flatten(),
      )
    },
    caption: caption,
    kind: table,
  )
  if label != none { [#fig #label] } else { fig }
}

// ---------- Specification table: mapping of each feature onto CityGML Core / Energy ADE ----------
#let mapping-table(sheet, caption: none, label: none) = {
  let rows = body(sheet)
  let last = rows.len() - 1
  let fig = figure(
    {
      set text(size: 6pt)
      table(
        columns: (2.8fr, 0.4fr, 0.3fr, 1.2fr, 1.6fr, 2fr, 2fr),
        align: (left, center, center, left, left, left, left),
        stroke: none,
        table.header(
          ..([*Feature*], [*%*], [*BRP*], [*Module*], [*Class*], [*Attribute*], [*Type*])
            .map(c => table.cell(stroke: rule-top, c)),
        ),
        ..rows.enumerate().map(((idx, r)) => {
          let s = if idx == last { (bottom: 1.2pt) }
          let inset = (x: 1pt, top: if r.at(0) == "" { 0pt } else { 4pt }, bottom: 4pt)
          if is-category(r) {
            (category-cell(r, idx, 7),)
          } else {
            let (ns, mod, cls, attr, typ) = r.slice(col.ns, col.ns + 5)
            let mod = if ns.trim() == "core" { mod + "*" } else { mod }
            let c(body, span: 1) = table.cell(colspan: span, inset: inset, stroke: s, body)
            let tail = if cls != "" and attr == "" and typ == "" {
              (c(cls, span: 3),)
            } else if attr != "" and typ == "" {
              (c(cls), c(attr, span: 2))
            } else {
              (c(cls), c(attr), c(typ))
            }
            (c(r.at(0)), c(pct(r.at(col.pct))), c(r.at(col.rel)), c(mod)) + tail
          }
        }).flatten(),
      )
    },
    caption: caption,
    kind: table,
  )
  if label != none { [#fig #label] } else { fig }
}

// ---------- Overview: share of each module's features covered by each initiative ----------
#let coverage-overview(caption: none, label: none) = {
  let shade(p) = rgb(42, 122, 176).transparentize(100% - p * 70%)
  let fig = figure(
    {
      set text(size: 7pt)
      table(
        columns: (auto, 2.6fr) + (0.4fr,) * n-init,
        align: (center + horizon, left + horizon) + (center + horizon,) * n-init,
        stroke: 0.4pt + gray,
        inset: 4pt,
        table.header([*Layer*], [*Module*], ..range(1, n-init + 1).map(i => [*#i*])),
        ..modules.map(m => {
          let fs = features(m.sheets).filter(r => mapping-status(r) != "n/a")
          let first-in-layer = modules.find(x => x.layer == m.layer).no == m.no
          let layer-cell = if first-in-layer {
            (table.cell(rowspan: modules.filter(x => x.layer == m.layer).len())[
              #rotate(-90deg, reflow: true)[*L#m.layer*]
            ],)
          } else { () }
          layer-cell + ([#m.no. #module-title(m) #text(fill: gray)[(#fs.len())]],) + range(1, n-init + 1).map(i => {
            let p = if fs.len() == 0 { 0 } else { fs.filter(r => r.at(i) == "✔").len() / fs.len() }
            table.cell(fill: shade(p))[#calc.round(p * 100)]
          })
        }).flatten(),
      )
    },
    caption: caption,
    kind: table,
  )
  if label != none { [#fig #label] } else { fig }
}

// ---------- Summary of the BRP relevance and mapping status per module ----------
#let mapping-summary(caption: none, label: none) = {
  let fig = figure(
    {
      set text(size: 8pt)
      let rows = modules.map(m => {
        let fs = features(m.sheets)
        let count(st) = fs.filter(r => mapping-status(r) == st).len()
        (m.no, module-title(m), fs.len(), fs.filter(is-relevant).len(), count("mapped"), count("gap"), count("n/a"))
      })
      let tot = range(2, 7).map(k => rows.map(r => r.at(k)).sum())
      let foot = (top: 0.8pt, bottom: 1.2pt)
      table(
        columns: (auto, 1fr, auto, auto, auto, auto, auto),
        align: (right, left, right, right, right, right, right),
        stroke: none,
        table.header(
          ..([*\#*], [*Module*], [*Features*], [*BRP-relevant*], [*Mapped*], [*Not mapped*], [*N/A*])
            .map(c => table.cell(stroke: rule-top, c)),
        ),
        ..rows.map(r => r.map(v => [#v])).flatten(),
        table.cell(stroke: foot)[],
        table.cell(stroke: foot)[*Total*],
        ..tot.map(v => table.cell(stroke: foot)[*#v*]),
      )
    },
    caption: caption,
    kind: table,
  )
  if label != none { [#fig #label] } else { fig }
}

// ---------- List of features without a mapping (candidate extensions) ----------
#let gap-table(caption: none, label: none) = {
  let fig = figure(
    {
      set text(size: 8pt)
      let rows = modules.map(m => features(m.sheets).filter(r => mapping-status(r) == "gap").map(r => (m.no, r))).join()
      table(
        columns: (auto, 1.4fr, auto, auto, auto, 1fr),
        align: (right, left, right, right, center, left),
        stroke: none,
        table.header(
          ..([*Module*], [*Feature*], [*Initiatives*], [*%*], [*BRP*], [*BRP reason*])
            .map(c => table.cell(stroke: rule-top, c)),
        ),
        ..rows.enumerate().map(((idx, (no, r))) => {
          let s = if idx == rows.len() - 1 { (bottom: 1.2pt) }
          ([#no], r.at(0).replace("**", ""), r.at(col.total), pct(r.at(col.pct)), r.at(col.rel), r.at(col.reason))
            .map(c => table.cell(stroke: s, c))
        }).flatten(),
      )
    },
    caption: caption,
    kind: table,
  )
  if label != none { [#fig #label] } else { fig }
}

// =====================================================================================
// Requirements Catalogue (MSRP) helpers
// =====================================================================================

#let dash = text(fill: gray)[–]
#let show-val(v) = if v == "" { dash } else { v }
#let simple-table(columns: (), align: auto, header: (), rows: (), size: 8pt, footer: none) = {
  set text(size: size)
  set par(justify: false)
  let foot = (top: 0.8pt, bottom: 1.2pt)
  table(
    columns: columns,
    align: align,
    stroke: none,
    inset: (x: 3pt, y: 3.5pt),
    table.header(..header.map(c => table.cell(stroke: rule-top, c))),
    ..rows.enumerate().map(((i, r)) => r.map(c => table.cell(
      stroke: if footer == none and i == rows.len() - 1 { (bottom: 1.2pt) },
      c,
    ))).flatten(),
    ..if footer != none { footer.map(c => table.cell(stroke: foot, c)) } else { () },
  )
}
#let as-figure(body, caption, label) = {
  let fig = figure(body, caption: caption, kind: table)
  if label != none { [#fig #label] } else { fig }
}

// ---------- Catalogue table: the in-scope data elements of one sheet with their characteristics ----------
#let catalogue-table(sheet, caption: none, label: none) = {
  // keep category headings only when at least one in-scope element follows them
  let groups = ()
  for r in body(sheet).filter(r => r.at(0) != "") {
    if is-category(r) { groups.push((r.at(0), ())) } else if is-feature(r) and in-scope(r) {
      if groups.len() == 0 { groups.push(("", ())) }
      groups.last().at(1).push(r)
    }
  }
  let groups = groups.filter(g => g.at(1).len() > 0)
  let n = 11
  let rows = groups.map(((cat, rs)) => {
    let head-row = if cat != "" { (table.cell(colspan: n, stroke: (top: 0.1pt))[*#cat*],) } else { () }
    head-row + rs.map(r => {
      let p = priority(r)
      (
        field(r, "ID"), r.at(0).replace("**", ""),
        if p == "Undecided" { text(fill: gray, style: "italic")[undecided] } else { p },
        ..("Data type", "Unit / code list", "Spatial resolution", "Temporal dimension", "Sensitivity", "Owner / holder", "Expected source")
          .map(f => show-val(field(r, f))),
        mapping-class(r),
      ).map(c => table.cell(c))
    }).join()
  }).join()
  let fig = figure(
    {
      set text(size: 6pt)
      set par(justify: false)
      table(
        columns: (0.6fr, 2.3fr, 0.65fr, 0.65fr, 0.55fr, 0.6fr, 0.6fr, 0.65fr, 0.65fr, 0.65fr, 0.7fr),
        align: left,
        stroke: none,
        inset: (x: 1.5pt, y: 3pt),
        table.header(
          ..([*ID*], [*Data element*], [*Priority*], [*Data type*], [*Unit*], [*Spatial*], [*Temporal*],
            [*Sensitivity*], [*Owner*], [*Source*], [*Mapping*]).map(c => table.cell(stroke: rule-top, c)),
        ),
        ..if rows == none { () } else { rows },
        table.hline(stroke: 1.2pt),
      )
    },
    caption: caption,
    kind: table,
  )
  if label != none { [#fig #label] } else { fig }
}

// ---------- Priority per module ----------
#let priority-summary(caption: none, label: none) = {
  let rows = modules.map(m => {
    let fs = features(m.sheets)
    (m.no, module-title(m), ..priorities.map(p => fs.filter(r => priority(r) == p).len()), fs.len())
  })
  let tot = range(2, priorities.len() + 3).map(k => rows.map(r => r.at(k)).sum())
  as-figure(
    simple-table(
      columns: (auto, 1fr) + (auto,) * (priorities.len() + 1),
      align: (right, left) + (right,) * (priorities.len() + 1),
      header: ([*\#*], [*Module*], ..priorities.map(p => [*#p*]), [*Total*]),
      rows: rows.map(r => r.map(v => [#v])),
      footer: ([], [*Total*], ..tot.map(v => [*#v*])),
    ),
    caption, label,
  )
}

// ---------- BRP relevance × mapping class ----------
#let relevance-mapping-crosstab(caption: none, label: none) = {
  let fs = modules.map(m => features(m.sheets)).join()
  let rows = ("Yes", "No", "N/A").map(v => {
    let sub = fs.filter(r => r.at(col.rel).trim() == v)
    ([*#v*], ..mapping-classes.map(c => [#sub.filter(r => mapping-class(r) == c).len()]), [#sub.len()])
  })
  as-figure(
    simple-table(
      columns: (auto,) + (1fr,) * (mapping-classes.len() + 1),
      align: (left,) + (right,) * (mapping-classes.len() + 1),
      header: ([*BRP relevance*], ..mapping-classes.map(c => [*#c*]), [*Total*]),
      rows: rows,
      footer: ([*Total*], ..mapping-classes.map(c => [*#fs.filter(r => mapping-class(r) == c).len()*]), [*#fs.len()*]),
    ),
    caption, label,
  )
}

// ---------- Completeness of the catalogue fields (in-scope elements) ----------
#let catalogue-fields = if "Fields" in workbook {
  workbook.at("Fields").slice(1).map(r => pad(r.map(cell-str), 5).slice(0, 5)).filter(r => r.at(1) != "")
} else { () }

#let completeness-table(caption: none, label: none) = {
  let fs = modules.map(m => features(m.sheets)).join().filter(in-scope)
  let rows = catalogue-fields.filter(f => f.at(1) != "ID").map(f => {
    let filled = fs.filter(r => field(r, f.at(1)) != "").len()
    (f.at(0), f.at(1), [#filled / #fs.len()], [#calc.round(filled / calc.max(fs.len(), 1) * 100)%])
  })
  as-figure(
    simple-table(
      columns: (auto, 1fr, auto, auto),
      align: (left, left, right, right),
      header: ([*Group*], [*Field*], [*Filled in*], [*%*]),
      rows: rows,
    ),
    caption, label,
  )
}

// ---------- Sensitivity × owner (in-scope elements): go/no-go evidence, handed over to D1.4 ----------
#let sensitivity-classes = ("Public", "Restricted", "Personal data (GDPR)", "Commercially sensitive")
#let governance-matrix(caption: none, label: none) = {
  let fs = modules.map(m => features(m.sheets)).join().filter(in-scope)
  let sens(r) = { let s = field(r, "Sensitivity"); if s == "" { "Unassigned" } else { s } }
  let own(r) = { let o = field(r, "Owner / holder"); if o == "" { "Unassigned" } else { o } }
  let srows = sensitivity-classes + fs.map(sens).filter(s => s not in sensitivity-classes).dedup()
  let owners = fs.map(own).filter(o => o != "Unassigned").dedup().sorted() + ("Unassigned",)
  let rows = srows.map(s => {
    let sub = fs.filter(r => sens(r) == s)
    ([*#s*], ..owners.map(o => { let k = sub.filter(r => own(r) == o).len(); if k == 0 { dash } else { [#k] } }), [#sub.len()])
  })
  as-figure(
    simple-table(
      columns: (auto,) + (1fr,) * (owners.len() + 1),
      align: (left,) + (right,) * (owners.len() + 1),
      header: ([*Sensitivity \\ Owner*], ..owners.map(o => [*#o*]), [*Total*]),
      rows: rows,
      size: 7.5pt,
    ),
    caption, label,
  )
}

// ---------- Field definitions (Annex) ----------
#let fields-table(caption: none, label: none) = as-figure(
  simple-table(
    columns: (auto, auto, 2fr, 2fr, 1.4fr),
    align: left,
    header: ([*Group*], [*Field*], [*Definition*], [*Allowed values*], [*Pre-fill*]),
    rows: catalogue-fields,
    size: 7.5pt,
  ),
  caption, label,
)

// ---------- Simplified UML class view of the classes used by a module's in-scope elements ----------
#let gap-red = rgb("b03a2e")
#let class-box(stereo, pkg, name, lines, dashed: false) = block(
  width: 100%,
  breakable: false,
  stroke: if dashed { (paint: gap-red, thickness: 0.7pt, dash: "dashed") } else { 0.6pt + luma(60) },
  {
    block(width: 100%, inset: 4pt, fill: if dashed { rgb("fbeeee") } else { rgb("eaf2f8") }, below: 0pt)[
      #set align(center)
      #text(size: 5.5pt, fill: luma(90))[«#stereo» #pkg] \
      #text(size: 7pt, weight: "bold")[#name]
    ]
    line(length: 100%, stroke: if dashed { (paint: gap-red, dash: "dashed", thickness: 0.5pt) } else { 0.5pt + luma(60) })
    block(width: 100%, inset: 4pt, above: 0pt)[
      #set align(left)
      #set text(size: 6pt)
      #set par(justify: false, leading: 0.45em)
      #lines.join(linebreak())
    ]
  },
)

#let class-view(no, caption: none, label: none) = {
  let m = modules.find(x => x.no == no)
  let classes = (:) // "ns|package|class" -> attribute lines
  let gaps = ()
  for sheet in m.sheets {
    let current = none
    for r in body(sheet) {
      if is-feature(r) { current = r } else if r.at(0) != "" { current = none }
      if current == none or not in-scope(current) { continue }
      let (ns, pkg, cls, attr, typ) = r.slice(col.ns, col.ns + 5).map(str.trim)
      if ns in ("core", "nrg") and cls != "" {
        let key = ns + "|" + pkg + "|" + cls
        let entry = if attr == "" or attr == "Multiple" { "(several attributes)" } else if attr.starts-with("N/A") {
          attr.replace("N/A ", "")
        } else if typ == "" or typ == "Multiple" { "+ " + attr } else { "+ " + attr + " : " + typ }
        classes.insert(key, (classes.at(key, default: ()) + (entry,)).dedup())
      } else if r == current and mapping-class(r) == "Extension needed" {
        gaps.push(field(r, "ID") + " " + r.at(0).replace("**", ""))
      }
    }
  }
  let boxes = classes.pairs().sorted(key: p => p.at(0)).map(((key, lines)) => {
    let (ns, pkg, cls) = key.split("|")
    class-box(if ns == "core" { "CityGML" } else { "Energy ADE" }, pkg, cls, lines)
  })
  if gaps.len() > 0 { boxes.push(class-box("proposed", "extension", "Not yet modelled", gaps, dashed: true)) }
  let fig = figure(grid(columns: (1fr, 1fr, 1fr), gutter: 6pt, ..boxes), caption: caption, kind: image)
  if label != none { [#fig #label] } else { fig }
}
