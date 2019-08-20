{{ define "assemblyline.coreService" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .component }}
  labels:
    app: assemblyline
    section: core
    component: {{ .component }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: assemblyline
      section: core
      component: {{ .component }}
  template:
    metadata:
      labels:
        app: assemblyline
        section: core
        component: {{ .component }}
    spec:
      containers:
        - name: {{ .component }}
          image: cccs/assemblyline-core:{{ .Values.coreVersion }}
          imagePullPolicy: Always
          command: ['python', '-m', '{{ .command }}']
          volumeMounts:
            - name: al-config
              mountPath: /etc/assemblyline/
      volumes:
        - name: al-config
          configMap:
            name: {{ .Release.Name }}-global-config
            items:
              - key: config
                path: config.yml
{{ end }}

{{- define "service-namespace" -}}
{{- if .Values.serviceNamespace -}}
    {{- .Values.serviceNamespace -}}
{{- else -}}
    {{- .Release.Name -}}-services
{{- end -}}
{{- end -}}