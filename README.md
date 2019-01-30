# terraform-learing
Terraform learning

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

