import sys
import subprocess
from dotenv import load_dotenv

# Carrega as variáveis do .env para o ambiente deste processo Python
load_dotenv()

# Repassa qualquer argumento (debug, run, test...) direto para o dbt,
# rodando dentro da pasta do projeto dbt
subprocess.run(["dbt"] + sys.argv[1:], cwd="nyc_taxi")