import os
import re

import yaml
from dotenv import dotenv_values


def get_variables(yaml_filename):
    """
    Načte YAML soubor a nahradí v něm placeholdery ${VAR} hodnotami z .env.example.
    """
    # Cesta k .env.example
    env_path = os.path.join(os.path.dirname(__file__), "..", ".env.example")

    # Načtení hodnot přímo ze souboru do slovníku (neovlivňuje os.environ)
    env_config = dotenv_values(env_path)

    # Cesta k YAML souboru
    path = os.path.join(os.path.dirname(__file__), yaml_filename)

    if not os.path.exists(path):
        raise FileNotFoundError(f"Konfigurační soubor nebyl nalezen: {path}")

    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # Regulární výraz pro hledání ${PROMENNA} nebo ${PROMENNA:-default}
    pattern = re.compile(r"\$\{(\w+)(?::-(.*))?\}")

    def replace_env_var(match):
        env_var = match.group(1)
        default_value = match.group(2)
        # Hledáme nejdříve v .env.example, pak v os.environ, pak default
        val = env_config.get(env_var) or os.getenv(env_var)

        if val is not None:
            return val
        if default_value is not None:
            return default_value
        return match.group(0)

    # Nahrazení placeholderů
    interpolated_content = pattern.sub(replace_env_var, content)

    # Načtení výsledného YAML
    data = yaml.safe_load(interpolated_content)

    # Speciální ošetření pro HEADLESS
    if data and "HEADLESS" in data:
        val = str(data["HEADLESS"]).lower()
        data["HEADLESS"] = val == "true"

    return data
