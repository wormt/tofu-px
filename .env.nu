let aws_key = (input -s 'aws key: ')

let pass0 = (input -s 'pass0: ')
let pass1 = $pass0
let auth = {
  "users": ["root@pam", "root@pam"]
  "passwords": [$pass0, $pass1]
}

let tfenv = {
  "environment_name": "prod"
  "s3_endpoint": "https://s3.us-west-2.idrivee2.com/"
  "s3_bucket": "tfstate"
  "skip_validation": true
  "pve_endpoint": "https://[fd00::200]:8006/"
}

$env.TF_VAR_env = ($tfenv|to json)
$env.TF_VAR_auth = ($auth|to json)

$env.AWS_REGION = "us-west-2"
$env.AWS_ACCESS_KEY_ID = "O1sh3RhWxWbn5bgOmflT"
$env.AWS_SECRET_ACCESS_KEY = $aws_key
