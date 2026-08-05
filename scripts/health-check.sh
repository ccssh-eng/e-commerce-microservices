#!/bin/bash

# Vérifier la santé de tous les services

echo " Health check de tous les services..."
echo ""

declare -A SERVICES=(
  ["auth-service"]="3001"
  ["product-service"]="3002"
  ["order-service"]="3003"
  ["cart-service"]="3004"
  ["payment-service"]="3005"
  ["inventory-service"]="3006"
  ["notification-service"]="3007"
)

ALL_OK=true

for SERVICE in "${!SERVICES[@]}"; do
  PORT="${SERVICES[$SERVICE]}"
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    http://localhost:$PORT/health 2>/dev/null)

  if [ "$RESPONSE" = "200" ]; then
    echo " $SERVICE (port $PORT) → OK"
  else
    echo " $SERVICE (port $PORT) → ERREUR (HTTP $RESPONSE)"
    ALL_OK=false
  fi
done

echo ""
if [ "$ALL_OK" = true ]; then
  echo " Tous les services sont opérationnels !"
else
  echo " Certains services ont des problèmes — vérifiez les logs :"
  echo "   docker compose logs -f"
fi

