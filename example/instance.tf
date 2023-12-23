# Port Generated (demo)
module "kubernetes-cluster" {
  source  = "./../"
  
  environment = "prod"
  location = "West Europe"
  name = "module-example"
}
