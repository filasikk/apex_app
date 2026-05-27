# Schéma výsledků (JSON)

Tento dokument definuje strukturu JSON souboru `parsed_results.json`, který generuje náš parser.

## Struktura objektu Run

```json
{
  "run_id": "ISO-8601 Timestamp",
  "app_name": "Název aplikace",
  "environment": "TEST/DEV/PROD",
  "started_at": "ISO-8601 Timestamp",
  "finished_at": "ISO-8601 Timestamp",
  "status": "PASS/FAIL",
  "total_tests": 10,
  "passed_tests": 9,
  "failed_tests": 1,
  "test_cases": [ ... ]
}
```

## Struktura objektu Test Case

```json
{
  "test_name": "Název testu",
  "status": "PASS/FAIL",
  "started_at": "ISO-8601 Timestamp",
  "finished_at": "ISO-8601 Timestamp",
  "duration_ms": 5000,
  "error_message": "Text chyby (null při PASS)",
  "screenshot_blob": "Base64 string obrázku (null při PASS)"
}
```

## Mapování na databázi
Tato struktura odpovídá tabulce `UTS_VYSLEDKY`, kde je celý JSON uložen v CLOB sloupci a parsován v APEXu pomocí `JSON_TABLE`.
