## Kubernetes Networking 

> **Since a Kubernetes cluster consists of various nodes and pods, understanding how they communicate between them is essential. The Kubernetes networking model supports different types of open source implementations.**

> The **`Kubernetes networking model,`** on the other hand, natively supports **`multi-host networking`** in which pods are able to communicate with each other by default, regardless of which host they live in.

> Kubernetes **`does not provide a default network implementation,`** it only enforces a model for third-party tools to implement. There is a variety of implementations nowadays, below we list some popular ones.
	
1. **`Flannel`** - a very simple overlay network that satisfies the Kubernetes requirements. Flannel runs an agent on each host and allocates a subnet lease to each of them out of a larger, preconfigured address space.Flannel creates a flat network called as overlay network which runs above the host network.
	
2. **`Project Calico`** - an open source container networking provider and network policy engine. Calico provides a highly scalable networking and network policy solution for connecting Kubernetes pods based on the same IP networking principles as the internet. Calico can be deployed without encapsulation or overlays to provide high-performance, high-scale data center networking.

3. **`Weave Net`** - a cloud native networking toolkit which provides a resilient and simple to use (does not require any configuration) network for Kubernetes and its hosted applications. It provides various functionalities like scaling, service discovery, performance without complexity and secure networking.
	
4. **`Other options`** include Cisco ACI , Cilium , Contiv , Contrail , Kube-router , Nuage , OVN , Romana , VMWare NSX-T with NSX-T Container Plug-in (NCP) . Some tools even support using multiple implementations, such as Huawei CNI-Genie and Multus .


## Pod to Pod Communication 

> Kubernetes follows an `“IP-per-pod”` model where each pod get assigned an IP address and all containers in a single pod share the same network namespaces and IP address. Containers in the same pod can therefore reach each other’s ports via localhost:<port>. 
	
> However, **`it is not recommended to communicate directly with a pod via its IP address`** due to pod’s volatility (a pod can be killed and replaced at any moment). 
	
> Instead, **`use a Kubernetes service`** which represents a group of pods acting as a single entity to the outside. Services get allocated their own IP address in the cluster and provide a reliable entry point.

> **Kubernetes services allow grouping pods under a common access policy (for example, load-balanced). The service gets assigned a virtual IP which pods outside the service can communicate with. Those requests are then transparently proxied (via the kube-proxy component that runs on each node) to the pods inside the service. Different proxy-modes are supported:**
	
* **`iptables:`** kube-proxy installs iptables rules trap access to service IP addresses and redirect them to the correct pods.

* **`userspace:`** kube-proxy opens a port (randomly chosen) on the local node. Requests on this “proxy port” get proxied to one of the service’s pods (as retrieved from Endpoints API).

* **`ipvs (from Kubernetes 1.9):`** calls netlink interface to create ipvs rules and regularly synchronizes them with the Endpoints API.
	
## DNS for Services and Pods
	
> Kubernetes provides its own DNS service to resolve domain names inside the cluster in order for pods to communicate with each other. This is implemented by deploying a regular Kubernetes service which does name resolution inside the cluster, and configuring individual containers to contact the DNS service to resolve domain names. Note that this “internal DNS” is compatible and expected to run along with the cloud provider’s DNS service.

> Every service gets assigned a DNS name which resolves to the cluster IP of the service. The naming convention includes the service name and its namespace. For example:
* **`my-service.my-namespace.svc.cluster.local`**

> A pod inside the same namespace as the service does not need to fully qualify its name, for example a pod in my-namespace could lookup this service with a DNS query for my-service , while a pod outside my-namespace would have to query for my-service.my-namespace .

> For headless services (without a cluster IP), the DNS name resolves to the set of IPs of the pods which are part of the service. The caller can then use the set of IPs as it sees fit (for example round-robin).

> By default pods get assigned a DNS name which includes the pod’s IP address and namespace. In order to assign a more meaningful DNS name, the pod’s specification can specify a hostname and subdomain:
		
