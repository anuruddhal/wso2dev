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


public type FieldValue record {
    string fieldPath;
    !...
};


public type SecretKeyValue record {
    string name;
    string key;
    !...
};

public type ResourceFieldValue record {
    string containerName;
    string ^"resource";
    !...
};

public type ConfigMapKeyValue record {
    string name;
    string key;
    !...
};

public type FieldRef record {
    FieldValue fieldRef;
    !...
};

public type SecretKeyRef record {
    SecretKeyValue secretKeyRef;
    !...
};

public type ResourceFieldRef record {
    ResourceFieldValue resourceFieldRef;
    !...
};

public type ConfigMapKeyRef record {
    ConfigMapKeyValue configMapKeyRef;
    !...
};

public type Deployment record {
    string namespace;
    map labels;
    int replicas;
    string imagePullPolicy;
    string image;
    ContainerPort[] containerPorts;
    map<string|FieldRef|SecretKeyRef|ResourceFieldRef|ConfigMapKeyRef> env;
    string[] imagePullSecrets;
    PersistentVolumeClaimConfig[] volumeClaims;
    ConfigMap[] configmap;
};


@final public SessionAffinity NONE = "None";
@final public SessionAffinity CLIENT_IP = "ClientIP";

# Session affinity field for kubernetes services.
public type SessionAffinity "None"|"ClientIP";


@final public ServiceType CLUSTER_IP = "ClusterIP";
@final public ServiceType NODE_PORT = "NodePort";
@final public ServiceType LOAD_BALANCER = "LoadBalancer";

# Service type field for kubernetes services.
public type ServiceType "NodePort"|"ClusterIP"|"LoadBalancer";


public type ServiceConfiguration record {
    string name;
    map labels;
    SessionAffinity sessionAffinity;
    ServiceType serviceType;
    Port[] ports;
};


public type IngressConfiguration record {
    string name;
    map labels;
    map annotations;
    map<IngressRule> rules;
};

public type IngressRule record {
    string serviceName;
    int servicePort;
    string path;
    string hostname;
};

public type PodAutoscalerConfig record {
    string name;
    map labels;
    int minReplicas;
    int maxReplicas;
    int cpuPercentage;
};

public type Secret record {
    string name;
    string mountPath;
    boolean readOnly;
};

public type ConfigMap record {
    string name;
    map labels;
    map annotations;
    map data;
};

public type ConfigMapMount record {
    string name;
    string mountPath;
    boolean readOnly;
};

public type PersistentVolumeClaimConfig record {
    string name;
    string mountPath;
    string accessMode;
    string volumeClaimSize;
    map annotations;
    boolean readOnly;
};

public type Application record{
    string name;
    Deployment deployment;
    map<ServiceConfiguration> services;
    map<IngressConfiguration> ingresses;
};

public type Port record{
    string? name;
    int port;
    int targetPort;
    string protocol;
    int? nodePort;
};

@final public Protocol TCP = "TCP";
@final public Protocol UDP = "UDP";

public type Protocol "TCP"|"UDP";

public type ContainerPort record{
    int port;
    Protocol protocol;
};

public function getDeploymentJSON(Application appDefintion) returns (json|error) {
    json deployment = {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": <json>appDefintion.name,
            "labels": check <json>appDefintion.deployment.labels
        },
        "spec": {
            "replicas": <json>appDefintion.deployment.replicas,
            "template": {
                "metadata": {
                    "labels": check <json>appDefintion.deployment.labels
                },
                "spec": {
                    "containers": [
                        {
                            "name": <json>appDefintion.name,
                            "image": <json>appDefintion.deployment.image,
                            "ports": check <json> appDefintion.deployment.containerPorts
                        }
                    ]
                }
            }
        }
    };
    return deployment;
}

public function deploy(Application appDefinition) returns (json|error) {
    return getDeploymentJSON(appDefinition);
}