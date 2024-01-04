# Port Generated (demo)
module "kubernetes-cluster" {
  source = "./../"

  environment         = "testing"
  location            = "West US"
  name                = "example"
  resource_group_name = "kubernetes-cluster-solution_example-testing"
}
