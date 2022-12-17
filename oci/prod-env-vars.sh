export TF_VAR_region=me-jeddah-1
### Authentication details
export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaaajqn5vtxsap42gqlmvtr46sluvvdzyxxlapoqips2aygucxtgwyq
export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaafc4nk6y7vq3ona5dqkhx643ggcsepjlxntbmy64iulifcg7s4buq
                        
                        

export TF_VAR_fingerprint=49:cd:a0:93:d3:9a:5c:f6:88:47:c8:fe:5f:90:3f:c9
export TF_VAR_private_key_path="$PWD/ssh_key/msn-prod-api-pvt-key.pem"

#export TF_VAR_availability_domain=1
export TF_VAR_TestServerShape="VM.Standard2.1"

export TF_VAR_CompartmentOCID=ocid1.tenancy.oc1..aaaaaaaaajqn5vtxsap42gqlmvtr46sluvvdzyxxlapoqips2aygucxtgwyq
    

### Public/private keys used on the instance
export TF_VAR_ssh_public_key="$PWD/ssh_key/ssh-prod.pub"
export TF_VAR_ssh_private_key="$PWD/ssh_key/ssh-prod.key"

