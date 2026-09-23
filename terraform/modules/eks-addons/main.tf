resource "aws_iam_policy" "alb_controller" {
  count       = var.enable_alb_controller ? 1 : 0
  name        = "${var.environment}-AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/policies/AWSLoadBalancerControllerIAMPolicy.json")

  tags = local.common_tags
}

resource "aws_iam_role" "alb_controller" {
  count = var.enable_alb_controller ? 1 : 0
  name  = "${var.environment}-aws-load-balancer-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  count      = var.enable_alb_controller ? 1 : 0
  role       = aws_iam_role.alb_controller[0].name
  policy_arn = aws_iam_policy.alb_controller[0].arn
}

resource "helm_release" "alb_controller" {
  count      = var.enable_alb_controller ? 1 : 0
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.2"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_controller[0].arn
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller
  ]
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count       = var.enable_cluster_autoscaler ? 1 : 0
  name        = "${var.environment}-EKSClusterAutoscalerIAMPolicy"
  description = "IAM policy for EKS Cluster Autoscaler"
  policy      = file("${path.module}/policies/EKSClusterAutoscalerIAMPolicy.json")

  tags = local.common_tags
}

resource "aws_iam_role" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  name  = "${var.environment}-eks-cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
        }
      }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  role       = aws_iam_role.cluster_autoscaler[0].name
  policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler[0].arn
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_autoscaler
  ]
}

resource "helm_release" "metrics_server" {
  count      = var.enable_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.12.1"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}

# ---------------------------------------------------------------------------
# EBS CSI Driver — required for PVC provisioning (gp2/gp3 volumes)
# Prometheus needs this to persist its data
# ---------------------------------------------------------------------------
resource "aws_iam_role" "ebs_csi_driver" {
  count = var.enable_ebs_csi_driver ? 1 : 0
  name  = "${var.environment}-ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  count      = var.enable_ebs_csi_driver ? 1 : 0
  role       = aws_iam_role.ebs_csi_driver[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  count                    = var.enable_ebs_csi_driver ? 1 : 0
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_driver[0].arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = local.common_tags

  depends_on = [aws_iam_role_policy_attachment.ebs_csi_driver]
}
# ---------------------------------------------------------------------------
# Prometheus + Grafana — kube-prometheus-stack
# Deploys: Prometheus, Alertmanager, Grafana, node-exporter, kube-state-metrics
# Namespace: monitoring
# Grafana access: kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
# ---------------------------------------------------------------------------
resource "helm_release" "kube_prometheus_stack" {
  count      = var.enable_monitoring ? 1 : 0
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "58.5.3"

  create_namespace = true

  # Grafana
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }
  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }

  # Prometheus retention and persistent storage
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "15d"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp2"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }

  # Alertmanager
  set {
    name  = "alertmanager.enabled"
    value = "true"
  }

  # node-exporter — host-level metrics from every node
  set {
    name  = "nodeExporter.enabled"
    value = "true"
  }

  # kube-state-metrics — K8s object metrics (pods, deployments, HPA, etc.)
  set {
    name  = "kubeStateMetrics.enabled"
    value = "true"
  }

  depends_on = [
     helm_release.metrics_server,
     aws_eks_addon.ebs_csi_driver
  ]
}


# ---------------------------------------------------------------------------
# Pre-destroy cleanup: remove AWS resources created by EKS/K8s controllers
# that are outside Terraform state (ALB, target groups, EKS-owned SGs).
# This runs BEFORE the VPC and IGW are destroyed, preventing stuck destroys.
# ---------------------------------------------------------------------------
resource "null_resource" "cleanup_eks_aws_resources" {
  count = var.enable_alb_controller ? 1 : 0

  # Tie lifecycle to the ALB controller helm release so this is destroyed first
  depends_on = [helm_release.alb_controller]

  triggers = {
    cluster_name = var.cluster_name
    vpc_id       = var.vpc_id
    region       = data.aws_region.current.name
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue

    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -e
      CLUSTER="${self.triggers.cluster_name}"
      VPC_ID="${self.triggers.vpc_id}"
      REGION="${self.triggers.region}"

      echo "=== Cleaning up EKS-provisioned AWS resources before VPC destroy ==="

      # 1. Delete all ALBs tagged with this cluster (created by ALB Ingress Controller)
      echo "--- Deleting ALBs for cluster: $CLUSTER ---"
      ALB_ARNS=$(aws elbv2 describe-load-balancers \
        --region "$REGION" \
        --query "LoadBalancers[?VpcId=='$VPC_ID'].LoadBalancerArn" \
        --output text 2>/dev/null || echo "")

      for ARN in $ALB_ARNS; do
        echo "Deleting ALB: $ARN"
        # Delete listeners first
        LISTENER_ARNS=$(aws elbv2 describe-listeners \
          --load-balancer-arn "$ARN" \
          --region "$REGION" \
          --query "Listeners[].ListenerArn" \
          --output text 2>/dev/null || echo "")
        for L in $LISTENER_ARNS; do
          aws elbv2 delete-listener --listener-arn "$L" --region "$REGION" || true
        done
        aws elbv2 delete-load-balancer --load-balancer-arn "$ARN" --region "$REGION" || true
      done

      # Wait for ALBs to finish deleting (they must be gone before SGs can be deleted)
      if [ -n "$ALB_ARNS" ]; then
        echo "Waiting for ALBs to be deleted..."
        sleep 30
      fi

      # 2. Delete target groups in the VPC
      echo "--- Deleting target groups in VPC: $VPC_ID ---"
      TG_ARNS=$(aws elbv2 describe-target-groups \
        --region "$REGION" \
        --query "TargetGroups[?VpcId=='$VPC_ID'].TargetGroupArn" \
        --output text 2>/dev/null || echo "")
      for TG in $TG_ARNS; do
        echo "Deleting target group: $TG"
        aws elbv2 delete-target-group --target-group-arn "$TG" --region "$REGION" || true
      done

      # 3. Delete EKS-owned security groups (tagged kubernetes.io/cluster/<name>)
      echo "--- Deleting EKS-owned security groups ---"
      SG_IDS=$(aws ec2 describe-security-groups \
        --region "$REGION" \
        --filters \
          "Name=vpc-id,Values=$VPC_ID" \
          "Name=tag-key,Values=kubernetes.io/cluster/$CLUSTER" \
        --query "SecurityGroups[].GroupId" \
        --output text 2>/dev/null || echo "")

      # Also catch SGs created by the ALB controller (tagged elbv2.k8s.aws/cluster)
      SG_IDS_ALB=$(aws ec2 describe-security-groups \
        --region "$REGION" \
        --filters \
          "Name=vpc-id,Values=$VPC_ID" \
          "Name=tag-key,Values=elbv2.k8s.aws/cluster" \
        --query "SecurityGroups[].GroupId" \
        --output text 2>/dev/null || echo "")

      ALL_SGS="$SG_IDS $SG_IDS_ALB"

      # Revoke all ingress/egress rules before deleting (avoids dependency errors)
      for SG in $ALL_SGS; do
        echo "Revoking rules for SG: $SG"
        aws ec2 revoke-security-group-ingress \
          --group-id "$SG" --region "$REGION" \
          --ip-permissions \
            "$(aws ec2 describe-security-groups --group-ids "$SG" --region "$REGION" \
               --query 'SecurityGroups[0].IpPermissions' --output json 2>/dev/null)" \
          2>/dev/null || true
        aws ec2 revoke-security-group-egress \
          --group-id "$SG" --region "$REGION" \
          --ip-permissions \
            "$(aws ec2 describe-security-groups --group-ids "$SG" --region "$REGION" \
               --query 'SecurityGroups[0].IpPermissionsEgress' --output json 2>/dev/null)" \
          2>/dev/null || true
      done

      for SG in $ALL_SGS; do
        echo "Deleting SG: $SG"
        aws ec2 delete-security-group --group-id "$SG" --region "$REGION" || true
      done

      echo "=== Cleanup complete ==="
    EOT
  }
}
