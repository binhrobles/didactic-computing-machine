aws cloudformation deploy \
  --template-file ./persistent-storage.cloudformation.yml \
  --stack-name ComplexProjPersistentStorage \
  --parameter-overrides \
    DBUser=postgres \
    DBPassword=postgres_password
