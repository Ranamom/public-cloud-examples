resource "kubectl_manifest" "kubeflow-istio-crd-authorizationpolicies" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    istio: security
    release: istio
  name: authorizationpolicies.security.istio.io
spec:
  group: security.istio.io
  names:
    categories:
    - istio-io
    - security-istio-io
    kind: AuthorizationPolicy
    listKind: AuthorizationPolicyList
    plural: authorizationpolicies
    singular: authorizationpolicy
  scope: Namespaced
  versions:
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration for access control on workloads. See more
              details at: https://istio.io/docs/reference/config/security/authorization-policy.html'
            oneOf:
            - not:
                anyOf:
                - required:
                  - provider
            - required:
              - provider
            properties:
              action:
                description: Optional.
                enum:
                - ALLOW
                - DENY
                - AUDIT
                - CUSTOM
                type: string
              provider:
                description: Specifies detailed configuration of the CUSTOM action.
                properties:
                  name:
                    description: Specifies the name of the extension provider.
                    type: string
                type: object
              rules:
                description: Optional.
                items:
                  properties:
                    from:
                      description: Optional.
                      items:
                        properties:
                          source:
                            description: Source specifies the source of a request.
                            properties:
                              ipBlocks:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              namespaces:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notIpBlocks:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notNamespaces:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notPrincipals:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notRemoteIpBlocks:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notRequestPrincipals:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              principals:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              remoteIpBlocks:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              requestPrincipals:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                            type: object
                        type: object
                      type: array
                    to:
                      description: Optional.
                      items:
                        properties:
                          operation:
                            description: Operation specifies the operation of a request.
                            properties:
                              hosts:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              methods:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notHosts:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notMethods:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notPaths:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              notPorts:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              paths:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                              ports:
                                description: Optional.
                                items:
                                  type: string
                                type: array
                            type: object
                        type: object
                      type: array
                    when:
                      description: Optional.
                      items:
                        properties:
                          key:
                            description: The name of an Istio attribute.
                            type: string
                          notValues:
                            description: Optional.
                            items:
                              type: string
                            type: array
                          values:
                            description: Optional.
                            items:
                              type: string
                            type: array
                        type: object
                      type: array
                  type: object
                type: array
              selector:
                description: Optional.
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-destinationrules" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: destinationrules.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: DestinationRule
    listKind: DestinationRuleList
    plural: destinationrules
    shortNames:
    - dr
    singular: destinationrule
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: The name of a service from the service registry
      jsonPath: .spec.host
      name: Host
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting load balancing, outlier detection,
              etc. See more details at: https://istio.io/docs/reference/config/networking/destination-rule.html'
            properties:
              exportTo:
                description: A list of namespaces to which this destination rule is
                  exported.
                items:
                  type: string
                type: array
              host:
                description: The name of a service from the service registry.
                type: string
              subsets:
                items:
                  properties:
                    labels:
                      additionalProperties:
                        type: string
                      type: object
                    name:
                      description: Name of the subset.
                      type: string
                    trafficPolicy:
                      description: Traffic policies that apply to this subset.
                      properties:
                        connectionPool:
                          properties:
                            http:
                              description: HTTP connection pool settings.
                              properties:
                                h2UpgradePolicy:
                                  description: Specify if http1.1 connection should
                                    be upgraded to http2 for the associated destination.
                                  enum:
                                  - DEFAULT
                                  - DO_NOT_UPGRADE
                                  - UPGRADE
                                  type: string
                                http1MaxPendingRequests:
                                  format: int32
                                  type: integer
                                http2MaxRequests:
                                  description: Maximum number of active requests to
                                    a destination.
                                  format: int32
                                  type: integer
                                idleTimeout:
                                  description: The idle timeout for upstream connection
                                    pool connections.
                                  type: string
                                maxRequestsPerConnection:
                                  description: Maximum number of requests per connection
                                    to a backend.
                                  format: int32
                                  type: integer
                                maxRetries:
                                  format: int32
                                  type: integer
                                useClientProtocol:
                                  description: If set to true, client protocol will
                                    be preserved while initiating connection to backend.
                                  type: boolean
                              type: object
                            tcp:
                              description: Settings common to both HTTP and TCP upstream
                                connections.
                              properties:
                                connectTimeout:
                                  description: TCP connection timeout.
                                  type: string
                                maxConnectionDuration:
                                  description: The maximum duration of a connection.
                                  type: string
                                maxConnections:
                                  description: Maximum number of HTTP1 /TCP connections
                                    to a destination host.
                                  format: int32
                                  type: integer
                                tcpKeepalive:
                                  description: If set then set SO_KEEPALIVE on the
                                    socket to enable TCP Keepalives.
                                  properties:
                                    interval:
                                      description: The time duration between keep-alive
                                        probes.
                                      type: string
                                    probes:
                                      type: integer
                                    time:
                                      type: string
                                  type: object
                              type: object
                          type: object
                        loadBalancer:
                          description: Settings controlling the load balancer algorithms.
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - simple
                              - properties:
                                  consistentHash:
                                    allOf:
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - httpHeaderName
                                          - required:
                                            - httpCookie
                                          - required:
                                            - useSourceIp
                                          - required:
                                            - httpQueryParameterName
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - ringHash
                                          - required:
                                            - maglev
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                    properties:
                                      minimumRingSize: {}
                                required:
                                - consistentHash
                          - required:
                            - simple
                          - properties:
                              consistentHash:
                                allOf:
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                  - required:
                                    - httpHeaderName
                                  - required:
                                    - httpCookie
                                  - required:
                                    - useSourceIp
                                  - required:
                                    - httpQueryParameterName
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                  - required:
                                    - ringHash
                                  - required:
                                    - maglev
                                properties:
                                  minimumRingSize: {}
                            required:
                            - consistentHash
                          properties:
                            consistentHash:
                              properties:
                                httpCookie:
                                  description: Hash based on HTTP cookie.
                                  properties:
                                    name:
                                      description: Name of the cookie.
                                      type: string
                                    path:
                                      description: Path to set for the cookie.
                                      type: string
                                    ttl:
                                      description: Lifetime of the cookie.
                                      type: string
                                  type: object
                                httpHeaderName:
                                  description: Hash based on a specific HTTP header.
                                  type: string
                                httpQueryParameterName:
                                  description: Hash based on a specific HTTP query
                                    parameter.
                                  type: string
                                maglev:
                                  description: The Maglev load balancer implements
                                    consistent hashing to backend hosts.
                                  properties:
                                    tableSize:
                                      description: The table size for Maglev hashing.
                                      type: integer
                                  type: object
                                minimumRingSize:
                                  description: Deprecated.
                                  type: integer
                                ringHash:
                                  description: The ring/modulo hash load balancer
                                    implements consistent hashing to backend hosts.
                                  properties:
                                    minimumRingSize:
                                      type: integer
                                  type: object
                                useSourceIp:
                                  description: Hash based on the source IP address.
                                  type: boolean
                              type: object
                            localityLbSetting:
                              properties:
                                distribute:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating locality, '/' separated,
                                          e.g.
                                        type: string
                                      to:
                                        additionalProperties:
                                          type: integer
                                        description: Map of upstream localities to
                                          traffic distribution weights.
                                        type: object
                                    type: object
                                  type: array
                                enabled:
                                  description: enable locality load balancing, this
                                    is DestinationRule-level and will override mesh
                                    wide settings in entirety.
                                  nullable: true
                                  type: boolean
                                failover:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating region.
                                        type: string
                                      to:
                                        type: string
                                    type: object
                                  type: array
                                failoverPriority:
                                  description: failoverPriority is an ordered list
                                    of labels used to sort endpoints to do priority
                                    based load balancing.
                                  items:
                                    type: string
                                  type: array
                              type: object
                            simple:
                              enum:
                              - UNSPECIFIED
                              - LEAST_CONN
                              - RANDOM
                              - PASSTHROUGH
                              - ROUND_ROBIN
                              - LEAST_REQUEST
                              type: string
                            warmupDurationSecs:
                              description: Represents the warmup duration of Service.
                              type: string
                          type: object
                        outlierDetection:
                          properties:
                            baseEjectionTime:
                              description: Minimum ejection duration.
                              type: string
                            consecutive5xxErrors:
                              description: Number of 5xx errors before a host is ejected
                                from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveErrors:
                              format: int32
                              type: integer
                            consecutiveGatewayErrors:
                              description: Number of gateway errors before a host
                                is ejected from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveLocalOriginFailures:
                              nullable: true
                              type: integer
                            interval:
                              description: Time interval between ejection sweep analysis.
                              type: string
                            maxEjectionPercent:
                              format: int32
                              type: integer
                            minHealthPercent:
                              format: int32
                              type: integer
                            splitExternalLocalOriginErrors:
                              description: Determines whether to distinguish local
                                origin failures from external errors.
                              type: boolean
                          type: object
                        portLevelSettings:
                          description: Traffic policies specific to individual ports.
                          items:
                            properties:
                              connectionPool:
                                properties:
                                  http:
                                    description: HTTP connection pool settings.
                                    properties:
                                      h2UpgradePolicy:
                                        description: Specify if http1.1 connection
                                          should be upgraded to http2 for the associated
                                          destination.
                                        enum:
                                        - DEFAULT
                                        - DO_NOT_UPGRADE
                                        - UPGRADE
                                        type: string
                                      http1MaxPendingRequests:
                                        format: int32
                                        type: integer
                                      http2MaxRequests:
                                        description: Maximum number of active requests
                                          to a destination.
                                        format: int32
                                        type: integer
                                      idleTimeout:
                                        description: The idle timeout for upstream
                                          connection pool connections.
                                        type: string
                                      maxRequestsPerConnection:
                                        description: Maximum number of requests per
                                          connection to a backend.
                                        format: int32
                                        type: integer
                                      maxRetries:
                                        format: int32
                                        type: integer
                                      useClientProtocol:
                                        description: If set to true, client protocol
                                          will be preserved while initiating connection
                                          to backend.
                                        type: boolean
                                    type: object
                                  tcp:
                                    description: Settings common to both HTTP and
                                      TCP upstream connections.
                                    properties:
                                      connectTimeout:
                                        description: TCP connection timeout.
                                        type: string
                                      maxConnectionDuration:
                                        description: The maximum duration of a connection.
                                        type: string
                                      maxConnections:
                                        description: Maximum number of HTTP1 /TCP
                                          connections to a destination host.
                                        format: int32
                                        type: integer
                                      tcpKeepalive:
                                        description: If set then set SO_KEEPALIVE
                                          on the socket to enable TCP Keepalives.
                                        properties:
                                          interval:
                                            description: The time duration between
                                              keep-alive probes.
                                            type: string
                                          probes:
                                            type: integer
                                          time:
                                            type: string
                                        type: object
                                    type: object
                                type: object
                              loadBalancer:
                                description: Settings controlling the load balancer
                                  algorithms.
                                oneOf:
                                - not:
                                    anyOf:
                                    - required:
                                      - simple
                                    - properties:
                                        consistentHash:
                                          allOf:
                                          - oneOf:
                                            - not:
                                                anyOf:
                                                - required:
                                                  - httpHeaderName
                                                - required:
                                                  - httpCookie
                                                - required:
                                                  - useSourceIp
                                                - required:
                                                  - httpQueryParameterName
                                            - required:
                                              - httpHeaderName
                                            - required:
                                              - httpCookie
                                            - required:
                                              - useSourceIp
                                            - required:
                                              - httpQueryParameterName
                                          - oneOf:
                                            - not:
                                                anyOf:
                                                - required:
                                                  - ringHash
                                                - required:
                                                  - maglev
                                            - required:
                                              - ringHash
                                            - required:
                                              - maglev
                                          properties:
                                            minimumRingSize: {}
                                      required:
                                      - consistentHash
                                - required:
                                  - simple
                                - properties:
                                    consistentHash:
                                      allOf:
                                      - oneOf:
                                        - not:
                                            anyOf:
                                            - required:
                                              - httpHeaderName
                                            - required:
                                              - httpCookie
                                            - required:
                                              - useSourceIp
                                            - required:
                                              - httpQueryParameterName
                                        - required:
                                          - httpHeaderName
                                        - required:
                                          - httpCookie
                                        - required:
                                          - useSourceIp
                                        - required:
                                          - httpQueryParameterName
                                      - oneOf:
                                        - not:
                                            anyOf:
                                            - required:
                                              - ringHash
                                            - required:
                                              - maglev
                                        - required:
                                          - ringHash
                                        - required:
                                          - maglev
                                      properties:
                                        minimumRingSize: {}
                                  required:
                                  - consistentHash
                                properties:
                                  consistentHash:
                                    properties:
                                      httpCookie:
                                        description: Hash based on HTTP cookie.
                                        properties:
                                          name:
                                            description: Name of the cookie.
                                            type: string
                                          path:
                                            description: Path to set for the cookie.
                                            type: string
                                          ttl:
                                            description: Lifetime of the cookie.
                                            type: string
                                        type: object
                                      httpHeaderName:
                                        description: Hash based on a specific HTTP
                                          header.
                                        type: string
                                      httpQueryParameterName:
                                        description: Hash based on a specific HTTP
                                          query parameter.
                                        type: string
                                      maglev:
                                        description: The Maglev load balancer implements
                                          consistent hashing to backend hosts.
                                        properties:
                                          tableSize:
                                            description: The table size for Maglev
                                              hashing.
                                            type: integer
                                        type: object
                                      minimumRingSize:
                                        description: Deprecated.
                                        type: integer
                                      ringHash:
                                        description: The ring/modulo hash load balancer
                                          implements consistent hashing to backend
                                          hosts.
                                        properties:
                                          minimumRingSize:
                                            type: integer
                                        type: object
                                      useSourceIp:
                                        description: Hash based on the source IP address.
                                        type: boolean
                                    type: object
                                  localityLbSetting:
                                    properties:
                                      distribute:
                                        description: 'Optional: only one of distribute,
                                          failover or failoverPriority can be set.'
                                        items:
                                          properties:
                                            from:
                                              description: Originating locality, '/'
                                                separated, e.g.
                                              type: string
                                            to:
                                              additionalProperties:
                                                type: integer
                                              description: Map of upstream localities
                                                to traffic distribution weights.
                                              type: object
                                          type: object
                                        type: array
                                      enabled:
                                        description: enable locality load balancing,
                                          this is DestinationRule-level and will override
                                          mesh wide settings in entirety.
                                        nullable: true
                                        type: boolean
                                      failover:
                                        description: 'Optional: only one of distribute,
                                          failover or failoverPriority can be set.'
                                        items:
                                          properties:
                                            from:
                                              description: Originating region.
                                              type: string
                                            to:
                                              type: string
                                          type: object
                                        type: array
                                      failoverPriority:
                                        description: failoverPriority is an ordered
                                          list of labels used to sort endpoints to
                                          do priority based load balancing.
                                        items:
                                          type: string
                                        type: array
                                    type: object
                                  simple:
                                    enum:
                                    - UNSPECIFIED
                                    - LEAST_CONN
                                    - RANDOM
                                    - PASSTHROUGH
                                    - ROUND_ROBIN
                                    - LEAST_REQUEST
                                    type: string
                                  warmupDurationSecs:
                                    description: Represents the warmup duration of
                                      Service.
                                    type: string
                                type: object
                              outlierDetection:
                                properties:
                                  baseEjectionTime:
                                    description: Minimum ejection duration.
                                    type: string
                                  consecutive5xxErrors:
                                    description: Number of 5xx errors before a host
                                      is ejected from the connection pool.
                                    nullable: true
                                    type: integer
                                  consecutiveErrors:
                                    format: int32
                                    type: integer
                                  consecutiveGatewayErrors:
                                    description: Number of gateway errors before a
                                      host is ejected from the connection pool.
                                    nullable: true
                                    type: integer
                                  consecutiveLocalOriginFailures:
                                    nullable: true
                                    type: integer
                                  interval:
                                    description: Time interval between ejection sweep
                                      analysis.
                                    type: string
                                  maxEjectionPercent:
                                    format: int32
                                    type: integer
                                  minHealthPercent:
                                    format: int32
                                    type: integer
                                  splitExternalLocalOriginErrors:
                                    description: Determines whether to distinguish
                                      local origin failures from external errors.
                                    type: boolean
                                type: object
                              port:
                                properties:
                                  number:
                                    type: integer
                                type: object
                              tls:
                                description: TLS related settings for connections
                                  to the upstream service.
                                properties:
                                  caCertificates:
                                    type: string
                                  clientCertificate:
                                    description: REQUIRED if mode is `MUTUAL`.
                                    type: string
                                  credentialName:
                                    type: string
                                  insecureSkipVerify:
                                    nullable: true
                                    type: boolean
                                  mode:
                                    enum:
                                    - DISABLE
                                    - SIMPLE
                                    - MUTUAL
                                    - ISTIO_MUTUAL
                                    type: string
                                  privateKey:
                                    description: REQUIRED if mode is `MUTUAL`.
                                    type: string
                                  sni:
                                    description: SNI string to present to the server
                                      during TLS handshake.
                                    type: string
                                  subjectAltNames:
                                    items:
                                      type: string
                                    type: array
                                type: object
                            type: object
                          type: array
                        tls:
                          description: TLS related settings for connections to the
                            upstream service.
                          properties:
                            caCertificates:
                              type: string
                            clientCertificate:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            credentialName:
                              type: string
                            insecureSkipVerify:
                              nullable: true
                              type: boolean
                            mode:
                              enum:
                              - DISABLE
                              - SIMPLE
                              - MUTUAL
                              - ISTIO_MUTUAL
                              type: string
                            privateKey:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            sni:
                              description: SNI string to present to the server during
                                TLS handshake.
                              type: string
                            subjectAltNames:
                              items:
                                type: string
                              type: array
                          type: object
                        tunnel:
                          properties:
                            protocol:
                              description: Specifies which protocol to use for tunneling
                                the downstream connection.
                              type: string
                            targetHost:
                              description: Specifies a host to which the downstream
                                connection is tunneled.
                              type: string
                            targetPort:
                              description: Specifies a port to which the downstream
                                connection is tunneled.
                              type: integer
                          type: object
                      type: object
                  type: object
                type: array
              trafficPolicy:
                properties:
                  connectionPool:
                    properties:
                      http:
                        description: HTTP connection pool settings.
                        properties:
                          h2UpgradePolicy:
                            description: Specify if http1.1 connection should be upgraded
                              to http2 for the associated destination.
                            enum:
                            - DEFAULT
                            - DO_NOT_UPGRADE
                            - UPGRADE
                            type: string
                          http1MaxPendingRequests:
                            format: int32
                            type: integer
                          http2MaxRequests:
                            description: Maximum number of active requests to a destination.
                            format: int32
                            type: integer
                          idleTimeout:
                            description: The idle timeout for upstream connection
                              pool connections.
                            type: string
                          maxRequestsPerConnection:
                            description: Maximum number of requests per connection
                              to a backend.
                            format: int32
                            type: integer
                          maxRetries:
                            format: int32
                            type: integer
                          useClientProtocol:
                            description: If set to true, client protocol will be preserved
                              while initiating connection to backend.
                            type: boolean
                        type: object
                      tcp:
                        description: Settings common to both HTTP and TCP upstream
                          connections.
                        properties:
                          connectTimeout:
                            description: TCP connection timeout.
                            type: string
                          maxConnectionDuration:
                            description: The maximum duration of a connection.
                            type: string
                          maxConnections:
                            description: Maximum number of HTTP1 /TCP connections
                              to a destination host.
                            format: int32
                            type: integer
                          tcpKeepalive:
                            description: If set then set SO_KEEPALIVE on the socket
                              to enable TCP Keepalives.
                            properties:
                              interval:
                                description: The time duration between keep-alive
                                  probes.
                                type: string
                              probes:
                                type: integer
                              time:
                                type: string
                            type: object
                        type: object
                    type: object
                  loadBalancer:
                    description: Settings controlling the load balancer algorithms.
                    oneOf:
                    - not:
                        anyOf:
                        - required:
                          - simple
                        - properties:
                            consistentHash:
                              allOf:
                              - oneOf:
                                - not:
                                    anyOf:
                                    - required:
                                      - httpHeaderName
                                    - required:
                                      - httpCookie
                                    - required:
                                      - useSourceIp
                                    - required:
                                      - httpQueryParameterName
                                - required:
                                  - httpHeaderName
                                - required:
                                  - httpCookie
                                - required:
                                  - useSourceIp
                                - required:
                                  - httpQueryParameterName
                              - oneOf:
                                - not:
                                    anyOf:
                                    - required:
                                      - ringHash
                                    - required:
                                      - maglev
                                - required:
                                  - ringHash
                                - required:
                                  - maglev
                              properties:
                                minimumRingSize: {}
                          required:
                          - consistentHash
                    - required:
                      - simple
                    - properties:
                        consistentHash:
                          allOf:
                          - oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - httpHeaderName
                                - required:
                                  - httpCookie
                                - required:
                                  - useSourceIp
                                - required:
                                  - httpQueryParameterName
                            - required:
                              - httpHeaderName
                            - required:
                              - httpCookie
                            - required:
                              - useSourceIp
                            - required:
                              - httpQueryParameterName
                          - oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - ringHash
                                - required:
                                  - maglev
                            - required:
                              - ringHash
                            - required:
                              - maglev
                          properties:
                            minimumRingSize: {}
                      required:
                      - consistentHash
                    properties:
                      consistentHash:
                        properties:
                          httpCookie:
                            description: Hash based on HTTP cookie.
                            properties:
                              name:
                                description: Name of the cookie.
                                type: string
                              path:
                                description: Path to set for the cookie.
                                type: string
                              ttl:
                                description: Lifetime of the cookie.
                                type: string
                            type: object
                          httpHeaderName:
                            description: Hash based on a specific HTTP header.
                            type: string
                          httpQueryParameterName:
                            description: Hash based on a specific HTTP query parameter.
                            type: string
                          maglev:
                            description: The Maglev load balancer implements consistent
                              hashing to backend hosts.
                            properties:
                              tableSize:
                                description: The table size for Maglev hashing.
                                type: integer
                            type: object
                          minimumRingSize:
                            description: Deprecated.
                            type: integer
                          ringHash:
                            description: The ring/modulo hash load balancer implements
                              consistent hashing to backend hosts.
                            properties:
                              minimumRingSize:
                                type: integer
                            type: object
                          useSourceIp:
                            description: Hash based on the source IP address.
                            type: boolean
                        type: object
                      localityLbSetting:
                        properties:
                          distribute:
                            description: 'Optional: only one of distribute, failover
                              or failoverPriority can be set.'
                            items:
                              properties:
                                from:
                                  description: Originating locality, '/' separated,
                                    e.g.
                                  type: string
                                to:
                                  additionalProperties:
                                    type: integer
                                  description: Map of upstream localities to traffic
                                    distribution weights.
                                  type: object
                              type: object
                            type: array
                          enabled:
                            description: enable locality load balancing, this is DestinationRule-level
                              and will override mesh wide settings in entirety.
                            nullable: true
                            type: boolean
                          failover:
                            description: 'Optional: only one of distribute, failover
                              or failoverPriority can be set.'
                            items:
                              properties:
                                from:
                                  description: Originating region.
                                  type: string
                                to:
                                  type: string
                              type: object
                            type: array
                          failoverPriority:
                            description: failoverPriority is an ordered list of labels
                              used to sort endpoints to do priority based load balancing.
                            items:
                              type: string
                            type: array
                        type: object
                      simple:
                        enum:
                        - UNSPECIFIED
                        - LEAST_CONN
                        - RANDOM
                        - PASSTHROUGH
                        - ROUND_ROBIN
                        - LEAST_REQUEST
                        type: string
                      warmupDurationSecs:
                        description: Represents the warmup duration of Service.
                        type: string
                    type: object
                  outlierDetection:
                    properties:
                      baseEjectionTime:
                        description: Minimum ejection duration.
                        type: string
                      consecutive5xxErrors:
                        description: Number of 5xx errors before a host is ejected
                          from the connection pool.
                        nullable: true
                        type: integer
                      consecutiveErrors:
                        format: int32
                        type: integer
                      consecutiveGatewayErrors:
                        description: Number of gateway errors before a host is ejected
                          from the connection pool.
                        nullable: true
                        type: integer
                      consecutiveLocalOriginFailures:
                        nullable: true
                        type: integer
                      interval:
                        description: Time interval between ejection sweep analysis.
                        type: string
                      maxEjectionPercent:
                        format: int32
                        type: integer
                      minHealthPercent:
                        format: int32
                        type: integer
                      splitExternalLocalOriginErrors:
                        description: Determines whether to distinguish local origin
                          failures from external errors.
                        type: boolean
                    type: object
                  portLevelSettings:
                    description: Traffic policies specific to individual ports.
                    items:
                      properties:
                        connectionPool:
                          properties:
                            http:
                              description: HTTP connection pool settings.
                              properties:
                                h2UpgradePolicy:
                                  description: Specify if http1.1 connection should
                                    be upgraded to http2 for the associated destination.
                                  enum:
                                  - DEFAULT
                                  - DO_NOT_UPGRADE
                                  - UPGRADE
                                  type: string
                                http1MaxPendingRequests:
                                  format: int32
                                  type: integer
                                http2MaxRequests:
                                  description: Maximum number of active requests to
                                    a destination.
                                  format: int32
                                  type: integer
                                idleTimeout:
                                  description: The idle timeout for upstream connection
                                    pool connections.
                                  type: string
                                maxRequestsPerConnection:
                                  description: Maximum number of requests per connection
                                    to a backend.
                                  format: int32
                                  type: integer
                                maxRetries:
                                  format: int32
                                  type: integer
                                useClientProtocol:
                                  description: If set to true, client protocol will
                                    be preserved while initiating connection to backend.
                                  type: boolean
                              type: object
                            tcp:
                              description: Settings common to both HTTP and TCP upstream
                                connections.
                              properties:
                                connectTimeout:
                                  description: TCP connection timeout.
                                  type: string
                                maxConnectionDuration:
                                  description: The maximum duration of a connection.
                                  type: string
                                maxConnections:
                                  description: Maximum number of HTTP1 /TCP connections
                                    to a destination host.
                                  format: int32
                                  type: integer
                                tcpKeepalive:
                                  description: If set then set SO_KEEPALIVE on the
                                    socket to enable TCP Keepalives.
                                  properties:
                                    interval:
                                      description: The time duration between keep-alive
                                        probes.
                                      type: string
                                    probes:
                                      type: integer
                                    time:
                                      type: string
                                  type: object
                              type: object
                          type: object
                        loadBalancer:
                          description: Settings controlling the load balancer algorithms.
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - simple
                              - properties:
                                  consistentHash:
                                    allOf:
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - httpHeaderName
                                          - required:
                                            - httpCookie
                                          - required:
                                            - useSourceIp
                                          - required:
                                            - httpQueryParameterName
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - ringHash
                                          - required:
                                            - maglev
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                    properties:
                                      minimumRingSize: {}
                                required:
                                - consistentHash
                          - required:
                            - simple
                          - properties:
                              consistentHash:
                                allOf:
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                  - required:
                                    - httpHeaderName
                                  - required:
                                    - httpCookie
                                  - required:
                                    - useSourceIp
                                  - required:
                                    - httpQueryParameterName
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                  - required:
                                    - ringHash
                                  - required:
                                    - maglev
                                properties:
                                  minimumRingSize: {}
                            required:
                            - consistentHash
                          properties:
                            consistentHash:
                              properties:
                                httpCookie:
                                  description: Hash based on HTTP cookie.
                                  properties:
                                    name:
                                      description: Name of the cookie.
                                      type: string
                                    path:
                                      description: Path to set for the cookie.
                                      type: string
                                    ttl:
                                      description: Lifetime of the cookie.
                                      type: string
                                  type: object
                                httpHeaderName:
                                  description: Hash based on a specific HTTP header.
                                  type: string
                                httpQueryParameterName:
                                  description: Hash based on a specific HTTP query
                                    parameter.
                                  type: string
                                maglev:
                                  description: The Maglev load balancer implements
                                    consistent hashing to backend hosts.
                                  properties:
                                    tableSize:
                                      description: The table size for Maglev hashing.
                                      type: integer
                                  type: object
                                minimumRingSize:
                                  description: Deprecated.
                                  type: integer
                                ringHash:
                                  description: The ring/modulo hash load balancer
                                    implements consistent hashing to backend hosts.
                                  properties:
                                    minimumRingSize:
                                      type: integer
                                  type: object
                                useSourceIp:
                                  description: Hash based on the source IP address.
                                  type: boolean
                              type: object
                            localityLbSetting:
                              properties:
                                distribute:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating locality, '/' separated,
                                          e.g.
                                        type: string
                                      to:
                                        additionalProperties:
                                          type: integer
                                        description: Map of upstream localities to
                                          traffic distribution weights.
                                        type: object
                                    type: object
                                  type: array
                                enabled:
                                  description: enable locality load balancing, this
                                    is DestinationRule-level and will override mesh
                                    wide settings in entirety.
                                  nullable: true
                                  type: boolean
                                failover:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating region.
                                        type: string
                                      to:
                                        type: string
                                    type: object
                                  type: array
                                failoverPriority:
                                  description: failoverPriority is an ordered list
                                    of labels used to sort endpoints to do priority
                                    based load balancing.
                                  items:
                                    type: string
                                  type: array
                              type: object
                            simple:
                              enum:
                              - UNSPECIFIED
                              - LEAST_CONN
                              - RANDOM
                              - PASSTHROUGH
                              - ROUND_ROBIN
                              - LEAST_REQUEST
                              type: string
                            warmupDurationSecs:
                              description: Represents the warmup duration of Service.
                              type: string
                          type: object
                        outlierDetection:
                          properties:
                            baseEjectionTime:
                              description: Minimum ejection duration.
                              type: string
                            consecutive5xxErrors:
                              description: Number of 5xx errors before a host is ejected
                                from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveErrors:
                              format: int32
                              type: integer
                            consecutiveGatewayErrors:
                              description: Number of gateway errors before a host
                                is ejected from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveLocalOriginFailures:
                              nullable: true
                              type: integer
                            interval:
                              description: Time interval between ejection sweep analysis.
                              type: string
                            maxEjectionPercent:
                              format: int32
                              type: integer
                            minHealthPercent:
                              format: int32
                              type: integer
                            splitExternalLocalOriginErrors:
                              description: Determines whether to distinguish local
                                origin failures from external errors.
                              type: boolean
                          type: object
                        port:
                          properties:
                            number:
                              type: integer
                          type: object
                        tls:
                          description: TLS related settings for connections to the
                            upstream service.
                          properties:
                            caCertificates:
                              type: string
                            clientCertificate:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            credentialName:
                              type: string
                            insecureSkipVerify:
                              nullable: true
                              type: boolean
                            mode:
                              enum:
                              - DISABLE
                              - SIMPLE
                              - MUTUAL
                              - ISTIO_MUTUAL
                              type: string
                            privateKey:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            sni:
                              description: SNI string to present to the server during
                                TLS handshake.
                              type: string
                            subjectAltNames:
                              items:
                                type: string
                              type: array
                          type: object
                      type: object
                    type: array
                  tls:
                    description: TLS related settings for connections to the upstream
                      service.
                    properties:
                      caCertificates:
                        type: string
                      clientCertificate:
                        description: REQUIRED if mode is `MUTUAL`.
                        type: string
                      credentialName:
                        type: string
                      insecureSkipVerify:
                        nullable: true
                        type: boolean
                      mode:
                        enum:
                        - DISABLE
                        - SIMPLE
                        - MUTUAL
                        - ISTIO_MUTUAL
                        type: string
                      privateKey:
                        description: REQUIRED if mode is `MUTUAL`.
                        type: string
                      sni:
                        description: SNI string to present to the server during TLS
                          handshake.
                        type: string
                      subjectAltNames:
                        items:
                          type: string
                        type: array
                    type: object
                  tunnel:
                    properties:
                      protocol:
                        description: Specifies which protocol to use for tunneling
                          the downstream connection.
                        type: string
                      targetHost:
                        description: Specifies a host to which the downstream connection
                          is tunneled.
                        type: string
                      targetPort:
                        description: Specifies a port to which the downstream connection
                          is tunneled.
                        type: integer
                    type: object
                type: object
              workloadSelector:
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - additionalPrinterColumns:
    - description: The name of a service from the service registry
      jsonPath: .spec.host
      name: Host
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting load balancing, outlier detection,
              etc. See more details at: https://istio.io/docs/reference/config/networking/destination-rule.html'
            properties:
              exportTo:
                description: A list of namespaces to which this destination rule is
                  exported.
                items:
                  type: string
                type: array
              host:
                description: The name of a service from the service registry.
                type: string
              subsets:
                items:
                  properties:
                    labels:
                      additionalProperties:
                        type: string
                      type: object
                    name:
                      description: Name of the subset.
                      type: string
                    trafficPolicy:
                      description: Traffic policies that apply to this subset.
                      properties:
                        connectionPool:
                          properties:
                            http:
                              description: HTTP connection pool settings.
                              properties:
                                h2UpgradePolicy:
                                  description: Specify if http1.1 connection should
                                    be upgraded to http2 for the associated destination.
                                  enum:
                                  - DEFAULT
                                  - DO_NOT_UPGRADE
                                  - UPGRADE
                                  type: string
                                http1MaxPendingRequests:
                                  format: int32
                                  type: integer
                                http2MaxRequests:
                                  description: Maximum number of active requests to
                                    a destination.
                                  format: int32
                                  type: integer
                                idleTimeout:
                                  description: The idle timeout for upstream connection
                                    pool connections.
                                  type: string
                                maxRequestsPerConnection:
                                  description: Maximum number of requests per connection
                                    to a backend.
                                  format: int32
                                  type: integer
                                maxRetries:
                                  format: int32
                                  type: integer
                                useClientProtocol:
                                  description: If set to true, client protocol will
                                    be preserved while initiating connection to backend.
                                  type: boolean
                              type: object
                            tcp:
                              description: Settings common to both HTTP and TCP upstream
                                connections.
                              properties:
                                connectTimeout:
                                  description: TCP connection timeout.
                                  type: string
                                maxConnectionDuration:
                                  description: The maximum duration of a connection.
                                  type: string
                                maxConnections:
                                  description: Maximum number of HTTP1 /TCP connections
                                    to a destination host.
                                  format: int32
                                  type: integer
                                tcpKeepalive:
                                  description: If set then set SO_KEEPALIVE on the
                                    socket to enable TCP Keepalives.
                                  properties:
                                    interval:
                                      description: The time duration between keep-alive
                                        probes.
                                      type: string
                                    probes:
                                      type: integer
                                    time:
                                      type: string
                                  type: object
                              type: object
                          type: object
                        loadBalancer:
                          description: Settings controlling the load balancer algorithms.
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - simple
                              - properties:
                                  consistentHash:
                                    allOf:
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - httpHeaderName
                                          - required:
                                            - httpCookie
                                          - required:
                                            - useSourceIp
                                          - required:
                                            - httpQueryParameterName
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - ringHash
                                          - required:
                                            - maglev
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                    properties:
                                      minimumRingSize: {}
                                required:
                                - consistentHash
                          - required:
                            - simple
                          - properties:
                              consistentHash:
                                allOf:
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                  - required:
                                    - httpHeaderName
                                  - required:
                                    - httpCookie
                                  - required:
                                    - useSourceIp
                                  - required:
                                    - httpQueryParameterName
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                  - required:
                                    - ringHash
                                  - required:
                                    - maglev
                                properties:
                                  minimumRingSize: {}
                            required:
                            - consistentHash
                          properties:
                            consistentHash:
                              properties:
                                httpCookie:
                                  description: Hash based on HTTP cookie.
                                  properties:
                                    name:
                                      description: Name of the cookie.
                                      type: string
                                    path:
                                      description: Path to set for the cookie.
                                      type: string
                                    ttl:
                                      description: Lifetime of the cookie.
                                      type: string
                                  type: object
                                httpHeaderName:
                                  description: Hash based on a specific HTTP header.
                                  type: string
                                httpQueryParameterName:
                                  description: Hash based on a specific HTTP query
                                    parameter.
                                  type: string
                                maglev:
                                  description: The Maglev load balancer implements
                                    consistent hashing to backend hosts.
                                  properties:
                                    tableSize:
                                      description: The table size for Maglev hashing.
                                      type: integer
                                  type: object
                                minimumRingSize:
                                  description: Deprecated.
                                  type: integer
                                ringHash:
                                  description: The ring/modulo hash load balancer
                                    implements consistent hashing to backend hosts.
                                  properties:
                                    minimumRingSize:
                                      type: integer
                                  type: object
                                useSourceIp:
                                  description: Hash based on the source IP address.
                                  type: boolean
                              type: object
                            localityLbSetting:
                              properties:
                                distribute:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating locality, '/' separated,
                                          e.g.
                                        type: string
                                      to:
                                        additionalProperties:
                                          type: integer
                                        description: Map of upstream localities to
                                          traffic distribution weights.
                                        type: object
                                    type: object
                                  type: array
                                enabled:
                                  description: enable locality load balancing, this
                                    is DestinationRule-level and will override mesh
                                    wide settings in entirety.
                                  nullable: true
                                  type: boolean
                                failover:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating region.
                                        type: string
                                      to:
                                        type: string
                                    type: object
                                  type: array
                                failoverPriority:
                                  description: failoverPriority is an ordered list
                                    of labels used to sort endpoints to do priority
                                    based load balancing.
                                  items:
                                    type: string
                                  type: array
                              type: object
                            simple:
                              enum:
                              - UNSPECIFIED
                              - LEAST_CONN
                              - RANDOM
                              - PASSTHROUGH
                              - ROUND_ROBIN
                              - LEAST_REQUEST
                              type: string
                            warmupDurationSecs:
                              description: Represents the warmup duration of Service.
                              type: string
                          type: object
                        outlierDetection:
                          properties:
                            baseEjectionTime:
                              description: Minimum ejection duration.
                              type: string
                            consecutive5xxErrors:
                              description: Number of 5xx errors before a host is ejected
                                from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveErrors:
                              format: int32
                              type: integer
                            consecutiveGatewayErrors:
                              description: Number of gateway errors before a host
                                is ejected from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveLocalOriginFailures:
                              nullable: true
                              type: integer
                            interval:
                              description: Time interval between ejection sweep analysis.
                              type: string
                            maxEjectionPercent:
                              format: int32
                              type: integer
                            minHealthPercent:
                              format: int32
                              type: integer
                            splitExternalLocalOriginErrors:
                              description: Determines whether to distinguish local
                                origin failures from external errors.
                              type: boolean
                          type: object
                        portLevelSettings:
                          description: Traffic policies specific to individual ports.
                          items:
                            properties:
                              connectionPool:
                                properties:
                                  http:
                                    description: HTTP connection pool settings.
                                    properties:
                                      h2UpgradePolicy:
                                        description: Specify if http1.1 connection
                                          should be upgraded to http2 for the associated
                                          destination.
                                        enum:
                                        - DEFAULT
                                        - DO_NOT_UPGRADE
                                        - UPGRADE
                                        type: string
                                      http1MaxPendingRequests:
                                        format: int32
                                        type: integer
                                      http2MaxRequests:
                                        description: Maximum number of active requests
                                          to a destination.
                                        format: int32
                                        type: integer
                                      idleTimeout:
                                        description: The idle timeout for upstream
                                          connection pool connections.
                                        type: string
                                      maxRequestsPerConnection:
                                        description: Maximum number of requests per
                                          connection to a backend.
                                        format: int32
                                        type: integer
                                      maxRetries:
                                        format: int32
                                        type: integer
                                      useClientProtocol:
                                        description: If set to true, client protocol
                                          will be preserved while initiating connection
                                          to backend.
                                        type: boolean
                                    type: object
                                  tcp:
                                    description: Settings common to both HTTP and
                                      TCP upstream connections.
                                    properties:
                                      connectTimeout:
                                        description: TCP connection timeout.
                                        type: string
                                      maxConnectionDuration:
                                        description: The maximum duration of a connection.
                                        type: string
                                      maxConnections:
                                        description: Maximum number of HTTP1 /TCP
                                          connections to a destination host.
                                        format: int32
                                        type: integer
                                      tcpKeepalive:
                                        description: If set then set SO_KEEPALIVE
                                          on the socket to enable TCP Keepalives.
                                        properties:
                                          interval:
                                            description: The time duration between
                                              keep-alive probes.
                                            type: string
                                          probes:
                                            type: integer
                                          time:
                                            type: string
                                        type: object
                                    type: object
                                type: object
                              loadBalancer:
                                description: Settings controlling the load balancer
                                  algorithms.
                                oneOf:
                                - not:
                                    anyOf:
                                    - required:
                                      - simple
                                    - properties:
                                        consistentHash:
                                          allOf:
                                          - oneOf:
                                            - not:
                                                anyOf:
                                                - required:
                                                  - httpHeaderName
                                                - required:
                                                  - httpCookie
                                                - required:
                                                  - useSourceIp
                                                - required:
                                                  - httpQueryParameterName
                                            - required:
                                              - httpHeaderName
                                            - required:
                                              - httpCookie
                                            - required:
                                              - useSourceIp
                                            - required:
                                              - httpQueryParameterName
                                          - oneOf:
                                            - not:
                                                anyOf:
                                                - required:
                                                  - ringHash
                                                - required:
                                                  - maglev
                                            - required:
                                              - ringHash
                                            - required:
                                              - maglev
                                          properties:
                                            minimumRingSize: {}
                                      required:
                                      - consistentHash
                                - required:
                                  - simple
                                - properties:
                                    consistentHash:
                                      allOf:
                                      - oneOf:
                                        - not:
                                            anyOf:
                                            - required:
                                              - httpHeaderName
                                            - required:
                                              - httpCookie
                                            - required:
                                              - useSourceIp
                                            - required:
                                              - httpQueryParameterName
                                        - required:
                                          - httpHeaderName
                                        - required:
                                          - httpCookie
                                        - required:
                                          - useSourceIp
                                        - required:
                                          - httpQueryParameterName
                                      - oneOf:
                                        - not:
                                            anyOf:
                                            - required:
                                              - ringHash
                                            - required:
                                              - maglev
                                        - required:
                                          - ringHash
                                        - required:
                                          - maglev
                                      properties:
                                        minimumRingSize: {}
                                  required:
                                  - consistentHash
                                properties:
                                  consistentHash:
                                    properties:
                                      httpCookie:
                                        description: Hash based on HTTP cookie.
                                        properties:
                                          name:
                                            description: Name of the cookie.
                                            type: string
                                          path:
                                            description: Path to set for the cookie.
                                            type: string
                                          ttl:
                                            description: Lifetime of the cookie.
                                            type: string
                                        type: object
                                      httpHeaderName:
                                        description: Hash based on a specific HTTP
                                          header.
                                        type: string
                                      httpQueryParameterName:
                                        description: Hash based on a specific HTTP
                                          query parameter.
                                        type: string
                                      maglev:
                                        description: The Maglev load balancer implements
                                          consistent hashing to backend hosts.
                                        properties:
                                          tableSize:
                                            description: The table size for Maglev
                                              hashing.
                                            type: integer
                                        type: object
                                      minimumRingSize:
                                        description: Deprecated.
                                        type: integer
                                      ringHash:
                                        description: The ring/modulo hash load balancer
                                          implements consistent hashing to backend
                                          hosts.
                                        properties:
                                          minimumRingSize:
                                            type: integer
                                        type: object
                                      useSourceIp:
                                        description: Hash based on the source IP address.
                                        type: boolean
                                    type: object
                                  localityLbSetting:
                                    properties:
                                      distribute:
                                        description: 'Optional: only one of distribute,
                                          failover or failoverPriority can be set.'
                                        items:
                                          properties:
                                            from:
                                              description: Originating locality, '/'
                                                separated, e.g.
                                              type: string
                                            to:
                                              additionalProperties:
                                                type: integer
                                              description: Map of upstream localities
                                                to traffic distribution weights.
                                              type: object
                                          type: object
                                        type: array
                                      enabled:
                                        description: enable locality load balancing,
                                          this is DestinationRule-level and will override
                                          mesh wide settings in entirety.
                                        nullable: true
                                        type: boolean
                                      failover:
                                        description: 'Optional: only one of distribute,
                                          failover or failoverPriority can be set.'
                                        items:
                                          properties:
                                            from:
                                              description: Originating region.
                                              type: string
                                            to:
                                              type: string
                                          type: object
                                        type: array
                                      failoverPriority:
                                        description: failoverPriority is an ordered
                                          list of labels used to sort endpoints to
                                          do priority based load balancing.
                                        items:
                                          type: string
                                        type: array
                                    type: object
                                  simple:
                                    enum:
                                    - UNSPECIFIED
                                    - LEAST_CONN
                                    - RANDOM
                                    - PASSTHROUGH
                                    - ROUND_ROBIN
                                    - LEAST_REQUEST
                                    type: string
                                  warmupDurationSecs:
                                    description: Represents the warmup duration of
                                      Service.
                                    type: string
                                type: object
                              outlierDetection:
                                properties:
                                  baseEjectionTime:
                                    description: Minimum ejection duration.
                                    type: string
                                  consecutive5xxErrors:
                                    description: Number of 5xx errors before a host
                                      is ejected from the connection pool.
                                    nullable: true
                                    type: integer
                                  consecutiveErrors:
                                    format: int32
                                    type: integer
                                  consecutiveGatewayErrors:
                                    description: Number of gateway errors before a
                                      host is ejected from the connection pool.
                                    nullable: true
                                    type: integer
                                  consecutiveLocalOriginFailures:
                                    nullable: true
                                    type: integer
                                  interval:
                                    description: Time interval between ejection sweep
                                      analysis.
                                    type: string
                                  maxEjectionPercent:
                                    format: int32
                                    type: integer
                                  minHealthPercent:
                                    format: int32
                                    type: integer
                                  splitExternalLocalOriginErrors:
                                    description: Determines whether to distinguish
                                      local origin failures from external errors.
                                    type: boolean
                                type: object
                              port:
                                properties:
                                  number:
                                    type: integer
                                type: object
                              tls:
                                description: TLS related settings for connections
                                  to the upstream service.
                                properties:
                                  caCertificates:
                                    type: string
                                  clientCertificate:
                                    description: REQUIRED if mode is `MUTUAL`.
                                    type: string
                                  credentialName:
                                    type: string
                                  insecureSkipVerify:
                                    nullable: true
                                    type: boolean
                                  mode:
                                    enum:
                                    - DISABLE
                                    - SIMPLE
                                    - MUTUAL
                                    - ISTIO_MUTUAL
                                    type: string
                                  privateKey:
                                    description: REQUIRED if mode is `MUTUAL`.
                                    type: string
                                  sni:
                                    description: SNI string to present to the server
                                      during TLS handshake.
                                    type: string
                                  subjectAltNames:
                                    items:
                                      type: string
                                    type: array
                                type: object
                            type: object
                          type: array
                        tls:
                          description: TLS related settings for connections to the
                            upstream service.
                          properties:
                            caCertificates:
                              type: string
                            clientCertificate:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            credentialName:
                              type: string
                            insecureSkipVerify:
                              nullable: true
                              type: boolean
                            mode:
                              enum:
                              - DISABLE
                              - SIMPLE
                              - MUTUAL
                              - ISTIO_MUTUAL
                              type: string
                            privateKey:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            sni:
                              description: SNI string to present to the server during
                                TLS handshake.
                              type: string
                            subjectAltNames:
                              items:
                                type: string
                              type: array
                          type: object
                        tunnel:
                          properties:
                            protocol:
                              description: Specifies which protocol to use for tunneling
                                the downstream connection.
                              type: string
                            targetHost:
                              description: Specifies a host to which the downstream
                                connection is tunneled.
                              type: string
                            targetPort:
                              description: Specifies a port to which the downstream
                                connection is tunneled.
                              type: integer
                          type: object
                      type: object
                  type: object
                type: array
              trafficPolicy:
                properties:
                  connectionPool:
                    properties:
                      http:
                        description: HTTP connection pool settings.
                        properties:
                          h2UpgradePolicy:
                            description: Specify if http1.1 connection should be upgraded
                              to http2 for the associated destination.
                            enum:
                            - DEFAULT
                            - DO_NOT_UPGRADE
                            - UPGRADE
                            type: string
                          http1MaxPendingRequests:
                            format: int32
                            type: integer
                          http2MaxRequests:
                            description: Maximum number of active requests to a destination.
                            format: int32
                            type: integer
                          idleTimeout:
                            description: The idle timeout for upstream connection
                              pool connections.
                            type: string
                          maxRequestsPerConnection:
                            description: Maximum number of requests per connection
                              to a backend.
                            format: int32
                            type: integer
                          maxRetries:
                            format: int32
                            type: integer
                          useClientProtocol:
                            description: If set to true, client protocol will be preserved
                              while initiating connection to backend.
                            type: boolean
                        type: object
                      tcp:
                        description: Settings common to both HTTP and TCP upstream
                          connections.
                        properties:
                          connectTimeout:
                            description: TCP connection timeout.
                            type: string
                          maxConnectionDuration:
                            description: The maximum duration of a connection.
                            type: string
                          maxConnections:
                            description: Maximum number of HTTP1 /TCP connections
                              to a destination host.
                            format: int32
                            type: integer
                          tcpKeepalive:
                            description: If set then set SO_KEEPALIVE on the socket
                              to enable TCP Keepalives.
                            properties:
                              interval:
                                description: The time duration between keep-alive
                                  probes.
                                type: string
                              probes:
                                type: integer
                              time:
                                type: string
                            type: object
                        type: object
                    type: object
                  loadBalancer:
                    description: Settings controlling the load balancer algorithms.
                    oneOf:
                    - not:
                        anyOf:
                        - required:
                          - simple
                        - properties:
                            consistentHash:
                              allOf:
                              - oneOf:
                                - not:
                                    anyOf:
                                    - required:
                                      - httpHeaderName
                                    - required:
                                      - httpCookie
                                    - required:
                                      - useSourceIp
                                    - required:
                                      - httpQueryParameterName
                                - required:
                                  - httpHeaderName
                                - required:
                                  - httpCookie
                                - required:
                                  - useSourceIp
                                - required:
                                  - httpQueryParameterName
                              - oneOf:
                                - not:
                                    anyOf:
                                    - required:
                                      - ringHash
                                    - required:
                                      - maglev
                                - required:
                                  - ringHash
                                - required:
                                  - maglev
                              properties:
                                minimumRingSize: {}
                          required:
                          - consistentHash
                    - required:
                      - simple
                    - properties:
                        consistentHash:
                          allOf:
                          - oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - httpHeaderName
                                - required:
                                  - httpCookie
                                - required:
                                  - useSourceIp
                                - required:
                                  - httpQueryParameterName
                            - required:
                              - httpHeaderName
                            - required:
                              - httpCookie
                            - required:
                              - useSourceIp
                            - required:
                              - httpQueryParameterName
                          - oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - ringHash
                                - required:
                                  - maglev
                            - required:
                              - ringHash
                            - required:
                              - maglev
                          properties:
                            minimumRingSize: {}
                      required:
                      - consistentHash
                    properties:
                      consistentHash:
                        properties:
                          httpCookie:
                            description: Hash based on HTTP cookie.
                            properties:
                              name:
                                description: Name of the cookie.
                                type: string
                              path:
                                description: Path to set for the cookie.
                                type: string
                              ttl:
                                description: Lifetime of the cookie.
                                type: string
                            type: object
                          httpHeaderName:
                            description: Hash based on a specific HTTP header.
                            type: string
                          httpQueryParameterName:
                            description: Hash based on a specific HTTP query parameter.
                            type: string
                          maglev:
                            description: The Maglev load balancer implements consistent
                              hashing to backend hosts.
                            properties:
                              tableSize:
                                description: The table size for Maglev hashing.
                                type: integer
                            type: object
                          minimumRingSize:
                            description: Deprecated.
                            type: integer
                          ringHash:
                            description: The ring/modulo hash load balancer implements
                              consistent hashing to backend hosts.
                            properties:
                              minimumRingSize:
                                type: integer
                            type: object
                          useSourceIp:
                            description: Hash based on the source IP address.
                            type: boolean
                        type: object
                      localityLbSetting:
                        properties:
                          distribute:
                            description: 'Optional: only one of distribute, failover
                              or failoverPriority can be set.'
                            items:
                              properties:
                                from:
                                  description: Originating locality, '/' separated,
                                    e.g.
                                  type: string
                                to:
                                  additionalProperties:
                                    type: integer
                                  description: Map of upstream localities to traffic
                                    distribution weights.
                                  type: object
                              type: object
                            type: array
                          enabled:
                            description: enable locality load balancing, this is DestinationRule-level
                              and will override mesh wide settings in entirety.
                            nullable: true
                            type: boolean
                          failover:
                            description: 'Optional: only one of distribute, failover
                              or failoverPriority can be set.'
                            items:
                              properties:
                                from:
                                  description: Originating region.
                                  type: string
                                to:
                                  type: string
                              type: object
                            type: array
                          failoverPriority:
                            description: failoverPriority is an ordered list of labels
                              used to sort endpoints to do priority based load balancing.
                            items:
                              type: string
                            type: array
                        type: object
                      simple:
                        enum:
                        - UNSPECIFIED
                        - LEAST_CONN
                        - RANDOM
                        - PASSTHROUGH
                        - ROUND_ROBIN
                        - LEAST_REQUEST
                        type: string
                      warmupDurationSecs:
                        description: Represents the warmup duration of Service.
                        type: string
                    type: object
                  outlierDetection:
                    properties:
                      baseEjectionTime:
                        description: Minimum ejection duration.
                        type: string
                      consecutive5xxErrors:
                        description: Number of 5xx errors before a host is ejected
                          from the connection pool.
                        nullable: true
                        type: integer
                      consecutiveErrors:
                        format: int32
                        type: integer
                      consecutiveGatewayErrors:
                        description: Number of gateway errors before a host is ejected
                          from the connection pool.
                        nullable: true
                        type: integer
                      consecutiveLocalOriginFailures:
                        nullable: true
                        type: integer
                      interval:
                        description: Time interval between ejection sweep analysis.
                        type: string
                      maxEjectionPercent:
                        format: int32
                        type: integer
                      minHealthPercent:
                        format: int32
                        type: integer
                      splitExternalLocalOriginErrors:
                        description: Determines whether to distinguish local origin
                          failures from external errors.
                        type: boolean
                    type: object
                  portLevelSettings:
                    description: Traffic policies specific to individual ports.
                    items:
                      properties:
                        connectionPool:
                          properties:
                            http:
                              description: HTTP connection pool settings.
                              properties:
                                h2UpgradePolicy:
                                  description: Specify if http1.1 connection should
                                    be upgraded to http2 for the associated destination.
                                  enum:
                                  - DEFAULT
                                  - DO_NOT_UPGRADE
                                  - UPGRADE
                                  type: string
                                http1MaxPendingRequests:
                                  format: int32
                                  type: integer
                                http2MaxRequests:
                                  description: Maximum number of active requests to
                                    a destination.
                                  format: int32
                                  type: integer
                                idleTimeout:
                                  description: The idle timeout for upstream connection
                                    pool connections.
                                  type: string
                                maxRequestsPerConnection:
                                  description: Maximum number of requests per connection
                                    to a backend.
                                  format: int32
                                  type: integer
                                maxRetries:
                                  format: int32
                                  type: integer
                                useClientProtocol:
                                  description: If set to true, client protocol will
                                    be preserved while initiating connection to backend.
                                  type: boolean
                              type: object
                            tcp:
                              description: Settings common to both HTTP and TCP upstream
                                connections.
                              properties:
                                connectTimeout:
                                  description: TCP connection timeout.
                                  type: string
                                maxConnectionDuration:
                                  description: The maximum duration of a connection.
                                  type: string
                                maxConnections:
                                  description: Maximum number of HTTP1 /TCP connections
                                    to a destination host.
                                  format: int32
                                  type: integer
                                tcpKeepalive:
                                  description: If set then set SO_KEEPALIVE on the
                                    socket to enable TCP Keepalives.
                                  properties:
                                    interval:
                                      description: The time duration between keep-alive
                                        probes.
                                      type: string
                                    probes:
                                      type: integer
                                    time:
                                      type: string
                                  type: object
                              type: object
                          type: object
                        loadBalancer:
                          description: Settings controlling the load balancer algorithms.
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - simple
                              - properties:
                                  consistentHash:
                                    allOf:
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - httpHeaderName
                                          - required:
                                            - httpCookie
                                          - required:
                                            - useSourceIp
                                          - required:
                                            - httpQueryParameterName
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                    - oneOf:
                                      - not:
                                          anyOf:
                                          - required:
                                            - ringHash
                                          - required:
                                            - maglev
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                    properties:
                                      minimumRingSize: {}
                                required:
                                - consistentHash
                          - required:
                            - simple
                          - properties:
                              consistentHash:
                                allOf:
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - httpHeaderName
                                      - required:
                                        - httpCookie
                                      - required:
                                        - useSourceIp
                                      - required:
                                        - httpQueryParameterName
                                  - required:
                                    - httpHeaderName
                                  - required:
                                    - httpCookie
                                  - required:
                                    - useSourceIp
                                  - required:
                                    - httpQueryParameterName
                                - oneOf:
                                  - not:
                                      anyOf:
                                      - required:
                                        - ringHash
                                      - required:
                                        - maglev
                                  - required:
                                    - ringHash
                                  - required:
                                    - maglev
                                properties:
                                  minimumRingSize: {}
                            required:
                            - consistentHash
                          properties:
                            consistentHash:
                              properties:
                                httpCookie:
                                  description: Hash based on HTTP cookie.
                                  properties:
                                    name:
                                      description: Name of the cookie.
                                      type: string
                                    path:
                                      description: Path to set for the cookie.
                                      type: string
                                    ttl:
                                      description: Lifetime of the cookie.
                                      type: string
                                  type: object
                                httpHeaderName:
                                  description: Hash based on a specific HTTP header.
                                  type: string
                                httpQueryParameterName:
                                  description: Hash based on a specific HTTP query
                                    parameter.
                                  type: string
                                maglev:
                                  description: The Maglev load balancer implements
                                    consistent hashing to backend hosts.
                                  properties:
                                    tableSize:
                                      description: The table size for Maglev hashing.
                                      type: integer
                                  type: object
                                minimumRingSize:
                                  description: Deprecated.
                                  type: integer
                                ringHash:
                                  description: The ring/modulo hash load balancer
                                    implements consistent hashing to backend hosts.
                                  properties:
                                    minimumRingSize:
                                      type: integer
                                  type: object
                                useSourceIp:
                                  description: Hash based on the source IP address.
                                  type: boolean
                              type: object
                            localityLbSetting:
                              properties:
                                distribute:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating locality, '/' separated,
                                          e.g.
                                        type: string
                                      to:
                                        additionalProperties:
                                          type: integer
                                        description: Map of upstream localities to
                                          traffic distribution weights.
                                        type: object
                                    type: object
                                  type: array
                                enabled:
                                  description: enable locality load balancing, this
                                    is DestinationRule-level and will override mesh
                                    wide settings in entirety.
                                  nullable: true
                                  type: boolean
                                failover:
                                  description: 'Optional: only one of distribute,
                                    failover or failoverPriority can be set.'
                                  items:
                                    properties:
                                      from:
                                        description: Originating region.
                                        type: string
                                      to:
                                        type: string
                                    type: object
                                  type: array
                                failoverPriority:
                                  description: failoverPriority is an ordered list
                                    of labels used to sort endpoints to do priority
                                    based load balancing.
                                  items:
                                    type: string
                                  type: array
                              type: object
                            simple:
                              enum:
                              - UNSPECIFIED
                              - LEAST_CONN
                              - RANDOM
                              - PASSTHROUGH
                              - ROUND_ROBIN
                              - LEAST_REQUEST
                              type: string
                            warmupDurationSecs:
                              description: Represents the warmup duration of Service.
                              type: string
                          type: object
                        outlierDetection:
                          properties:
                            baseEjectionTime:
                              description: Minimum ejection duration.
                              type: string
                            consecutive5xxErrors:
                              description: Number of 5xx errors before a host is ejected
                                from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveErrors:
                              format: int32
                              type: integer
                            consecutiveGatewayErrors:
                              description: Number of gateway errors before a host
                                is ejected from the connection pool.
                              nullable: true
                              type: integer
                            consecutiveLocalOriginFailures:
                              nullable: true
                              type: integer
                            interval:
                              description: Time interval between ejection sweep analysis.
                              type: string
                            maxEjectionPercent:
                              format: int32
                              type: integer
                            minHealthPercent:
                              format: int32
                              type: integer
                            splitExternalLocalOriginErrors:
                              description: Determines whether to distinguish local
                                origin failures from external errors.
                              type: boolean
                          type: object
                        port:
                          properties:
                            number:
                              type: integer
                          type: object
                        tls:
                          description: TLS related settings for connections to the
                            upstream service.
                          properties:
                            caCertificates:
                              type: string
                            clientCertificate:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            credentialName:
                              type: string
                            insecureSkipVerify:
                              nullable: true
                              type: boolean
                            mode:
                              enum:
                              - DISABLE
                              - SIMPLE
                              - MUTUAL
                              - ISTIO_MUTUAL
                              type: string
                            privateKey:
                              description: REQUIRED if mode is `MUTUAL`.
                              type: string
                            sni:
                              description: SNI string to present to the server during
                                TLS handshake.
                              type: string
                            subjectAltNames:
                              items:
                                type: string
                              type: array
                          type: object
                      type: object
                    type: array
                  tls:
                    description: TLS related settings for connections to the upstream
                      service.
                    properties:
                      caCertificates:
                        type: string
                      clientCertificate:
                        description: REQUIRED if mode is `MUTUAL`.
                        type: string
                      credentialName:
                        type: string
                      insecureSkipVerify:
                        nullable: true
                        type: boolean
                      mode:
                        enum:
                        - DISABLE
                        - SIMPLE
                        - MUTUAL
                        - ISTIO_MUTUAL
                        type: string
                      privateKey:
                        description: REQUIRED if mode is `MUTUAL`.
                        type: string
                      sni:
                        description: SNI string to present to the server during TLS
                          handshake.
                        type: string
                      subjectAltNames:
                        items:
                          type: string
                        type: array
                    type: object
                  tunnel:
                    properties:
                      protocol:
                        description: Specifies which protocol to use for tunneling
                          the downstream connection.
                        type: string
                      targetHost:
                        description: Specifies a host to which the downstream connection
                          is tunneled.
                        type: string
                      targetPort:
                        description: Specifies a port to which the downstream connection
                          is tunneled.
                        type: integer
                    type: object
                type: object
              workloadSelector:
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-envoyfilters" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: envoyfilters.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: EnvoyFilter
    listKind: EnvoyFilterList
    plural: envoyfilters
    singular: envoyfilter
  scope: Namespaced
  versions:
  - name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Customizing Envoy configuration generated by Istio. See
              more details at: https://istio.io/docs/reference/config/networking/envoy-filter.html'
            properties:
              configPatches:
                description: One or more patches with match conditions.
                items:
                  properties:
                    applyTo:
                      enum:
                      - INVALID
                      - LISTENER
                      - FILTER_CHAIN
                      - NETWORK_FILTER
                      - HTTP_FILTER
                      - ROUTE_CONFIGURATION
                      - VIRTUAL_HOST
                      - HTTP_ROUTE
                      - CLUSTER
                      - EXTENSION_CONFIG
                      - BOOTSTRAP
                      type: string
                    match:
                      description: Match on listener/route configuration/cluster.
                      oneOf:
                      - not:
                          anyOf:
                          - required:
                            - listener
                          - required:
                            - routeConfiguration
                          - required:
                            - cluster
                      - required:
                        - listener
                      - required:
                        - routeConfiguration
                      - required:
                        - cluster
                      properties:
                        cluster:
                          description: Match on envoy cluster attributes.
                          properties:
                            name:
                              description: The exact name of the cluster to match.
                              type: string
                            portNumber:
                              description: The service port for which this cluster
                                was generated.
                              type: integer
                            service:
                              description: The fully qualified service name for this
                                cluster.
                              type: string
                            subset:
                              description: The subset associated with the service.
                              type: string
                          type: object
                        context:
                          description: The specific config generation context to match
                            on.
                          enum:
                          - ANY
                          - SIDECAR_INBOUND
                          - SIDECAR_OUTBOUND
                          - GATEWAY
                          type: string
                        listener:
                          description: Match on envoy listener attributes.
                          properties:
                            filterChain:
                              description: Match a specific filter chain in a listener.
                              properties:
                                applicationProtocols:
                                  description: Applies only to sidecars.
                                  type: string
                                destinationPort:
                                  description: The destination_port value used by
                                    a filter chain's match condition.
                                  type: integer
                                filter:
                                  description: The name of a specific filter to apply
                                    the patch to.
                                  properties:
                                    name:
                                      description: The filter name to match on.
                                      type: string
                                    subFilter:
                                      properties:
                                        name:
                                          description: The filter name to match on.
                                          type: string
                                      type: object
                                  type: object
                                name:
                                  description: The name assigned to the filter chain.
                                  type: string
                                sni:
                                  description: The SNI value used by a filter chain's
                                    match condition.
                                  type: string
                                transportProtocol:
                                  description: Applies only to `SIDECAR_INBOUND` context.
                                  type: string
                              type: object
                            name:
                              description: Match a specific listener by its name.
                              type: string
                            portName:
                              type: string
                            portNumber:
                              type: integer
                          type: object
                        proxy:
                          description: Match on properties associated with a proxy.
                          properties:
                            metadata:
                              additionalProperties:
                                type: string
                              type: object
                            proxyVersion:
                              type: string
                          type: object
                        routeConfiguration:
                          description: Match on envoy HTTP route configuration attributes.
                          properties:
                            gateway:
                              type: string
                            name:
                              description: Route configuration name to match on.
                              type: string
                            portName:
                              description: Applicable only for GATEWAY context.
                              type: string
                            portNumber:
                              type: integer
                            vhost:
                              properties:
                                name:
                                  type: string
                                route:
                                  description: Match a specific route within the virtual
                                    host.
                                  properties:
                                    action:
                                      description: Match a route with specific action
                                        type.
                                      enum:
                                      - ANY
                                      - ROUTE
                                      - REDIRECT
                                      - DIRECT_RESPONSE
                                      type: string
                                    name:
                                      type: string
                                  type: object
                              type: object
                          type: object
                      type: object
                    patch:
                      description: The patch to apply along with the operation.
                      properties:
                        filterClass:
                          description: Determines the filter insertion order.
                          enum:
                          - UNSPECIFIED
                          - AUTHN
                          - AUTHZ
                          - STATS
                          type: string
                        operation:
                          description: Determines how the patch should be applied.
                          enum:
                          - INVALID
                          - MERGE
                          - ADD
                          - REMOVE
                          - INSERT_BEFORE
                          - INSERT_AFTER
                          - INSERT_FIRST
                          - REPLACE
                          type: string
                        value:
                          description: The JSON config of the object being patched.
                          type: object
                          x-kubernetes-preserve-unknown-fields: true
                      type: object
                  type: object
                type: array
              priority:
                description: Priority defines the order in which patch sets are applied
                  within a context.
                format: int32
                type: integer
              workloadSelector:
                properties:
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-gateways" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: gateways.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: Gateway
    listKind: GatewayList
    plural: gateways
    shortNames:
    - gw
    singular: gateway
  scope: Namespaced
  versions:
  - name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting edge load balancer. See more details
              at: https://istio.io/docs/reference/config/networking/gateway.html'
            properties:
              selector:
                additionalProperties:
                  type: string
                type: object
              servers:
                description: A list of server specifications.
                items:
                  properties:
                    bind:
                      type: string
                    defaultEndpoint:
                      type: string
                    hosts:
                      description: One or more hosts exposed by this gateway.
                      items:
                        type: string
                      type: array
                    name:
                      description: An optional name of the server, when set must be
                        unique across all servers.
                      type: string
                    port:
                      properties:
                        name:
                          description: Label assigned to the port.
                          type: string
                        number:
                          description: A valid non-negative integer port number.
                          type: integer
                        protocol:
                          description: The protocol exposed on the port.
                          type: string
                        targetPort:
                          type: integer
                      type: object
                    tls:
                      description: Set of TLS related options that govern the server's
                        behavior.
                      properties:
                        caCertificates:
                          description: REQUIRED if mode is `MUTUAL`.
                          type: string
                        cipherSuites:
                          description: 'Optional: If specified, only support the specified
                            cipher list.'
                          items:
                            type: string
                          type: array
                        credentialName:
                          type: string
                        httpsRedirect:
                          type: boolean
                        maxProtocolVersion:
                          description: 'Optional: Maximum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        minProtocolVersion:
                          description: 'Optional: Minimum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        mode:
                          enum:
                          - PASSTHROUGH
                          - SIMPLE
                          - MUTUAL
                          - AUTO_PASSTHROUGH
                          - ISTIO_MUTUAL
                          type: string
                        privateKey:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        serverCertificate:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        subjectAltNames:
                          items:
                            type: string
                          type: array
                        verifyCertificateHash:
                          items:
                            type: string
                          type: array
                        verifyCertificateSpki:
                          items:
                            type: string
                          type: array
                      type: object
                  type: object
                type: array
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting edge load balancer. See more details
              at: https://istio.io/docs/reference/config/networking/gateway.html'
            properties:
              selector:
                additionalProperties:
                  type: string
                type: object
              servers:
                description: A list of server specifications.
                items:
                  properties:
                    bind:
                      type: string
                    defaultEndpoint:
                      type: string
                    hosts:
                      description: One or more hosts exposed by this gateway.
                      items:
                        type: string
                      type: array
                    name:
                      description: An optional name of the server, when set must be
                        unique across all servers.
                      type: string
                    port:
                      properties:
                        name:
                          description: Label assigned to the port.
                          type: string
                        number:
                          description: A valid non-negative integer port number.
                          type: integer
                        protocol:
                          description: The protocol exposed on the port.
                          type: string
                        targetPort:
                          type: integer
                      type: object
                    tls:
                      description: Set of TLS related options that govern the server's
                        behavior.
                      properties:
                        caCertificates:
                          description: REQUIRED if mode is `MUTUAL`.
                          type: string
                        cipherSuites:
                          description: 'Optional: If specified, only support the specified
                            cipher list.'
                          items:
                            type: string
                          type: array
                        credentialName:
                          type: string
                        httpsRedirect:
                          type: boolean
                        maxProtocolVersion:
                          description: 'Optional: Maximum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        minProtocolVersion:
                          description: 'Optional: Minimum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        mode:
                          enum:
                          - PASSTHROUGH
                          - SIMPLE
                          - MUTUAL
                          - AUTO_PASSTHROUGH
                          - ISTIO_MUTUAL
                          type: string
                        privateKey:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        serverCertificate:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        subjectAltNames:
                          items:
                            type: string
                          type: array
                        verifyCertificateHash:
                          items:
                            type: string
                          type: array
                        verifyCertificateSpki:
                          items:
                            type: string
                          type: array
                      type: object
                  type: object
                type: array
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-istiooperators" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    release: istio
  name: istiooperators.install.istio.io
spec:
  conversion:
    strategy: None
  group: install.istio.io
  names:
    kind: IstioOperator
    listKind: IstioOperatorList
    plural: istiooperators
    shortNames:
    - iop
    - io
    singular: istiooperator
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Istio control plane revision
      jsonPath: .spec.revision
      name: Revision
      type: string
    - description: IOP current state
      jsonPath: .status.status
      name: Status
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha1
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-peerauthentications" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    istio: security
    release: istio
  name: peerauthentications.security.istio.io
spec:
  group: security.istio.io
  names:
    categories:
    - istio-io
    - security-istio-io
    kind: PeerAuthentication
    listKind: PeerAuthenticationList
    plural: peerauthentications
    shortNames:
    - pa
    singular: peerauthentication
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Defines the mTLS mode used for peer authentication.
      jsonPath: .spec.mtls.mode
      name: Mode
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: PeerAuthentication defines how traffic will be tunneled (or
              not) to the sidecar.
            properties:
              mtls:
                description: Mutual TLS settings for workload.
                properties:
                  mode:
                    description: Defines the mTLS mode used for peer authentication.
                    enum:
                    - UNSET
                    - DISABLE
                    - PERMISSIVE
                    - STRICT
                    type: string
                type: object
              portLevelMtls:
                additionalProperties:
                  properties:
                    mode:
                      description: Defines the mTLS mode used for peer authentication.
                      enum:
                      - UNSET
                      - DISABLE
                      - PERMISSIVE
                      - STRICT
                      type: string
                  type: object
                description: Port specific mutual TLS settings.
                type: object
              selector:
                description: The selector determines the workloads to apply the ChannelAuthentication
                  on.
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-proxyconfigs" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: proxyconfigs.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: ProxyConfig
    listKind: ProxyConfigList
    plural: proxyconfigs
    singular: proxyconfig
  scope: Namespaced
  versions:
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Provides configuration for individual workloads. See more
              details at: https://istio.io/docs/reference/config/networking/proxy-config.html'
            properties:
              concurrency:
                description: The number of worker threads to run.
                nullable: true
                type: integer
              environmentVariables:
                additionalProperties:
                  type: string
                description: Additional environment variables for the proxy.
                type: object
              image:
                description: Specifies the details of the proxy image.
                properties:
                  imageType:
                    description: The image type of the image.
                    type: string
                type: object
              selector:
                description: Optional.
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-requestauthentications" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    istio: security
    release: istio
  name: requestauthentications.security.istio.io
spec:
  group: security.istio.io
  names:
    categories:
    - istio-io
    - security-istio-io
    kind: RequestAuthentication
    listKind: RequestAuthenticationList
    plural: requestauthentications
    shortNames:
    - ra
    singular: requestauthentication
  scope: Namespaced
  versions:
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: RequestAuthentication defines what request authentication
              methods are supported by a workload.
            properties:
              jwtRules:
                description: Define the list of JWTs that can be validated at the
                  selected workloads' proxy.
                items:
                  properties:
                    audiences:
                      items:
                        type: string
                      type: array
                    forwardOriginalToken:
                      description: If set to true, the original token will be kept
                        for the upstream request.
                      type: boolean
                    fromHeaders:
                      description: List of header locations from which JWT is expected.
                      items:
                        properties:
                          name:
                            description: The HTTP header name.
                            type: string
                          prefix:
                            description: The prefix that should be stripped before
                              decoding the token.
                            type: string
                        type: object
                      type: array
                    fromParams:
                      description: List of query parameters from which JWT is expected.
                      items:
                        type: string
                      type: array
                    issuer:
                      description: Identifies the issuer that issued the JWT.
                      type: string
                    jwks:
                      description: JSON Web Key Set of public keys to validate signature
                        of the JWT.
                      type: string
                    jwks_uri:
                      type: string
                    jwksUri:
                      type: string
                    outputPayloadToHeader:
                      type: string
                  type: object
                type: array
              selector:
                description: Optional.
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-serviceentries" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: serviceentries.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: ServiceEntry
    listKind: ServiceEntryList
    plural: serviceentries
    shortNames:
    - se
    singular: serviceentry
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: The hosts associated with the ServiceEntry
      jsonPath: .spec.hosts
      name: Hosts
      type: string
    - description: Whether the service is external to the mesh or part of the mesh
        (MESH_EXTERNAL or MESH_INTERNAL)
      jsonPath: .spec.location
      name: Location
      type: string
    - description: Service discovery mode for the hosts (NONE, STATIC, or DNS)
      jsonPath: .spec.resolution
      name: Resolution
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting service registry. See more details
              at: https://istio.io/docs/reference/config/networking/service-entry.html'
            properties:
              addresses:
                description: The virtual IP addresses associated with the service.
                items:
                  type: string
                type: array
              endpoints:
                description: One or more endpoints associated with the service.
                items:
                  properties:
                    address:
                      type: string
                    labels:
                      additionalProperties:
                        type: string
                      description: One or more labels associated with the endpoint.
                      type: object
                    locality:
                      description: The locality associated with the endpoint.
                      type: string
                    network:
                      type: string
                    ports:
                      additionalProperties:
                        type: integer
                      description: Set of ports associated with the endpoint.
                      type: object
                    serviceAccount:
                      type: string
                    weight:
                      description: The load balancing weight associated with the endpoint.
                      type: integer
                  type: object
                type: array
              exportTo:
                description: A list of namespaces to which this service is exported.
                items:
                  type: string
                type: array
              hosts:
                description: The hosts associated with the ServiceEntry.
                items:
                  type: string
                type: array
              location:
                enum:
                - MESH_EXTERNAL
                - MESH_INTERNAL
                type: string
              ports:
                description: The ports associated with the external service.
                items:
                  properties:
                    name:
                      description: Label assigned to the port.
                      type: string
                    number:
                      description: A valid non-negative integer port number.
                      type: integer
                    protocol:
                      description: The protocol exposed on the port.
                      type: string
                    targetPort:
                      type: integer
                  type: object
                type: array
              resolution:
                description: Service discovery mode for the hosts.
                enum:
                - NONE
                - STATIC
                - DNS
                - DNS_ROUND_ROBIN
                type: string
              subjectAltNames:
                items:
                  type: string
                type: array
              workloadSelector:
                description: Applicable only for MESH_INTERNAL services.
                properties:
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - additionalPrinterColumns:
    - description: The hosts associated with the ServiceEntry
      jsonPath: .spec.hosts
      name: Hosts
      type: string
    - description: Whether the service is external to the mesh or part of the mesh
        (MESH_EXTERNAL or MESH_INTERNAL)
      jsonPath: .spec.location
      name: Location
      type: string
    - description: Service discovery mode for the hosts (NONE, STATIC, or DNS)
      jsonPath: .spec.resolution
      name: Resolution
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting service registry. See more details
              at: https://istio.io/docs/reference/config/networking/service-entry.html'
            properties:
              addresses:
                description: The virtual IP addresses associated with the service.
                items:
                  type: string
                type: array
              endpoints:
                description: One or more endpoints associated with the service.
                items:
                  properties:
                    address:
                      type: string
                    labels:
                      additionalProperties:
                        type: string
                      description: One or more labels associated with the endpoint.
                      type: object
                    locality:
                      description: The locality associated with the endpoint.
                      type: string
                    network:
                      type: string
                    ports:
                      additionalProperties:
                        type: integer
                      description: Set of ports associated with the endpoint.
                      type: object
                    serviceAccount:
                      type: string
                    weight:
                      description: The load balancing weight associated with the endpoint.
                      type: integer
                  type: object
                type: array
              exportTo:
                description: A list of namespaces to which this service is exported.
                items:
                  type: string
                type: array
              hosts:
                description: The hosts associated with the ServiceEntry.
                items:
                  type: string
                type: array
              location:
                enum:
                - MESH_EXTERNAL
                - MESH_INTERNAL
                type: string
              ports:
                description: The ports associated with the external service.
                items:
                  properties:
                    name:
                      description: Label assigned to the port.
                      type: string
                    number:
                      description: A valid non-negative integer port number.
                      type: integer
                    protocol:
                      description: The protocol exposed on the port.
                      type: string
                    targetPort:
                      type: integer
                  type: object
                type: array
              resolution:
                description: Service discovery mode for the hosts.
                enum:
                - NONE
                - STATIC
                - DNS
                - DNS_ROUND_ROBIN
                type: string
              subjectAltNames:
                items:
                  type: string
                type: array
              workloadSelector:
                description: Applicable only for MESH_INTERNAL services.
                properties:
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-sidecars" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: sidecars.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: Sidecar
    listKind: SidecarList
    plural: sidecars
    singular: sidecar
  scope: Namespaced
  versions:
  - name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting network reachability of a sidecar.
              See more details at: https://istio.io/docs/reference/config/networking/sidecar.html'
            properties:
              egress:
                items:
                  properties:
                    bind:
                      type: string
                    captureMode:
                      enum:
                      - DEFAULT
                      - IPTABLES
                      - NONE
                      type: string
                    hosts:
                      items:
                        type: string
                      type: array
                    port:
                      description: The port associated with the listener.
                      properties:
                        name:
                          description: Label assigned to the port.
                          type: string
                        number:
                          description: A valid non-negative integer port number.
                          type: integer
                        protocol:
                          description: The protocol exposed on the port.
                          type: string
                        targetPort:
                          type: integer
                      type: object
                  type: object
                type: array
              ingress:
                items:
                  properties:
                    bind:
                      description: The IP(IPv4 or IPv6) to which the listener should
                        be bound.
                      type: string
                    captureMode:
                      enum:
                      - DEFAULT
                      - IPTABLES
                      - NONE
                      type: string
                    defaultEndpoint:
                      type: string
                    port:
                      description: The port associated with the listener.
                      properties:
                        name:
                          description: Label assigned to the port.
                          type: string
                        number:
                          description: A valid non-negative integer port number.
                          type: integer
                        protocol:
                          description: The protocol exposed on the port.
                          type: string
                        targetPort:
                          type: integer
                      type: object
                    tls:
                      properties:
                        caCertificates:
                          description: REQUIRED if mode is `MUTUAL`.
                          type: string
                        cipherSuites:
                          description: 'Optional: If specified, only support the specified
                            cipher list.'
                          items:
                            type: string
                          type: array
                        credentialName:
                          type: string
                        httpsRedirect:
                          type: boolean
                        maxProtocolVersion:
                          description: 'Optional: Maximum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        minProtocolVersion:
                          description: 'Optional: Minimum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        mode:
                          enum:
                          - PASSTHROUGH
                          - SIMPLE
                          - MUTUAL
                          - AUTO_PASSTHROUGH
                          - ISTIO_MUTUAL
                          type: string
                        privateKey:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        serverCertificate:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        subjectAltNames:
                          items:
                            type: string
                          type: array
                        verifyCertificateHash:
                          items:
                            type: string
                          type: array
                        verifyCertificateSpki:
                          items:
                            type: string
                          type: array
                      type: object
                  type: object
                type: array
              outboundTrafficPolicy:
                description: Configuration for the outbound traffic policy.
                properties:
                  egressProxy:
                    properties:
                      host:
                        description: The name of a service from the service registry.
                        type: string
                      port:
                        description: Specifies the port on the host that is being
                          addressed.
                        properties:
                          number:
                            type: integer
                        type: object
                      subset:
                        description: The name of a subset within the service.
                        type: string
                    type: object
                  mode:
                    enum:
                    - REGISTRY_ONLY
                    - ALLOW_ANY
                    type: string
                type: object
              workloadSelector:
                properties:
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting network reachability of a sidecar.
              See more details at: https://istio.io/docs/reference/config/networking/sidecar.html'
            properties:
              egress:
                items:
                  properties:
                    bind:
                      type: string
                    captureMode:
                      enum:
                      - DEFAULT
                      - IPTABLES
                      - NONE
                      type: string
                    hosts:
                      items:
                        type: string
                      type: array
                    port:
                      description: The port associated with the listener.
                      properties:
                        name:
                          description: Label assigned to the port.
                          type: string
                        number:
                          description: A valid non-negative integer port number.
                          type: integer
                        protocol:
                          description: The protocol exposed on the port.
                          type: string
                        targetPort:
                          type: integer
                      type: object
                  type: object
                type: array
              ingress:
                items:
                  properties:
                    bind:
                      description: The IP(IPv4 or IPv6) to which the listener should
                        be bound.
                      type: string
                    captureMode:
                      enum:
                      - DEFAULT
                      - IPTABLES
                      - NONE
                      type: string
                    defaultEndpoint:
                      type: string
                    port:
                      description: The port associated with the listener.
                      properties:
                        name:
                          description: Label assigned to the port.
                          type: string
                        number:
                          description: A valid non-negative integer port number.
                          type: integer
                        protocol:
                          description: The protocol exposed on the port.
                          type: string
                        targetPort:
                          type: integer
                      type: object
                    tls:
                      properties:
                        caCertificates:
                          description: REQUIRED if mode is `MUTUAL`.
                          type: string
                        cipherSuites:
                          description: 'Optional: If specified, only support the specified
                            cipher list.'
                          items:
                            type: string
                          type: array
                        credentialName:
                          type: string
                        httpsRedirect:
                          type: boolean
                        maxProtocolVersion:
                          description: 'Optional: Maximum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        minProtocolVersion:
                          description: 'Optional: Minimum TLS protocol version.'
                          enum:
                          - TLS_AUTO
                          - TLSV1_0
                          - TLSV1_1
                          - TLSV1_2
                          - TLSV1_3
                          type: string
                        mode:
                          enum:
                          - PASSTHROUGH
                          - SIMPLE
                          - MUTUAL
                          - AUTO_PASSTHROUGH
                          - ISTIO_MUTUAL
                          type: string
                        privateKey:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        serverCertificate:
                          description: REQUIRED if mode is `SIMPLE` or `MUTUAL`.
                          type: string
                        subjectAltNames:
                          items:
                            type: string
                          type: array
                        verifyCertificateHash:
                          items:
                            type: string
                          type: array
                        verifyCertificateSpki:
                          items:
                            type: string
                          type: array
                      type: object
                  type: object
                type: array
              outboundTrafficPolicy:
                description: Configuration for the outbound traffic policy.
                properties:
                  egressProxy:
                    properties:
                      host:
                        description: The name of a service from the service registry.
                        type: string
                      port:
                        description: Specifies the port on the host that is being
                          addressed.
                        properties:
                          number:
                            type: integer
                        type: object
                      subset:
                        description: The name of a subset within the service.
                        type: string
                    type: object
                  mode:
                    enum:
                    - REGISTRY_ONLY
                    - ALLOW_ANY
                    type: string
                type: object
              workloadSelector:
                properties:
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-telemetries" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    istio: telemetry
    release: istio
  name: telemetries.telemetry.istio.io
spec:
  group: telemetry.istio.io
  names:
    categories:
    - istio-io
    - telemetry-istio-io
    kind: Telemetry
    listKind: TelemetryList
    plural: telemetries
    shortNames:
    - telemetry
    singular: telemetry
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Telemetry configuration for workloads. See more details
              at: https://istio.io/docs/reference/config/telemetry.html'
            properties:
              accessLogging:
                description: Optional.
                items:
                  properties:
                    disabled:
                      description: Controls logging.
                      nullable: true
                      type: boolean
                    filter:
                      description: Optional.
                      properties:
                        expression:
                          description: CEL expression for selecting when requests/connections
                            should be logged.
                          type: string
                      type: object
                    match:
                      description: Allows tailoring of logging behavior to specific
                        conditions.
                      properties:
                        mode:
                          enum:
                          - CLIENT_AND_SERVER
                          - CLIENT
                          - SERVER
                          type: string
                      type: object
                    providers:
                      description: Optional.
                      items:
                        properties:
                          name:
                            description: Required.
                            type: string
                        type: object
                      type: array
                  type: object
                type: array
              metrics:
                description: Optional.
                items:
                  properties:
                    overrides:
                      description: Optional.
                      items:
                        properties:
                          disabled:
                            description: Optional.
                            nullable: true
                            type: boolean
                          match:
                            description: Match allows provides the scope of the override.
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - metric
                                - required:
                                  - customMetric
                            - required:
                              - metric
                            - required:
                              - customMetric
                            properties:
                              customMetric:
                                description: Allows free-form specification of a metric.
                                type: string
                              metric:
                                description: One of the well-known Istio Standard
                                  Metrics.
                                enum:
                                - ALL_METRICS
                                - REQUEST_COUNT
                                - REQUEST_DURATION
                                - REQUEST_SIZE
                                - RESPONSE_SIZE
                                - TCP_OPENED_CONNECTIONS
                                - TCP_CLOSED_CONNECTIONS
                                - TCP_SENT_BYTES
                                - TCP_RECEIVED_BYTES
                                - GRPC_REQUEST_MESSAGES
                                - GRPC_RESPONSE_MESSAGES
                                type: string
                              mode:
                                enum:
                                - CLIENT_AND_SERVER
                                - CLIENT
                                - SERVER
                                type: string
                            type: object
                          tagOverrides:
                            additionalProperties:
                              properties:
                                operation:
                                  description: Operation controls whether or not to
                                    update/add a tag, or to remove it.
                                  enum:
                                  - UPSERT
                                  - REMOVE
                                  type: string
                                value:
                                  description: Value is only considered if the operation
                                    is `UPSERT`.
                                  type: string
                              type: object
                            description: Optional.
                            type: object
                        type: object
                      type: array
                    providers:
                      description: Optional.
                      items:
                        properties:
                          name:
                            description: Required.
                            type: string
                        type: object
                      type: array
                  type: object
                type: array
              selector:
                description: Optional.
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
              tracing:
                description: Optional.
                items:
                  properties:
                    customTags:
                      additionalProperties:
                        oneOf:
                        - not:
                            anyOf:
                            - required:
                              - literal
                            - required:
                              - environment
                            - required:
                              - header
                        - required:
                          - literal
                        - required:
                          - environment
                        - required:
                          - header
                        properties:
                          environment:
                            description: Environment adds the value of an environment
                              variable to each span.
                            properties:
                              defaultValue:
                                description: Optional.
                                type: string
                              name:
                                description: Name of the environment variable from
                                  which to extract the tag value.
                                type: string
                            type: object
                          header:
                            properties:
                              defaultValue:
                                description: Optional.
                                type: string
                              name:
                                description: Name of the header from which to extract
                                  the tag value.
                                type: string
                            type: object
                          literal:
                            description: Literal adds the same, hard-coded value to
                              each span.
                            properties:
                              value:
                                description: The tag value to use.
                                type: string
                            type: object
                        type: object
                      description: Optional.
                      type: object
                    disableSpanReporting:
                      description: Controls span reporting.
                      nullable: true
                      type: boolean
                    match:
                      description: Allows tailoring of behavior to specific conditions.
                      properties:
                        mode:
                          enum:
                          - CLIENT_AND_SERVER
                          - CLIENT
                          - SERVER
                          type: string
                      type: object
                    providers:
                      description: Optional.
                      items:
                        properties:
                          name:
                            description: Required.
                            type: string
                        type: object
                      type: array
                    randomSamplingPercentage:
                      nullable: true
                      type: number
                    useRequestIdForTraceSampling:
                      nullable: true
                      type: boolean
                  type: object
                type: array
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-virtualservices" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: virtualservices.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: VirtualService
    listKind: VirtualServiceList
    plural: virtualservices
    shortNames:
    - vs
    singular: virtualservice
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: The names of gateways and sidecars that should apply these routes
      jsonPath: .spec.gateways
      name: Gateways
      type: string
    - description: The destination hosts to which traffic is being sent
      jsonPath: .spec.hosts
      name: Hosts
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting label/content routing, sni routing,
              etc. See more details at: https://istio.io/docs/reference/config/networking/virtual-service.html'
            properties:
              exportTo:
                description: A list of namespaces to which this virtual service is
                  exported.
                items:
                  type: string
                type: array
              gateways:
                description: The names of gateways and sidecars that should apply
                  these routes.
                items:
                  type: string
                type: array
              hosts:
                description: The destination hosts to which traffic is being sent.
                items:
                  type: string
                type: array
              http:
                description: An ordered list of route rules for HTTP traffic.
                items:
                  properties:
                    corsPolicy:
                      description: Cross-Origin Resource Sharing policy (CORS).
                      properties:
                        allowCredentials:
                          nullable: true
                          type: boolean
                        allowHeaders:
                          items:
                            type: string
                          type: array
                        allowMethods:
                          description: List of HTTP methods allowed to access the
                            resource.
                          items:
                            type: string
                          type: array
                        allowOrigin:
                          description: The list of origins that are allowed to perform
                            CORS requests.
                          items:
                            type: string
                          type: array
                        allowOrigins:
                          description: String patterns that match allowed origins.
                          items:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          type: array
                        exposeHeaders:
                          items:
                            type: string
                          type: array
                        maxAge:
                          type: string
                      type: object
                    delegate:
                      properties:
                        name:
                          description: Name specifies the name of the delegate VirtualService.
                          type: string
                        namespace:
                          description: Namespace specifies the namespace where the
                            delegate VirtualService resides.
                          type: string
                      type: object
                    directResponse:
                      description: A HTTP rule can either return a direct_response,
                        redirect or forward (default) traffic.
                      properties:
                        body:
                          description: Specifies the content of the response body.
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - string
                              - required:
                                - bytes
                          - required:
                            - string
                          - required:
                            - bytes
                          properties:
                            bytes:
                              description: response body as base64 encoded bytes.
                              format: binary
                              type: string
                            string:
                              type: string
                          type: object
                        status:
                          description: Specifies the HTTP response status to be returned.
                          type: integer
                      type: object
                    fault:
                      description: Fault injection policy to apply on HTTP traffic
                        at the client side.
                      properties:
                        abort:
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - httpStatus
                              - required:
                                - grpcStatus
                              - required:
                                - http2Error
                          - required:
                            - httpStatus
                          - required:
                            - grpcStatus
                          - required:
                            - http2Error
                          properties:
                            grpcStatus:
                              description: GRPC status code to use to abort the request.
                              type: string
                            http2Error:
                              type: string
                            httpStatus:
                              description: HTTP status code to use to abort the Http
                                request.
                              format: int32
                              type: integer
                            percentage:
                              description: Percentage of requests to be aborted with
                                the error code provided.
                              properties:
                                value:
                                  format: double
                                  type: number
                              type: object
                          type: object
                        delay:
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - fixedDelay
                              - required:
                                - exponentialDelay
                          - required:
                            - fixedDelay
                          - required:
                            - exponentialDelay
                          properties:
                            exponentialDelay:
                              type: string
                            fixedDelay:
                              description: Add a fixed delay before forwarding the
                                request.
                              type: string
                            percent:
                              description: Percentage of requests on which the delay
                                will be injected (0-100).
                              format: int32
                              type: integer
                            percentage:
                              description: Percentage of requests on which the delay
                                will be injected.
                              properties:
                                value:
                                  format: double
                                  type: number
                              type: object
                          type: object
                      type: object
                    headers:
                      properties:
                        request:
                          properties:
                            add:
                              additionalProperties:
                                type: string
                              type: object
                            remove:
                              items:
                                type: string
                              type: array
                            set:
                              additionalProperties:
                                type: string
                              type: object
                          type: object
                        response:
                          properties:
                            add:
                              additionalProperties:
                                type: string
                              type: object
                            remove:
                              items:
                                type: string
                              type: array
                            set:
                              additionalProperties:
                                type: string
                              type: object
                          type: object
                      type: object
                    match:
                      items:
                        properties:
                          authority:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          gateways:
                            description: Names of gateways where the rule should be
                              applied.
                            items:
                              type: string
                            type: array
                          headers:
                            additionalProperties:
                              oneOf:
                              - not:
                                  anyOf:
                                  - required:
                                    - exact
                                  - required:
                                    - prefix
                                  - required:
                                    - regex
                              - required:
                                - exact
                              - required:
                                - prefix
                              - required:
                                - regex
                              properties:
                                exact:
                                  type: string
                                prefix:
                                  type: string
                                regex:
                                  description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                  type: string
                              type: object
                            type: object
                          ignoreUriCase:
                            description: Flag to specify whether the URI matching
                              should be case-insensitive.
                            type: boolean
                          method:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          name:
                            description: The name assigned to a match.
                            type: string
                          port:
                            description: Specifies the ports on the host that is being
                              addressed.
                            type: integer
                          queryParams:
                            additionalProperties:
                              oneOf:
                              - not:
                                  anyOf:
                                  - required:
                                    - exact
                                  - required:
                                    - prefix
                                  - required:
                                    - regex
                              - required:
                                - exact
                              - required:
                                - prefix
                              - required:
                                - regex
                              properties:
                                exact:
                                  type: string
                                prefix:
                                  type: string
                                regex:
                                  description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                  type: string
                              type: object
                            description: Query parameters for matching.
                            type: object
                          scheme:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          sourceLabels:
                            additionalProperties:
                              type: string
                            type: object
                          sourceNamespace:
                            description: Source namespace constraining the applicability
                              of a rule to workloads in that namespace.
                            type: string
                          statPrefix:
                            description: The human readable prefix to use when emitting
                              statistics for this route.
                            type: string
                          uri:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          withoutHeaders:
                            additionalProperties:
                              oneOf:
                              - not:
                                  anyOf:
                                  - required:
                                    - exact
                                  - required:
                                    - prefix
                                  - required:
                                    - regex
                              - required:
                                - exact
                              - required:
                                - prefix
                              - required:
                                - regex
                              properties:
                                exact:
                                  type: string
                                prefix:
                                  type: string
                                regex:
                                  description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                  type: string
                              type: object
                            description: withoutHeader has the same syntax with the
                              header, but has opposite meaning.
                            type: object
                        type: object
                      type: array
                    mirror:
                      properties:
                        host:
                          description: The name of a service from the service registry.
                          type: string
                        port:
                          description: Specifies the port on the host that is being
                            addressed.
                          properties:
                            number:
                              type: integer
                          type: object
                        subset:
                          description: The name of a subset within the service.
                          type: string
                      type: object
                    mirror_percent:
                      description: Percentage of the traffic to be mirrored by the
                        `mirror` field.
                      nullable: true
                      type: integer
                    mirrorPercent:
                      description: Percentage of the traffic to be mirrored by the
                        `mirror` field.
                      nullable: true
                      type: integer
                    mirrorPercentage:
                      description: Percentage of the traffic to be mirrored by the
                        `mirror` field.
                      properties:
                        value:
                          format: double
                          type: number
                      type: object
                    name:
                      description: The name assigned to the route for debugging purposes.
                      type: string
                    redirect:
                      description: A HTTP rule can either return a direct_response,
                        redirect or forward (default) traffic.
                      oneOf:
                      - not:
                          anyOf:
                          - required:
                            - port
                          - required:
                            - derivePort
                      - required:
                        - port
                      - required:
                        - derivePort
                      properties:
                        authority:
                          type: string
                        derivePort:
                          enum:
                          - FROM_PROTOCOL_DEFAULT
                          - FROM_REQUEST_PORT
                          type: string
                        port:
                          description: On a redirect, overwrite the port portion of
                            the URL with this value.
                          type: integer
                        redirectCode:
                          type: integer
                        scheme:
                          description: On a redirect, overwrite the scheme portion
                            of the URL with this value.
                          type: string
                        uri:
                          type: string
                      type: object
                    retries:
                      description: Retry policy for HTTP requests.
                      properties:
                        attempts:
                          description: Number of retries to be allowed for a given
                            request.
                          format: int32
                          type: integer
                        perTryTimeout:
                          description: Timeout per attempt for a given request, including
                            the initial call and any retries.
                          type: string
                        retryOn:
                          description: Specifies the conditions under which retry
                            takes place.
                          type: string
                        retryRemoteLocalities:
                          description: Flag to specify whether the retries should
                            retry to other localities.
                          nullable: true
                          type: boolean
                      type: object
                    rewrite:
                      description: Rewrite HTTP URIs and Authority headers.
                      properties:
                        authority:
                          description: rewrite the Authority/Host header with this
                            value.
                          type: string
                        uri:
                          type: string
                      type: object
                    route:
                      description: A HTTP rule can either return a direct_response,
                        redirect or forward (default) traffic.
                      items:
                        properties:
                          destination:
                            properties:
                              host:
                                description: The name of a service from the service
                                  registry.
                                type: string
                              port:
                                description: Specifies the port on the host that is
                                  being addressed.
                                properties:
                                  number:
                                    type: integer
                                type: object
                              subset:
                                description: The name of a subset within the service.
                                type: string
                            type: object
                          headers:
                            properties:
                              request:
                                properties:
                                  add:
                                    additionalProperties:
                                      type: string
                                    type: object
                                  remove:
                                    items:
                                      type: string
                                    type: array
                                  set:
                                    additionalProperties:
                                      type: string
                                    type: object
                                type: object
                              response:
                                properties:
                                  add:
                                    additionalProperties:
                                      type: string
                                    type: object
                                  remove:
                                    items:
                                      type: string
                                    type: array
                                  set:
                                    additionalProperties:
                                      type: string
                                    type: object
                                type: object
                            type: object
                          weight:
                            description: Weight specifies the relative proportion
                              of traffic to be forwarded to the destination.
                            format: int32
                            type: integer
                        type: object
                      type: array
                    timeout:
                      description: Timeout for HTTP requests, default is disabled.
                      type: string
                  type: object
                type: array
              tcp:
                description: An ordered list of route rules for opaque TCP traffic.
                items:
                  properties:
                    match:
                      items:
                        properties:
                          destinationSubnets:
                            description: IPv4 or IPv6 ip addresses of destination
                              with optional subnet.
                            items:
                              type: string
                            type: array
                          gateways:
                            description: Names of gateways where the rule should be
                              applied.
                            items:
                              type: string
                            type: array
                          port:
                            description: Specifies the port on the host that is being
                              addressed.
                            type: integer
                          sourceLabels:
                            additionalProperties:
                              type: string
                            type: object
                          sourceNamespace:
                            description: Source namespace constraining the applicability
                              of a rule to workloads in that namespace.
                            type: string
                          sourceSubnet:
                            description: IPv4 or IPv6 ip address of source with optional
                              subnet.
                            type: string
                        type: object
                      type: array
                    route:
                      description: The destination to which the connection should
                        be forwarded to.
                      items:
                        properties:
                          destination:
                            properties:
                              host:
                                description: The name of a service from the service
                                  registry.
                                type: string
                              port:
                                description: Specifies the port on the host that is
                                  being addressed.
                                properties:
                                  number:
                                    type: integer
                                type: object
                              subset:
                                description: The name of a subset within the service.
                                type: string
                            type: object
                          weight:
                            description: Weight specifies the relative proportion
                              of traffic to be forwarded to the destination.
                            format: int32
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
              tls:
                items:
                  properties:
                    match:
                      items:
                        properties:
                          destinationSubnets:
                            description: IPv4 or IPv6 ip addresses of destination
                              with optional subnet.
                            items:
                              type: string
                            type: array
                          gateways:
                            description: Names of gateways where the rule should be
                              applied.
                            items:
                              type: string
                            type: array
                          port:
                            description: Specifies the port on the host that is being
                              addressed.
                            type: integer
                          sniHosts:
                            description: SNI (server name indicator) to match on.
                            items:
                              type: string
                            type: array
                          sourceLabels:
                            additionalProperties:
                              type: string
                            type: object
                          sourceNamespace:
                            description: Source namespace constraining the applicability
                              of a rule to workloads in that namespace.
                            type: string
                        type: object
                      type: array
                    route:
                      description: The destination to which the connection should
                        be forwarded to.
                      items:
                        properties:
                          destination:
                            properties:
                              host:
                                description: The name of a service from the service
                                  registry.
                                type: string
                              port:
                                description: Specifies the port on the host that is
                                  being addressed.
                                properties:
                                  number:
                                    type: integer
                                type: object
                              subset:
                                description: The name of a subset within the service.
                                type: string
                            type: object
                          weight:
                            description: Weight specifies the relative proportion
                              of traffic to be forwarded to the destination.
                            format: int32
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - additionalPrinterColumns:
    - description: The names of gateways and sidecars that should apply these routes
      jsonPath: .spec.gateways
      name: Gateways
      type: string
    - description: The destination hosts to which traffic is being sent
      jsonPath: .spec.hosts
      name: Hosts
      type: string
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting label/content routing, sni routing,
              etc. See more details at: https://istio.io/docs/reference/config/networking/virtual-service.html'
            properties:
              exportTo:
                description: A list of namespaces to which this virtual service is
                  exported.
                items:
                  type: string
                type: array
              gateways:
                description: The names of gateways and sidecars that should apply
                  these routes.
                items:
                  type: string
                type: array
              hosts:
                description: The destination hosts to which traffic is being sent.
                items:
                  type: string
                type: array
              http:
                description: An ordered list of route rules for HTTP traffic.
                items:
                  properties:
                    corsPolicy:
                      description: Cross-Origin Resource Sharing policy (CORS).
                      properties:
                        allowCredentials:
                          nullable: true
                          type: boolean
                        allowHeaders:
                          items:
                            type: string
                          type: array
                        allowMethods:
                          description: List of HTTP methods allowed to access the
                            resource.
                          items:
                            type: string
                          type: array
                        allowOrigin:
                          description: The list of origins that are allowed to perform
                            CORS requests.
                          items:
                            type: string
                          type: array
                        allowOrigins:
                          description: String patterns that match allowed origins.
                          items:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          type: array
                        exposeHeaders:
                          items:
                            type: string
                          type: array
                        maxAge:
                          type: string
                      type: object
                    delegate:
                      properties:
                        name:
                          description: Name specifies the name of the delegate VirtualService.
                          type: string
                        namespace:
                          description: Namespace specifies the namespace where the
                            delegate VirtualService resides.
                          type: string
                      type: object
                    directResponse:
                      description: A HTTP rule can either return a direct_response,
                        redirect or forward (default) traffic.
                      properties:
                        body:
                          description: Specifies the content of the response body.
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - string
                              - required:
                                - bytes
                          - required:
                            - string
                          - required:
                            - bytes
                          properties:
                            bytes:
                              description: response body as base64 encoded bytes.
                              format: binary
                              type: string
                            string:
                              type: string
                          type: object
                        status:
                          description: Specifies the HTTP response status to be returned.
                          type: integer
                      type: object
                    fault:
                      description: Fault injection policy to apply on HTTP traffic
                        at the client side.
                      properties:
                        abort:
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - httpStatus
                              - required:
                                - grpcStatus
                              - required:
                                - http2Error
                          - required:
                            - httpStatus
                          - required:
                            - grpcStatus
                          - required:
                            - http2Error
                          properties:
                            grpcStatus:
                              description: GRPC status code to use to abort the request.
                              type: string
                            http2Error:
                              type: string
                            httpStatus:
                              description: HTTP status code to use to abort the Http
                                request.
                              format: int32
                              type: integer
                            percentage:
                              description: Percentage of requests to be aborted with
                                the error code provided.
                              properties:
                                value:
                                  format: double
                                  type: number
                              type: object
                          type: object
                        delay:
                          oneOf:
                          - not:
                              anyOf:
                              - required:
                                - fixedDelay
                              - required:
                                - exponentialDelay
                          - required:
                            - fixedDelay
                          - required:
                            - exponentialDelay
                          properties:
                            exponentialDelay:
                              type: string
                            fixedDelay:
                              description: Add a fixed delay before forwarding the
                                request.
                              type: string
                            percent:
                              description: Percentage of requests on which the delay
                                will be injected (0-100).
                              format: int32
                              type: integer
                            percentage:
                              description: Percentage of requests on which the delay
                                will be injected.
                              properties:
                                value:
                                  format: double
                                  type: number
                              type: object
                          type: object
                      type: object
                    headers:
                      properties:
                        request:
                          properties:
                            add:
                              additionalProperties:
                                type: string
                              type: object
                            remove:
                              items:
                                type: string
                              type: array
                            set:
                              additionalProperties:
                                type: string
                              type: object
                          type: object
                        response:
                          properties:
                            add:
                              additionalProperties:
                                type: string
                              type: object
                            remove:
                              items:
                                type: string
                              type: array
                            set:
                              additionalProperties:
                                type: string
                              type: object
                          type: object
                      type: object
                    match:
                      items:
                        properties:
                          authority:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          gateways:
                            description: Names of gateways where the rule should be
                              applied.
                            items:
                              type: string
                            type: array
                          headers:
                            additionalProperties:
                              oneOf:
                              - not:
                                  anyOf:
                                  - required:
                                    - exact
                                  - required:
                                    - prefix
                                  - required:
                                    - regex
                              - required:
                                - exact
                              - required:
                                - prefix
                              - required:
                                - regex
                              properties:
                                exact:
                                  type: string
                                prefix:
                                  type: string
                                regex:
                                  description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                  type: string
                              type: object
                            type: object
                          ignoreUriCase:
                            description: Flag to specify whether the URI matching
                              should be case-insensitive.
                            type: boolean
                          method:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          name:
                            description: The name assigned to a match.
                            type: string
                          port:
                            description: Specifies the ports on the host that is being
                              addressed.
                            type: integer
                          queryParams:
                            additionalProperties:
                              oneOf:
                              - not:
                                  anyOf:
                                  - required:
                                    - exact
                                  - required:
                                    - prefix
                                  - required:
                                    - regex
                              - required:
                                - exact
                              - required:
                                - prefix
                              - required:
                                - regex
                              properties:
                                exact:
                                  type: string
                                prefix:
                                  type: string
                                regex:
                                  description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                  type: string
                              type: object
                            description: Query parameters for matching.
                            type: object
                          scheme:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          sourceLabels:
                            additionalProperties:
                              type: string
                            type: object
                          sourceNamespace:
                            description: Source namespace constraining the applicability
                              of a rule to workloads in that namespace.
                            type: string
                          statPrefix:
                            description: The human readable prefix to use when emitting
                              statistics for this route.
                            type: string
                          uri:
                            oneOf:
                            - not:
                                anyOf:
                                - required:
                                  - exact
                                - required:
                                  - prefix
                                - required:
                                  - regex
                            - required:
                              - exact
                            - required:
                              - prefix
                            - required:
                              - regex
                            properties:
                              exact:
                                type: string
                              prefix:
                                type: string
                              regex:
                                description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                type: string
                            type: object
                          withoutHeaders:
                            additionalProperties:
                              oneOf:
                              - not:
                                  anyOf:
                                  - required:
                                    - exact
                                  - required:
                                    - prefix
                                  - required:
                                    - regex
                              - required:
                                - exact
                              - required:
                                - prefix
                              - required:
                                - regex
                              properties:
                                exact:
                                  type: string
                                prefix:
                                  type: string
                                regex:
                                  description: RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax).
                                  type: string
                              type: object
                            description: withoutHeader has the same syntax with the
                              header, but has opposite meaning.
                            type: object
                        type: object
                      type: array
                    mirror:
                      properties:
                        host:
                          description: The name of a service from the service registry.
                          type: string
                        port:
                          description: Specifies the port on the host that is being
                            addressed.
                          properties:
                            number:
                              type: integer
                          type: object
                        subset:
                          description: The name of a subset within the service.
                          type: string
                      type: object
                    mirror_percent:
                      description: Percentage of the traffic to be mirrored by the
                        `mirror` field.
                      nullable: true
                      type: integer
                    mirrorPercent:
                      description: Percentage of the traffic to be mirrored by the
                        `mirror` field.
                      nullable: true
                      type: integer
                    mirrorPercentage:
                      description: Percentage of the traffic to be mirrored by the
                        `mirror` field.
                      properties:
                        value:
                          format: double
                          type: number
                      type: object
                    name:
                      description: The name assigned to the route for debugging purposes.
                      type: string
                    redirect:
                      description: A HTTP rule can either return a direct_response,
                        redirect or forward (default) traffic.
                      oneOf:
                      - not:
                          anyOf:
                          - required:
                            - port
                          - required:
                            - derivePort
                      - required:
                        - port
                      - required:
                        - derivePort
                      properties:
                        authority:
                          type: string
                        derivePort:
                          enum:
                          - FROM_PROTOCOL_DEFAULT
                          - FROM_REQUEST_PORT
                          type: string
                        port:
                          description: On a redirect, overwrite the port portion of
                            the URL with this value.
                          type: integer
                        redirectCode:
                          type: integer
                        scheme:
                          description: On a redirect, overwrite the scheme portion
                            of the URL with this value.
                          type: string
                        uri:
                          type: string
                      type: object
                    retries:
                      description: Retry policy for HTTP requests.
                      properties:
                        attempts:
                          description: Number of retries to be allowed for a given
                            request.
                          format: int32
                          type: integer
                        perTryTimeout:
                          description: Timeout per attempt for a given request, including
                            the initial call and any retries.
                          type: string
                        retryOn:
                          description: Specifies the conditions under which retry
                            takes place.
                          type: string
                        retryRemoteLocalities:
                          description: Flag to specify whether the retries should
                            retry to other localities.
                          nullable: true
                          type: boolean
                      type: object
                    rewrite:
                      description: Rewrite HTTP URIs and Authority headers.
                      properties:
                        authority:
                          description: rewrite the Authority/Host header with this
                            value.
                          type: string
                        uri:
                          type: string
                      type: object
                    route:
                      description: A HTTP rule can either return a direct_response,
                        redirect or forward (default) traffic.
                      items:
                        properties:
                          destination:
                            properties:
                              host:
                                description: The name of a service from the service
                                  registry.
                                type: string
                              port:
                                description: Specifies the port on the host that is
                                  being addressed.
                                properties:
                                  number:
                                    type: integer
                                type: object
                              subset:
                                description: The name of a subset within the service.
                                type: string
                            type: object
                          headers:
                            properties:
                              request:
                                properties:
                                  add:
                                    additionalProperties:
                                      type: string
                                    type: object
                                  remove:
                                    items:
                                      type: string
                                    type: array
                                  set:
                                    additionalProperties:
                                      type: string
                                    type: object
                                type: object
                              response:
                                properties:
                                  add:
                                    additionalProperties:
                                      type: string
                                    type: object
                                  remove:
                                    items:
                                      type: string
                                    type: array
                                  set:
                                    additionalProperties:
                                      type: string
                                    type: object
                                type: object
                            type: object
                          weight:
                            description: Weight specifies the relative proportion
                              of traffic to be forwarded to the destination.
                            format: int32
                            type: integer
                        type: object
                      type: array
                    timeout:
                      description: Timeout for HTTP requests, default is disabled.
                      type: string
                  type: object
                type: array
              tcp:
                description: An ordered list of route rules for opaque TCP traffic.
                items:
                  properties:
                    match:
                      items:
                        properties:
                          destinationSubnets:
                            description: IPv4 or IPv6 ip addresses of destination
                              with optional subnet.
                            items:
                              type: string
                            type: array
                          gateways:
                            description: Names of gateways where the rule should be
                              applied.
                            items:
                              type: string
                            type: array
                          port:
                            description: Specifies the port on the host that is being
                              addressed.
                            type: integer
                          sourceLabels:
                            additionalProperties:
                              type: string
                            type: object
                          sourceNamespace:
                            description: Source namespace constraining the applicability
                              of a rule to workloads in that namespace.
                            type: string
                          sourceSubnet:
                            description: IPv4 or IPv6 ip address of source with optional
                              subnet.
                            type: string
                        type: object
                      type: array
                    route:
                      description: The destination to which the connection should
                        be forwarded to.
                      items:
                        properties:
                          destination:
                            properties:
                              host:
                                description: The name of a service from the service
                                  registry.
                                type: string
                              port:
                                description: Specifies the port on the host that is
                                  being addressed.
                                properties:
                                  number:
                                    type: integer
                                type: object
                              subset:
                                description: The name of a subset within the service.
                                type: string
                            type: object
                          weight:
                            description: Weight specifies the relative proportion
                              of traffic to be forwarded to the destination.
                            format: int32
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
              tls:
                items:
                  properties:
                    match:
                      items:
                        properties:
                          destinationSubnets:
                            description: IPv4 or IPv6 ip addresses of destination
                              with optional subnet.
                            items:
                              type: string
                            type: array
                          gateways:
                            description: Names of gateways where the rule should be
                              applied.
                            items:
                              type: string
                            type: array
                          port:
                            description: Specifies the port on the host that is being
                              addressed.
                            type: integer
                          sniHosts:
                            description: SNI (server name indicator) to match on.
                            items:
                              type: string
                            type: array
                          sourceLabels:
                            additionalProperties:
                              type: string
                            type: object
                          sourceNamespace:
                            description: Source namespace constraining the applicability
                              of a rule to workloads in that namespace.
                            type: string
                        type: object
                      type: array
                    route:
                      description: The destination to which the connection should
                        be forwarded to.
                      items:
                        properties:
                          destination:
                            properties:
                              host:
                                description: The name of a service from the service
                                  registry.
                                type: string
                              port:
                                description: Specifies the port on the host that is
                                  being addressed.
                                properties:
                                  number:
                                    type: integer
                                type: object
                              subset:
                                description: The name of a subset within the service.
                                type: string
                            type: object
                          weight:
                            description: Weight specifies the relative proportion
                              of traffic to be forwarded to the destination.
                            format: int32
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-wasmplugins" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: wasmplugins.extensions.istio.io
spec:
  group: extensions.istio.io
  names:
    categories:
    - istio-io
    - extensions-istio-io
    kind: WasmPlugin
    listKind: WasmPluginList
    plural: wasmplugins
    singular: wasmplugin
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Extend the functionality provided by the Istio proxy through
              WebAssembly filters. See more details at: https://istio.io/docs/reference/config/proxy_extensions/wasm-plugin.html'
            properties:
              imagePullPolicy:
                enum:
                - UNSPECIFIED_POLICY
                - IfNotPresent
                - Always
                type: string
              imagePullSecret:
                description: Credentials to use for OCI image pulling.
                type: string
              match:
                items:
                  properties:
                    mode:
                      enum:
                      - UNDEFINED
                      - CLIENT
                      - SERVER
                      - CLIENT_AND_SERVER
                      type: string
                    ports:
                      items:
                        properties:
                          number:
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
              phase:
                description: Determines where in the filter chain this `WasmPlugin`
                  is to be injected.
                enum:
                - UNSPECIFIED_PHASE
                - AUTHN
                - AUTHZ
                - STATS
                type: string
              pluginConfig:
                description: The configuration that will be passed on to the plugin.
                type: object
                x-kubernetes-preserve-unknown-fields: true
              pluginName:
                type: string
              priority:
                description: Determines ordering of `WasmPlugins` in the same `phase`.
                nullable: true
                type: integer
              selector:
                properties:
                  matchLabels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
              sha256:
                description: SHA256 checksum that will be used to verify Wasm module
                  or OCI container.
                type: string
              url:
                description: URL of a Wasm module or OCI container.
                type: string
              verificationKey:
                type: string
              vmConfig:
                description: Configuration for a Wasm VM.
                properties:
                  env:
                    description: Specifies environment variables to be injected to
                      this VM.
                    items:
                      properties:
                        name:
                          type: string
                        value:
                          description: Value for the environment variable.
                          type: string
                        valueFrom:
                          enum:
                          - INLINE
                          - HOST
                          type: string
                      type: object
                    type: array
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-workloadentries" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    helm.sh/resource-policy: keep
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: workloadentries.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: WorkloadEntry
    listKind: WorkloadEntryList
    plural: workloadentries
    shortNames:
    - we
    singular: workloadentry
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    - description: Address associated with the network endpoint.
      jsonPath: .spec.address
      name: Address
      type: string
    name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting VMs onboarded into the mesh. See
              more details at: https://istio.io/docs/reference/config/networking/workload-entry.html'
            properties:
              address:
                type: string
              labels:
                additionalProperties:
                  type: string
                description: One or more labels associated with the endpoint.
                type: object
              locality:
                description: The locality associated with the endpoint.
                type: string
              network:
                type: string
              ports:
                additionalProperties:
                  type: integer
                description: Set of ports associated with the endpoint.
                type: object
              serviceAccount:
                type: string
              weight:
                description: The load balancing weight associated with the endpoint.
                type: integer
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - additionalPrinterColumns:
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    - description: Address associated with the network endpoint.
      jsonPath: .spec.address
      name: Address
      type: string
    name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Configuration affecting VMs onboarded into the mesh. See
              more details at: https://istio.io/docs/reference/config/networking/workload-entry.html'
            properties:
              address:
                type: string
              labels:
                additionalProperties:
                  type: string
                description: One or more labels associated with the endpoint.
                type: object
              locality:
                description: The locality associated with the endpoint.
                type: string
              network:
                type: string
              ports:
                additionalProperties:
                  type: integer
                description: Set of ports associated with the endpoint.
                type: object
              serviceAccount:
                type: string
              weight:
                description: The load balancing weight associated with the endpoint.
                type: integer
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-crd-workloadgroups" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    app: istio-pilot
    chart: istio
    heritage: Tiller
    release: istio
  name: workloadgroups.networking.istio.io
spec:
  group: networking.istio.io
  names:
    categories:
    - istio-io
    - networking-istio-io
    kind: WorkloadGroup
    listKind: WorkloadGroupList
    plural: workloadgroups
    shortNames:
    - wg
    singular: workloadgroup
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha3
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: 'Describes a collection of workload instances. See more details
              at: https://istio.io/docs/reference/config/networking/workload-group.html'
            properties:
              metadata:
                description: Metadata that will be used for all corresponding `WorkloadEntries`.
                properties:
                  annotations:
                    additionalProperties:
                      type: string
                    type: object
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
              probe:
                description: '`ReadinessProbe` describes the configuration the user
                  must provide for healthchecking on their workload.'
                oneOf:
                - not:
                    anyOf:
                    - required:
                      - httpGet
                    - required:
                      - tcpSocket
                    - required:
                      - exec
                - required:
                  - httpGet
                - required:
                  - tcpSocket
                - required:
                  - exec
                properties:
                  exec:
                    description: Health is determined by how the command that is executed
                      exited.
                    properties:
                      command:
                        description: Command to run.
                        items:
                          type: string
                        type: array
                    type: object
                  failureThreshold:
                    description: Minimum consecutive failures for the probe to be
                      considered failed after having succeeded.
                    format: int32
                    type: integer
                  httpGet:
                    properties:
                      host:
                        description: Host name to connect to, defaults to the pod
                          IP.
                        type: string
                      httpHeaders:
                        description: Headers the proxy will pass on to make the request.
                        items:
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                          type: object
                        type: array
                      path:
                        description: Path to access on the HTTP server.
                        type: string
                      port:
                        description: Port on which the endpoint lives.
                        type: integer
                      scheme:
                        type: string
                    type: object
                  initialDelaySeconds:
                    description: Number of seconds after the container has started
                      before readiness probes are initiated.
                    format: int32
                    type: integer
                  periodSeconds:
                    description: How often (in seconds) to perform the probe.
                    format: int32
                    type: integer
                  successThreshold:
                    description: Minimum consecutive successes for the probe to be
                      considered successful after having failed.
                    format: int32
                    type: integer
                  tcpSocket:
                    description: Health is determined by if the proxy is able to connect.
                    properties:
                      host:
                        type: string
                      port:
                        type: integer
                    type: object
                  timeoutSeconds:
                    description: Number of seconds after which the probe times out.
                    format: int32
                    type: integer
                type: object
              template:
                description: Template to be used for the generation of `WorkloadEntry`
                  resources that belong to this `WorkloadGroup`.
                properties:
                  address:
                    type: string
                  labels:
                    additionalProperties:
                      type: string
                    description: One or more labels associated with the endpoint.
                    type: object
                  locality:
                    description: The locality associated with the endpoint.
                    type: string
                  network:
                    type: string
                  ports:
                    additionalProperties:
                      type: integer
                    description: Set of ports associated with the endpoint.
                    type: object
                  serviceAccount:
                    type: string
                  weight:
                    description: The load balancing weight associated with the endpoint.
                    type: integer
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - additionalPrinterColumns:
    - description: 'CreationTimestamp is a timestamp representing the server time
        when this object was created. It is not guaranteed to be set in happens-before
        order across separate operations. Clients may not set this value. It is represented
        in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for
        lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata'
      jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          spec:
            properties:
              metadata:
                description: Metadata that will be used for all corresponding `WorkloadEntries`.
                properties:
                  annotations:
                    additionalProperties:
                      type: string
                    type: object
                  labels:
                    additionalProperties:
                      type: string
                    type: object
                type: object
              probe:
                description: '`ReadinessProbe` describes the configuration the user
                  must provide for healthchecking on their workload.'
                oneOf:
                - not:
                    anyOf:
                    - required:
                      - httpGet
                    - required:
                      - tcpSocket
                    - required:
                      - exec
                - required:
                  - httpGet
                - required:
                  - tcpSocket
                - required:
                  - exec
                properties:
                  exec:
                    description: Health is determined by how the command that is executed
                      exited.
                    properties:
                      command:
                        description: Command to run.
                        items:
                          type: string
                        type: array
                    type: object
                  failureThreshold:
                    description: Minimum consecutive failures for the probe to be
                      considered failed after having succeeded.
                    format: int32
                    type: integer
                  httpGet:
                    properties:
                      host:
                        description: Host name to connect to, defaults to the pod
                          IP.
                        type: string
                      httpHeaders:
                        description: Headers the proxy will pass on to make the request.
                        items:
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                          type: object
                        type: array
                      path:
                        description: Path to access on the HTTP server.
                        type: string
                      port:
                        description: Port on which the endpoint lives.
                        type: integer
                      scheme:
                        type: string
                    type: object
                  initialDelaySeconds:
                    description: Number of seconds after the container has started
                      before readiness probes are initiated.
                    format: int32
                    type: integer
                  periodSeconds:
                    description: How often (in seconds) to perform the probe.
                    format: int32
                    type: integer
                  successThreshold:
                    description: Minimum consecutive successes for the probe to be
                      considered successful after having failed.
                    format: int32
                    type: integer
                  tcpSocket:
                    description: Health is determined by if the proxy is able to connect.
                    properties:
                      host:
                        type: string
                      port:
                        type: integer
                    type: object
                  timeoutSeconds:
                    description: Number of seconds after which the probe times out.
                    format: int32
                    type: integer
                type: object
              template:
                description: Template to be used for the generation of `WorkloadEntry`
                  resources that belong to this `WorkloadGroup`.
                properties:
                  address:
                    type: string
                  labels:
                    additionalProperties:
                      type: string
                    description: One or more labels associated with the endpoint.
                    type: object
                  locality:
                    description: The locality associated with the endpoint.
                    type: string
                  network:
                    type: string
                  ports:
                    additionalProperties:
                      type: integer
                    description: Set of ports associated with the endpoint.
                    type: object
                  serviceAccount:
                    type: string
                  weight:
                    description: The load balancing weight associated with the endpoint.
                    type: integer
                type: object
            type: object
          status:
            type: object
            x-kubernetes-preserve-unknown-fields: true
        type: object
    served: true
    storage: false
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  labels:
    istio-injection: disabled
    istio-operator-managed: Reconcile
  name: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-istio-serviceaccount-ingressgateway" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: istio-ingressgateway
    install.operator.istio.io/owning-resource: unknown
    istio: ingressgateway
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    release: istio
  name: istio-ingressgateway-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-serviceaccount-reader" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: istio-reader
    release: istio
  name: istio-reader-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-serviceaccount-istiod" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-serviceaccount-istiod-sa" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-role-ingressgateway-sds" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    install.operator.istio.io/owning-resource: unknown
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    release: istio
  name: istio-ingressgateway-sds
  namespace: istio-system
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - watch
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-role-istiod" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod
  namespace: istio-system
rules:
- apiGroups:
  - networking.istio.io
  resources:
  - gateways
  verbs:
  - create
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - create
  - get
  - watch
  - list
  - update
  - delete
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - delete
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-role-istiod-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-istio-system
  namespace: istio-system
rules:
- apiGroups:
  - networking.istio.io
  resources:
  - gateways
  verbs:
  - create
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - create
  - get
  - watch
  - list
  - update
  - delete
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrole-reader-clusterrole-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: istio-reader
    release: istio
  name: istio-reader-clusterrole-istio-system
rules:
- apiGroups:
  - config.istio.io
  - security.istio.io
  - networking.istio.io
  - authentication.istio.io
  - rbac.istio.io
  resources:
  - '*'
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - endpoints
  - pods
  - services
  - nodes
  - replicationcontrollers
  - namespaces
  - secrets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.istio.io
  resources:
  - workloadentries
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceexports
  verbs:
  - get
  - list
  - watch
  - create
  - delete
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceimports
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - apps
  resources:
  - replicasets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrole-reader-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: istio-reader
    release: istio
  name: istio-reader-istio-system
rules:
- apiGroups:
  - config.istio.io
  - security.istio.io
  - networking.istio.io
  - authentication.istio.io
  - rbac.istio.io
  resources:
  - '*'
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - endpoints
  - pods
  - services
  - nodes
  - replicationcontrollers
  - namespaces
  - secrets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.istio.io
  resources:
  - workloadentries
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - apps
  resources:
  - replicasets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceexports
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceimports
  verbs:
  - get
  - watch
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrole-istiod-clusterrole-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-clusterrole-istio-system
rules:
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - mutatingwebhookconfigurations
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - validatingwebhookconfigurations
  verbs:
  - get
  - list
  - watch
  - update
- apiGroups:
  - config.istio.io
  - security.istio.io
  - networking.istio.io
  - authentication.istio.io
  - rbac.istio.io
  - telemetry.istio.io
  - extensions.istio.io
  resources:
  - '*'
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - networking.istio.io
  resources:
  - workloadentries
  verbs:
  - get
  - watch
  - list
  - update
  - patch
  - create
  - delete
- apiGroups:
  - networking.istio.io
  resources:
  - workloadentries/status
  verbs:
  - get
  - watch
  - list
  - update
  - patch
  - create
  - delete
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - pods
  - nodes
  - services
  - namespaces
  - endpoints
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  - ingressclasses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses/status
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
  - get
  - list
  - watch
  - update
- apiGroups:
  - certificates.k8s.io
  resources:
  - certificatesigningrequests
  - certificatesigningrequests/approval
  - certificatesigningrequests/status
  verbs:
  - update
  - create
  - get
  - delete
  - watch
- apiGroups:
  - certificates.k8s.io
  resourceNames:
  - kubernetes.io/legacy-unknown
  resources:
  - signers
  verbs:
  - approve
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - networking.x-k8s.io
  - gateway.networking.k8s.io
  resources:
  - '*'
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - networking.x-k8s.io
  - gateway.networking.k8s.io
  resources:
  - '*'
  verbs:
  - update
  - patch
- apiGroups:
  - gateway.networking.k8s.io
  resources:
  - gatewayclasses
  verbs:
  - create
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceexports
  verbs:
  - get
  - watch
  - list
  - create
  - delete
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceimports
  verbs:
  - get
  - watch
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrole-istiod-gateway-controller-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-gateway-controller-istio-system
rules:
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - get
  - watch
  - list
  - update
  - patch
  - create
  - delete
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - watch
  - list
  - update
  - patch
  - create
  - delete
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrole-istiod-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-istio-system
rules:
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - mutatingwebhookconfigurations
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - validatingwebhookconfigurations
  verbs:
  - get
  - list
  - watch
  - update
- apiGroups:
  - config.istio.io
  - security.istio.io
  - networking.istio.io
  - authentication.istio.io
  - rbac.istio.io
  - telemetry.istio.io
  resources:
  - '*'
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - networking.istio.io
  resources:
  - workloadentries
  verbs:
  - get
  - watch
  - list
  - update
  - patch
  - create
  - delete
- apiGroups:
  - networking.istio.io
  resources:
  - workloadentries/status
  verbs:
  - get
  - watch
  - list
  - update
  - patch
  - create
  - delete
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - pods
  - nodes
  - services
  - namespaces
  - endpoints
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  - ingressclasses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses/status
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
  - get
  - list
  - watch
  - update
- apiGroups:
  - certificates.k8s.io
  resources:
  - certificatesigningrequests
  - certificatesigningrequests/approval
  - certificatesigningrequests/status
  verbs:
  - update
  - create
  - get
  - delete
  - watch
- apiGroups:
  - certificates.k8s.io
  resourceNames:
  - kubernetes.io/legacy-unknown
  resources:
  - signers
  verbs:
  - approve
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - networking.x-k8s.io
  - gateway.networking.k8s.io
  resources:
  - '*'
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - networking.x-k8s.io
  - gateway.networking.k8s.io
  resources:
  - '*'
  verbs:
  - update
- apiGroups:
  - gateway.networking.k8s.io
  resources:
  - gatewayclasses
  verbs:
  - create
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceexports
  verbs:
  - get
  - watch
  - list
  - create
  - delete
- apiGroups:
  - multicluster.x-k8s.io
  resources:
  - serviceimports
  verbs:
  - get
  - watch
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-rolebinding-ingressgateway-sds" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    install.operator.istio.io/owning-resource: unknown
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    release: istio
  name: istio-ingressgateway-sds
  namespace: istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: istio-ingressgateway-sds
subjects:
- kind: ServiceAccount
  name: istio-ingressgateway-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-rolebinding-istiod" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod
  namespace: istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: istiod
subjects:
- kind: ServiceAccount
  name: istiod
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-rolebinding-istiod-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-istio-system
  namespace: istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: istiod-istio-system
subjects:
- kind: ServiceAccount
  name: istiod-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrolebinding-reader-clusterrole-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: istio-reader
    release: istio
  name: istio-reader-clusterrole-istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: istio-reader-clusterrole-istio-system
subjects:
- kind: ServiceAccount
  name: istio-reader-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrolebinding-reader-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: istio-reader
    release: istio
  name: istio-reader-istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: istio-reader-istio-system
subjects:
- kind: ServiceAccount
  name: istio-reader-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrolebinding-istiod-clusterrole-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-clusterrole-istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: istiod-clusterrole-istio-system
subjects:
- kind: ServiceAccount
  name: istiod
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrolebinding-gateway-controller-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-gateway-controller-istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: istiod-gateway-controller-istio-system
subjects:
- kind: ServiceAccount
  name: istiod
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-clusterrolebinding-istiod-istio-system" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: istiod
    release: istio
  name: istiod-istio-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: istiod-istio-system
subjects:
- kind: ServiceAccount
  name: istiod-service-account
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-configmap-istio" {
  yaml_body = <<YAML
apiVersion: v1
data:
  mesh: |-
    accessLogFile: /dev/stdout
    defaultConfig:
      discoveryAddress: istiod.istio-system.svc:15012
      proxyMetadata: {}
      tracing: {}
    enablePrometheusMerge: true
    rootNamespace: istio-system
    tcpKeepalive:
      interval: 5s
      probes: 3
      time: 10s
    trustDomain: cluster.local
  meshNetworks: 'networks: {}'
kind: ConfigMap
metadata:
  labels:
    install.operator.istio.io/owning-resource: unknown
    istio.io/rev: default
    operator.istio.io/component: Pilot
    release: istio
  name: istio
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-configmap-istio-sidecar-injector" {
  yaml_body = <<YAML
apiVersion: v1
data:
  config: |-
    # defaultTemplates defines the default template to use for pods that do not explicitly specify a template
    defaultTemplates: [sidecar]
    policy: enabled
    alwaysInjectSelector:
      []
    neverInjectSelector:
      []
    injectedAnnotations:
    template: "{{ Template_Version_And_Istio_Version_Mismatched_Check_Installation }}"
    templates:
      sidecar: |
        {{- define "resources"  }}
          {{- if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit`) }}
            {{- if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) }}
              requests:
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) -}}
                cpu: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU` }}"
                {{ end }}
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) -}}
                memory: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory` }}"
                {{ end }}
            {{- end }}
            {{- if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit`) }}
              limits:
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit`) -}}
                cpu: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit` }}"
                {{ end }}
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit`) -}}
                memory: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit` }}"
                {{ end }}
            {{- end }}
          {{- else }}
            {{- if .Values.global.proxy.resources }}
              {{ toYaml .Values.global.proxy.resources | indent 6 }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- $containers := list }}
        {{- range $index, $container := .Spec.Containers }}{{ if not (eq $container.Name "istio-proxy") }}{{ $containers = append $containers $container.Name }}{{end}}{{- end}}
        metadata:
          labels:
            security.istio.io/tlsMode: {{ index .ObjectMeta.Labels `security.istio.io/tlsMode` | default "istio"  | quote }}
            {{- if eq (index .ProxyConfig.ProxyMetadata "ISTIO_META_ENABLE_HBONE") "true" }}
            networking.istio.io/tunnel: {{ index .ObjectMeta.Labels `networking.istio.io/tunnel` | default "http"  | quote }}
            {{- end }}
            service.istio.io/canonical-name: {{ index .ObjectMeta.Labels `service.istio.io/canonical-name` | default (index .ObjectMeta.Labels `app.kubernetes.io/name`) | default (index .ObjectMeta.Labels `app`) | default .DeploymentMeta.Name  | quote }}
            service.istio.io/canonical-revision: {{ index .ObjectMeta.Labels `service.istio.io/canonical-revision` | default (index .ObjectMeta.Labels `app.kubernetes.io/version`) | default (index .ObjectMeta.Labels `version`) | default "latest"  | quote }}
          annotations: {
            {{- if ge (len $containers) 1 }}
            {{- if not (isset .ObjectMeta.Annotations `kubectl.kubernetes.io/default-logs-container`) }}
            kubectl.kubernetes.io/default-logs-container: "{{ index $containers 0 }}",
            {{- end }}
            {{- if not (isset .ObjectMeta.Annotations `kubectl.kubernetes.io/default-container`) }}
            kubectl.kubernetes.io/default-container: "{{ index $containers 0 }}",
            {{- end }}
            {{- end }}
        {{- if .Values.istio_cni.enabled }}
            {{- if not .Values.istio_cni.chained }}
            k8s.v1.cni.cncf.io/networks: '{{ appendMultusNetwork (index .ObjectMeta.Annotations `k8s.v1.cni.cncf.io/networks`) `istio-cni` }}',
            {{- end }}
            sidecar.istio.io/interceptionMode: "{{ annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode }}",
            {{ with annotation .ObjectMeta `traffic.sidecar.istio.io/includeOutboundIPRanges` .Values.global.proxy.includeIPRanges }}traffic.sidecar.istio.io/includeOutboundIPRanges: "{{.}}",{{ end }}
            {{ with annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundIPRanges` .Values.global.proxy.excludeIPRanges }}traffic.sidecar.istio.io/excludeOutboundIPRanges: "{{.}}",{{ end }}
            {{ with annotation .ObjectMeta `traffic.sidecar.istio.io/includeInboundPorts` .Values.global.proxy.includeInboundPorts }}traffic.sidecar.istio.io/includeInboundPorts: "{{.}}",{{ end }}
            traffic.sidecar.istio.io/excludeInboundPorts: "{{ excludeInboundPort (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) (annotation .ObjectMeta `traffic.sidecar.istio.io/excludeInboundPorts` .Values.global.proxy.excludeInboundPorts) }}",
            {{ if or (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/includeOutboundPorts`) (ne (valueOrDefault .Values.global.proxy.includeOutboundPorts "") "") }}
            traffic.sidecar.istio.io/includeOutboundPorts: "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeOutboundPorts` .Values.global.proxy.includeOutboundPorts }}",
            {{- end }}
            {{ if or (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeOutboundPorts`) (ne .Values.global.proxy.excludeOutboundPorts "") }}
            traffic.sidecar.istio.io/excludeOutboundPorts: "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundPorts` .Values.global.proxy.excludeOutboundPorts }}",
            {{- end }}
            {{ with index .ObjectMeta.Annotations `traffic.sidecar.istio.io/kubevirtInterfaces` }}traffic.sidecar.istio.io/kubevirtInterfaces: "{{.}}",{{ end }}
            {{ with index .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeInterfaces` }}traffic.sidecar.istio.io/excludeInterfaces: "{{.}}",{{ end }}
        {{- end }}
          }
        spec:
          {{- $holdProxy := or .ProxyConfig.HoldApplicationUntilProxyStarts.GetValue .Values.global.proxy.holdApplicationUntilProxyStarts }}
          initContainers:
          {{ if ne (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `NONE` }}
          {{ if .Values.istio_cni.enabled -}}
          - name: istio-validation
          {{ else -}}
          - name: istio-init
          {{ end -}}
          {{- if contains "/" (annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy_init.image) }}
            image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy_init.image }}"
          {{- else }}
            image: "{{ .ProxyImage }}"
          {{- end }}
            args:
            - istio-iptables
            - "-p"
            - {{ .MeshConfig.ProxyListenPort | default "15001" | quote }}
            - "-z"
            - "15006"
            - "-u"
            - "1337"
            - "-m"
            - "{{ annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode }}"
            - "-i"
            - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeOutboundIPRanges` .Values.global.proxy.includeIPRanges }}"
            - "-x"
            - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundIPRanges` .Values.global.proxy.excludeIPRanges }}"
            - "-b"
            - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeInboundPorts` .Values.global.proxy.includeInboundPorts }}"
            - "-d"
          {{- if excludeInboundPort (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) (annotation .ObjectMeta `traffic.sidecar.istio.io/excludeInboundPorts` .Values.global.proxy.excludeInboundPorts) }}
            - "15090,15021,{{ excludeInboundPort (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) (annotation .ObjectMeta `traffic.sidecar.istio.io/excludeInboundPorts` .Values.global.proxy.excludeInboundPorts) }}"
          {{- else }}
            - "15090,15021"
          {{- end }}
            {{ if or (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/includeOutboundPorts`) (ne (valueOrDefault .Values.global.proxy.includeOutboundPorts "") "") -}}
            - "-q"
            - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeOutboundPorts` .Values.global.proxy.includeOutboundPorts }}"
            {{ end -}}
            {{ if or (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeOutboundPorts`) (ne (valueOrDefault .Values.global.proxy.excludeOutboundPorts "") "") -}}
            - "-o"
            - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundPorts` .Values.global.proxy.excludeOutboundPorts }}"
            {{ end -}}
            {{ if (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/kubevirtInterfaces`) -}}
            - "-k"
            - "{{ index .ObjectMeta.Annotations `traffic.sidecar.istio.io/kubevirtInterfaces` }}"
            {{ end -}}
             {{ if (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeInterfaces`) -}}
            - "-c"
            - "{{ index .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeInterfaces` }}"
            {{ end -}}
            - "--log_output_level={{ annotation .ObjectMeta `sidecar.istio.io/agentLogLevel` .Values.global.logging.level }}"
            {{ if .Values.global.logAsJson -}}
            - "--log_as_json"
            {{ end -}}
            {{ if .Values.istio_cni.enabled -}}
            - "--run-validation"
            - "--skip-rule-apply"
            {{ end -}}
            {{with .Values.global.imagePullPolicy }}imagePullPolicy: "{{.}}"{{end}}
          {{- if .ProxyConfig.ProxyMetadata }}
            env:
            {{- range $key, $value := .ProxyConfig.ProxyMetadata }}
            - name: {{ $key }}
              value: "{{ $value }}"
            {{- end }}
          {{- end }}
            resources:
          {{ template "resources" . }}
            securityContext:
              allowPrivilegeEscalation: {{ .Values.global.proxy.privileged }}
              privileged: {{ .Values.global.proxy.privileged }}
              capabilities:
            {{- if not .Values.istio_cni.enabled }}
                add:
                - NET_ADMIN
                - NET_RAW
            {{- end }}
                drop:
                - ALL
            {{- if not .Values.istio_cni.enabled }}
              readOnlyRootFilesystem: false
              runAsGroup: 0
              runAsNonRoot: false
              runAsUser: 0
            {{- else }}
              readOnlyRootFilesystem: true
              runAsGroup: 1337
              runAsUser: 1337
              runAsNonRoot: true
            {{- end }}
            restartPolicy: Always
          {{ end -}}
          {{- if eq (annotation .ObjectMeta `sidecar.istio.io/enableCoreDump` .Values.global.proxy.enableCoreDump) "true" }}
          - name: enable-core-dump
            args:
            - -c
            - sysctl -w kernel.core_pattern=/var/lib/istio/data/core.proxy && ulimit -c unlimited
            command:
              - /bin/sh
          {{- if contains "/" (annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy_init.image) }}
            image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy_init.image }}"
          {{- else }}
            image: "{{ .ProxyImage }}"
          {{- end }}
            {{with .Values.global.imagePullPolicy }}imagePullPolicy: "{{.}}"{{end}}
            resources:
          {{ template "resources" . }}
            securityContext:
              allowPrivilegeEscalation: true
              capabilities:
                add:
                - SYS_ADMIN
                drop:
                - ALL
              privileged: true
              readOnlyRootFilesystem: false
              runAsGroup: 0
              runAsNonRoot: false
              runAsUser: 0
          {{ end }}
          containers:
          - name: istio-proxy
          {{- if contains "/" (annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image) }}
            image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image }}"
          {{- else }}
            image: "{{ .ProxyImage }}"
          {{- end }}
            ports:
            - containerPort: 15090
              protocol: TCP
              name: http-envoy-prom
            args:
            - proxy
            - sidecar
            - --domain
            - $(POD_NAMESPACE).svc.{{ .Values.global.proxy.clusterDomain }}
            - --proxyLogLevel={{ annotation .ObjectMeta `sidecar.istio.io/logLevel` .Values.global.proxy.logLevel }}
            - --proxyComponentLogLevel={{ annotation .ObjectMeta `sidecar.istio.io/componentLogLevel` .Values.global.proxy.componentLogLevel }}
            - --log_output_level={{ annotation .ObjectMeta `sidecar.istio.io/agentLogLevel` .Values.global.logging.level }}
          {{- if .Values.global.sts.servicePort }}
            - --stsPort={{ .Values.global.sts.servicePort }}
          {{- end }}
          {{- if .Values.global.logAsJson }}
            - --log_as_json
          {{- end }}
          {{- if gt .EstimatedConcurrency 0 }}
            - --concurrency
            - "{{ .EstimatedConcurrency }}"
          {{- end -}}
          {{- if .Values.global.proxy.lifecycle }}
            lifecycle:
              {{ toYaml .Values.global.proxy.lifecycle | indent 6 }}
          {{- else if $holdProxy }}
            lifecycle:
              postStart:
                exec:
                  command:
                  - pilot-agent
                  - wait
          {{- end }}
            env:
            {{- if eq (env "PILOT_ENABLE_INBOUND_PASSTHROUGH" "true") "false" }}
            - name: REWRITE_PROBE_LEGACY_LOCALHOST_DESTINATION
              value: "true"
            {{- end }}
            - name: JWT_POLICY
              value: {{ .Values.global.jwtPolicy }}
            - name: PILOT_CERT_PROVIDER
              value: {{ .Values.global.pilotCertProvider }}
            - name: CA_ADDR
            {{- if .Values.global.caAddress }}
              value: {{ .Values.global.caAddress }}
            {{- else }}
              value: istiod{{- if not (eq .Values.revision "") }}-{{ .Values.revision }}{{- end }}.{{ .Values.global.istioNamespace }}.svc:15012
            {{- end }}
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: INSTANCE_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: SERVICE_ACCOUNT
              valueFrom:
                fieldRef:
                  fieldPath: spec.serviceAccountName
            - name: HOST_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.hostIP
            - name: PROXY_CONFIG
              value: |
                     {{ protoToJSON .ProxyConfig }}
            - name: ISTIO_META_POD_PORTS
              value: |-
                [
                {{- $first := true }}
                {{- range $index1, $c := .Spec.Containers }}
                  {{- range $index2, $p := $c.Ports }}
                    {{- if (structToJSON $p) }}
                    {{if not $first}},{{end}}{{ structToJSON $p }}
                    {{- $first = false }}
                    {{- end }}
                  {{- end}}
                {{- end}}
                ]
            - name: ISTIO_META_APP_CONTAINERS
              value: "{{ $containers | join "," }}"
            - name: ISTIO_META_CLUSTER_ID
              value: "{{ valueOrDefault .Values.global.multiCluster.clusterName `Kubernetes` }}"
            - name: ISTIO_META_INTERCEPTION_MODE
              value: "{{ or (index .ObjectMeta.Annotations `sidecar.istio.io/interceptionMode`) .ProxyConfig.InterceptionMode.String }}"
            {{- if .Values.global.network }}
            - name: ISTIO_META_NETWORK
              value: "{{ .Values.global.network }}"
            {{- end }}
            {{- if .DeploymentMeta.Name }}
            - name: ISTIO_META_WORKLOAD_NAME
              value: "{{ .DeploymentMeta.Name }}"
            {{ end }}
            {{- if and .TypeMeta.APIVersion .DeploymentMeta.Name }}
            - name: ISTIO_META_OWNER
              value: kubernetes://apis/{{ .TypeMeta.APIVersion }}/namespaces/{{ valueOrDefault .DeploymentMeta.Namespace `default` }}/{{ toLower .TypeMeta.Kind}}s/{{ .DeploymentMeta.Name }}
            {{- end}}
            {{- if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
            - name: ISTIO_BOOTSTRAP_OVERRIDE
              value: "/etc/istio/custom-bootstrap/custom_bootstrap.json"
            {{- end }}
            {{- if .Values.global.meshID }}
            - name: ISTIO_META_MESH_ID
              value: "{{ .Values.global.meshID }}"
            {{- else if (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain) }}
            - name: ISTIO_META_MESH_ID
              value: "{{ (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain) }}"
            {{- end }}
            {{- with (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain)  }}
            - name: TRUST_DOMAIN
              value: "{{ . }}"
            {{- end }}
            {{- if and (eq .Values.global.proxy.tracer "datadog") (isset .ObjectMeta.Annotations `apm.datadoghq.com/env`) }}
            {{- range $key, $value := fromJSON (index .ObjectMeta.Annotations `apm.datadoghq.com/env`) }}
            - name: {{ $key }}
              value: "{{ $value }}"
            {{- end }}
            {{- end }}
            {{- range $key, $value := .ProxyConfig.ProxyMetadata }}
            - name: {{ $key }}
              value: "{{ $value }}"
            {{- end }}
            {{with .Values.global.imagePullPolicy }}imagePullPolicy: "{{.}}"{{end}}
            {{ if ne (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) `0` }}
            readinessProbe:
              httpGet:
                path: /healthz/ready
                port: 15021
              initialDelaySeconds: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/initialDelaySeconds` .Values.global.proxy.readinessInitialDelaySeconds }}
              periodSeconds: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/periodSeconds` .Values.global.proxy.readinessPeriodSeconds }}
              timeoutSeconds: 3
              failureThreshold: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/failureThreshold` .Values.global.proxy.readinessFailureThreshold }}
            {{ end -}}
            securityContext:
              {{- if eq (index .ProxyConfig.ProxyMetadata "IPTABLES_TRACE_LOGGING") "true" }}
              allowPrivilegeEscalation: true
              capabilities:
                add:
                - NET_ADMIN
                drop:
                - ALL
              privileged: true
              readOnlyRootFilesystem: {{ ne (annotation .ObjectMeta `sidecar.istio.io/enableCoreDump` .Values.global.proxy.enableCoreDump) "true" }}
              runAsGroup: 1337
              fsGroup: 1337
              runAsNonRoot: false
              runAsUser: 0
              {{- else }}
              allowPrivilegeEscalation: {{ .Values.global.proxy.privileged }}
              capabilities:
                {{ if or (eq (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `TPROXY`) (eq (annotation .ObjectMeta `sidecar.istio.io/capNetBindService` .Values.global.proxy.capNetBindService) `true`) -}}
                add:
                {{ if eq (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `TPROXY` -}}
                - NET_ADMIN
                {{- end }}
                {{ if eq (annotation .ObjectMeta `sidecar.istio.io/capNetBindService` .Values.global.proxy.capNetBindService) `true` -}}
                - NET_BIND_SERVICE
                {{- end }}
                {{- end }}
                drop:
                - ALL
              privileged: {{ .Values.global.proxy.privileged }}
              readOnlyRootFilesystem: {{ ne (annotation .ObjectMeta `sidecar.istio.io/enableCoreDump` .Values.global.proxy.enableCoreDump) "true" }}
              runAsGroup: 1337
              fsGroup: 1337
              {{ if or (eq (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `TPROXY`) (eq (annotation .ObjectMeta `sidecar.istio.io/capNetBindService` .Values.global.proxy.capNetBindService) `true`) -}}
              runAsNonRoot: false
              runAsUser: 0
              {{- else -}}
              runAsNonRoot: true
              runAsUser: 1337
              {{- end }}
              {{- end }}
            resources:
          {{ template "resources" . }}
            volumeMounts:
            - name: workload-socket
              mountPath: /var/run/secrets/workload-spiffe-uds
            - name: credential-socket
              mountPath: /var/run/secrets/credential-uds
            {{- if eq .Values.global.caName "GkeWorkloadCertificate" }}
            - name: gke-workload-certificate
              mountPath: /var/run/secrets/workload-spiffe-credentials
              readOnly: true
            {{- else }}
            - name: workload-certs
              mountPath: /var/run/secrets/workload-spiffe-credentials
            {{- end }}
            {{- if eq .Values.global.pilotCertProvider "istiod" }}
            - mountPath: /var/run/secrets/istio
              name: istiod-ca-cert
            {{- end }}
            - mountPath: /var/lib/istio/data
              name: istio-data
            {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
            - mountPath: /etc/istio/custom-bootstrap
              name: custom-bootstrap-volume
            {{- end }}
            # SDS channel between istioagent and Envoy
            - mountPath: /etc/istio/proxy
              name: istio-envoy
            {{- if eq .Values.global.jwtPolicy "third-party-jwt" }}
            - mountPath: /var/run/secrets/tokens
              name: istio-token
            {{- end }}
            {{- if .Values.global.mountMtlsCerts }}
            # Use the key and cert mounted to /etc/certs/ for the in-cluster mTLS communications.
            - mountPath: /etc/certs/
              name: istio-certs
              readOnly: true
            {{- end }}
            - name: istio-podinfo
              mountPath: /etc/istio/pod
             {{- if and (eq .Values.global.proxy.tracer "lightstep") .ProxyConfig.GetTracing.GetTlsSettings }}
            - mountPath: {{ directory .ProxyConfig.GetTracing.GetTlsSettings.GetCaCertificates }}
              name: lightstep-certs
              readOnly: true
            {{- end }}
              {{- if isset .ObjectMeta.Annotations `sidecar.istio.io/userVolumeMount` }}
              {{ range $index, $value := fromJSON (index .ObjectMeta.Annotations `sidecar.istio.io/userVolumeMount`) }}
            - name: "{{  $index }}"
              {{ toYaml $value | indent 6 }}
              {{ end }}
              {{- end }}
          volumes:
          - emptyDir:
            name: workload-socket
          - emptyDir:
            name: credential-socket
          {{- if eq .Values.global.caName "GkeWorkloadCertificate" }}
          - name: gke-workload-certificate
            csi:
              driver: workloadcertificates.security.cloud.google.com
          {{- else }}
          - emptyDir:
            name: workload-certs
          {{- end }}
          {{- if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
          - name: custom-bootstrap-volume
            configMap:
              name: {{ annotation .ObjectMeta `sidecar.istio.io/bootstrapOverride` "" }}
          {{- end }}
          # SDS channel between istioagent and Envoy
          - emptyDir:
              medium: Memory
            name: istio-envoy
          - name: istio-data
            emptyDir: {}
          - name: istio-podinfo
            downwardAPI:
              items:
                - path: "labels"
                  fieldRef:
                    fieldPath: metadata.labels
                - path: "annotations"
                  fieldRef:
                    fieldPath: metadata.annotations
          {{- if eq .Values.global.jwtPolicy "third-party-jwt" }}
          - name: istio-token
            projected:
              sources:
              - serviceAccountToken:
                  path: istio-token
                  expirationSeconds: 43200
                  audience: {{ .Values.global.sds.token.aud }}
          {{- end }}
          {{- if eq .Values.global.pilotCertProvider "istiod" }}
          - name: istiod-ca-cert
            configMap:
              name: istio-ca-root-cert
          {{- end }}
          {{- if .Values.global.mountMtlsCerts }}
          # Use the key and cert mounted to /etc/certs/ for the in-cluster mTLS communications.
          - name: istio-certs
            secret:
              optional: true
              {{ if eq .Spec.ServiceAccountName "" }}
              secretName: istio.default
              {{ else -}}
              secretName: {{  printf "istio.%s" .Spec.ServiceAccountName }}
              {{  end -}}
          {{- end }}
            {{- if isset .ObjectMeta.Annotations `sidecar.istio.io/userVolume` }}
            {{range $index, $value := fromJSON (index .ObjectMeta.Annotations `sidecar.istio.io/userVolume`) }}
          - name: "{{ $index }}"
            {{ toYaml $value | indent 4 }}
            {{ end }}
            {{ end }}
          {{- if and (eq .Values.global.proxy.tracer "lightstep") .ProxyConfig.GetTracing.GetTlsSettings }}
          - name: lightstep-certs
            secret:
              optional: true
              secretName: lightstep.cacert
          {{- end }}
          {{- if .Values.global.imagePullSecrets }}
          imagePullSecrets:
            {{- range .Values.global.imagePullSecrets }}
            - name: {{ . }}
            {{- end }}
          {{- end }}
          {{- if eq (env "ENABLE_LEGACY_FSGROUP_INJECTION" "false") "true" }}
          securityContext:
            fsGroup: 1337
          {{- end }}
      gateway: |
        {{- $containers := list }}
        {{- range $index, $container := .Spec.Containers }}{{ if not (eq $container.Name "istio-proxy") }}{{ $containers = append $containers $container.Name }}{{end}}{{- end}}
        metadata:
          labels:
            service.istio.io/canonical-name: {{ index .ObjectMeta.Labels `service.istio.io/canonical-name` | default (index .ObjectMeta.Labels `app.kubernetes.io/name`) | default (index .ObjectMeta.Labels `app`) | default .DeploymentMeta.Name  | quote }}
            service.istio.io/canonical-revision: {{ index .ObjectMeta.Labels `service.istio.io/canonical-revision` | default (index .ObjectMeta.Labels `app.kubernetes.io/version`) | default (index .ObjectMeta.Labels `version`) | default "latest"  | quote }}
            istio.io/rev: {{ .Revision | default "default" | quote }}
          annotations: {
            {{- if eq (len $containers) 1 }}
            kubectl.kubernetes.io/default-logs-container: "{{ index $containers 0 }}",
            kubectl.kubernetes.io/default-container: "{{ index $containers 0 }}",
            {{ end }}
          }
        spec:
          containers:
          - name: istio-proxy
          {{- if contains "/" .Values.global.proxy.image }}
            image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image }}"
          {{- else }}
            image: "{{ .ProxyImage }}"
          {{- end }}
            ports:
            - containerPort: 15090
              protocol: TCP
              name: http-envoy-prom
            args:
            - proxy
            - router
            - --domain
            - $(POD_NAMESPACE).svc.{{ .Values.global.proxy.clusterDomain }}
            - --proxyLogLevel={{ annotation .ObjectMeta `sidecar.istio.io/logLevel` .Values.global.proxy.logLevel }}
            - --proxyComponentLogLevel={{ annotation .ObjectMeta `sidecar.istio.io/componentLogLevel` .Values.global.proxy.componentLogLevel }}
            - --log_output_level={{ annotation .ObjectMeta `sidecar.istio.io/agentLogLevel` .Values.global.logging.level }}
          {{- if .Values.global.sts.servicePort }}
            - --stsPort={{ .Values.global.sts.servicePort }}
          {{- end }}
          {{- if .Values.global.logAsJson }}
            - --log_as_json
          {{- end }}
          {{- if .Values.global.proxy.lifecycle }}
            lifecycle:
              {{ toYaml .Values.global.proxy.lifecycle | indent 6 }}
          {{- end }}
            env:
            - name: JWT_POLICY
              value: {{ .Values.global.jwtPolicy }}
            - name: PILOT_CERT_PROVIDER
              value: {{ .Values.global.pilotCertProvider }}
            - name: CA_ADDR
            {{- if .Values.global.caAddress }}
              value: {{ .Values.global.caAddress }}
            {{- else }}
              value: istiod{{- if not (eq .Values.revision "") }}-{{ .Values.revision }}{{- end }}.{{ .Values.global.istioNamespace }}.svc:15012
            {{- end }}
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: INSTANCE_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: SERVICE_ACCOUNT
              valueFrom:
                fieldRef:
                  fieldPath: spec.serviceAccountName
            - name: HOST_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.hostIP
            - name: PROXY_CONFIG
              value: |
                     {{ protoToJSON .ProxyConfig }}
            - name: ISTIO_META_POD_PORTS
              value: |-
                [
                {{- $first := true }}
                {{- range $index1, $c := .Spec.Containers }}
                  {{- range $index2, $p := $c.Ports }}
                    {{- if (structToJSON $p) }}
                    {{if not $first}},{{end}}{{ structToJSON $p }}
                    {{- $first = false }}
                    {{- end }}
                  {{- end}}
                {{- end}}
                ]
            - name: ISTIO_META_APP_CONTAINERS
              value: "{{ $containers | join "," }}"
            - name: ISTIO_META_CLUSTER_ID
              value: "{{ valueOrDefault .Values.global.multiCluster.clusterName `Kubernetes` }}"
            - name: ISTIO_META_INTERCEPTION_MODE
              value: "{{ .ProxyConfig.InterceptionMode.String }}"
            {{- if .Values.global.network }}
            - name: ISTIO_META_NETWORK
              value: "{{ .Values.global.network }}"
            {{- end }}
            {{- if .DeploymentMeta.Name }}
            - name: ISTIO_META_WORKLOAD_NAME
              value: "{{ .DeploymentMeta.Name }}"
            {{ end }}
            {{- if and .TypeMeta.APIVersion .DeploymentMeta.Name }}
            - name: ISTIO_META_OWNER
              value: kubernetes://apis/{{ .TypeMeta.APIVersion }}/namespaces/{{ valueOrDefault .DeploymentMeta.Namespace `default` }}/{{ toLower .TypeMeta.Kind}}s/{{ .DeploymentMeta.Name }}
            {{- end}}
            {{- if .Values.global.meshID }}
            - name: ISTIO_META_MESH_ID
              value: "{{ .Values.global.meshID }}"
            {{- else if (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain) }}
            - name: ISTIO_META_MESH_ID
              value: "{{ (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain) }}"
            {{- end }}
            {{- with (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain)  }}
            - name: TRUST_DOMAIN
              value: "{{ . }}"
            {{- end }}
            {{- range $key, $value := .ProxyConfig.ProxyMetadata }}
            - name: {{ $key }}
              value: "{{ $value }}"
            {{- end }}
            {{with .Values.global.imagePullPolicy }}imagePullPolicy: "{{.}}"{{end}}
            readinessProbe:
              httpGet:
                path: /healthz/ready
                port: 15021
              initialDelaySeconds: {{.Values.global.proxy.readinessInitialDelaySeconds }}
              periodSeconds: {{ .Values.global.proxy.readinessPeriodSeconds }}
              timeoutSeconds: 3
              failureThreshold: {{ .Values.global.proxy.readinessFailureThreshold }}
            volumeMounts:
            - name: workload-socket
              mountPath: /var/run/secrets/workload-spiffe-uds
            - name: credential-socket
              mountPath: /var/run/secrets/credential-uds
            {{- if eq .Values.global.caName "GkeWorkloadCertificate" }}
            - name: gke-workload-certificate
              mountPath: /var/run/secrets/workload-spiffe-credentials
              readOnly: true
            {{- else }}
            - name: workload-certs
              mountPath: /var/run/secrets/workload-spiffe-credentials
            {{- end }}
            {{- if eq .Values.global.pilotCertProvider "istiod" }}
            - mountPath: /var/run/secrets/istio
              name: istiod-ca-cert
            {{- end }}
            - mountPath: /var/lib/istio/data
              name: istio-data
            # SDS channel between istioagent and Envoy
            - mountPath: /etc/istio/proxy
              name: istio-envoy
            {{- if eq .Values.global.jwtPolicy "third-party-jwt" }}
            - mountPath: /var/run/secrets/tokens
              name: istio-token
            {{- end }}
            {{- if .Values.global.mountMtlsCerts }}
            # Use the key and cert mounted to /etc/certs/ for the in-cluster mTLS communications.
            - mountPath: /etc/certs/
              name: istio-certs
              readOnly: true
            {{- end }}
            - name: istio-podinfo
              mountPath: /etc/istio/pod
          volumes:
          - emptyDir: {}
            name: workload-socket
          - emptyDir: {}
            name: credential-socket
          {{- if eq .Values.global.caName "GkeWorkloadCertificate" }}
          - name: gke-workload-certificate
            csi:
              driver: workloadcertificates.security.cloud.google.com
          {{- else}}
          - emptyDir: {}
            name: workload-certs
          {{- end }}
          # SDS channel between istioagent and Envoy
          - emptyDir:
              medium: Memory
            name: istio-envoy
          - name: istio-data
            emptyDir: {}
          - name: istio-podinfo
            downwardAPI:
              items:
                - path: "labels"
                  fieldRef:
                    fieldPath: metadata.labels
                - path: "annotations"
                  fieldRef:
                    fieldPath: metadata.annotations
          {{- if eq .Values.global.jwtPolicy "third-party-jwt" }}
          - name: istio-token
            projected:
              sources:
              - serviceAccountToken:
                  path: istio-token
                  expirationSeconds: 43200
                  audience: {{ .Values.global.sds.token.aud }}
          {{- end }}
          {{- if eq .Values.global.pilotCertProvider "istiod" }}
          - name: istiod-ca-cert
            configMap:
              name: istio-ca-root-cert
          {{- end }}
          {{- if .Values.global.mountMtlsCerts }}
          # Use the key and cert mounted to /etc/certs/ for the in-cluster mTLS communications.
          - name: istio-certs
            secret:
              optional: true
              {{ if eq .Spec.ServiceAccountName "" }}
              secretName: istio.default
              {{ else -}}
              secretName: {{  printf "istio.%s" .Spec.ServiceAccountName }}
              {{  end -}}
          {{- end }}
          {{- if .Values.global.imagePullSecrets }}
          imagePullSecrets:
            {{- range .Values.global.imagePullSecrets }}
            - name: {{ . }}
            {{- end }}
          {{- end }}
          {{- if eq (env "ENABLE_LEGACY_FSGROUP_INJECTION" "false") "true" }}
          securityContext:
            fsGroup: 1337
          {{- end }}
      grpc-simple: |
        metadata:
          sidecar.istio.io/rewriteAppHTTPProbers: "false"
        spec:
          initContainers:
            - name: grpc-bootstrap-init
              image: busybox:1.28
              volumeMounts:
                - mountPath: /var/lib/grpc/data/
                  name: grpc-io-proxyless-bootstrap
              env:
                - name: INSTANCE_IP
                  valueFrom:
                    fieldRef:
                      fieldPath: status.podIP
                - name: POD_NAME
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.name
                - name: POD_NAMESPACE
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.namespace
                - name: ISTIO_NAMESPACE
                  value: |
                     {{ .Values.global.istioNamespace }}
              command:
                - sh
                - "-c"
                - |-
                  NODE_ID="sidecar~$${INSTANCE_IP}~$${POD_NAME}.$${POD_NAMESPACE}~cluster.local"
                  SERVER_URI="dns:///istiod.$${ISTIO_NAMESPACE}.svc:15010"
                  echo '
                  {
                    "xds_servers": [
                      {
                        "server_uri": "'$${SERVER_URI}'",
                        "channel_creds": [{"type": "insecure"}],
                        "server_features" : ["xds_v3"]
                      }
                    ],
                    "node": {
                      "id": "'$${NODE_ID}'",
                      "metadata": {
                        "GENERATOR": "grpc"
                      }
                    }
                  }' > /var/lib/grpc/data/bootstrap.json
          containers:
          {{- range $index, $container := .Spec.Containers }}
          - name: {{ $container.Name }}
            env:
              - name: GRPC_XDS_BOOTSTRAP
                value: /var/lib/grpc/data/bootstrap.json
              - name: GRPC_GO_LOG_VERBOSITY_LEVEL
                value: "99"
              - name: GRPC_GO_LOG_SEVERITY_LEVEL
                value: info
            volumeMounts:
              - mountPath: /var/lib/grpc/data/
                name: grpc-io-proxyless-bootstrap
          {{- end }}
          volumes:
            - name: grpc-io-proxyless-bootstrap
              emptyDir: {}
      grpc-agent: |
        {{- define "resources"  }}
          {{- if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit`) }}
            {{- if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) }}
              requests:
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) -}}
                cpu: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU` }}"
                {{ end }}
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) -}}
                memory: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory` }}"
                {{ end }}
            {{- end }}
            {{- if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit`) }}
              limits:
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit`) -}}
                cpu: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyCPULimit` }}"
                {{ end }}
                {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit`) -}}
                memory: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyMemoryLimit` }}"
                {{ end }}
            {{- end }}
          {{- else }}
            {{- if .Values.global.proxy.resources }}
              {{ toYaml .Values.global.proxy.resources | indent 6 }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- $containers := list }}
        {{- range $index, $container := .Spec.Containers }}{{ if not (eq $container.Name "istio-proxy") }}{{ $containers = append $containers $container.Name }}{{end}}{{- end}}
        metadata:
          labels:
            {{/* security.istio.io/tlsMode: istio must be set by user, if gRPC is using mTLS initialization code. We can't set it automatically. */}}
            service.istio.io/canonical-name: {{ index .ObjectMeta.Labels `service.istio.io/canonical-name` | default (index .ObjectMeta.Labels `app.kubernetes.io/name`) | default (index .ObjectMeta.Labels `app`) | default .DeploymentMeta.Name  | quote }}
            service.istio.io/canonical-revision: {{ index .ObjectMeta.Labels `service.istio.io/canonical-revision` | default (index .ObjectMeta.Labels `app.kubernetes.io/version`) | default (index .ObjectMeta.Labels `version`) | default "latest"  | quote }}
          annotations: {
            {{- if ge (len $containers) 1 }}
            {{- if not (isset .ObjectMeta.Annotations `kubectl.kubernetes.io/default-logs-container`) }}
            kubectl.kubernetes.io/default-logs-container: "{{ index $containers 0 }}",
            {{- end }}
            {{- if not (isset .ObjectMeta.Annotations `kubectl.kubernetes.io/default-container`) }}
            kubectl.kubernetes.io/default-container: "{{ index $containers 0 }}",
            {{- end }}
            {{- end }}
            sidecar.istio.io/rewriteAppHTTPProbers: "false",
          }
        spec:
          containers:
          - name: istio-proxy
          {{- if contains "/" (annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image) }}
            image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image }}"
          {{- else }}
            image: "{{ .ProxyImage }}"
          {{- end }}
            ports:
            - containerPort: 15020
              protocol: TCP
              name: mesh-metrics
            args:
            - proxy
            - sidecar
            - --domain
            - $(POD_NAMESPACE).svc.{{ .Values.global.proxy.clusterDomain }}
            - --proxyLogLevel={{ annotation .ObjectMeta `sidecar.istio.io/logLevel` .Values.global.proxy.logLevel }}
            - --proxyComponentLogLevel={{ annotation .ObjectMeta `sidecar.istio.io/componentLogLevel` .Values.global.proxy.componentLogLevel }}
            - --log_output_level={{ annotation .ObjectMeta `sidecar.istio.io/agentLogLevel` .Values.global.logging.level }}
          {{- if .Values.global.sts.servicePort }}
            - --stsPort={{ .Values.global.sts.servicePort }}
          {{- end }}
          {{- if .Values.global.logAsJson }}
            - --log_as_json
          {{- end }}
            lifecycle:
              postStart:
                exec:
                  command:
                  - pilot-agent
                  - wait
                  - --url=http://localhost:15020/healthz/ready
            env:
            - name: ISTIO_META_GENERATOR
              value: grpc
            - name: OUTPUT_CERTS
              value: /var/lib/istio/data
            {{- if eq (env "PILOT_ENABLE_INBOUND_PASSTHROUGH" "true") "false" }}
            - name: REWRITE_PROBE_LEGACY_LOCALHOST_DESTINATION
              value: "true"
            {{- end }}
            - name: JWT_POLICY
              value: {{ .Values.global.jwtPolicy }}
            - name: PILOT_CERT_PROVIDER
              value: {{ .Values.global.pilotCertProvider }}
            - name: CA_ADDR
            {{- if .Values.global.caAddress }}
              value: {{ .Values.global.caAddress }}
            {{- else }}
              value: istiod{{- if not (eq .Values.revision "") }}-{{ .Values.revision }}{{- end }}.{{ .Values.global.istioNamespace }}.svc:15012
            {{- end }}
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: INSTANCE_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: SERVICE_ACCOUNT
              valueFrom:
                fieldRef:
                  fieldPath: spec.serviceAccountName
            - name: HOST_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.hostIP
            - name: PROXY_CONFIG
              value: |
                     {{ protoToJSON .ProxyConfig }}
            - name: ISTIO_META_POD_PORTS
              value: |-
                [
                {{- $first := true }}
                {{- range $index1, $c := .Spec.Containers }}
                  {{- range $index2, $p := $c.Ports }}
                    {{- if (structToJSON $p) }}
                    {{if not $first}},{{end}}{{ structToJSON $p }}
                    {{- $first = false }}
                    {{- end }}
                  {{- end}}
                {{- end}}
                ]
            - name: ISTIO_META_APP_CONTAINERS
              value: "{{ $containers | join "," }}"
            - name: ISTIO_META_CLUSTER_ID
              value: "{{ valueOrDefault .Values.global.multiCluster.clusterName `Kubernetes` }}"
            {{- if .Values.global.network }}
            - name: ISTIO_META_NETWORK
              value: "{{ .Values.global.network }}"
            {{- end }}
            {{- if .DeploymentMeta.Name }}
            - name: ISTIO_META_WORKLOAD_NAME
              value: "{{ .DeploymentMeta.Name }}"
            {{ end }}
            {{- if and .TypeMeta.APIVersion .DeploymentMeta.Name }}
            - name: ISTIO_META_OWNER
              value: kubernetes://apis/{{ .TypeMeta.APIVersion }}/namespaces/{{ valueOrDefault .DeploymentMeta.Namespace `default` }}/{{ toLower .TypeMeta.Kind}}s/{{ .DeploymentMeta.Name }}
            {{- end}}
            {{- if .Values.global.meshID }}
            - name: ISTIO_META_MESH_ID
              value: "{{ .Values.global.meshID }}"
            {{- else if (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain) }}
            - name: ISTIO_META_MESH_ID
              value: "{{ (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain) }}"
            {{- end }}
            {{- with (valueOrDefault .MeshConfig.TrustDomain .Values.global.trustDomain)  }}
            - name: TRUST_DOMAIN
              value: "{{ . }}"
            {{- end }}
            {{- range $key, $value := .ProxyConfig.ProxyMetadata }}
            - name: {{ $key }}
              value: "{{ $value }}"
            {{- end }}
            # grpc uses xds:/// to resolve – no need to resolve VIP
            - name: ISTIO_META_DNS_CAPTURE
              value: "false"
            - name: DISABLE_ENVOY
              value: "true"
            {{with .Values.global.imagePullPolicy }}imagePullPolicy: "{{.}}"{{end}}
            {{ if ne (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) `0` }}
            readinessProbe:
              httpGet:
                path: /healthz/ready
                port: 15020
              initialDelaySeconds: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/initialDelaySeconds` .Values.global.proxy.readinessInitialDelaySeconds }}
              periodSeconds: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/periodSeconds` .Values.global.proxy.readinessPeriodSeconds }}
              timeoutSeconds: 3
              failureThreshold: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/failureThreshold` .Values.global.proxy.readinessFailureThreshold }}
            resources:
          {{ template "resources" . }}
            volumeMounts:
            - name: workload-socket
              mountPath: /var/run/secrets/workload-spiffe-uds
            {{- if eq .Values.global.caName "GkeWorkloadCertificate" }}
            - name: gke-workload-certificate
              mountPath: /var/run/secrets/workload-spiffe-credentials
              readOnly: true
            {{- else }}
            - name: workload-certs
              mountPath: /var/run/secrets/workload-spiffe-credentials
            {{- end }}
            {{- if eq .Values.global.pilotCertProvider "istiod" }}
            - mountPath: /var/run/secrets/istio
              name: istiod-ca-cert
            {{- end }}
            - mountPath: /var/lib/istio/data
              name: istio-data
            # UDS channel between istioagent and gRPC client for XDS/SDS
            - mountPath: /etc/istio/proxy
              name: istio-xds
            {{- if eq .Values.global.jwtPolicy "third-party-jwt" }}
            - mountPath: /var/run/secrets/tokens
              name: istio-token
            {{- end }}
            {{- if .Values.global.mountMtlsCerts }}
            # Use the key and cert mounted to /etc/certs/ for the in-cluster mTLS communications.
            - mountPath: /etc/certs/
              name: istio-certs
              readOnly: true
            {{- end }}
            - name: istio-podinfo
              mountPath: /etc/istio/pod
            {{- end }}
              {{- if isset .ObjectMeta.Annotations `sidecar.istio.io/userVolumeMount` }}
              {{ range $index, $value := fromJSON (index .ObjectMeta.Annotations `sidecar.istio.io/userVolumeMount`) }}
            - name: "{{  $index }}"
              {{ toYaml $value | indent 6 }}
              {{ end }}
              {{- end }}
        {{- range $index, $container := .Spec.Containers  }}
        {{ if not (eq $container.Name "istio-proxy") }}
          - name: {{ $container.Name }}
            env:
              - name: "GRPC_XDS_EXPERIMENTAL_SECURITY_SUPPORT"
                value: "true"
              - name: "GRPC_XDS_BOOTSTRAP"
                value: "/etc/istio/proxy/grpc-bootstrap.json"
            volumeMounts:
              - mountPath: /var/lib/istio/data
                name: istio-data
              # UDS channel between istioagent and gRPC client for XDS/SDS
              - mountPath: /etc/istio/proxy
                name: istio-xds
              {{- if eq $.Values.global.caName "GkeWorkloadCertificate" }}
              - name: gke-workload-certificate
                mountPath: /var/run/secrets/workload-spiffe-credentials
                readOnly: true
              {{- else }}
              - name: workload-certs
                mountPath: /var/run/secrets/workload-spiffe-credentials
              {{- end }}
        {{- end }}
        {{- end }}
          volumes:
          - emptyDir:
            name: workload-socket
          {{- if eq .Values.global.caName "GkeWorkloadCertificate" }}
          - name: gke-workload-certificate
            csi:
              driver: workloadcertificates.security.cloud.google.com
          {{- else }}
          - emptyDir:
            name: workload-certs
          {{- end }}
          {{- if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
          - name: custom-bootstrap-volume
            configMap:
              name: {{ annotation .ObjectMeta `sidecar.istio.io/bootstrapOverride` "" }}
          {{- end }}
          # SDS channel between istioagent and Envoy
          - emptyDir:
              medium: Memory
            name: istio-xds
          - name: istio-data
            emptyDir: {}
          - name: istio-podinfo
            downwardAPI:
              items:
                - path: "labels"
                  fieldRef:
                    fieldPath: metadata.labels
                - path: "annotations"
                  fieldRef:
                    fieldPath: metadata.annotations
          {{- if eq .Values.global.jwtPolicy "third-party-jwt" }}
          - name: istio-token
            projected:
              sources:
              - serviceAccountToken:
                  path: istio-token
                  expirationSeconds: 43200
                  audience: {{ .Values.global.sds.token.aud }}
          {{- end }}
          {{- if eq .Values.global.pilotCertProvider "istiod" }}
          - name: istiod-ca-cert
            configMap:
              name: istio-ca-root-cert
          {{- end }}
          {{- if .Values.global.mountMtlsCerts }}
          # Use the key and cert mounted to /etc/certs/ for the in-cluster mTLS communications.
          - name: istio-certs
            secret:
              optional: true
              {{ if eq .Spec.ServiceAccountName "" }}
              secretName: istio.default
              {{ else -}}
              secretName: {{  printf "istio.%s" .Spec.ServiceAccountName }}
              {{  end -}}
          {{- end }}
            {{- if isset .ObjectMeta.Annotations `sidecar.istio.io/userVolume` }}
            {{range $index, $value := fromJSON (index .ObjectMeta.Annotations `sidecar.istio.io/userVolume`) }}
          - name: "{{ $index }}"
            {{ toYaml $value | indent 4 }}
            {{ end }}
            {{ end }}
          {{- if .Values.global.imagePullSecrets }}
          imagePullSecrets:
            {{- range .Values.global.imagePullSecrets }}
            - name: {{ . }}
            {{- end }}
          {{- end }}
          {{- if eq (env "ENABLE_LEGACY_FSGROUP_INJECTION" "false") "true" }}
          securityContext:
            fsGroup: 1337
          {{- end }}
  values: |-
    {
      "global": {
        "autoscalingv2API": true,
        "caAddress": "",
        "caName": "",
        "configCluster": false,
        "configValidation": true,
        "defaultNodeSelector": {},
        "defaultPodDisruptionBudget": {
          "enabled": true
        },
        "defaultResources": {
          "requests": {
            "cpu": "10m"
          }
        },
        "enabled": true,
        "externalIstiod": false,
        "hub": "docker.io/istio",
        "imagePullPolicy": "",
        "imagePullSecrets": [],
        "istioNamespace": "istio-system",
        "istiod": {
          "enableAnalysis": false
        },
        "jwtPolicy": "third-party-jwt",
        "logAsJson": false,
        "logging": {
          "level": "default:info"
        },
        "meshID": "",
        "meshNetworks": {},
        "mountMtlsCerts": false,
        "multiCluster": {
          "clusterName": "",
          "enabled": false
        },
        "namespace": "istio-system",
        "network": "",
        "omitSidecarInjectorConfigMap": false,
        "oneNamespace": false,
        "operatorManageWebhooks": false,
        "pilotCertProvider": "istiod",
        "priorityClassName": "",
        "proxy": {
          "autoInject": "enabled",
          "clusterDomain": "cluster.local",
          "componentLogLevel": "misc:error",
          "enableCoreDump": false,
          "excludeIPRanges": "",
          "excludeInboundPorts": "",
          "excludeOutboundPorts": "",
          "holdApplicationUntilProxyStarts": false,
          "image": "proxyv2",
          "includeIPRanges": "*",
          "includeInboundPorts": "*",
          "includeOutboundPorts": "",
          "logLevel": "warning",
          "privileged": false,
          "readinessFailureThreshold": 30,
          "readinessInitialDelaySeconds": 1,
          "readinessPeriodSeconds": 2,
          "resources": {
            "limits": {
              "cpu": "2000m",
              "memory": "1024Mi"
            },
            "requests": {
              "cpu": "10m",
              "memory": "40Mi"
            }
          },
          "statusPort": 15020,
          "tracer": "zipkin"
        },
        "proxy_init": {
          "image": "proxyv2",
          "resources": {
            "limits": {
              "cpu": "2000m",
              "memory": "1024Mi"
            },
            "requests": {
              "cpu": "10m",
              "memory": "10Mi"
            }
          }
        },
        "remotePilotAddress": "",
        "sds": {
          "token": {
            "aud": "istio-ca"
          }
        },
        "sts": {
          "servicePort": 0
        },
        "tag": "1.16.0",
        "tracer": {
          "datadog": {
            "address": "$(HOST_IP):8126"
          },
          "lightstep": {
            "accessToken": "",
            "address": ""
          },
          "stackdriver": {
            "debug": false,
            "maxNumberOfAnnotations": 200,
            "maxNumberOfAttributes": 200,
            "maxNumberOfMessageEvents": 200
          },
          "zipkin": {
            "address": ""
          }
        },
        "useMCP": false,
        "variant": ""
      },
      "istio_cni": {
        "enabled": false
      },
      "revision": "",
      "sidecarInjectorWebhook": {
        "alwaysInjectSelector": [],
        "defaultTemplates": [],
        "enableNamespacesByDefault": false,
        "injectedAnnotations": {},
        "neverInjectSelector": [],
        "rewriteAppHTTPProbe": true,
        "templates": {}
      }
    }
kind: ConfigMap
metadata:
  labels:
    install.operator.istio.io/owning-resource: unknown
    istio.io/rev: default
    operator.istio.io/component: Pilot
    release: istio
  name: istio-sidecar-injector
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-service-ingressgateway" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: istio-ingressgateway
    install.operator.istio.io/owning-resource: unknown
    istio: ingressgateway
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    release: istio
  name: istio-ingressgateway
  namespace: istio-system
spec:
  ports:
  - name: status-port
    port: 15021
    protocol: TCP
    targetPort: 15021
  - name: http2
    port: 80
    protocol: TCP
    targetPort: 8080
  - name: https
    port: 443
    protocol: TCP
    targetPort: 8443
  - name: tcp
    port: 31400
    protocol: TCP
    targetPort: 31400
  - name: tls
    port: 15443
    protocol: TCP
    targetPort: 15443
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  type: LoadBalancer
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-service-istiod" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: istiod
    install.operator.istio.io/owning-resource: unknown
    istio: pilot
    istio.io/rev: default
    operator.istio.io/component: Pilot
    release: istio
  name: istiod
  namespace: istio-system
spec:
  ports:
  - name: grpc-xds
    port: 15010
    protocol: TCP
  - name: https-dns
    port: 15012
    protocol: TCP
  - name: https-webhook
    port: 443
    protocol: TCP
    targetPort: 15017
  - name: http-monitoring
    port: 15014
    protocol: TCP
  selector:
    app: istiod
    istio: pilot
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-deployment-ingressgateway" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: istio-ingressgateway
    install.operator.istio.io/owning-resource: unknown
    istio: ingressgateway
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    release: istio
  name: istio-ingressgateway
  namespace: istio-system
spec:
  selector:
    matchLabels:
      app: istio-ingressgateway
      istio: ingressgateway
  strategy:
    rollingUpdate:
      maxSurge: 100%
      maxUnavailable: 25%
  template:
    metadata:
      annotations:
        prometheus.io/path: /stats/prometheus
        prometheus.io/port: "15020"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      labels:
        app: istio-ingressgateway
        chart: gateways
        heritage: Tiller
        install.operator.istio.io/owning-resource: unknown
        istio: ingressgateway
        istio.io/rev: default
        operator.istio.io/component: IngressGateways
        release: istio
        service.istio.io/canonical-name: istio-ingressgateway
        service.istio.io/canonical-revision: latest
        sidecar.istio.io/inject: "false"
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution: null
          requiredDuringSchedulingIgnoredDuringExecution: null
      containers:
      - args:
        - proxy
        - router
        - --domain
        - $(POD_NAMESPACE).svc.cluster.local
        - --proxyLogLevel=warning
        - --proxyComponentLogLevel=misc:error
        - --log_output_level=default:info
        env:
        - name: JWT_POLICY
          value: third-party-jwt
        - name: PILOT_CERT_PROVIDER
          value: istiod
        - name: CA_ADDR
          value: istiod.istio-system.svc:15012
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        - name: POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: INSTANCE_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
        - name: HOST_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.hostIP
        - name: SERVICE_ACCOUNT
          valueFrom:
            fieldRef:
              fieldPath: spec.serviceAccountName
        - name: ISTIO_META_WORKLOAD_NAME
          value: istio-ingressgateway
        - name: ISTIO_META_OWNER
          value: kubernetes://apis/apps/v1/namespaces/istio-system/deployments/istio-ingressgateway
        - name: ISTIO_META_MESH_ID
          value: cluster.local
        - name: TRUST_DOMAIN
          value: cluster.local
        - name: ISTIO_META_UNPRIVILEGED_POD
          value: "true"
        - name: ISTIO_META_CLUSTER_ID
          value: Kubernetes
        image: docker.io/istio/proxyv2:1.16.0
        name: istio-proxy
        ports:
        - containerPort: 15021
          protocol: TCP
        - containerPort: 8080
          protocol: TCP
        - containerPort: 8443
          protocol: TCP
        - containerPort: 31400
          protocol: TCP
        - containerPort: 15443
          protocol: TCP
        - containerPort: 15090
          name: http-envoy-prom
          protocol: TCP
        readinessProbe:
          failureThreshold: 30
          httpGet:
            path: /healthz/ready
            port: 15021
            scheme: HTTP
          initialDelaySeconds: 1
          periodSeconds: 2
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          limits:
            cpu: 2000m
            memory: 1024Mi
          requests:
            cpu: 10m
            memory: 40Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          privileged: false
          readOnlyRootFilesystem: true
        volumeMounts:
        - mountPath: /var/run/secrets/workload-spiffe-uds
          name: workload-socket
        - mountPath: /var/run/secrets/credential-uds
          name: credential-socket
        - mountPath: /var/run/secrets/workload-spiffe-credentials
          name: workload-certs
        - mountPath: /etc/istio/proxy
          name: istio-envoy
        - mountPath: /etc/istio/config
          name: config-volume
        - mountPath: /var/run/secrets/istio
          name: istiod-ca-cert
        - mountPath: /var/run/secrets/tokens
          name: istio-token
          readOnly: true
        - mountPath: /var/lib/istio/data
          name: istio-data
        - mountPath: /etc/istio/pod
          name: podinfo
        - mountPath: /etc/istio/ingressgateway-certs
          name: ingressgateway-certs
          readOnly: true
        - mountPath: /etc/istio/ingressgateway-ca-certs
          name: ingressgateway-ca-certs
          readOnly: true
      securityContext:
        fsGroup: 1337
        runAsGroup: 1337
        runAsNonRoot: true
        runAsUser: 1337
      serviceAccountName: istio-ingressgateway-service-account
      volumes:
      - emptyDir: {}
        name: workload-socket
      - emptyDir: {}
        name: credential-socket
      - emptyDir: {}
        name: workload-certs
      - configMap:
          name: istio-ca-root-cert
        name: istiod-ca-cert
      - downwardAPI:
          items:
          - fieldRef:
              fieldPath: metadata.labels
            path: labels
          - fieldRef:
              fieldPath: metadata.annotations
            path: annotations
        name: podinfo
      - emptyDir: {}
        name: istio-envoy
      - emptyDir: {}
        name: istio-data
      - name: istio-token
        projected:
          sources:
          - serviceAccountToken:
              audience: istio-ca
              expirationSeconds: 43200
              path: istio-token
      - configMap:
          name: istio
          optional: true
        name: config-volume
      - name: ingressgateway-certs
        secret:
          optional: true
          secretName: istio-ingressgateway-certs
      - name: ingressgateway-ca-certs
        secret:
          optional: true
          secretName: istio-ingressgateway-ca-certs
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-deployment-istiod" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: istiod
    install.operator.istio.io/owning-resource: unknown
    istio: pilot
    istio.io/rev: default
    operator.istio.io/component: Pilot
    release: istio
  name: istiod
  namespace: istio-system
spec:
  replicas: 1
  selector:
    matchLabels:
      istio: pilot
  strategy:
    rollingUpdate:
      maxSurge: 100%
      maxUnavailable: 25%
  template:
    metadata:
      annotations:
        prometheus.io/port: "15014"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      labels:
        app: istiod
        install.operator.istio.io/owning-resource: unknown
        istio: pilot
        istio.io/rev: default
        operator.istio.io/component: Pilot
        sidecar.istio.io/inject: "false"
    spec:
      containers:
      - args:
        - discovery
        - --monitoringAddr=:15014
        - --log_output_level=default:info
        - --domain
        - cluster.local
        - --keepaliveMaxServerConnectionAge
        - 30m
        env:
        - name: ENABLE_DEBUG_ON_HTTP
        - name: REVISION
          value: default
        - name: JWT_POLICY
          value: third-party-jwt
        - name: PILOT_CERT_PROVIDER
          value: istiod
        - name: POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: SERVICE_ACCOUNT
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.serviceAccountName
        - name: KUBECONFIG
          value: /var/run/secrets/remote/config
        - name: PILOT_TRACE_SAMPLING
          value: "100"
        - name: PILOT_ENABLE_PROTOCOL_SNIFFING_FOR_OUTBOUND
          value: "true"
        - name: PILOT_ENABLE_PROTOCOL_SNIFFING_FOR_INBOUND
          value: "true"
        - name: ISTIOD_ADDR
          value: istiod.istio-system.svc:15012
        - name: PILOT_ENABLE_ANALYSIS
          value: "false"
        - name: CLUSTER_ID
          value: Kubernetes
        image: docker.io/istio/pilot:1.16.0
        name: discovery
        ports:
        - containerPort: 8080
          protocol: TCP
        - containerPort: 15010
          protocol: TCP
        - containerPort: 15017
          protocol: TCP
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 1
          periodSeconds: 3
          timeoutSeconds: 5
        resources:
          requests:
            cpu: 10m
            memory: 100Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsGroup: 1337
          runAsNonRoot: true
          runAsUser: 1337
        volumeMounts:
        - mountPath: /var/run/secrets/tokens
          name: istio-token
          readOnly: true
        - mountPath: /var/run/secrets/istio-dns
          name: local-certs
        - mountPath: /etc/cacerts
          name: cacerts
          readOnly: true
        - mountPath: /var/run/secrets/remote
          name: istio-kubeconfig
          readOnly: true
        - mountPath: /var/run/secrets/istiod/tls
          name: istio-csr-dns-cert
          readOnly: true
        - mountPath: /var/run/secrets/istiod/ca
          name: istio-csr-ca-configmap
          readOnly: true
      securityContext:
        fsGroup: 1337
      serviceAccountName: istiod
      volumes:
      - emptyDir:
          medium: Memory
        name: local-certs
      - name: istio-token
        projected:
          sources:
          - serviceAccountToken:
              audience: istio-ca
              expirationSeconds: 43200
              path: istio-token
      - name: cacerts
        secret:
          optional: true
          secretName: cacerts
      - name: istio-kubeconfig
        secret:
          optional: true
          secretName: istio-kubeconfig
      - name: istio-csr-dns-cert
        secret:
          optional: true
          secretName: istiod-tls
      - configMap:
          defaultMode: 420
          name: istio-ca-root-cert
          optional: true
        name: istio-csr-ca-configmap
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-pdb-istio-ingressgateway" {
  yaml_body = <<YAML
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  labels:
    app: istio-ingressgateway
    install.operator.istio.io/owning-resource: unknown
    istio: ingressgateway
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    release: istio
  name: istio-ingressgateway
  namespace: istio-system
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: istio-ingressgateway
      istio: ingressgateway
 YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-pdb-istiod" {
  yaml_body = <<YAML
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  labels:
    app: istiod
    install.operator.istio.io/owning-resource: unknown
    istio: pilot
    istio.io/rev: default
    operator.istio.io/component: Pilot
    release: istio
  name: istiod
  namespace: istio-system
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: istiod
      istio: pilot
 YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
} 

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-stats-filter-113" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: stats-filter-1.13
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.13.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.13.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_inbound
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.13.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-stats-filter-114" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: stats-filter-1.14
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.14.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.14.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_inbound
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.14.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-stats-filter-115" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: stats-filter-1.15
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.15.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.15.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_inbound
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.15.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-stats-filter-116" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: stats-filter-1.16
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.16.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.16.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_inbound
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
      proxy:
        proxyVersion: ^1\.16.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio",
                    "disable_host_header_fallback": true
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-tcp-stats-filter-113" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: tcp-stats-filter-1.13
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.13.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_inbound
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.13.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  - applyTo: NETWORK_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.13.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-tcp-stats-filter-114" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: tcp-stats-filter-1.14
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.14.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_inbound
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.14.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  - applyTo: NETWORK_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.14.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-tcp-stats-filter-115" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: tcp-stats-filter-1.15
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.15.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_inbound
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.15.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  - applyTo: NETWORK_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.15.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-tcp-stats-filter-116" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  labels:
    istio.io/rev: default
  name: tcp-stats-filter-1.16
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_INBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.16.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_inbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_inbound
  - applyTo: NETWORK_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.16.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  - applyTo: NETWORK_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.tcp_proxy
      proxy:
        proxyVersion: ^1\.16.*
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.stats
        typed_config:
          '@type': type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.network.wasm.v3.Wasm
          value:
            config:
              configuration:
                '@type': type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "debug": "false",
                    "stat_prefix": "istio"
                  }
              root_id: stats_outbound
              vm_config:
                code:
                  local:
                    inline_string: envoy.wasm.stats
                runtime: envoy.wasm.runtime.null
                vm_id: tcp_stats_outbound
  priority: -1
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-envoyfilter-x-forwarded-host" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: x-forwarded-host
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.http_connection_manager
            subFilter:
              name: envoy.router
    patch:
      operation: INSERT_BEFORE
      value:
        name: envoy.filters.http.lua
        typed_config:
          '@type': type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
          inlineCode: |
            function envoy_on_request(request_handle)
              local host = request_handle:headers():get(":authority")
              request_handle:headers():add("x-forwarded-host", host)
            end
  workloadSelector:
    labels:
      istio: ingressgateway
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace, kubectl_manifest.kubeflow-istio-crd-envoyfilters]
}

resource "kubectl_manifest" "kubeflow-istio-gateway-ingressgateway" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  labels:
    release: istio
  name: istio-ingressgateway
  namespace: istio-system
spec:
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  servers:
  - hosts:
    - '*'
    port:
      name: http
      number: 80
      protocol: HTTP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-authorizationpolicy-global-deny-all" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: global-deny-all
  namespace: istio-system
spec: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-authorizationpolicy-ingressgateway" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: istio-ingressgateway
  namespace: istio-system
spec:
  action: ALLOW
  rules:
  - {}
  selector:
    matchLabels:
      app: istio-ingressgateway
      istio: ingressgateway
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  labels:
    app: sidecar-injector
    install.operator.istio.io/owning-resource: unknown
    istio.io/rev: default
    operator.istio.io/component: Pilot
    release: istio
  name: istio-sidecar-injector
webhooks:
- admissionReviewVersions:
  - v1beta1
  - v1
  clientConfig:
    service:
      name: istiod
      namespace: istio-system
      path: /inject
      port: 443
  failurePolicy: Fail
  name: rev.namespace.sidecar-injector.istio.io
  namespaceSelector:
    matchExpressions:
    - key: istio.io/rev
      operator: In
      values:
      - default
    - key: istio-injection
      operator: DoesNotExist
  objectSelector:
    matchExpressions:
    - key: sidecar.istio.io/inject
      operator: NotIn
      values:
      - "false"
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    resources:
    - pods
  sideEffects: None
- admissionReviewVersions:
  - v1beta1
  - v1
  clientConfig:
    service:
      name: istiod
      namespace: istio-system
      path: /inject
      port: 443
  failurePolicy: Fail
  name: rev.object.sidecar-injector.istio.io
  namespaceSelector:
    matchExpressions:
    - key: istio.io/rev
      operator: DoesNotExist
    - key: istio-injection
      operator: DoesNotExist
  objectSelector:
    matchExpressions:
    - key: sidecar.istio.io/inject
      operator: NotIn
      values:
      - "false"
    - key: istio.io/rev
      operator: In
      values:
      - default
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    resources:
    - pods
  sideEffects: None
- admissionReviewVersions:
  - v1beta1
  - v1
  clientConfig:
    service:
      name: istiod
      namespace: istio-system
      path: /inject
      port: 443
  failurePolicy: Fail
  name: namespace.sidecar-injector.istio.io
  namespaceSelector:
    matchExpressions:
    - key: istio-injection
      operator: In
      values:
      - enabled
  objectSelector:
    matchExpressions:
    - key: sidecar.istio.io/inject
      operator: NotIn
      values:
      - "false"
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    resources:
    - pods
  sideEffects: None
- admissionReviewVersions:
  - v1beta1
  - v1
  clientConfig:
    service:
      name: istiod
      namespace: istio-system
      path: /inject
      port: 443
  failurePolicy: Fail
  name: object.sidecar-injector.istio.io
  namespaceSelector:
    matchExpressions:
    - key: istio-injection
      operator: DoesNotExist
    - key: istio.io/rev
      operator: DoesNotExist
  objectSelector:
    matchExpressions:
    - key: sidecar.istio.io/inject
      operator: In
      values:
      - "true"
    - key: istio.io/rev
      operator: DoesNotExist
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    resources:
    - pods
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-istio-validatingwebhookconfiguration-validator-istio-system" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  labels:
    app: istiod
    istio: istiod
    istio.io/rev: default
    release: istio
  name: istio-validator-istio-system
webhooks:
- admissionReviewVersions:
  - v1beta1
  - v1
  clientConfig:
    service:
      name: istiod
      namespace: istio-system
      path: /validate
  failurePolicy: Ignore
  name: rev.validation.istio.io
  objectSelector:
    matchExpressions:
    - key: istio.io/rev
      operator: In
      values:
      - default
  rules:
  - apiGroups:
    - security.istio.io
    - networking.istio.io
    - telemetry.istio.io
    - extensions.istio.io
    apiVersions:
    - '*'
    operations:
    - CREATE
    - UPDATE
    resources:
    - '*'
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}