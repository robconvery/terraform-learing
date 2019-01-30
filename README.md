# terraform-learing
Terraform learning

## Remote storage
```$xslt
terraform remote config \
-backend = s3 \
-backend-config ="bucket =(YOUR_BUCKET_NAME)" \
-backend-config ="key = global/ s3/ terraform.tfstate" \
-backend-config ="region = eu-west-1" \
-backend-config ="encrypt = true"
```

