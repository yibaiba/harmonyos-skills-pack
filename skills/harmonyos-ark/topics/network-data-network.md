# 网络请求与图片加载（离线参考）

> 本文件从 network-data.md 拆分而来
> 内容：Network Kit HTTP/WebSocket/Socket、图片加载与缓存

## Network Kit简介

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/net-mgmt-overview-V5

Network Kit（网络服务）主要提供以下功能：

HTTP数据请求：通过HTTP发起一个数据请求。
WebSocket连接：使用WebSocket建立服务器与客户端的双向连接。
Socket连接：通过Socket进行数据传输。
网络连接管理：网络连接管理提供管理网络一些基础能力，包括WiFi/蜂窝/Ethernet等多网络连接优先级管理、网络质量评估、订阅默认/指定网络连接状态变化、查询网络连接信息、DNS解析等功能。
MDNS管理：MDNS即多播DNS（Multicast DNS），提供局域网内的本地服务添加、移除、发现、解析等能力。
约束与限制

使用网络管理模块的相关功能时，需要请求相应的权限。

在申请权限前，请保证符合权限使用的基本原则。然后参考访问控制-声明权限声明对应权限。

权限名	说明
ohos.permission.GET_NETWORK_INFO	获取网络连接信息。
ohos.permission.INTERNET	允许程序打开网络套接字，进行网络连接。

---

## HTTP数据请求

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/http-request-V5

场景介绍

应用通过HTTP发起一个数据请求，支持常见的GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT方法。

接口说明

HTTP数据请求功能主要由http模块提供。

使用该功能需要申请ohos.permission.INTERNET权限。

权限申请请参考声明权限。

涉及的接口如下表，具体的接口说明请参考API文档。

接口名	描述
createHttp()	创建一个http请求。
request()	根据URL地址，发起HTTP网络请求。
requestInStream()10+	根据URL地址，发起HTTP网络请求并返回流式响应。
destroy()	中断请求任务。
on(type: 'headersReceive')	订阅HTTP Response Header 事件。
off(type: 'headersReceive')	取消订阅HTTP Response Header 事件。
once('headersReceive')8+	订阅HTTP Response Header 事件，但是只触发一次。
on('dataReceive')10+	订阅HTTP流式响应数据接收事件。
off('dataReceive')10+	取消订阅HTTP流式响应数据接收事件。
on('dataEnd')10+	订阅HTTP流式响应数据接收完毕事件。
off('dataEnd')10+	取消订阅HTTP流式响应数据接收完毕事件。
on('dataReceiveProgress')10+	订阅HTTP流式响应数据接收进度事件。
off('dataReceiveProgress')10+	取消订阅HTTP流式响应数据接收进度事件。
on('dataSendProgress')11+	订阅HTTP网络请求数据发送进度事件。
off('dataSendProgress')11+	取消订阅HTTP网络请求数据发送进度事件。
request接口开发步骤
从@kit.NetworkKit中导入http命名空间。
调用createHttp()方法，创建一个HttpRequest对象。
调用该对象的on()方法，订阅http响应头事件，此接口会比request请求先返回。可以根据业务需要订阅此消息。
调用该对象的request()方法，传入http请求的url地址和可选参数，发起网络请求。
按照实际业务需要，解析返回结果。
调用该对象的off()方法，取消订阅http响应头事件。
当该请求使用完毕时，调用destroy()方法主动销毁。
// 引入包名
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


// 每一个httpRequest对应一个HTTP请求任务，不可复用
let httpRequest = http.createHttp();
// 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
// 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
httpRequest.on('headersReceive', (header) => {
  console.info('header: ' + JSON.stringify(header));
});
httpRequest.request(
  // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
  "EXAMPLE_URL",
  {
    method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
    // 开发者根据自身业务需要添加header字段
    header: {
      'Content-Type': 'application/json'
    },
    // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
    extraData: "data to send",
    expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
    usingCache: true, // 可选，默认为true
    priority: 1, // 可选，默认为1
    connectTimeout: 60000, // 可选，默认为60000ms
    readTimeout: 60000, // 可选，默认为60000ms
    usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
    usingProxy: false, // 可选，默认不使用网络代理，自API 10开始支持该属性
    caPath:'/path/to/cacert.pem', // 可选，默认使用系统预制证书，自API 10开始支持该属性
    clientCert: { // 可选，默认不使用客户端证书，自API 11开始支持该属性
      certPath: '/path/to/client.pem', // 默认不使用客户端证书，自API 11开始支持该属性
      keyPath: '/path/to/client.key', // 若证书包含Key信息，传入空字符串，自API 11开始支持该属性
      certType: http.CertType.PEM, // 可选，默认使用PEM，自API 11开始支持该属性
      keyPassword: "passwordToKey" // 可选，输入key文件的密码，自API 11开始支持该属性
    },
    multiFormDataList: [ // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效，自API 11开始支持该属性
      {
        name: "Part1", // 数据名，自API 11开始支持该属性
        contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
        data: 'Example data', // 可选，数据内容，自API 11开始支持该属性
        remoteFileName: 'example.txt' // 可选，自API 11开始支持该属性
      }, {
        name: "Part2", // 数据名，自API 11开始支持该属性
        contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
        // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt
        filePath: `${getContext(this).filesDir}/fileName.txt`, // 可选，传入文件路径，自API 11开始支持该属性
        remoteFileName: 'fileName.txt' // 可选，自API 11开始支持该属性
      }
    ]
  }, (err: BusinessError, data: http.HttpResponse) => {
    if (!err) {
      // data.result为HTTP响应内容，可根据业务需要进行解析
      console.info('Result:' + JSON.stringify(data.result));
      console.info('code:' + JSON.stringify(data.responseCode));
      // data.header为HTTP响应头，可根据业务需要进行解析
      console.info('header:' + JSON.stringify(data.header));
      console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    } else {
      console.error('error:' + JSON.stringify(err));
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    }
  }
);
requestInStream接口开发步骤
从@kit.NetworkKit中导入http命名空间。
调用createHttp()方法，创建一个HttpRequest对象。
调用该对象的on()方法，可以根据业务需要订阅HTTP响应头事件、HTTP流式响应数据接收事件、HTTP流式响应数据接收进度事件和HTTP流式响应数据接收完毕事件。
调用该对象的requestInStream()方法，传入http请求的url地址和可选参数，发起网络请求。
按照实际业务需要，可以解析返回的响应码。
调用该对象的off()方法，取消订阅响应事件。
当该请求使用完毕时，调用destroy()方法主动销毁。
// 引入包名
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


// 每一个httpRequest对应一个HTTP请求任务，不可复用
let httpRequest = http.createHttp();
// 用于订阅HTTP响应头事件
httpRequest.on('headersReceive', (header: Object) => {
  console.info('header: ' + JSON.stringify(header));
});
// 用于订阅HTTP流式响应数据接收事件
let res = new ArrayBuffer(0);
httpRequest.on('dataReceive', (data: ArrayBuffer) => {
   const newRes = new ArrayBuffer(res.byteLength + data.byteLength);
   const resView = new Uint8Array(newRes);
   resView.set(new Uint8Array(res));
   resView.set(new Uint8Array(data), res.byteLength);
   res = newRes;
   console.info('res length: ' + res.byteLength);
});
// 用于订阅HTTP流式响应数据接收完毕事件
httpRequest.on('dataEnd', () => {
  console.info('No more data in response, data receive end');
});
// 用于订阅HTTP流式响应数据接收进度事件
class Data {
  receiveSize: number = 0;
  totalSize: number = 0;
}
httpRequest.on('dataReceiveProgress', (data: Data) => {
  console.log("dataReceiveProgress receiveSize:" + data.receiveSize + ", totalSize:" + data.totalSize);
});


let streamInfo: http.HttpRequestOptions = {
  method: http.RequestMethod.POST,  // 可选，默认为http.RequestMethod.GET
  // 开发者根据自身业务需要添加header字段
  header: {
    'Content-Type': 'application/json'
  },
  // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
  extraData: "data to send",
  expectDataType:  http.HttpDataType.STRING,// 可选，指定返回数据的类型
  usingCache: true, // 可选，默认为true
  priority: 1, // 可选，默认为1
  connectTimeout: 60000, // 可选，默认为60000ms
  readTimeout: 60000, // 可选，默认为60000ms。若传输的数据较大，需要较长的时间，建议增大该参数以保证数据传输正常终止
  usingProtocol: http.HttpProtocol.HTTP1_1 // 可选，协议类型默认值由系统自动指定
}


// 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
httpRequest.requestInStream("EXAMPLE_URL", streamInfo).then((data: number) => {
  console.info("requestInStream OK!");
  console.info('ResponseCode :' + JSON.stringify(data));
  // 取消订阅HTTP响应头事件
  httpRequest.off('headersReceive');
  // 取消订阅HTTP流式响应数据接收事件
  httpRequest.off('dataReceive');
  // 取消订阅HTTP流式响应数据接收进度事件
  httpRequest.off('dataReceiveProgress');
  // 取消订阅HTTP流式响应数据接收完毕事件
  httpRequest.off('dataEnd');
  // 当该请求使用完毕时，调用destroy方法主动销毁
  httpRequest.destroy();
}).catch((err: Error) => {
  console.info("requestInStream ERROR : err = " + JSON.stringify(err));
});
证书锁定

可以通过预置应用级证书，或者预置证书公钥哈希值的方式来进行证书锁定，即只有开发者特别指定的证书才能正常建立https连接。

两种方式都是在配置文件中配置的，配置文件在APP中的路径是：src/main/resources/base/profile/network_config.json。在该配置中，可以为预置的证书与网络服务器建立对应关系。

如果不知道服务器域名的证书，可以通过以下方式访问该域名获取证书，注意把www.example.com改成想要获取域名证书的域名，www.example.com.pem改成想保存的证书文件名：

openssl s_client -servername www.example.com -connect www.example.com:443 \
    < /dev/null | sed -n "/-----BEGIN/,/-----END/p" > www.example.com.pem

如果你的环境是Windows系统，需要注意：

将/dev/null替换成NUL。
和Linux的OpenSSL表现可能不同，OpenSSL可能会等待用户输入才会退出，按Enter键即可。
如果没有sed命令，将输出中从-----BEGIN CERTIFICATE-----到-----END CERTIFICATE-----之间的部分复制下来保存即可（复制部分包括这两行）。
预置应用级证书

直接把证书原文件预置在APP中。目前支持crt和pem格式的证书文件。

注意

当前ohos.net.http和Image组件的证书锁定，会匹配证书链上所有证书的哈希值，如果服务器更新了任意一本证书，都会导致校验失败。如果服务器出现了更新证书的情况，APP版本应当随之更新并推荐消费者尽快升级APP版本，否则可能导致联网失败。

预置证书公钥哈希值

通过在配置中指定域名证书公钥的哈希值来只允许使用公钥哈希值匹配的域名证书访问此域名。

域名证书的公钥哈希值可以用如下的命令计算，这里假设域名证书是通过上面的OpenSSL命令获得的，并保存在www.example.com.pem文件。#开头的行是注释，可以不用输入：

# 从证书中提取出公钥
openssl x509 -in www.example.com.pem -pubkey -noout > www.example.com.pubkey.pem
# 将pem格式的公钥转换成der格式
openssl asn1parse -noout -inform pem -in www.example.com.pubkey.pem -out www.example.com.pubkey.der
# 计算公钥的SHA256并转换成base64编码
openssl dgst -sha256 -binary www.example.com.pubkey.der | openssl base64
JSON配置文件示例

预置应用级证书的配置例子如下：

{
  "network-security-config": {
    "base-config": {
      "trust-anchors": [
        {
          "certificates": "/etc/security/certificates"
        }
      ]
    },
    "domain-config": [
      {
        "domains": [
          {
            "include-subdomains": true,
            "name": "example.com"
          }
        ],
        "trust-anchors": [
          {
            "certificates": "/data/storage/el1/bundle/entry/resources/resfile"
          }
        ]
      }
    ]
  }
}

预置证书公钥哈希值的配置例子如下:

{
  "network-security-config": {
    "domain-config": [
      {
        "domains": [
          {
            "include-subdomains": true,
            "name": "server.com"
          }
        ],
        "pin-set": {
          "expiration": "2024-11-08",
          "pin": [
            {
              "digest-algorithm": "sha256",
              "digest": "FEDCBA987654321"
            }
          ]
        }
      }
    ]
  }
}

各个字段含义:

字段	类型	说明
network-security-config	object	网络安全配置。可包含0或者1个base-config，必须包含1个domain-config。
base-config	object	指示应用程序范围的安全配置。必须包含1个trust-anchors。
domain-config	array	指示每个域的安全配置。可以包含任意个item。item必须包含1个domains，可以包含0或者1个trust-anchors，可以包含0个或者1个pin-set。
trust-anchors	array	受信任的CA。可以包含任意个item。item必须包含1个certificates。
certificates	string	CA证书路径。
domains	array	域。可以包含任意个item。item必须包含1个name(string:指示域名)，可以包含0或者1个include-subdomains。
include-subdomains	boolean	指示规则是否适用于子域。
pin-set	object	证书公钥哈希设置。必须包含1个pin，可以包含0或者1个expiration。
expiration	string	指示证书公钥哈希的过期时间。
pin	array	证书公钥哈希。可以包含任意个item。item必须包含1个digest-algorithm，item必须包含1个digest。
digest-algorithm	string	指示用于生成哈希的摘要算法。目前只支持sha256。
digest	string	指示公钥哈希。

---

## WebSocket连接

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/websocket-connection-V5

场景介绍

使用WebSocket建立服务器与客户端的双向连接，需要先通过createWebSocket()方法创建WebSocket对象，然后通过connect()方法连接到服务器。当连接成功后，客户端会收到open事件的回调，之后客户端就可以通过send()方法与服务器进行通信。当服务器发信息给客户端时，客户端会收到message事件的回调。当客户端不要此连接时，可以通过调用close()方法主动断开连接，之后客户端会收到close事件的回调。

若在上述任一过程中发生错误，客户端会收到error事件的回调。

websocket支持心跳检测机制，在客户端和服务端建立WebSocket连接之后，每间隔一段时间会客户端会发送Ping帧给服务器，服务器收到后应立即回复Pong帧。

接口说明

WebSocket连接功能主要由webSocket模块提供。使用该功能需要申请ohos.permission.INTERNET权限。具体接口说明如下表。

接口名	描述
createWebSocket()	创建一个WebSocket连接。
connect()	根据URL地址，建立一个WebSocket连接。
send()	通过WebSocket连接发送数据。
close()	关闭WebSocket连接。
on(type: 'open')	订阅WebSocket的打开事件。
off(type: 'open')	取消订阅WebSocket的打开事件。
on(type: 'message')	订阅WebSocket的接收到服务器消息事件。
off(type: 'message')	取消订阅WebSocket的接收到服务器消息事件。
on(type: 'close')	订阅WebSocket的关闭事件。
off(type: 'close')	取消订阅WebSocket的关闭事件
on(type: 'error')	订阅WebSocket的Error事件。
off(type: 'error')	取消订阅WebSocket的Error事件。
开发步骤

导入需要的webSocket模块。

创建一个WebSocket连接，返回一个WebSocket对象。

（可选）订阅WebSocket的打开、消息接收、关闭、Error事件。

根据URL地址，发起WebSocket连接。

使用完WebSocket连接之后，主动断开连接。

import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


let defaultIpAddress = "ws://";
let ws = webSocket.createWebSocket();
ws.on('open', (err: BusinessError, value: Object) => {
  console.log("on open, status:" + JSON.stringify(value));
  // 当收到on('open')事件时，可以通过send()方法与服务器进行通信
  ws.send("Hello, server!", (err: BusinessError, value: boolean) => {
    if (!err) {
      console.log("Message send successfully");
    } else {
      console.log("Failed to send the message. Err:" + JSON.stringify(err));
    }
  });
});
ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
  console.log("on message, message:" + value);
  // 当收到服务器的`bye`消息时（此消息字段仅为示意，具体字段需要与服务器协商），主动断开连接
  if (value === 'bye') {
    ws.close((err: BusinessError, value: boolean) => {
      if (!err) {
        console.log("Connection closed successfully");
      } else {
        console.log("Failed to close the connection. Err: " + JSON.stringify(err));
      }
    });
  }
});
ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
  console.log("on close, code is " + value.code + ", reason is " + value.reason);
});
ws.on('error', (err: BusinessError) => {
  console.log("on error, error:" + JSON.stringify(err));
});
ws.connect(defaultIpAddress, (err: BusinessError, value: boolean) => {
  if (!err) {
    console.log("Connected successfully");
  } else {
    console.log("Connection failed. Err:" + JSON.stringify(err));
  }
});

---

## Socket连接

> 来源: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/socket-connection-V5

简介

Socket 连接主要是通过 Socket 进行数据传输，支持 TCP/UDP/Multicast/TLS 协议。

说明

应用退后台又切回前台后，需要对网络通信做失败重试，通信失败后匹配错误码并重新创建新的TCP/UDP连接对象。

基本概念
Socket：套接字，就是对网络中不同主机上的应用进程之间进行双向通信的端点的抽象。
TCP：传输控制协议(Transmission Control Protocol)。是一种面向连接的、可靠的、基于字节流的传输层通信协议。
UDP：用户数据报协议(User Datagram Protocol)。是一个简单的面向消息的传输层，不需要连接。
Multicast：多播，基于UDP的一种通信模式，用于实现组内所有设备之间广播形式的通信。
LocalSocket：本地套接字，IPC(Inter-Process Communication)进程间通信的一种，实现设备内进程之间相互通信，无需网络。
TLS：安全传输层协议(Transport Layer Security)。用于在两个通信应用程序之间提供保密性和数据完整性。
场景介绍

应用通过 Socket 进行数据传输，支持 TCP/UDP/Multicast/TLS 协议。主要场景有：

应用通过 TCP/UDP Socket进行数据传输
应用通过 TCP Socket Server 进行数据传输
应用通过 Multicast Socket 进行数据传输
应用通过 Local Socket进行数据传输
应用通过 Local Socket Server 进行数据传输
应用通过 TLS Socket 进行加密数据传输
应用通过 TLS Socket Server 进行加密数据传输
接口说明

完整的 API 说明以及实例代码请参考：Socket 连接。

Socket 连接主要由 socket 模块提供。具体接口说明如下表。

接口名	描述
constructUDPSocketInstance()	创建一个 UDPSocket 对象。
constructTCPSocketInstance()	创建一个 TCPSocket 对象。
constructTCPSocketServerInstance()	创建一个 TCPSocketServer 对象。
constructMulticastSocketInstance()	创建一个 MulticastSocket 对象。
constructLocalSocketInstance()	创建一个 LocalSocket 对象。
constructLocalSocketServerInstance()	创建一个 LocalSocketServer 对象。
listen()	绑定、监听并启动服务，接收客户端的连接请求。（仅 TCP/LocalSocket 支持）。
bind()	绑定 IP 地址和端口，或是绑定本地套接字路径。
send()	发送数据。
close()	关闭连接。
getState()	获取 Socket 状态。
connect()	连接到指定的 IP 地址和端口，或是连接到本地套接字（仅 TCP/LocalSocket 支持）。
getRemoteAddress()	获取对端 Socket 地址（仅 TCP 支持，需要先调用 connect 方法）。
setExtraOptions()	设置 Socket 连接的其他属性。
getExtraOptions()	获取 Socket 连接的其他属性（仅 LocalSocket 支持）。
addMembership()	加入到指定的多播组 IP 中 (仅 Multicast 支持)。
dropMembership()	从指定的多播组 IP 中退出 (仅 Multicast 支持)。
setMulticastTTL()	设置数据传输跳数 TTL (仅 Multicast 支持)。
getMulticastTTL()	获取数据传输跳数 TTL (仅 Multicast 支持)。
setLoopbackMode()	设置回环模式，允许主机在本地循环接收自己发送的多播数据包 (仅 Multicast 支持)。
getLoopbackMode()	获取回环模式开启或关闭的状态 (仅 Multicast 支持)。
on(type: 'message')	订阅 Socket 连接的接收消息事件。
off(type: 'message')	取消订阅 Socket 连接的接收消息事件。
on(type: 'close')	订阅 Socket 连接的关闭事件。
off(type: 'close')	取消订阅 Socket 连接的关闭事件。
on(type: 'error')	订阅 Socket 连接的 Error 事件。
off(type: 'error')	取消订阅 Socket 连接的 Error 事件。
on(type: 'listening')	订阅 UDPSocket 连接的数据包消息事件（仅 UDP 支持）。
off(type: 'listening')	取消订阅 UDPSocket 连接的数据包消息事件（仅 UDP 支持）。
on(type: 'connect')	订阅 Socket 的连接事件（仅 TCP/LocalSocket 支持）。
off(type: 'connect')	取消订阅 Socket 的连接事件（仅 TCP/LocalSocket 支持）。

TLS Socket 连接主要由 tls_socket 模块提供。具体接口说明如下表。

接口名	功能描述
constructTLSSocketInstance()	创建一个 TLSSocket 对象。
bind()	绑定 IP 地址和端口号。
close(type: 'error')	关闭连接。
connect()	连接到指定的 IP 地址和端口。
getCertificate()	返回表示本地证书的对象。
getCipherSuite()	返回包含协商的密码套件信息的列表。
getProtocol()	返回包含当前连接协商的 SSL/TLS 协议版本的字符串。
getRemoteAddress()	获取 TLSSocket 连接的对端地址。
getRemoteCertificate()	返回表示对等证书的对象。
getSignatureAlgorithms()	在服务器和客户端之间共享的签名算法列表，按优先级降序排列。
getState()	获取 TLSSocket 连接的状态。
off(type: 'close')	取消订阅 TLSSocket 连接的关闭事件。
off(type: 'error')	取消订阅 TLSSocket 连接的 Error 事件。
off(type: 'message')	取消订阅 TLSSocket 连接的接收消息事件。
on(type: 'close')	订阅 TLSSocket 连接的关闭事件。
on(type: 'error')	订阅 TLSSocket 连接的 Error 事件。
on(type: 'message')	订阅 TLSSocket 连接的接收消息事件。
send()	发送数据。
setExtraOptions()	设置 TLSSocket 连接的其他属性。
应用 TCP/UDP 协议进行通信

UDP 与 TCP 流程大体类似，下面以 TCP 为例：

import 需要的 socket 模块。

创建一个 TCPSocket 连接，返回一个 TCPSocket 对象。

（可选）订阅 TCPSocket 相关的订阅事件。

绑定 IP 地址和端口，端口可以指定或由系统随机分配。

连接到指定的 IP 地址和端口。

发送数据。

Socket 连接使用完毕后，主动关闭。

import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
// 创建一个TCPSocket连接，返回一个TCPSocket对象。
let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
tcp.on('message', (value: SocketInfo) => {
  console.log("on message");
  let buffer = value.message;
  let dataView = new DataView(buffer);
  let str = "";
  for (let i = 0; i < dataView.byteLength; ++i) {
    str += String.fromCharCode(dataView.getUint8(i));
  }
  console.log("on connect received:" + str);
});
tcp.on('connect', () => {
  console.log("on connect");
});
tcp.on('close', () => {
  console.log("on close");
});


// 绑定本地IP地址和端口。
let ipAddress : socket.NetAddress = {} as socket.NetAddress;
ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 1234;
tcp.bind(ipAddress, (err: BusinessError) => {
  if (err) {
    console.log('bind fail');
    return;
  }
  console.log('bind success');


  // 连接到指定的IP地址和端口。
  ipAddress.address = "192.168.xxx.xxx";
  ipAddress.port = 5678;


  let tcpConnect : socket.TCPConnectOptions = {} as socket.TCPConnectOptions;
  tcpConnect.address = ipAddress;
  tcpConnect.timeout = 6000;


  tcp.connect(tcpConnect).then(() => {
    console.log('connect success');
    let tcpSendOptions: socket.TCPSendOptions = {
      data: 'Hello, server!'
    }
    tcp.send(tcpSendOptions).then(() => {
      console.log('send success');
    }).catch((err: BusinessError) => {
      console.log('send fail');
    });
  }).catch((err: BusinessError) => {
    console.log('connect fail');
  });
});


// 连接使用完毕后，主动关闭。取消相关事件的订阅。
setTimeout(() => {
  tcp.close().then(() => {
    console.log('close success');
  }).catch((err: BusinessError) => {
    console.log('close fail');
  });
  tcp.off('message');
  tcp.off('connect');
  tcp.off('close');
}, 30 * 1000);
应用通过 TCP Socket Server 进行数据传输

服务端 TCP Socket 流程：

import 需要的 socket 模块。
创建一个 TCPSocketServer 连接，返回一个 TCPSocketServer 对象。
绑定本地 IP 地址和端口，监听并接受与此套接字建立的客户端 TCPSocket 连接。
订阅 TCPSocketServer 的 connect 事件，用于监听客户端的连接状态。
客户端与服务端建立连接后，返回一个 TCPSocketConnection 对象，用于与客户端通信。
订阅 TCPSocketConnection 相关的事件，通过 TCPSocketConnection 向客户端发送数据。
主动关闭与客户端的连接。
取消 TCPSocketConnection 和 TCPSocketServer 相关事件的订阅。
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


// 创建一个TCPSocketServer连接，返回一个TCPSocketServer对象。
let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
// 绑定本地IP地址和端口，进行监听


let ipAddress : socket.NetAddress = {} as socket.NetAddress;
ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 4651;
tcpServer.listen(ipAddress).then(() => {
  console.log('listen success');
}).catch((err: BusinessError) => {
  console.log('listen fail');
});


class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
// 订阅TCPSocketServer的connect事件
tcpServer.on("connect", (client: socket.TCPSocketConnection) => {
  // 订阅TCPSocketConnection相关的事件
  client.on("close", () => {
    console.log("on close success");
  });
  client.on("message", (value: SocketInfo) => {
    let buffer = value.message;
    let dataView = new DataView(buffer);
    let str = "";
    for (let i = 0; i < dataView.byteLength; ++i) {
      str += String.fromCharCode(dataView.getUint8(i));
    }
    console.log("received message--:" + str);
    console.log("received address--:" + value.remoteInfo.address);
    console.log("received family--:" + value.remoteInfo.family);
    console.log("received port--:" + value.remoteInfo.port);
    console.log("received size--:" + value.remoteInfo.size);
  });


  // 向客户端发送数据
  let tcpSendOptions : socket.TCPSendOptions = {} as socket.TCPSendOptions;
  tcpSendOptions.data = 'Hello, client!';
  client.send(tcpSendOptions).then(() => {
    console.log('send success');
  }).catch((err: Object) => {
    console.error('send fail: ' + JSON.stringify(err));
  });


  // 关闭与客户端的连接
  client.close().then(() => {
    console.log('close success');
  }).catch((err: BusinessError) => {
    console.log('close fail');
  });


  // 取消TCPSocketConnection相关的事件订阅
  setTimeout(() => {
    client.off("message");
    client.off("close");
  }, 10 * 1000);
});


// 取消TCPSocketServer相关的事件订阅
setTimeout(() => {
  tcpServer.off("connect");
}, 30 * 1000);
应用通过 Multicast Socket 进行数据传输

import 需要的 socket 模块。

创建 multicastSocket 多播对象。

指定多播 IP 与端口，加入多播组。

开启消息 message 监听。

发送数据，数据以广播的形式传输，同一多播组中已经开启消息 message 监听的多播对象都会接收到数据。

关闭 message 消息的监听。

退出多播组。

import { socket } from '@kit.NetworkKit';


// 创建Multicast对象
let multicast: socket.MulticastSocket = socket.constructMulticastSocketInstance();


let addr : socket.NetAddress = {
  address: '239.255.0.1',
  port: 32123,
  family: 1
}


// 加入多播组
multicast.addMembership(addr).then(() => {
  console.log('addMembership success');
}).catch((err: Object) => {
  console.log('addMembership fail');
});


// 开启监听消息数据，将接收到的ArrayBuffer类型数据转换为String
class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
multicast.on('message', (data: SocketInfo) => {
  console.info('接收的数据: ' + JSON.stringify(data))
  const uintArray = new Uint8Array(data.message)
  let str = ''
  for (let i = 0; i < uintArray.length; ++i) {
    str += String.fromCharCode(uintArray[i])
  }
  console.info(str)
})


// 发送数据
multicast.send({ data:'Hello12345', address: addr }).then(() => {
  console.log('send success');
}).catch((err: Object) => {
  console.log('send fail, ' + JSON.stringify(err));
});


// 关闭消息的监听
multicast.off('message')


// 退出多播组
multicast.dropMembership(addr).then(() => {
  console.log('drop membership success');
}).catch((err: Object) => {
  console.log('drop membership fail');
});
应用通过 LocalSocket 进行数据传输

import 需要的 socket 模块。

使用 constructLocalSocketInstance 接口，创建一个 LocalSocket 客户端对象。

注册 LocalSocket 的消息(message)事件，以及一些其它事件(可选)。

连接到指定的本地套接字文件路径。

发送数据。

Socket 连接使用完毕后，取消事件的注册，并关闭套接字。

import { socket } from '@kit.NetworkKit';


// 创建一个LocalSocket连接，返回一个LocalSocket对象。
let client: socket.LocalSocket = socket.constructLocalSocketInstance();
client.on('message', (value: socket.LocalSocketMessageInfo) => {
  const uintArray = new Uint8Array(value.message)
  let messageView = '';
  for (let i = 0; i < uintArray.length; i++) {
    messageView += String.fromCharCode(uintArray[i]);
  }
  console.log('total receive: ' + JSON.stringify(value));
  console.log('message information: ' + messageView);
});
client.on('connect', () => {
  console.log("on connect");
});
client.on('close', () => {
  console.log("on close");
});


// 传入指定的本地套接字路径，连接服务端。
let sandboxPath: string = getContext(this).filesDir + '/testSocket'
let localAddress : socket.LocalAddress = {
  address: sandboxPath
}
let connectOpt: socket.LocalConnectOptions = {
  address: localAddress,
  timeout: 6000
}
let sendOpt: socket.LocalSendOptions = {
  data: 'Hello world!'
}
client.connect(connectOpt).then(() => {
  console.log('connect success')
  client.send(sendOpt).then(() => {
  console.log('send success')
  }).catch((err: Object) => {
    console.log('send failed: ' + JSON.stringify(err))
  })
}).catch((err: Object) => {
  console.log('connect fail: ' + JSON.stringify(err));
});


// 当不需要再连接服务端，需要断开且取消事件的监听时
client.off('message');
client.off('connect');
client.off('close');
client.close().then(() => {
  console.log('close client success')
}).catch((err: Object) => {
  console.log('close client err: ' + JSON.stringify(err))
})
应用通过 Local Socket Server 进行数据传输

服务端 LocalSocket Server 流程：

import 需要的 socket 模块。

使用 constructLocalSocketServerInstance 接口，创建一个 LocalSocketServer 服务端对象。

启动服务，绑定本地套接字路径，创建出本地套接字文件，监听客户端的连接请求。

注册 LocalSocket 的客户端连接(connect)事件，以及一些其它事件(可选)。

在客户端连接上来时，通过连接事件的回调函数，获取连接会话对象。

给会话对象 LocalSocketConnection 注册消息(message)事件，以及一些其它事件(可选)。

通过会话对象主动向客户端发送消息。

结束与客户端的通信，主动断开与客户端的连接。

取消 LocalSocketConnection 和 LocalSocketServer 相关事件的订阅。

import { socket } from '@kit.NetworkKit';


// 创建一个LocalSocketServer连接，返回一个LocalSocketServer对象。
let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
// 创建并绑定本地套接字文件testSocket，进行监听
let sandboxPath: string = getContext(this).filesDir + '/testSocket'
let listenAddr: socket.LocalAddress = {
  address: sandboxPath
}
server.listen(listenAddr).then(() => {
  console.log("listen success");
}).catch((err: Object) => {
  console.log("listen fail: " + JSON.stringify(err));
});


// 订阅LocalSocketServer的connect事件
server.on('connect', (connection: socket.LocalSocketConnection) => {
  // 订阅LocalSocketConnection相关的事件
  connection.on('error', (err: Object) => {
    console.log("on error success");
  });
  connection.on('message', (value: socket.LocalSocketMessageInfo) => {
    const uintArray = new Uint8Array(value.message);
    let messageView = '';
    for (let i = 0; i < uintArray.length; i++) {
      messageView += String.fromCharCode(uintArray[i]);
    }
    console.log('total: ' + JSON.stringify(value));
    console.log('message information: ' + messageView);
  });


  connection.on('error', (err: Object) => {
    console.log("err:" + JSON.stringify(err));
  })


  // 向客户端发送数据
  let sendOpt : socket.LocalSendOptions = {
    data: 'Hello world!'
  };
  connection.send(sendOpt).then(() => {
    console.log('send success');
  }).catch((err: Object) => {
    console.log('send failed: ' + JSON.stringify(err));
  })


  // 关闭与客户端的连接
  connection.close().then(() => {
    console.log('close success');
  }).catch((err: Object) => {
    console.log('close failed: ' + JSON.stringify(err));
  });


  // 取消LocalSocketConnection相关的事件订阅
  connection.off('message');
  connection.off('error');
});


// 取消LocalSocketServer相关的事件订阅
server.off('connect');
server.off('error');
应用通过 TLS Socket 进行加密数据传输

客户端 TLS Socket 流程：

import 需要的 socket 模块。

绑定服务器 IP 和端口号。

双向认证上传客户端 CA 证书及数字证书；单向认证上传客户端 CA 证书。

创建一个 TLSSocket 连接，返回一个 TLSSocket 对象。

（可选）订阅 TLSSocket 相关的订阅事件。

发送数据。

TLSSocket 连接使用完毕后，主动关闭。

import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
// 创建一个（双向认证）TLS Socket连接，返回一个TLS Socket对象。
let tlsTwoWay: socket.TLSSocket = socket.constructTLSSocketInstance();
// 订阅TLS Socket相关的订阅事件
tlsTwoWay.on('message', (value: SocketInfo) => {
  console.log("on message");
  let buffer = value.message;
  let dataView = new DataView(buffer);
  let str = "";
  for (let i = 0; i < dataView.byteLength; ++i) {
    str += String.fromCharCode(dataView.getUint8(i));
  }
  console.log("on connect received:" + str);
});
tlsTwoWay.on('connect', () => {
  console.log("on connect");
});
tlsTwoWay.on('close', () => {
  console.log("on close");
});


// 绑定本地IP地址和端口。
let ipAddress : socket.NetAddress = {} as socket.NetAddress;
ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 4512;
tlsTwoWay.bind(ipAddress, (err: BusinessError) => {
  if (err) {
    console.log('bind fail');
    return;
  }
  console.log('bind success');
});


ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 1234;


let tlsSecureOption : socket.TLSSecureOptions = {} as socket.TLSSecureOptions;
tlsSecureOption.key = "xxxx";
tlsSecureOption.cert = "xxxx";
tlsSecureOption.ca = ["xxxx"];
tlsSecureOption.password = "xxxx";
tlsSecureOption.protocols = [socket.Protocol.TLSv12];
tlsSecureOption.useRemoteCipherPrefer = true;
tlsSecureOption.signatureAlgorithms = "rsa_pss_rsae_sha256:ECDSA+SHA256";
tlsSecureOption.cipherSuite = "AES256-SHA256";


let tlsTwoWayConnectOption : socket.TLSConnectOptions = {} as socket.TLSConnectOptions;
tlsSecureOption.key = "xxxx";
tlsTwoWayConnectOption.address = ipAddress;
tlsTwoWayConnectOption.secureOptions = tlsSecureOption;
tlsTwoWayConnectOption.ALPNProtocols = ["spdy/1", "http/1.1"];


// 建立连接
tlsTwoWay.connect(tlsTwoWayConnectOption).then(() => {
  console.log("connect successfully");
}).catch((err: BusinessError) => {
  console.log("connect failed " + JSON.stringify(err));
});


// 连接使用完毕后，主动关闭。取消相关事件的订阅。
tlsTwoWay.close((err: BusinessError) => {
  if (err) {
    console.log("close callback error = " + err);
  } else {
    console.log("close success");
  }
  tlsTwoWay.off('message');
  tlsTwoWay.off('connect');
  tlsTwoWay.off('close');
});


// 创建一个（单向认证）TLS Socket连接，返回一个TLS Socket对象。
let tlsOneWay: socket.TLSSocket = socket.constructTLSSocketInstance(); // One way authentication


// 订阅TLS Socket相关的订阅事件
tlsTwoWay.on('message', (value: SocketInfo) => {
  console.log("on message");
  let buffer = value.message;
  let dataView = new DataView(buffer);
  let str = "";
  for (let i = 0; i < dataView.byteLength; ++i) {
    str += String.fromCharCode(dataView.getUint8(i));
  }
  console.log("on connect received:" + str);
});
tlsTwoWay.on('connect', () => {
  console.log("on connect");
});
tlsTwoWay.on('close', () => {
  console.log("on close");
});


// 绑定本地IP地址和端口。
ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 5445;
tlsOneWay.bind(ipAddress, (err:BusinessError) => {
  if (err) {
    console.log('bind fail');
    return;
  }
  console.log('bind success');
});


ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 8789;
let tlsOneWaySecureOption : socket.TLSSecureOptions = {} as socket.TLSSecureOptions;
tlsOneWaySecureOption.ca = ["xxxx", "xxxx"];
tlsOneWaySecureOption.cipherSuite = "AES256-SHA256";


let tlsOneWayConnectOptions: socket.TLSConnectOptions = {} as socket.TLSConnectOptions;
tlsOneWayConnectOptions.address = ipAddress;
tlsOneWayConnectOptions.secureOptions = tlsOneWaySecureOption;


// 建立连接
tlsOneWay.connect(tlsOneWayConnectOptions).then(() => {
  console.log("connect successfully");
}).catch((err: BusinessError) => {
  console.log("connect failed " + JSON.stringify(err));
});


// 连接使用完毕后，主动关闭。取消相关事件的订阅。
tlsTwoWay.close((err: BusinessError) => {
  if (err) {
    console.log("close callback error = " + err);
  } else {
    console.log("close success");
  }
  tlsTwoWay.off('message');
  tlsTwoWay.off('connect');
  tlsTwoWay.off('close');
});
应用通过将 TCP Socket 升级为 TLS Socket 进行加密数据传输

客户端 TCP Socket 升级为 TLS Socket 流程：

import 需要的 socket 模块。

参考应用 TCP/UDP 协议进行通信，创建一个 TCPSocket 连接。

确保 TCPSocket 已连接后，使用该 TCPSocket 对象创建 TLSSocket 连接，返回一个 TLSSocket 对象。

双向认证上传客户端 CA 证书及数字证书；单向认证上传客户端 CA 证书。

（可选）订阅 TLSSocket 相关的订阅事件。

发送数据。

TLSSocket 连接使用完毕后，主动关闭。

import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}


// 创建一个TCPSocket连接，返回一个TCPSocket对象。
let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
tcp.on('message', (value: SocketInfo) => {
  console.log("on message");
  let buffer = value.message;
  let dataView = new DataView(buffer);
  let str = "";
  for (let i = 0; i < dataView.byteLength; ++i) {
    str += String.fromCharCode(dataView.getUint8(i));
  }
  console.log("on connect received:" + str);
});
tcp.on('connect', () => {
  console.log("on connect");
});


// 绑定本地IP地址和端口。
let ipAddress: socket.NetAddress = {} as socket.NetAddress;
ipAddress.address = "192.168.xxx.xxx";
ipAddress.port = 1234;
tcp.bind(ipAddress, (err: BusinessError) => {
  if (err) {
    console.log('bind fail');
    return;
  }
  console.log('bind success');


  // 连接到指定的IP地址和端口。
  ipAddress.address = "192.168.xxx.xxx";
  ipAddress.port = 443;


  let tcpConnect: socket.TCPConnectOptions = {} as socket.TCPConnectOptions;
  tcpConnect.address = ipAddress;
  tcpConnect.timeout = 6000;


  tcp.connect(tcpConnect, (err: BusinessError) => {
    if (err) {
      console.log('connect fail');
      return;
    }
    console.log('connect success');


    // 确保TCPSocket已连接后，将其升级为TLSSocket连接。
    let tlsTwoWay: socket.TLSSocket = socket.constructTLSSocketInstance(tcp);
    // 订阅TLSSocket相关的订阅事件。
    tlsTwoWay.on('message', (value: SocketInfo) => {
      console.log("tls on message");
      let buffer = value.message;
      let dataView = new DataView(buffer);
      let str = "";
      for (let i = 0; i < dataView.byteLength; ++i) {
        str += String.fromCharCode(dataView.getUint8(i));
      }
      console.log("tls on connect received:" + str);
    });
    tlsTwoWay.on('connect', () => {
      console.log("tls on connect");
    });
    tlsTwoWay.on('close', () => {
      console.log("tls on close");
    });


    // 配置TLSSocket目的地址、证书等信息。
    ipAddress.address = "192.168.xxx.xxx";
    ipAddress.port = 1234;


    let tlsSecureOption: socket.TLSSecureOptions = {} as socket.TLSSecureOptions;
    tlsSecureOption.key = "xxxx";
    tlsSecureOption.cert = "xxxx";
    tlsSecureOption.ca = ["xxxx"];
    tlsSecureOption.password = "xxxx";
    tlsSecureOption.protocols = [socket.Protocol.TLSv12];
    tlsSecureOption.useRemoteCipherPrefer = true;
    tlsSecureOption.signatureAlgorithms = "rsa_pss_rsae_sha256:ECDSA+SHA256";
    tlsSecureOption.cipherSuite = "AES256-SHA256";


    let tlsTwoWayConnectOption: socket.TLSConnectOptions = {} as socket.TLSConnectOptions;
    tlsSecureOption.key = "xxxx";
    tlsTwoWayConnectOption.address = ipAddress;
    tlsTwoWayConnectOption.secureOptions = tlsSecureOption;
    tlsTwoWayConnectOption.ALPNProtocols = ["spdy/1", "http/1.1"];


    // 建立TLSSocket连接
    tlsTwoWay.connect(tlsTwoWayConnectOption, () => {
      console.log("tls connect success");


      // 连接使用完毕后，主动关闭。取消相关事件的订阅。
      tlsTwoWay.close((err: BusinessError) => {
        if (err) {
          console.log("tls close callback error = " + err);
        } else {
          console.log("tls close success");
        }
        tlsTwoWay.off('message');
        tlsTwoWay.off('connect');
        tlsTwoWay.off('close');
      });
    });
  });
});
应用通过 TLS Socket Server 进行加密数据传输

服务端 TLS Socket Server 流程：

import 需要的 socket 模块。

启动服务，绑定 IP 和端口号，监听客户端连接，创建并初始化 TLS 会话，加载证书密钥并验证。

订阅 TLSSocketServer 的连接事件。

收到客户端连接，通过回调得到 TLSSocketConnection 对象。

订阅 TLSSocketConnection 相关的事件。

发送数据。

TLSSocketConnection 连接使用完毕后，断开连接。

取消订阅 TLSSocketConnection 以及 TLSSocketServer 的相关事件。

import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();


let netAddress: socket.NetAddress = {
  address: '192.168.xx.xxx',
  port: 8080
}


let tlsSecureOptions: socket.TLSSecureOptions = {
  key: "xxxx",
  cert: "xxxx",
  ca: ["xxxx"],
  password: "xxxx",
  protocols: socket.Protocol.TLSv12,
  useRemoteCipherPrefer: true,
  signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
  cipherSuite: "AES256-SHA256"
}


let tlsConnectOptions: socket.TLSConnectOptions = {
  address: netAddress,
  secureOptions: tlsSecureOptions,
  ALPNProtocols: ["spdy/1", "http/1.1"]
}


tlsServer.listen(tlsConnectOptions).then(() => {
  console.log("listen callback success");
}).catch((err: BusinessError) => {
  console.log("failed" + err);
});


class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
let callback = (value: SocketInfo) => {
  let messageView = '';
  for (let i: number = 0; i < value.message.byteLength; i++) {
    let uint8Array = new Uint8Array(value.message)
    let messages = uint8Array[i]
    let message = String.fromCharCode(messages);
    messageView += message;
  }
  console.log('on message message: ' + JSON.stringify(messageView));
  console.log('remoteInfo: ' + JSON.stringify(value.remoteInfo));
}
tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
  client.on('message', callback);


  // 发送数据
  client.send('Hello, client!').then(() => {
    console.log('send success');
  }).catch((err: BusinessError) => {
    console.log('send fail');
  });


  // 断开连接
  client.close().then(() => {
    console.log('close success');
  }).catch((err: BusinessError) => {
    console.log('close fail');
  });


  // 可以指定传入on中的callback取消一个订阅，也可以不指定callback清空所有订阅。
  client.off('message', callback);
  client.off('message');
});


// 取消订阅tlsServer的相关事件
tlsServer.off('connect');


---

## 图片加载与缓存策略

### Image 组件基础

```typescript
// 网络图片（自动缓存）
Image('https://example.com/photo.jpg')
  .width(200).height(200)
  .objectFit(ImageFit.Cover)
  .alt($r('app.media.placeholder'))  // 占位图

// 本地资源图片
Image($r('app.media.icon'))

// Base64 图片
Image(`data:image/png;base64,${base64Str}`)
```

### 缓存策略选择

| 场景 | 方案 | 说明 |
|------|------|------|
| 普通网络图片 | Image 组件直接加载 | 系统自动管理内存缓存 + 磁盘缓存 |
| 需要手动控制缓存 | `http.request()` + 文件写入 | 自行管理缓存目录和过期策略 |
| 大量图片列表 | LazyForEach + Image | 配合 `cachedCount` 控制缓存数量 |
| 头像等固定图 | `ImageKnife`（三方库） | 圆形裁剪、渐变占位、缓存策略 |

### 手动缓存示例

```typescript
import { http } from '@kit.NetworkKit'
import { fileIo } from '@kit.CoreFileKit'

const CACHE_DIR = getContext().cacheDir + '/images/'

async function getCachedImage(url: string): Promise<string> {
  const fileName = CACHE_DIR + url.split('/').pop()
  // 命中缓存直接返回
  if (fileIo.accessSync(fileName)) {
    return fileName
  }
  // 下载并缓存
  const resp = await http.createHttp().request(url, {
    expectDataType: http.HttpDataType.ARRAY_BUFFER
  })
  const file = fileIo.openSync(fileName, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY)
  fileIo.writeSync(file.fd, resp.result as ArrayBuffer)
  fileIo.closeSync(file.fd)
  return fileName
}
```

### 性能要点

1. **列表场景必须用 LazyForEach**：避免一次性创建所有 Image 组件
2. **设置合理的 `cachedCount`**：默认缓存当前屏 ± 1 屏，大图可减少
3. **使用 `alt` 占位图**：避免加载期间布局跳动
4. **禁用不必要的动画**：大量图片加载时关闭 `transition` 减少 GPU 压力

---


## See Also

- [network-data.md](./network-data.md) — ArkData 数据持久化
- [image-kit.md](./image-kit.md) — Image Kit 图片处理
- [common-patterns.md](../starter-kit/snippets/common-patterns.md) — HttpUtil 等代码模式
