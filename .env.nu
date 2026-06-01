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
$env.PROXMOX_VE_USERNAME = $auth.users.0
$env.PROXMOX_VE_PASSWORD = $auth.passwords.0

$env.AWS_REGION = "us-west-2"
$env.AWS_ACCESS_KEY_ID = "O1sh3RhWxWbn5bgOmflT"
$env.AWS_SECRET_ACCESS_KEY = $aws_key

@complete external
def --wrapped --env devexec [...args] {
  (
    ^devcontainer exec
    --remote-env $"TF_VAR_env=($env.TF_VAR_env)"
    --remote-env $"TF_VAR_auth=($env.TF_VAR_auth)"
    --remote-env $"PROXMOX_VE_USERNAME=($env.PROXMOX_VE_USERNAME)"
    --remote-env $"PROXMOX_VE_PASSWORD=($env.PROXMOX_VE_PASSWORD)"
    --remote-env $"AWS_REGION=($env.AWS_REGION)"
    --remote-env $"AWS_ACCESS_KEY_ID=($env.AWS_ACCESS_KEY_ID)"
    --remote-env $"AWS_SECRET_ACCESS_KEY=($env.AWS_SECRET_ACCESS_KEY)"
    ...$args
  )
}

@complete external
def --wrapped --env terraform [...args] {
  (
    ^devcontainer exec
    --remote-env $"TF_VAR_env=($env.TF_VAR_env)"
    --remote-env $"TF_VAR_auth=($env.TF_VAR_auth)"
    --remote-env $"PROXMOX_VE_USERNAME=($env.PROXMOX_VE_USERNAME)"
    --remote-env $"PROXMOX_VE_PASSWORD=($env.PROXMOX_VE_PASSWORD)"
    --remote-env $"AWS_REGION=($env.AWS_REGION)"
    --remote-env $"AWS_ACCESS_KEY_ID=($env.AWS_ACCESS_KEY_ID)"
    --remote-env $"AWS_SECRET_ACCESS_KEY=($env.AWS_SECRET_ACCESS_KEY)"
    terraform ...$args
  )
}

@complete external
def --wrapped --env tf [...args] {
  $env.o = (
    ^devcontainer exec
    --remote-env $"TF_VAR_env=($env.TF_VAR_env)"
    --remote-env $"TF_VAR_auth=($env.TF_VAR_auth)"
    --remote-env $"PROXMOX_VE_USERNAME=($env.PROXMOX_VE_USERNAME)"
    --remote-env $"PROXMOX_VE_PASSWORD=($env.PROXMOX_VE_PASSWORD)"
    --remote-env $"AWS_REGION=($env.AWS_REGION)"
    --remote-env $"AWS_ACCESS_KEY_ID=($env.AWS_ACCESS_KEY_ID)"
    --remote-env $"AWS_SECRET_ACCESS_KEY=($env.AWS_SECRET_ACCESS_KEY)"
    terraform ...$args -json|lines|each {from json}
  )

  try {
    $env.o | lines | each {from json}
  } catch {
    $env.o
  }
}
