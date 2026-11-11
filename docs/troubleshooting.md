# Troubleshooting: order-service failure simulation

## Symptom
Grafana Blackbox dashboard showed http://nginx/orders/health DOWN. curl returned 502.

## Detection
Prometheus probe_success{instance="http://nginx/orders/health"} dropped to 0.

## Investigation
- docker compose ps -a: order-service Exited
- docker compose logs order-service / nginx: upstream connection failed
- docker inspect: exit code and state

## Root cause
Container was stopped (simulated failure).

## Resolution
docker compose up -d; /orders/health returned 200 and Grafana showed UP.

## Prevention
restart: unless-stopped policy, healthchecks, alerting on probe_success == 0.
