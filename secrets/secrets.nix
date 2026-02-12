let
  maxdu-nixtop = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3Q9jDm+XTiLWaNuxFcV7EKMpLMNkdG8lcMlH89Co86yPOg+PmyqvNBLcjvt63YEPLFQqSwi/l3os2zMAbYDzRtr2BPRo1yqXOcPaqCqyu11yIKl4y5T04BxvnmRtkn1scGFBkXX+xgFP/BR8LPvGBfSva2R/vnlcUMmsXxrtVhdj9JnrDdHm/VtoPL1TfmL7oX4JtsEmYus4YPrT3VS3Xa40qJNxBsz09bpBqEExtTXMGI8sv/slRJwS2+HiT0yQTfRojPGc4DvhONFlH+c9N3sd9hEjjm4I1XTA/FskFB9J2XiJiCxoKhpEcp1mg8x2wSoT5S45myWV+aBHahJeUYbdPixpR+5V5S/THpEM1ZLhz3Zw1CxnCEG14dAbLgMqK6MsVhgl9Dk9gSt8RhGQMHErFVbRmDFyWKGEdZD0lPbq5P6KARmFgPWERE8PHiKQ8HFL/KWA0owpxsR45WR13Za9jR3PP7jscuDwm5eCHyVxO8Kt0qutD9CP3h7RaO33tNNomke3e8rc9wpgOn3RXp1B6FEdJpp2J3WWinQnqmfUwqsWlk+o11kTatX2u0GpY/ldgTwfJfmilqVs0aefqGRln1Vmu9PLzcv0/XQV2OJVQulskYLwVolgAtkcEi7IXKofQWwHCZ/AH6LuDbtZwgeqyPXV1rTUMcAnOiTRztw==";
  nixtop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYwYX6X3gVXemN4Zp5ZNPvskRdFhLo/PvD7RHGuKuXY";

  nixtop-users = [
    maxdu-nixtop
    nixtop
  ];
in
{
  "wg-full-private.age".publicKeys = nixtop-users;
  "wg-full-preshared.age".publicKeys = nixtop-users;
  "wg-dns-private.age".publicKeys = nixtop-users;
  "wg-dns-preshared.age".publicKeys = nixtop-users;
  "iphone-mac.age".publicKeys = nixtop-users;
}
