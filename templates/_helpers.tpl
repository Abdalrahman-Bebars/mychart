{{- define "mychart.containerResources" -}}
resources:
  limits:
    {{- with .Values.resources.limits }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  requests:
    {{- with .Values.resources.requests }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
