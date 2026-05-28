import os
from pathlib import Path

import oracledb
from dotenv import load_dotenv


def send_results_to_db():
    # Načtení proměnných prostředí z .env.example
    env_path = Path(__file__).parent.parent / ".env.example"
    load_dotenv(dotenv_path=env_path)

    results_path = Path("results/parsed_results.json")

    if not results_path.exists():
        print(f"Chyba: Soubor {results_path} nebyl nalezen.")
        print("Nejdříve spusť: python reporting/parse_results.py")
        return

    # 2. Načtení JSONu
    print(f"Načítám výsledky z {results_path}...")
    try:
        with open(results_path, "r", encoding="utf-8") as f:
            json_string = f.read()
    except Exception as e:
        print(f"Chyba při čtení souboru: {e}")
        return

    print("Připojuji se k databázi...")
    try:
        user = os.getenv("TEST_DB_USER")
        password = os.getenv("TEST_DB_PASSWORD")
        dsn = os.getenv("TEST_DB_DSN")

        if not all([user, password, dsn]):
            print(
                "Chyba: Chybějící konfigurační údaje v .env.example (TEST_DB_USER, TEST_DB_PASSWORD, TEST_DB_DSN)."
            )
            return

        conn = oracledb.connect(user=user, password=password, dsn=dsn)
        cursor = conn.cursor()

        print("Aktualizuji tabulku UTS_VYSLEDKY...")
        sql = """
            UPDATE UTS_VYSLEDKY
            SET json_data = :1,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = 1
        """
        cursor.execute(sql, [json_string])

        if cursor.rowcount == 0:
            print("Upozornění: Řádek s ID=1 nebyl nalezen. Zkouším INSERT...")
            sql_insert = "INSERT INTO UTS_VYSLEDKY (id, json_data) VALUES (1, :1)"
            cursor.execute(sql_insert, [json_string])

        conn.commit()
        print("\nSUCCESS: Výsledky byly úspěšně uloženy do databáze.")

        cursor.close()
        conn.close()
    except oracledb.Error as e:
        print(f"\nCHYBA Databáze: {e}")
    except Exception as e:
        print(f"\nNEOČEKÁVANÁ CHYBA: {e}")


if __name__ == "__main__":
    send_results_to_db()
