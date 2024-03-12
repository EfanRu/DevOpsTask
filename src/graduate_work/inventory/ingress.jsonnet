local kp =
  (import 'kube-prometheus/main.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },
    },
    prometheus+:: {
      prometheus+: {
        spec+: {
          externalUrl: 'http://prometheus.example.com',
        },
      },
    },
    ingress+:: {
      'prometheus-k8s': {
        apiVersion: 'networking.k8s.io/v1',
        kind: 'Ingress',
        metadata: {
          name: $.prometheus.prometheus.metadata.name,
          namespace: $.prometheus.prometheus.metadata.namespace,
          annotations: {
            'nginx.ingress.kubernetes.io/auth-type': 'basic',
            'nginx.ingress.kubernetes.io/auth-secret': 'basic-auth',
            'nginx.ingress.kubernetes.io/auth-realm': 'Authentication Required',
          },
        },
        spec: {
          rules: [{
            host: 'prometheus.example.com',
            http: {
              paths: [{
                backend: {
                  service: {
                    name: $.prometheus.service.metadata.name,
                    port: 'web',
                  },
                },
              }],
            },
          }],
        },
    },
  } + {
    ingress+:: {
      'basic-auth-secret': {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata: {
          name: 'basic-auth',
          namespace: $._config.namespace,
        },
        data: { auth: std.base64('1264') },
        type: 'Opaque',
      },
    },
  };