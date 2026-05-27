apex-test-flow/
├── tests/
│   ├── prihlaseni.robot
│   ├── navigace.robot
│   ├── interactive_grid.robot
│   └── formulare_prihlasky.robot
├── resources/
│   ├── prihlaseni_klicova_slova.resource
│   ├── grid_klicova_slova.resource
│   ├── formular_klicova_slova.resource
│   ├── databaze_klicova_slova.resource
│   └── spolecne.resource
├── variables/
│   ├── uzivatele.example.yaml
│   ├── stranky.yaml
│   ├── aplikace.yaml
├── db/
│   ├── setup/
│   │   ├── kurz_pred_deadlinem.sql
│   │   ├── kurz_plny.sql
│   │   └── kurz_po_deadlinu.sql
│   ├── teardown/
│   │   └── uklid_testovacich_dat.sql
│   └── README.md
├── results/
│   ├── parsed_results.json
│   └── .gitkeep
├── reporting/
│   ├── parse_results.py
│   └──  send_results_to_apex.py
└── docs/
│    ├── analysis.md
│    ├── architecture.md
│    ├── selectors.md
│    ├── how_to_write_tests.md
│    ├── system_overview.md
│    ├── typical_workflow.md
│    ├── worklog.md
│    └── adr/
│        └── 0001-volba-testovaciho-stacku.md
└── README.md
