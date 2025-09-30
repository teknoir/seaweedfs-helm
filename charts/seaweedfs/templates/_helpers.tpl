{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec). If release name contains chart name it will
be used as a full name.
*/}}
{{- define "seaweedfs.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "seaweedfs.chart" -}}
{{- printf "%s-helm" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "seaweedfs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Inject extra environment vars in the format key:value, if populated
*/}}
{{- define "seaweedfs.extraEnvironmentVars" -}}
{{- if .extraEnvironmentVars -}}
{{- range $key, $value := .extraEnvironmentVars }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Return the proper filer image */}}
{{- define "filer.image" -}}
{{- if .Values.filer.imageOverride -}}
{{- $imageOverride := .Values.filer.imageOverride -}}
{{- printf "%s" $imageOverride -}}
{{- else -}}
{{- include "common.image" . }}
{{- end -}}
{{- end -}}

{{/* Return the proper master image */}}
{{- define "master.image" -}}
{{- if .Values.master.imageOverride -}}
{{- $imageOverride := .Values.master.imageOverride -}}
{{- printf "%s" $imageOverride -}}
{{- else -}}
{{- include "common.image" . }}
{{- end -}}
{{- end -}}

{{/* Return the proper volume image */}}
{{- define "volume.image" -}}
{{- if .Values.volume.imageOverride -}}
{{- $imageOverride := .Values.volume.imageOverride -}}
{{- printf "%s" $imageOverride -}}
{{- else -}}
{{- include "common.image" . }}
{{- end -}}
{{- end -}}

{{/* Computes the container image name for all components (if they are not overridden) */}}
{{- define "common.image" -}}
{{- $registryName := default .Values.image.registry .Values.global.registry | toString -}}
{{- $repositoryName := default .Values.image.repository .Values.global.repository | toString -}}
{{- $name := .Values.global.imageName | toString -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag  | toString -}}
{{- if $repositoryName -}}
{{-   $name = printf "%s/%s" (trimSuffix "/" $repositoryName) (base $name) -}}
{{- end -}}
{{- if $registryName -}}
{{-   printf "%s/%s:%s" $registryName $name $tag -}}
{{- else -}}
{{-   printf "%s:%s" $name $tag -}}
{{- end -}}
{{- end -}}

{{/*
Compute the master service address to be used in cluster env vars.
If allInOne is enabled, point to the all-in-one service; otherwise, point to the master service.
*/}}
{{- define "seaweedfs.cluster.masterAddress" -}}
{{- $serviceNameSuffix := "" -}}
{{- printf "%s%s.%s:%d" (include "seaweedfs.name" .) $serviceNameSuffix .Release.Namespace (int .Values.master.port) -}}
{{- end -}}

{{/*
Compute the filer service address to be used in cluster env vars.
If allInOne is enabled, point to the all-in-one service; otherwise, point to the filer-client service.
*/}}
{{- define "seaweedfs.cluster.filerAddress" -}}
{{- $serviceNameSuffix := "" -}}
{{- printf "%s%s.%s:%d" (include "seaweedfs.name" .) $serviceNameSuffix .Release.Namespace (int .Values.filer.port) -}}
{{- end -}}
