apex-test-flow/
├── README.md
├── requirements.txt               
├── .env.example
├── tests/
│   ├── prihlaseni.robot
│   ├── navigace.robot
│   ├── interactive_grid.robot
│   ├── menu.robot
│   └── formulare_prihlasky.robot
├── resources/
│   ├── apex_klicova_slova.resource
│   ├── prihlaseni_klicova_slova.resource
│   ├── grid_klicova_slova.resource
│   ├── menu_klicova_slova.resource
│   ├── formular_klicova_slova.resource
│   ├── databaze_klicova_slova.resource
│   └── spolecne.resource
├── variables/
│   ├── uzivatele.example.yaml
│   ├── stranky.yaml
│   ├── aplikace.yaml
│   └── test_data.yaml
├── db/
│   ├── setup/
│   │        
│   ├── teardown/
│   │  
│   └── README.md
├── results/
│   └── .gitkeep
├── reporting/
│   ├── parse_results.py
│   ├── send_results_to_apex.py
│   └── result_schema.md
└── docs/
    ├── analysis.md
    ├── architecture.md
    ├── selectors.md
    ├── how_to_write_tests.md
    ├── system_overview.md
    ├── typical_workflow.md
    ├── worklog.md
    └── adr/
        └── 0001-volba-testovaciho-stacku.md
