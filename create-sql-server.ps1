# ============================================================
# FIAP - DevOps Tools & Cloud Computing
# Aula 15.05 - SQL Server Azure
# RM: 563748
# ============================================================

$RESOURCE_GROUP="rg-movtodimdim"
$LOCATION="chilecentral"

$SQL_SERVER="sqlserver-rm563748"
$DATABASE="dimdimdb"

$SQL_ADMIN="admsql"
$SQL_PASSWORD="Fiap@2tdsvms"

Write-Host "============================================"
Write-Host " Criando infraestrutura SQL Server no Azure"
Write-Host "============================================"

# ------------------------------------------------------------
# 1. Criar Resource Group
# ------------------------------------------------------------

Write-Host ""
Write-Host "Criando Resource Group..."

az group create `
    --name $RESOURCE_GROUP `
    --location $LOCATION

if ($LASTEXITCODE -ne 0) {
    Write-Error "Erro ao criar o Resource Group."
    exit 1
}

# ------------------------------------------------------------
# 2. Criar Azure SQL Server
# ------------------------------------------------------------

Write-Host ""
Write-Host "Criando SQL Server..."

az sql server create `
    --name $SQL_SERVER `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --admin-user $SQL_ADMIN `
    --admin-password $SQL_PASSWORD

if ($LASTEXITCODE -ne 0) {
    Write-Error "Erro ao criar o SQL Server."
    exit 1
}

# ------------------------------------------------------------
# 3. Permitir acesso de recursos Azure
# ------------------------------------------------------------

Write-Host ""
Write-Host "Configurando Firewall..."

az sql server firewall-rule create `
    --resource-group $RESOURCE_GROUP `
    --server $SQL_SERVER `
    --name AllowAzureServices `
    --start-ip-address 0.0.0.0 `
    --end-ip-address 0.0.0.0

if ($LASTEXITCODE -ne 0) {
    Write-Error "Erro ao configurar o Firewall."
    exit 1
}

# ------------------------------------------------------------
# 4. Criar banco dimdimdb
# ------------------------------------------------------------

Write-Host ""
Write-Host "Criando banco dimdimdb..."

az sql db create `
    --resource-group $RESOURCE_GROUP `
    --server $SQL_SERVER `
    --name $DATABASE `
    --service-objective Basic

if ($LASTEXITCODE -ne 0) {
    Write-Error "Erro ao criar o banco."
    exit 1
}

# ------------------------------------------------------------
# 5. Mostrar dados necessários para a aplicação
# ------------------------------------------------------------

$JDBC_URL="jdbc:sqlserver://${SQL_SERVER}.database.windows.net:1433;database=${DATABASE};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"

Write-Host ""
Write-Host "============================================"
Write-Host " INFRAESTRUTURA CRIADA COM SUCESSO"
Write-Host "============================================"
Write-Host ""
Write-Host "Resource Group:"
Write-Host $RESOURCE_GROUP

Write-Host ""
Write-Host "SQL Server:"
Write-Host $SQL_SERVER

Write-Host ""
Write-Host "Database:"
Write-Host $DATABASE

Write-Host ""
Write-Host "Usuario:"
Write-Host $SQL_ADMIN

Write-Host ""
Write-Host "SPRING_DATASOURCE_URL:"
Write-Host $JDBC_URL

Write-Host ""
Write-Host "SPRING_DATASOURCE_USERNAME:"
Write-Host $SQL_ADMIN

Write-Host ""
Write-Host "============================================"
Write-Host "Finalizado."
Write-Host "============================================"
