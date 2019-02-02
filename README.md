# terraform-learning
Terraform learning

##RDS database
Setting the password locally
```$xslt
export TF_VAR_db_password="(YOUR_DB_PASSWORD)"
```

Sets the password to be used within `{directory-name}/data-stores/mysql/var.tf`

```$xslt
variable "db_password" {
    description = "The password used by the database."    
}
```

## Remote storage

terraform remote config `removed`. See https://www.terraform.io/docs/backends/types/s3.html 

```$xslt
terraform remote config \
-backend=s3 \
-backend-config="bucket=(YOUR_BUCKET_NAME)" \
-backend-config="key=global/s3/terraform.tfstate" \
-backend-config="region=eu-west-1" \
-backend-config="encrypt=true"
```

