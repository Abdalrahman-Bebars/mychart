# MyChart Helm Chart

## Lab: Named Templates (Helm Helpers)

This chart demonstrates **Helm named templates** and reusable YAML blocks (`_helpers.tpl`).
It defines container resource settings, includes them in a Deployment, and tests default vs. override values.

---

## 🚀 Setup

1. Go into your chart directory:

   ```bash
   cd mychart
   ```
2. Create the helpers file:

   ```bash
   touch templates/_helpers.tpl
   ```
3. In `values.yaml`, add default resources:

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

## 🔹 Step 1: Define the Named Template

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

## 🔹 Step 2: Include Template in Deployment

In `templates/deployment.yaml`, under the container spec:

```yaml
containers:
  - name: nginx
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- include "mychart.containerResources" . | nindent 10 }}
```

---

## 🔹 Step 3: Test Defaults

Run:

```bash
helm template mychart .
```

Expected snippet in Deployment:

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

Expected snippet:

```yaml
resources:
  limits:
    cpu: 100m
    memory: 256Mi
  requests:
    cpu: 75m
```

---

## 📦 Chart Files

* `Chart.yaml` — chart metadata
* `values.yaml` — default configuration
* `templates/_helpers.tpl` — reusable named templates
* `templates/deployment.yaml` — Deployment manifest using the helper

---

✅ With this lab you can practice creating, including, and testing Helm named templates with defaults and overrides.
