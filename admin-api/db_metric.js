const opentelemetry = require('@opentelemetry/api');
const {
  MeterProvider,
  PeriodicExportingMetricReader,
} = require('@opentelemetry/sdk-metrics');
const { Resource } = require('@opentelemetry/resources');
const { SemanticResourceAttributes } = require('@opentelemetry/semantic-conventions');
const { OTLPMetricExporter } = require('@opentelemetry/exporter-metrics-otlp-proto')

const resource = Resource.default().merge(
  new Resource({
    [SemanticResourceAttributes.SERVICE_NAME]: 'reservoir-server',
    [SemanticResourceAttributes.SERVICE_VERSION]: '0.1.0',
  }),
);

const metricReader = new PeriodicExportingMetricReader({
  exporter: new OTLPMetricExporter({
    url: 'http://otel-collector:4318/v1/metrics',
    headers: {},
    concurrencyLimit: 1,
  }),

  // Default is 60000ms (60 seconds). Set to 3 seconds for demonstrative purposes only.
  exportIntervalMillis: 3000,
});

const myServiceMeterProvider = new MeterProvider({
  resource: resource,
});


myServiceMeterProvider.addMetricReader(metricReader);

// Set this MeterProvider to be global to the app being instrumented.
opentelemetry.metrics.setGlobalMeterProvider(myServiceMeterProvider);