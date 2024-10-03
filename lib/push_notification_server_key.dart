import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationServerKey {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "push-474fb",
      "private_key_id": "8a9f8c7d64f10db9e3f7e386a2f2fe318c4cf2ca",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDEU2dGR54+W0E7\nR0v5AtQZEElGor0pl5S9keK1nr240x8ne05g4Dc+R4Ey8sBJJzwFSNAwiSUtN2Qr\niNc3aBFVYoZxF6TmP2vYO9FySSiLaj82yzzcnH01x0pN6+rUT3T+4Re4tl5PAY60\nc303Kc6jpP3pNSLPb6ZiE3cqQmHrP3a5OWXM6+zt8PH/M0nue8+XfeYXI1ta4jFm\nO3pvPpPQzvCLzdx0NxYrNWhv3Ssi5NXRsOhkJoC34y2zY3Kszkv8QBP33uGzZC74\ngQO/L97mog6g3T9kS2ZGkUlQB5fzgxj+n42EEBXzMV8pV8iX2R8e9x9AqFBf5voW\nHfn18LrfAgMBAAECggEAEHog1cuBoswiimjDyI9jNlihPcC/eDPU86AV00ESZ+ZY\nMVvDn+p8LcmZ31PJAvARtS5/l+3lZTPGlXIeVfPHA0/fPAihpK1io2WfK3oBDB+2\nVHv0N15u58o6besZ7LMKfQXD6ZMXZobD763YWX6JwumVtzKSzFlw278J0Ph8orNY\nALoJPqiMR4iS8ogwYyt4uE7MDCQ9E5hzg2p4pR86W4TSRN+pyOqxiC/zT5tJx0Ih\ns2R4Q/oaq3bE8eHtBmLfN/LXmstYmXJzeTOQslGPxgE/SYYKymkQoxnUUruG1hgK\n/GsqRc0Ex8KGEQsPXJ5Y7lwswnDd2YFN/iXRNPaQgQKBgQD6OMRCNoyk8yGCd7og\ni5gzoVuTCSrZCI7u4zZTtrvMGtPh5krwuHlgQpbTn0uXJQZPtFWpF5764i6jjEo3\nJpeEhJjiZkam8gp7++VStIVgwRW2aRxfnWWQrNfu9O1F/wmIqSKHjTddx94JEChF\nGDF4QvDeExPKNPDwt+vNgfmmQQKBgQDI3AVIarWW8XpBemNyDbz37Klvyi0Dt8N8\nC2/ywGXix4jSB/u3AS0JAiImT+WdvX1MWKzCY4UOlOW/SiK7RO9ayH6tAE5s9BBh\n+OIJqgwGvQsk6E4ptk3myFKRLCX12Wh+lGgvwthJ+2tEbq2z8vBjSw4BkniRyULL\nEqaPbalZHwKBgBbSAIwtX2xXxDGa6722HX5v8+MYDfFXR3nf/P9rhfsaY0KR9zm3\nCVLPH+RS/djeBpJUVw+h2Nz2rdw6mjYnbeAnG65iN4VYQ76E/agqUJO/aFSHh4/s\n0et86ACiE9WzadIt4rlMFsWVydk3wQR0LWbTbBZE1SQ26dZ6X6YReYxBAoGBAKXc\nuigQph8dDN2hGRmHqrH4JfqAMyfMyYpXT3xf0EKyjpMRsJRwTiYQMu78LxpQ7XTs\nDM0ArVFbN1T8/S0zQYvv4Fsv05M4/4ZHpTBh0UiHNvqlMlZTioS2iygCEt6vRxCv\nsFEwTrbY/L0nwBzG0ibMRaaasyF/1r4mipAJ+Dv1AoGBAKGi63kn2/EsFedkdfN6\nWqX7pSvmkj5qrYl7scQG2azZmKmUncrQwBKizI/5ArfJGtXZ2i+U8+XXAREnrQu8\nLxqcL4j16QHw4I5aThJYFf8MMoR3NIYjhVy5woxgGhxGQeqCDLgzB2NeKb3OIvGR\ncDFv4e7WMrbmAAAx7JMiIzMv\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-rfwol@push-474fb.iam.gserviceaccount.com",
      "client_id": "114478585274981724494",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-rfwol%40push-474fb.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await
    auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);


    final auth.ServiceAccountCredentials credentials =
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

    final auth.AccessCredentials accessCredentials = await auth.obtainAccessCredentialsViaServiceAccount(
      credentials,
      scopes,
      http.Client(),
    );


    client.close();

    return accessCredentials.accessToken.data;
  }
}



