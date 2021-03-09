variable resourcegroup {
  default     = "demoResourceGroupUsingVariable"
}

variable location {
  default     = "eastus"
}

variable vname {
  default     = "terraformdemo"
}

variable addressspace {
    type      = "list"
  default     = ["10.0.0.0/16"]
}

variable addressprefix {
  default     = ["10.0.2.0/24"]
}

variable subname {
  default     = "subnet"
}

# variable tag {
#   type      = "map"

#   default    {
#       "key" = "value"
#       "1"   = "2"
#       "tf"  = "res"
#   }
# }

variable publicip {
  default     = "publicipname"
}

variable machinename {
  default     = "createdfordemo"
}

variable vmname {
  default     = "createdfordemo"
}

variable vmsize {
  default     = "Standard_DS2_v2"
}