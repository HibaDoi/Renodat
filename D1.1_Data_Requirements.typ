// RenoDat — Deliverable 1.1
#let deliverable = (
  id: "D1.1",
  title: "Data Requirements and Specifications for the Renovation Passport",
  wp: "WP1",
  due: "M24",
  status: "Draft",
  version: "0.1",
  authors: ("TBD",),
  date: datetime.today(),
)

#set document(title: deliverable.id + " – " + deliverable.title, author: deliverable.authors)
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  header: context if counter(page).get().first() > 1 [
    #set text(9pt, fill: gray)
    RenoDat — #deliverable.id #h(1fr) #deliverable.title
  ],
)
#set text(font: "Libertinus Serif", size: 11pt, lang: "en")
#set par(justify: true)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => { pagebreak(weak: true); it; v(0.4em) }

// ---------- Title page ----------
#page(numbering: none, header: none)[
  #v(4cm)
  #text(14pt, fill: gray)[RenoDat Project]
  #v(0.5cm)
  #text(28pt, weight: "bold")[#deliverable.id]
  #v(0.2cm)
  #text(20pt)[#deliverable.title]
  #v(2cm)
  #table(
    columns: (auto, 1fr),
    stroke: none,
    inset: 6pt,
    [*Work package*], deliverable.wp,
    [*Due date*], deliverable.due,
    [*Status*], deliverable.status,
    [*Version*], deliverable.version,
    [*Authors*], deliverable.authors.join(", "),
    [*Date*], deliverable.date.display("[day] [month repr:long] [year]"),
  )
]

// ---------- Document history ----------
#heading(numbering: none, outlined: false)[Document History]
#table(
  columns: (auto, auto, 1fr, 2fr),
  [*Version*], [*Date*], [*Author*], [*Changes*],
  [0.1], [], [], [Initial structure],
)

#outline(depth: 2)

#heading(numbering: none)[Executive Summary]
// TODO: write once chapters 2, 3 and 6 are filled in.

// ---------- Tables and figures generated from D1.1/data/Initiatives comparison_14.xlsx ----------
#import "D1.1/tables.typ": *
#show figure.caption: set text(size: 9pt)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: table): set block(breakable: true)
#let todo(body) = block(width: 100%, inset: 6pt, fill: rgb("fff4d6"), stroke: (left: 2pt + rgb("e0a800")))[#text(size: 9pt)[*TODO:* #body]]

= Introduction <sec:intro>

== Purpose and Scope
This deliverable defines the data requirements and specifications for the Dutch Renovation Passport (Task 1.1 of WP1). Its main outcome is the *Renovation Passport Data Requirements Catalogue* (@sec:catalogue): the Minimum Set of Required Parameters (MSRP), in which every data element is classified as mandatory or optional and characterised by its data type, accuracy, spatial resolution and temporal dimension. For each element, the catalogue also records a preliminary sensitivity class, its expected source and its owner, which are taken up in the analysis of data sources (D1.2) and data governance (D1.4).

#todo[Define the scope: Renovation Passport (BRP) versus Digital Building Logbook (DBL) and Energy Performance Certificate (EPC); building types covered (e.g. private homes, VvEs).]

== Relation to Other Deliverables
- *D1.2* verifies the expected sources listed in the catalogue and assesses their quality, accessibility and conformity.
- *D1.3* designs the integration of public and private data on the basis of the catalogue and its Energy ADE mapping.
- *D1.4* refines the preliminary sensitivity and ownership assessment into a data governance framework.
- *WP2* implements the catalogue in the Renovation Passport prototype.

== Reference Data Model
The data specification uses CityGML together with the Energy Application Domain Extension, version 3.0 (beta 8), as reference data model (@sec:specification).

= Policy and Standards Framework <sec:policy>
The proposal sets as the starting point for Task 1.1 the Energy Performance of Buildings Directive IV and the five overarching EPB standards (ISO 52000-1, ISO 52003-1, ISO 52010-1, ISO 52016-1 and ISO 52018-1), together with the specific Dutch requirements and legislative situation. These are the _top-down_ sources of requirements, complementing the _bottom-up_ comparison of existing initiatives in @sec:comparison.

== EPBD IV and the Renovation Passport
#todo[Summarise the EPBD IV provisions on the renovation passport and the EPC, and list the data they require. Each requirement found here should appear as *Justification = EPBD IV* in the catalogue.]

== EPB Standards (ISO 52000 Series)
#todo[Summarise the input data needed by the overarching EPB standards and their Dutch implementation for the energy label calculation. Data needed for the calculation should appear as *Justification = ISO 52000 series / NTA 8800*.]

== Dutch Context
#todo[Dutch legislation and the status of the national renovation passport; relevant national registers.]

== EU Digital Building Logbook Framework
#todo[Relate the catalogue to the EU DBL semantic data model (dictionary and ontology), e.g. as a cross-walk table in an annex.]

= Use Cases and Stakeholders <sec:usecases>
The project summary names example applications that the data infrastructure must support. They are used as the initial use cases of the catalogue (column *Use cases*).

#figure(
  simple-table(
    columns: (auto, 1.4fr, 2fr),
    align: left,
    header: ([*ID*], [*Use case*], [*Description*]),
    rows: (
      ([UC1], [Energy performance assessment], [Assessing the energy performance of a building.]),
      ([UC2], [Renovation advice], [Giving renovation advice to private homeowners and associations of owners (VvEs).]),
      ([UC3], [Renovation and maintenance log], [Recording the history of renovations and maintenance.]),
      ([UC4], [National monitoring], [Deriving progress indicators for the building stock at national level.]),
    ),
  ),
  caption: [Initial use cases of the Renovation Passport (draft).],
  kind: table,
) <tab:usecases>

#todo[Validate and detail the use cases with the Task 1.1 partners (Kadaster, RVO, The Green Village, VRO) and WP2/WP3; add actors and the data each use case needs.]

= Methodology <sec:method>
The catalogue is built in five steps:
+ *Top-down requirements* from EPBD IV, the EPB standards and the Dutch context (@sec:policy).
+ *Bottom-up comparison* of #n-init existing BRP and DBL initiatives, whose features are grouped into 13 modules in three layers (@sec:comparison).
+ *Prioritisation.* Each feature is first screened for BRP relevance (Yes/No). Relevant elements are then classified as _Mandatory_ if they are required by EPBD IV, needed as input for the Dutch energy performance calculation, or needed for a core use case; otherwise they are _Optional_. Non-relevant features are _Out of scope_ (DBL only).
+ *Characterisation* of every in-scope element by data type, unit or code list, accuracy, spatial resolution and temporal dimension, and a preliminary *governance assessment*: sensitivity, owner/holder, expected source and acquisition method.
+ *Specification* of every element in CityGML / Energy ADE 3.0, classified as _Native_, _Workaround_ (represented through a generic mechanism such as an indicator or an external reference) or _Extension needed_.

The fields of the catalogue are defined in @tab:fields (Annex C). Data type, spatial resolution, temporal dimension and mapping status were pre-filled from the Energy ADE mapping and still need to be verified.

#todo[Describe the stakeholder validation of the catalogue (workshops, interviews).]

= Comparison of Existing Initiatives <sec:comparison>
Every feature found in at least one of the #n-init initiatives is recorded and grouped into 13 modules, organised in three layers: a _repository layer_ (input & inventory, modules 1–9), an _assessment layer_ (performance & calculation, modules 10–12) and a _functional layer_ (decision support & services, module 13). @tab:coverage-overview summarises the coverage per module and initiative; the full tables per module are given in Annex A. The initiatives are numbered as follows: #initiative-key().

#coverage-overview(
  caption: [Share (%) of the features of each module included per initiative. The number of features per module is given in brackets. Initiative key: #initiative-key().],
  label: <tab:coverage-overview>,
)

= Renovation Passport Data Requirements Catalogue <sec:catalogue>

== Overview
@tab:priority gives the priority of the data elements per module. _Undecided_ marks BRP-relevant elements whose priority (mandatory or optional) has not yet been set. @tab:completeness shows how far the catalogue fields have been filled in for the in-scope elements.

#priority-summary(
  caption: [Priority of the data elements per module.],
  label: <tab:priority>,
)

#completeness-table(
  caption: [Completeness of the catalogue fields for the in-scope (mandatory, optional or undecided) data elements.],
  label: <tab:completeness>,
)

== Sensitivity and Ownership
@tab:governance crosses the preliminary sensitivity class of the in-scope elements with their owner or holder. It identifies which personal or commercially sensitive data the Renovation Passport needs and from whom, and is the starting point for the governance analysis in D1.4.

#governance-matrix(
  caption: [Preliminary sensitivity class versus owner/holder of the in-scope data elements (number of elements).],
  label: <tab:governance>,
)

== Catalogue per Module
The tables below list the in-scope data elements; out-of-scope features are listed in Annex A. A dash (–) marks a field that has not yet been filled in.

== Layer 1: Repository (Input & Inventory)

=== Module 1: Identification & administrative details
#catalogue-table("M1", caption: [Catalogue entries of module 1: Identification & administrative details.], label: <tab:cat-m1>)

=== Module 2: General building characteristics
#catalogue-table("M2", caption: [Catalogue entries of module 2: General building characteristics.], label: <tab:cat-m2>)

=== Module 3: Envelope, construction & materials
#catalogue-table("M3.1", caption: [Catalogue entries of module 3: Envelope, construction & materials, Part I.], label: <tab:cat-m3.1>)
#catalogue-table("M3.2", caption: [Catalogue entries of module 3: Envelope, construction & materials, Part II.], label: <tab:cat-m3.2>)

=== Module 4: Technical systems
#catalogue-table("M4", caption: [Catalogue entries of module 4: Technical systems.], label: <tab:cat-m4>)

=== Module 5: Attachable documents (file repository)
#catalogue-table("M5", caption: [Catalogue entries of module 5: Attachable documents (file repository).], label: <tab:cat-m5>)

=== Module 6: Dimensions
#catalogue-table("M6", caption: [Catalogue entries of module 6: Dimensions.], label: <tab:cat-m6>)

=== Module 7: Operation and use
#catalogue-table("M7", caption: [Catalogue entries of module 7: Operation and use.], label: <tab:cat-m7>)

=== Module 8: Legal and finance
#catalogue-table("M8", caption: [Catalogue entries of module 8: Legal and finance.], label: <tab:cat-m8>)

=== Module 9: Ancillary data & (environmental) context
#catalogue-table("M9", caption: [Catalogue entries of module 9: Ancillary data & (environmental) context.], label: <tab:cat-m9>)

== Layer 2: Assessment (Performance & Calculation)

=== Module 10: Energy performance
#catalogue-table("M10", caption: [Catalogue entries of module 10: Energy performance.], label: <tab:cat-m10>)

=== Module 11: Indoor environmental quality (IEQ)
#catalogue-table("M11.1", caption: [Catalogue entries of module 11: Indoor environmental quality (IEQ), Part I: Thermal comfort.], label: <tab:cat-m11.1>)
#catalogue-table("M11.2", caption: [Catalogue entries of module 11: Indoor environmental quality (IEQ), Part II: Indoor air quality.], label: <tab:cat-m11.2>)
#catalogue-table("M11.3", caption: [Catalogue entries of module 11: Indoor environmental quality (IEQ), Part III: Visual comfort / lighting.], label: <tab:cat-m11.3>)
#catalogue-table("M11.4", caption: [Catalogue entries of module 11: Indoor environmental quality (IEQ), Part IV: Health & well-being indicators.], label: <tab:cat-m11.4>)
#catalogue-table("M11.5", caption: [Catalogue entries of module 11: Indoor environmental quality (IEQ), Part V: Acoustic comfort.], label: <tab:cat-m11.5>)
#catalogue-table("M11.6", caption: [Catalogue entries of module 11: Indoor environmental quality (IEQ), Part VI: Assessment method characteristics.], label: <tab:cat-m11.6>)

=== Module 12: Smart Readiness Indicator (SRI)
#catalogue-table("M12.1", caption: [Catalogue entries of module 12: Smart Readiness Indicator (SRI), Part I.], label: <tab:cat-m12.1>)
#catalogue-table("M12.2", caption: [Catalogue entries of module 12: Smart Readiness Indicator (SRI), Part II.], label: <tab:cat-m12.2>)

== Layer 3: Functional (Decision Support & Services)

=== Module 13: Renovation advice
#catalogue-table("M13", caption: [Catalogue entries of module 13: Renovation advice.], label: <tab:cat-m13>)

= Data Specification in Energy ADE 3.0 <sec:specification>

== Mapping Overview
Each feature is mapped onto CityGML Core and/or the Energy ADE 3.0. @tab:mapping-summary summarises the result per module and @tab:relevance-mapping crosses it with the BRP relevance. Of the BRP-relevant features, those classified as _Extension needed_ cannot be represented yet and are candidate extensions of the Energy ADE (@tab:gaps). Most of them belong to module 13 (renovation advice): the renovation roadmap, which is the core of a renovation passport, is the least supported part of the data model.

#mapping-summary(
  caption: [BRP relevance and mapping status per module. _BRP-relevant_: features marked as relevant for a building renovation passport; _Mapped_: representable in CityGML Core or the Energy ADE; _Not mapped_: no suitable element; _N/A_: not a feature in itself (e.g. only a general recommendation in an initiative).],
  label: <tab:mapping-summary>,
)

#relevance-mapping-crosstab(
  caption: [BRP relevance versus mapping class. _Native_: dedicated class/attribute; _Workaround_: represented through a generic mechanism; _Extension needed_: relevant but not representable; _Out of scope_: not relevant and not representable.],
  label: <tab:relevance-mapping>,
)

== Simplified Class Views per Module
For each module, the figures below show only the CityGML and Energy ADE classes, and the attributes of these classes, that represent the in-scope data elements. Elements that cannot be represented yet are listed in a dashed box. The complete attribute-level mapping is given in Annex B.

#todo[Add an overview UML diagram of the Energy ADE 3.0 (beta 8) showing the associations between the classes used.]

== Layer 1: Repository (Input & Inventory)

=== Module 1: Identification & administrative details
#class-view(1, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 1: Identification & administrative details. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m1.], label: <fig:uml-m1>)

Module 1 is already almost fully covered by the data model as is, except for the address details of the building owner, if different from the building's address. A DBL/BRP describes the physical characteristics of a building; owner details not linked to the building itself raise privacy concerns, which likely explains why only five of the fourteen initiatives include it. The owner identity, similar to login credentials, should be maintained in an external administrative system and linked via the building's stable unique identifier. Login/system credentials should not be stored in the data model either; these are an implementation concern and should be handled in a separate authentication layer.

Regarding the building identification, ExternalReferences could also be used if there is a desire to store both a national and an INSPIRE cadastral ID simultaneously. Whether both are required simultaneously in a (Dutch) BRP is up to the ministry. What matters most is that either is a unique identifier which is stable for the whole lifecycle of a building.

=== Module 2: General building characteristics
#class-view(2, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 2: General building characteristics. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m2.], label: <fig:uml-m2>)

Module 2 is fully covered by the data model as is. The number of (disabled) parking spaces, while a little more complex, can be linked to any CityObject, e.g. a building, through the CityObjectRelation from the Core module.

Similarly, the number of dwelling or total units can simply be classified by function and counted if building-unit objects are explicitly modelled. However, if available, a better proxy for simulation is the qualified floor area split into residential and non-residential, rather than a raw unit count.

The overall building conservation status and other such descriptive, and rather subjective, attributes are best treated as a derived description, e.g. from an inspection, rather than a direct input attribute. Such an attribute could be useful for prioritising renovation works, but this level of granularity and subjectivity cannot be used as input for objective analysis and simulation.

Lastly, the 'expected building lifetime' feature is denoted as representable using the terminationDate attribute, which, if set to a future date, could imply an expected end of life. Whether this is sufficient remains open, as no concrete use case has been established so far.

=== Module 3: Envelope, construction & materials
#class-view(3, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 3: Envelope, construction & materials. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m3.1, @tab:map-m3.2.], label: <fig:uml-m3>)

The initiatives that include a high-level type of construction and facade type have added this as a dedicated attribute, yet no dedicated attribute is needed. This can be modelled by attaching one representative LayeredConstruction to the building directly, with a single-layer proxy, e.g. concrete. This is consistent with how walls reference constructions, applied at the building level. Note that 'facade' in the data model means all exterior vertical surfaces touching outside air.

Identified (post-catastrophic) damages cannot be modelled. Similar to the 'overall building conservation status' feature of module 2, their use in renovation passports remains limited mainly to prioritising damaged elements, which offers an opportunity not only to repair but to renovate.

There is currently no way to directly map the airtightness class of openings; however, the infiltration rate on AbstractZones exists and is a more useful simulation parameter. As with the expected building lifetime, no clear use case or requirement has been found.

The quantity of identical openings is not included as a separate 'count' field. When the individual openings are not modelled geometrically, the total surface area and opaque area values can be stored and used as a proxy. Counting identical openings of a single type says little without details such as the U-value or size of the opening.

A formal (quality) description of the state of openings is not possible. This could be an interesting addition, for example through an extra free-text field attachable to any CityObject, particularly useful in inspection workflows.

The features missing from the data model in @tab:map-m3.2 are mainly used in Life Cycle Assessment and are of interest after demolition, making them primarily relevant for DBLs rather than BRPs. Combined with their low coverage in the existing initiatives (7–21%), these features are deemed not relevant to include. If they are needed, the most suitable place would be a few extra attributes in the material library.

=== Module 4: Technical systems
#class-view(4, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 4: Technical systems. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m4.], label: <fig:uml-m4>)

The data model has no served area/served units attribute; instead, a system can be linked through CityObjectRelations to any building, zone or unit to denote which areas it serves, e.g. a heating system linked only to the living-room zone.

There is currently no dedicated attribute to indicate the control/automation class per system. In theory, this could be modelled with the generic indicator attribute, but it would then not be a formal indicator with a fixed format. A dedicated attribute should be added.

Regarding 'maintenance record present': the data model can describe interventions, which include maintenance. If this part of the data model is filled in, a maintenance record is present. The last maintenance/inspection date can be stored and derived in the same way, with multiple dates forming a maintenance history.

=== Module 5: Attachable documents (file repository)
#class-view(5, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 5: Attachable documents (file repository). Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m5.], label: <fig:uml-m5>)

=== Module 6: Dimensions
#class-view(6, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 6: Dimensions. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m6.], label: <fig:uml-m6>)

=== Module 7: Operation and use
#class-view(7, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 7: Operation and use. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m7.], label: <fig:uml-m7>)

For the four 'intensity' attributes, the preference is to store the actual measured values of resource use or production; an intensity level at this granularity is a simplified proxy that is hard to use in practice. Nevertheless, the intensity can be expressed on such a scale with the indicator attribute.

The 'room for auditor advice' and 'owner satisfaction rating' features concern perception and move into the consultancy domain. While interesting, they are quite subjective.

=== Module 8: Legal and finance
#class-view(8, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 8: Legal and finance. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m8.], label: <fig:uml-m8>)

=== Module 9: Ancillary data & (environmental) context
#class-view(9, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 9: Ancillary data & (environmental) context. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m9.], label: <fig:uml-m9>)

Cadastral parcel details can be linked via ExternalReferences. If both a national and an INSPIRE cadastral ID need to be stored simultaneously, two ExternalReference entries can be used. Any feature in the Energy ADE can have any number of ExternalReferences, for example to images.

== Layer 2: Assessment (Performance & Calculation)

=== Module 10: Energy performance
#class-view(10, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 10: Energy performance. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m10.], label: <fig:uml-m10>)

=== Module 11: Indoor environmental quality (IEQ)
#class-view(11, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 11: Indoor environmental quality (IEQ). Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m11.1, @tab:map-m11.2, @tab:map-m11.3, @tab:map-m11.4, @tab:map-m11.5, @tab:map-m11.6.], label: <fig:uml-m11>)

=== Module 12: Smart Readiness Indicator (SRI)
#class-view(12, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 12: Smart Readiness Indicator (SRI). Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m12.1, @tab:map-m12.2.], label: <fig:uml-m12>)

== Layer 3: Functional (Decision Support & Services)

=== Module 13: Renovation advice
#class-view(13, caption: [Energy ADE 3.0 / CityGML classes used by the in-scope data elements of module 13: Renovation advice. Dashed box: elements that cannot be represented yet (proposed extension). Full mapping: @tab:map-m13.], label: <fig:uml-m13>)

== Gaps and Candidate Extensions
#gap-table(
  caption: [Features for which no suitable element exists in CityGML Core or the Energy ADE, with the number and share of initiatives that include them.],
  label: <tab:gaps>,
)

= Conclusions and Hand-over <sec:conclusions>
#todo[Summarise the MSRP, the open decisions (undecided priorities, missing characteristics) and the hand-over to D1.2 (sources), D1.3 (integration), D1.4 (governance) and WP2 (prototype).]

#heading(numbering: none)[References]
// #bibliography("refs.bib")

// ---------- Annexes ----------
#counter(heading).update(0)
#set heading(numbering: (..n) => "Annex " + numbering("A.1", ..n))

= Initiative Comparison Tables <annex:comparison>
For each feature, the tables record which initiatives include it (✔), how many of them do so (*Total* and *%*), and whether the feature is considered relevant for a building renovation passport (*BRP*), with the reason. Initiative key: #initiative-key().

== Layer 1: Repository (Input & Inventory)

=== Module 1: Identification & administrative details
#feature-table("M1", caption: [Features of module 1: Identification & administrative details, per initiative.], label: <tab:req-m1>)

=== Module 2: General building characteristics
#feature-table("M2", caption: [Features of module 2: General building characteristics, per initiative.], label: <tab:req-m2>)

=== Module 3: Envelope, construction & materials
#feature-table("M3.1", caption: [Features of module 3: Envelope, construction & materials, Part I, per initiative.], label: <tab:req-m3.1>)
#feature-table("M3.2", caption: [Features of module 3: Envelope, construction & materials, Part II, per initiative.], label: <tab:req-m3.2>)

=== Module 4: Technical systems
#feature-table("M4", caption: [Features of module 4: Technical systems, per initiative.], label: <tab:req-m4>)

=== Module 5: Attachable documents (file repository)
#feature-table("M5", caption: [Features of module 5: Attachable documents (file repository), per initiative.], label: <tab:req-m5>)

=== Module 6: Dimensions
#feature-table("M6", caption: [Features of module 6: Dimensions, per initiative.], label: <tab:req-m6>)

=== Module 7: Operation and use
#feature-table("M7", caption: [Features of module 7: Operation and use, per initiative.], label: <tab:req-m7>)

=== Module 8: Legal and finance
#feature-table("M8", caption: [Features of module 8: Legal and finance, per initiative.], label: <tab:req-m8>)

=== Module 9: Ancillary data & (environmental) context
#feature-table("M9", caption: [Features of module 9: Ancillary data & (environmental) context, per initiative.], label: <tab:req-m9>)

== Layer 2: Assessment (Performance & Calculation)

=== Module 10: Energy performance
#feature-table("M10", caption: [Features of module 10: Energy performance, per initiative.], label: <tab:req-m10>)

=== Module 11: Indoor environmental quality (IEQ)
#feature-table("M11.1", caption: [Features of module 11: Indoor environmental quality (IEQ), Part I: Thermal comfort, per initiative.], label: <tab:req-m11.1>)
#feature-table("M11.2", caption: [Features of module 11: Indoor environmental quality (IEQ), Part II: Indoor air quality, per initiative.], label: <tab:req-m11.2>)
#feature-table("M11.3", caption: [Features of module 11: Indoor environmental quality (IEQ), Part III: Visual comfort / lighting, per initiative.], label: <tab:req-m11.3>)
#feature-table("M11.4", caption: [Features of module 11: Indoor environmental quality (IEQ), Part IV: Health & well-being indicators, per initiative.], label: <tab:req-m11.4>)
#feature-table("M11.5", caption: [Features of module 11: Indoor environmental quality (IEQ), Part V: Acoustic comfort, per initiative.], label: <tab:req-m11.5>)
#feature-table("M11.6", caption: [Features of module 11: Indoor environmental quality (IEQ), Part VI: Assessment method characteristics, per initiative.], label: <tab:req-m11.6>)

=== Module 12: Smart Readiness Indicator (SRI)
#feature-table("M12.1", caption: [Features of module 12: Smart Readiness Indicator (SRI), Part I, per initiative.], label: <tab:req-m12.1>)
#feature-table("M12.2", caption: [Features of module 12: Smart Readiness Indicator (SRI), Part II, per initiative.], label: <tab:req-m12.2>)

== Layer 3: Functional (Decision Support & Services)

=== Module 13: Renovation advice
#feature-table("M13", caption: [Features of module 13: Renovation advice, per initiative.], label: <tab:req-m13>)

= Attribute-Level Mapping Tables <annex:mapping>
In the mapping tables, the *Module*, *Class*, *Attribute* and *Type* columns give the target element of the data model. An asterisk (\*) after the module denotes a CityGML Core attribute; no asterisk denotes an Energy ADE attribute.

== Layer 1: Repository (Input & Inventory)

=== Module 1: Identification & administrative details
#mapping-table("M1", caption: [Mapping of module 1 onto CityGML Core and/or the Energy ADE. \*\*Besides the Energy ADE attributes, 3DCityDB instances have additional administrative database fields for all CityObjects.], label: <tab:map-m1>)

=== Module 2: General building characteristics
#mapping-table("M2", caption: [Mapping of module 2 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m2>)

=== Module 3: Envelope, construction & materials
#mapping-table("M3.1", caption: [Mapping of module 3, Part I onto CityGML Core and/or the Energy ADE.], label: <tab:map-m3.1>)
#mapping-table("M3.2", caption: [Mapping of module 3, Part II onto CityGML Core and/or the Energy ADE.], label: <tab:map-m3.2>)

=== Module 4: Technical systems
#mapping-table("M4", caption: [Mapping of module 4 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m4>)

=== Module 5: Attachable documents (file repository)
#mapping-table("M5", caption: [Mapping of module 5 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m5>)

=== Module 6: Dimensions
#mapping-table("M6", caption: [Mapping of module 6 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m6>)

=== Module 7: Operation and use
#mapping-table("M7", caption: [Mapping of module 7 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m7>)

=== Module 8: Legal and finance
#mapping-table("M8", caption: [Mapping of module 8 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m8>)

=== Module 9: Ancillary data & (environmental) context
#mapping-table("M9", caption: [Mapping of module 9 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m9>)

== Layer 2: Assessment (Performance & Calculation)

=== Module 10: Energy performance
#mapping-table("M10", caption: [Mapping of module 10 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m10>)

=== Module 11: Indoor environmental quality (IEQ)
#mapping-table("M11.1", caption: [Mapping of module 11, Part I: Thermal comfort onto CityGML Core and/or the Energy ADE.], label: <tab:map-m11.1>)
#mapping-table("M11.2", caption: [Mapping of module 11, Part II: Indoor air quality onto CityGML Core and/or the Energy ADE.], label: <tab:map-m11.2>)
#mapping-table("M11.3", caption: [Mapping of module 11, Part III: Visual comfort / lighting onto CityGML Core and/or the Energy ADE.], label: <tab:map-m11.3>)
#mapping-table("M11.4", caption: [Mapping of module 11, Part IV: Health & well-being indicators onto CityGML Core and/or the Energy ADE.], label: <tab:map-m11.4>)
#mapping-table("M11.5", caption: [Mapping of module 11, Part V: Acoustic comfort onto CityGML Core and/or the Energy ADE.], label: <tab:map-m11.5>)
#mapping-table("M11.6", caption: [Mapping of module 11, Part VI: Assessment method characteristics onto CityGML Core and/or the Energy ADE.], label: <tab:map-m11.6>)

=== Module 12: Smart Readiness Indicator (SRI)
#mapping-table("M12.1", caption: [Mapping of module 12, Part I onto CityGML Core and/or the Energy ADE.], label: <tab:map-m12.1>)
#mapping-table("M12.2", caption: [Mapping of module 12, Part II onto CityGML Core and/or the Energy ADE.], label: <tab:map-m12.2>)

== Layer 3: Functional (Decision Support & Services)

=== Module 13: Renovation advice
#mapping-table("M13", caption: [Mapping of module 13 onto CityGML Core and/or the Energy ADE.], label: <tab:map-m13>)

= Catalogue Field Definitions <annex:fields>
#fields-table(
  caption: [Fields of the Renovation Passport Data Requirements Catalogue.],
  label: <tab:fields>,
)
