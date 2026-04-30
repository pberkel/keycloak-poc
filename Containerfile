FROM quay.io/keycloak/keycloak:26.6.1 AS builder

# Build-time flags — baked into the optimised binary by kc.sh build.
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.6.1
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Runtime configuration (KC_DB_URL, KC_DB_USERNAME, KC_DB_PASSWORD, KC_HOSTNAME,
# KC_BOOTSTRAP_ADMIN_USERNAME, KC_BOOTSTRAP_ADMIN_PASSWORD) must be provided
# via Kubernetes Secrets and ConfigMap — do not set them here.

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
