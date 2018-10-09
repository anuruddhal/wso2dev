// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


# Value for a field.
#
# + fieldPath - Path of the field
public type FieldValue record {
    string fieldPath;
    !...
};

# Value for a secret key.
#
# + name - Name of the secret.
# + key - Key of the secret.
public type SecretKeyValue record {
    string name;
    string key;
    !...
};

# Value for resource field.
#
# + containerName - Name of the container.
# + resource - Resource field
public type ResourceFieldValue record {
    string containerName;
    string ^"resource";
    !...
};

# Value for config map key.
#
# + name - name of the config.
# + key - key of the config.
public type ConfigMapKeyValue record {
    string name;
    string key;
    !...
};

# Value from field.
#
# + fieldRef - Reference for a field.
public type FieldRef record {
    FieldValue fieldRef;
    !...
};

# Value from secret key.
#
# + secretKeyRef - Reference for secret key.
public type SecretKeyRef record {
    SecretKeyValue secretKeyRef;
    !...
};

# Value from resource field.
#
# + resourceFieldRef - Reference for resource field.
public type ResourceFieldRef record {
    ResourceFieldValue resourceFieldRef;
    !...
};

# Value from config map key.
#
# + configMapKeyRef - Reference for config map key.
public type ConfigMapKeyRef record {
    ConfigMapKeyValue configMapKeyRef;
    !...
};

# Kubernetes deployment configuration.
#
# + name - Name of the deployment
# + namespace - Kubernetes namespace
# + labels - Map of labels for deployment
# + replicas - Number of replicas
# + imagePullPolicy - Kubernetes image pull policy
# + image - Docker image with tag
# + env - Environment varialbe map for containers
# + imagePullSecrets - Image pull secrets
public type Deployment record {
    string name;
    string namespace;
    map labels;
    int replicas;
    string imagePullPolicy;
    string image;
    map<string|FieldRef|SecretKeyRef|ResourceFieldRef|ConfigMapKeyRef> env;
    string[] imagePullSecrets;
};


@final public SessionAffinity NONE = "None";
@final public SessionAffinity CLIENT_IP = "ClientIP";

# Session affinity field for kubernetes services.
public type SessionAffinity "None"|"ClientIP";


@final public ServiceType CLIENT_IP = "ClientIP";
@final public ServiceType NODE_PORT = "Nodeport";
@final public ServiceType LOAD_BALANCER = "LoadBalancer";

# Service type field for kubernetes services.
public type ServiceType "NodePort"|"ClientIP"|"LoadBalancer";



# Kubernetes service configuration.
#
# + name - Name of the service
# + labels - Map of labels for deployment
# + sessionAffinity - Session affinity for pods
# + serviceType - Service type of the service
public type ServiceConfiguration record {
    string name;
    map labels;
    SessionAffinity sessionAffinity;
    ServiceType serviceType;
};


# Kubernetes ingress configuration.
#
# + name - Name of the ingress
# + endpointName - Name of the endpoint ingress attached
# + labels - Label map for ingress
# + annotations - Map of additional annotations
# + hostname - Host name of the ingress
# + path - Resource path
# + targetPath - Target path for url rewrite
# + ingressClass - Ingress class
# + enableTLS - Enable/Disable ingress TLS
public type IngressConfiguration record {
    string name;
    string endpointName;
    map labels;
    map annotations;
    string hostname;
    string path;
    string targetPath;
    string ingressClass;
    boolean enableTLS;
};


# Kubernetes Horizontal Pod Autoscaler configuration
#
# + name - Name of the Autoscaler
# + labels - Labels for Autoscaler
# + minReplicas - Minimum number of replicas
# + maxReplicas - Maximum number of replicas
# + cpuPercentage - CPU percentage to start scaling
public type PodAutoscalerConfig record {
    string name;
    map labels;
    int minReplicas;
    int maxReplicas;
    int cpuPercentage;
};

# Kubernetes secret volume mount.
#
# + name - Name of the volume mount
# + mountPath - Mount path
# + readOnly - Is mount read only
# + data - Paths to data files as an array
public type Secret record {
    string name;
    string mountPath;
    boolean readOnly;
    string[] data;
};

#Secret volume mount configurations for kubernetes.
#
# + secrets - Array of [Secret](kubernetes.html#Secret)
public type SecretMount record {
    Secret[] secrets;
};


# Kubernetes Config Map volume mount.
#
# + name - Name of the volume mount
# + mountPath - Mount path
# + readOnly - Is mount read only
# + data - Paths to data files
public type ConfigMap record {
    string name;
    string mountPath;
    boolean readOnly;
    string[] data;
};

# Secret volume mount configurations for kubernetes.
#
# + ballerinaConf - path to ballerina configuration file
# + configMaps - Array of [ConfigMap](kubernetes.html#ConfigMap)
public type ConfigMapMount record {
    string ballerinaConf;
    ConfigMap[] configMaps;
};


# Kubernetes Persistent Volume Claim.
#
# + name - Name of the volume claim
# + mountPath - Mount Path
# + accessMode - Access mode
# + volumeClaimSize - Size of the volume claim
# + annotations - Map of annotation values
# + readOnly - Is mount read only
public type PersistentVolumeClaimConfig record {
    string name;
    string mountPath;
    string accessMode;
    string volumeClaimSize;
    map annotations;
    boolean readOnly;
};

# Persistent Volume Claims configurations for kubernetes.
#
# + volumeClaims - Array of [PersistentVolumeClaimConfig](kubernetes.html#PersistentVolumeClaimConfig)
public type PersistentVolumeClaims record {
    PersistentVolumeClaimConfig[] volumeClaims;
};

