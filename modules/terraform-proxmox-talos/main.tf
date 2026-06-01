resource "proxmox_virtual_environment_download_file" "release_20231228_debian_12_bookworm_qcow2_img" {
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "nocloud-amd64.raw.xz"
  node_name          = "px1"
  url                = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.12.4/nocloud-amd64.raw.xz"
  checksum           = "293661659dd59b35a88b827547d41ff48cc3f31120a1cfc91c26854ca52407a5f0c4beac34da958a2b7054e886d4f6fbb424e415dac96f76cddbe4427338f490"
  checksum_algorithm = "sha512"
}
