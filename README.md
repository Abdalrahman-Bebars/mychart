# MyChart Helm Chart

## Lab: Using Named Templates (Helpers) in Helm

This chart demonstrates how to use **Helm named templates** (`_helpers.tpl`) to define reusable YAML blocks.
It focuses on container resource settings, showing how to apply defaults and override values.

---

## 🚀 Setup

1. Navigate to your chart directory:

   ```bash
   cd mychart
   ```

2. Create the helpers file:

   ```bash
   touch templates/_helpers.tpl
   ```

3. Add default values to `values.yaml`:

   ```yaml
   replicaCount: 1
   image:
     repository: nginx
     tag: stable
     pullPolicy: IfNotPresent
   resources:
     limits:
       cpu: 100m
     requests: {}
   ```

---

## 🔹 Step 1: Define a Named Template

In `templates/_helpers.tpl`:

```yaml
{{- define "mychart.containerResources" -}}
resources:
  {{- if .Values.resources.limits }}
  limits:
    {{- toYaml .Values.resources.limits | nindent 4 }}
  {{- end }}
  {{- if .Values.resources.requests }}
  requests:
    {{- toYaml .Values.resources.requests | nindent 4 }}
  {{- end }}
{{- end }}
```

---

## 🔹 Step 2: Use Template in Deployment

Inside `templates/deployment.yaml`:

```yaml
containers:
  - name: nginx
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- include "mychart.containerResources" . | nindent 10 }}
```

---

## 🔹 Step 3: Test Defaults

Render the chart:

```bash
helm template mychart .
```

Expected Deployment snippet:

```yaml
resources:
  limits:
    cpu: 100m
```

---

## 🔹 Step 4: Test Overrides

Create `override-resources.yaml`:

```yaml
resources:
  limits:
    memory: 256Mi
  requests:
    cpu: 75m
```

Run:

```bash
helm template mychart . -f override-resources.yaml
```

Expected output:

```yaml
resources:
  limits:
    cpu: 100m
    memory: 256Mi
  requests:
    cpu: 75m
```

---

## 📦 Files in the Chart

* **Chart.yaml** — chart metadata
* **values.yaml** — default configuration
* **templates/_helpers.tpl** — reusable named templates
* **templates/deployment.yaml** — Deployment using the helper

---

✅ This lab walks you through defining helpers, including them in manifests, and testing with both default and overridden values.
