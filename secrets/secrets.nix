let
  maxdu-nixtop = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3Q9jDm+XTiLWaNuxFcV7EKMpLMNkdG8lcMlH89Co86yPOg+PmyqvNBLcjvt63YEPLFQqSwi/l3os2zMAbYDzRtr2BPRo1yqXOcPaqCqyu11yIKl4y5T04BxvnmRtkn1scGFBkXX+xgFP/BR8LPvGBfSva2R/vnlcUMmsXxrtVhdj9JnrDdHm/VtoPL1TfmL7oX4JtsEmYus4YPrT3VS3Xa40qJNxBsz09bpBqEExtTXMGI8sv/slRJwS2+HiT0yQTfRojPGc4DvhONFlH+c9N3sd9hEjjm4I1XTA/FskFB9J2XiJiCxoKhpEcp1mg8x2wSoT5S45myWV+aBHahJeUYbdPixpR+5V5S/THpEM1ZLhz3Zw1CxnCEG14dAbLgMqK6MsVhgl9Dk9gSt8RhGQMHErFVbRmDFyWKGEdZD0lPbq5P6KARmFgPWERE8PHiKQ8HFL/KWA0owpxsR45WR13Za9jR3PP7jscuDwm5eCHyVxO8Kt0qutD9CP3h7RaO33tNNomke3e8rc9wpgOn3RXp1B6FEdJpp2J3WWinQnqmfUwqsWlk+o11kTatX2u0GpY/ldgTwfJfmilqVs0aefqGRln1Vmu9PLzcv0/XQV2OJVQulskYLwVolgAtkcEi7IXKofQWwHCZ/AH6LuDbtZwgeqyPXV1rTUMcAnOiTRztw==";
  nixtop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYwYX6X3gVXemN4Zp5ZNPvskRdFhLo/PvD7RHGuKuXY";
  nixserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDlpu9B69sB8izlX4LpldJvlD0zoLTX/lIMNGnaJjIf";
  maxdu-nixserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3gjma2f0VFLFn9oIp/jIXgZpl+9FrCN9BqSYPrvVw8";
  nixtop-users = [
    maxdu-nixtop
    nixtop
  ];
nixserver-users = [
    maxdu-nixserver
    nixserver
  ];
in
{
  "wg-full-private.age".publicKeys = nixtop-users;
  "wg-full-preshared.age".publicKeys = nixtop-users ++ [ nixserver ];
  "wg-dns-private.age".publicKeys = nixtop-users;
  "wg-dns-preshared.age".publicKeys = nixtop-users ++ [ nixserver ];
  "iphone-mac.age".publicKeys = nixtop-users;
  "ddclientpass.age".publicKeys = nixserver-users;
	"wg-server-private.age".publicKeys = nixserver-users;
	"wg-client1-preshared.age".publicKeys = nixserver-users;
	"wg-client2-preshared.age".publicKeys = nixserver-users;
	"wg-client3-preshared.age".publicKeys = nixserver-users;
	"wg-client4-preshared.age".publicKeys = nixserver-users;
	"wg-client5-preshared.age".publicKeys = nixserver-users;
	"wg-client6-preshared.age".publicKeys = nixserver-users;
	"wg-client7-preshared.age".publicKeys = nixserver-users;
	"wg-client8-preshared.age".publicKeys = nixserver-users;
	"livekitkey.age".publicKeys = nixserver-users;
	"livekitsecret.age".publicKeys = nixserver-users;
	"livekitkeyfile.age".publicKeys = nixserver-users;
	"matrix-registration-secret.age".publicKeys = nixserver-users;
}
