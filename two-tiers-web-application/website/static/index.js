function deletecert(certId) {
  fetch("/delete-cert", {
    method: "POST",
    body: JSON.stringify({ certId: certId }),
  }).then((_res) => {
    window.location.href = "/";
  });
}
