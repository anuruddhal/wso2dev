import ballerina/http;
import ballerina/io;

public type KubernetesConnector object {
    public string masterURL;
    public string namespace;
    public http:Client client;
    public function getNodes() returns json;
    public function getEndpoints();

    public function createDeployment(json deployment) returns json;
    public function getDeployments() returns json;
    public function getDeployment(string name) returns json;
    public function deleteDeployment(string name) returns json;

    public function createService(json serviceJSON);
    public function getServices() returns json;
    public function getService(string name) returns json;
    public function deleteService(string name) returns json;

    public function createIngress(json ingressJSON);
    public function getIngress(string name) returns json;
    public function getIngresses() returns json;
    public function deleteIngress(string name) returns json;

};

function KubernetesConnector::getNodes() returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/api/v1/nodes/";

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => return payload;
                error err => throw err;
            }
        }
        error err => throw err;
    }
}

function KubernetesConnector::getEndpoints() {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/api/v1/namespaces/" + self.namespace + "/endpoints/";

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => io:println(payload);
                error err => io:println(err);
            }
        }
        error err => io:println(err);
    }
}

function KubernetesConnector::getDeployments() returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/apps/v1/namespaces/" + self.namespace + "/deployments/";

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::getDeployment(string name) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/apps/v1/namespaces/" + self.namespace + "/deployments/" + name;

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::deleteDeployment(string name) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/apps/v1/namespaces/" + self.namespace + "/deployments/" + name;

    var response = httpClient->delete(requestPath, "");
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::createDeployment(json deployment) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/" + deployment.apiVersion.toString() + "/namespaces/" + self.namespace + "/deployments/"
    ;
    io:println(requestPath);
    var response = httpClient->post(requestPath, deployment);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    json j = { "error": err.message };
                    return j;
                }
            }
        }
        error err => {
            json j1 = { "error": err.message };
            return j1;
        }
    }
}

function KubernetesConnector::createService(json serviceJSON) {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/api/" + serviceJSON.apiVersion.toString() + "/namespaces/" + self.namespace + "/services/";
    var response = httpClient->post(requestPath, serviceJSON);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => io:println(payload);
                error err => io:println(err);
            }
        }
        error err => io:println(err);
    }
}

function KubernetesConnector::getServices() returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/api/v1/namespaces/" + self.namespace + "/services/";

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::getService(string name) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/api/v1/namespaces/" + self.namespace + "/services/" + name;

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::deleteService(string name) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/api/v1/namespaces/" + self.namespace + "/services/" + name;

    var response = httpClient->delete(requestPath, "");
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::createIngress(json ingressJSON) {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/" + ingressJSON.apiVersion.toString() + "/namespaces/" + self.namespace + "/ingresses/";

    var response = httpClient->post(requestPath, ingressJSON);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => io:println(payload);
                error err => io:println(err);
            }
        }
        error err => io:println(err);
    }
}

function KubernetesConnector::getIngress(string name) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/extensions/v1beta1/namespaces/" + self.namespace + "/ingresses/" + name;
    io:println(requestPath);

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::deleteIngress(string name) returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/extensions/v1beta1/namespaces/" + self.namespace + "/ingresses/" + name;
    io:println(requestPath);

    var response = httpClient->delete(requestPath, "");
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}

function KubernetesConnector::getIngresses() returns json {
    endpoint http:Client httpClient = self.client;
    string requestPath = "/apis/extensions/v1beta1/namespaces/" + self.namespace + "/ingresses/";
    io:println(requestPath);

    var response = httpClient->get(requestPath);
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    return payload;
                }
                error err => {
                    io:println(err);
                    throw err;
                }
            }
        }
        error err => {
            io:println(err);
            throw err;
        }

    }
}
