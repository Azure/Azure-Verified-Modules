---
title: Process Overview
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---
{{< toc >}}

This page will provide an overview of the contribution process for AVM modules.

## New Module Proposal & Creation

{{< mermaid class="text-center" >}}
flowchart TD
    A[Module Proposal Created] -->|GitHub Issue/Form Submitted| B{AVM Team Triage}
    B -->|Module Approved for Creation| C[[Module Owner/s Identified]]
    B -->|Module Rejected| D(Issue closed with reasoning)
    C -->E[[Repo/Directory Created Following Contribution Guide]]
    E -->F(Module Developed by Owner/s & their Contributors)
    F -->G[[Self & AVM Module Tests]]
    G -->|Tests Fail|I(Modules/Tests Fixed To Make Them Pass)
    I -->F
    G -->|Tests Pass|J[[Pre-Release v0.1.0 created]]
    J -->K[[Publish to IaC Registry]]
    K -->L(Take Feedback from v0.1.0 Consumers)
    L -->M{Anything to be resolved before v1.0.0 release?}
    M -->|Yes|FixPreV1(Module Feedback Incorporated by Owner/s & their Contributors)
    FixPreV1 -->PreV1Tests[[Self & AVM Module Tests]]
    PreV1Tests -->|Tests Fail|PreV1TestsFix(Modules/Tests Fixed To Make Them Pass)
    PreV1TestsFix -->N
    M -->|No|N[[Publish v1.0.0 Release]]
    N -->O[[Publish to IaC Registry]]
    O -->P[[Module BAU Starts]]
{{< /mermaid >}}
