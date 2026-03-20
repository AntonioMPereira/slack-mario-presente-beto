# Mario Slackware Splash

Site estático no S3 com splash page de boot Slackware + jogo Super Mario.

## Deploy
```bash
chmod +x deploy.sh && ./deploy.sh
```

## Destruir
```bash
aws s3 rm s3://$(terraform output -raw bucket_name) --recursive --profile pessoal
terraform destroy -auto-approve
```
