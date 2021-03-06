defmodule Aliyun.Oss.Object do
  @moduledoc """
  Object 相关操作
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]

  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Request, Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()


  @doc """
  HeadObject只返回某个Object的meta信息，不返回文件内容。

  ## Examples

      iex> Aliyun.Oss.Object.head_object("some-bucket", "some-object")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Wed, 05 Dec 2018 05:50:02 GMT"},
          {"Content-Type", "application/octet-stream"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"Accept-Ranges", "bytes"},
          {"ETag", "\"D4100000000000000000000000000000\""},
          {"Last-Modified", "Mon, 15 Oct 2018 01:38:47 GMT"},
          {"x-oss-object-type", "Normal"},
          {"x-oss-hash-crc64ecma", "0"},
          {"x-oss-storage-class", "IA"},
          {"Content-MD5", "1B2M2Y8AsgTpgAmY7PhCfg=="},
          {"x-oss-server-time", "19"}
        ]
      }}
      iex> Aliyun.Oss.Object.head_object("some-bucket", "unknown-object")
      {:error, %Aliyun.Oss.Client.Error{status_code: 404, body: "", parsed_details: nil}}
  """
  @spec head_object(String.t(), String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def head_object(bucket, object, headers \\ %{}) do
    Service.head(bucket, object, headers: headers)
  end


  @doc """
  GetObject 用于获取某个 Object

  ## Examples

      iex> Aliyun.Oss.Object.get_object("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }


  亦可用于获取某个 Object 指定 SubResource(GetObjectXXX)。

  ## Examples

      iex> Aliyun.Oss.Object.get_object("some-bucket", "some-object", %{}, %{"acl" => nil})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "AccessControlPolicy" => %{
              "AccessControlList" => %{"Grant" => "default"},
              "Owner" => %{
                "DisplayName" => "1111111111111111",
                "ID" => "1111111111111111"
              }
            }
          },
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }
  """
  @spec get_object(String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_object(bucket, object, headers \\ %{}, sub_resources \\ %{}) do
    Service.get(bucket, object, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  GetObjectACL 用来获取某个Bucket下的某个Object的访问权限。

  ## Examples

      iex> Aliyun.Oss.Object.get_object_acl("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "AccessControlPolicy" => %{
              "AccessControlList" => %{"Grant" => "default"},
              "Owner" => %{
                "DisplayName" => "1111111111111111",
                "ID" => "1111111111111111"
              }
            }
          },
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }
  """
  @spec get_object_acl(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_object_acl(bucket, object) do
    get_object(bucket, object, %{}, %{"acl" => nil})
  end


  @doc """
  GetSymlink接口用于获取符号链接。此操作需要您对该符号链接有读权限。

  ## Examples

      iex> Aliyun.Oss.Object.get_symlink("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:26:07 GMT"},
            {"Content-Type", "text/plain"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C7000000000000000000000"},
            {"Last-Modified", "Fri, 01 Mar 2019 06:23:13 GMT"},
            {"ETag", "\"6751C000000000000000000000000000\""},
            {"x-oss-symlink-target", "test.txt"},
            {"x-oss-server-time", "1"}
          ]
        }
      }
  """
  @spec get_symlink(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_symlink(bucket, object) do
    get_object(bucket, object, %{}, %{"symlink" => nil})
  end


  @doc """
  通过GetObjectTagging接口获取对象的标签信息。

  ## Examples

      iex> Aliyun.Oss.Object.get_object_tagging("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"Tagging" => %{"TagSet" => [%{"Key" => "key", "Value" => "value"}]}},
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:26:07 GMT"},
            {"Content-Type", "text/plain"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C7000000000000000000000"},
            {"Last-Modified", "Fri, 01 Mar 2019 06:23:13 GMT"},
            {"ETag", "\"6751C000000000000000000000000000\""},
            {"x-oss-symlink-target", "test.txt"},
            {"x-oss-server-time", "1"}
          ]
        }
      }
  """
  @spec get_object_tagging(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_object_tagging(bucket, object) do
    get_object(bucket, object, %{}, %{"tagging" => nil})
  end

  @doc """
  生成包含签名的 Object URL

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.signed_url("some-bucket", "some-object", expires, "GET", %{"Content-Type" -> ""})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"
      iex> Aliyun.Oss.Object.signed_url("some-bucket", "some-object", expires, "PUT", %{"Content-Type" -> "text/plain"})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"
  """
  @spec signed_url(String.t(), String.t(), integer(), String.t(), map(), map()) :: String.t()
  def signed_url(bucket, object, expires, method, headers, sub_resources \\ %{}) do
    %{
      verb: method,
      host: "#{bucket}.#{endpoint()}",
      path: "/#{object}",
      resource: "/#{bucket}/#{object}",
      sub_resources: sub_resources,
      headers: headers,
      expires: expires
    }
    |> Request.build()
    |> Request.signed_query_url()
  end


  @doc """
  生成包含签名的可用于直接访问的 Object URL

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.object_url("some-bucket", "some-object", expires)
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc56s936**9l&Expires=1141889120&Signature=vjbyPxybdZaNmGa%2ByT272YEAiv4%3D"
  """
  @spec object_url(String.t(), String.t(), integer()) :: String.t()
  def object_url(bucket, object, expires) do
    signed_url(bucket, object, expires, "GET", %{"Content-Type" => ""})
  end

  @doc """
  PutObject接口用于上传文件（Object）。
   - 添加的文件大小不得超过5 GB。
   - 如果已经存在同名的Object，并且有访问权限，则新添加的文件将覆盖原来的文件，并成功返回200 OK。

  ## Examples

      iex> Aliyun.Oss.Object.put_object("some-bucket", "some-object", "CONTENT")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec put_object(String.t(), String.t(), String.t(), map(), map()) :: {:error, error()} | {:ok, Response.t()}
  def put_object(bucket, object, body, headers \\ %{}, sub_resources \\ %{}) do
    Service.put(bucket, object, body, headers: headers, sub_resources: sub_resources)
  end


  @doc """
  PutSymlink接口用于为OSS的TargetObject创建软链接，您可以通过该软链接访问TargetObject。

  ## Examples

      iex> Aliyun.Oss.Object.put_symlink("some-bucket", "symlink", "target-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec put_symlink(String.t(), String.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put_symlink(bucket, symlink, target_object, storage_class \\ "Standard") do
    put_object(bucket, symlink, "", %{"x-oss-symlink-target" => target_object, "x-oss-storage-class" => storage_class}, %{"symlink" => nil})
  end

  @doc """
  PutObjectACL接口用于修改Object的访问权限。

  ## Examples

      iex> Aliyun.Oss.Object.put_object_acl("some-bucket", "some-object", "private")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec put_object_acl(String.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put_object_acl(bucket, object, acl) do
    put_object(bucket, object, "", %{"x-oss-object-acl" => acl}, %{"acl" => nil})
  end


  @doc """
  CopyObject接口用于在存储空间（Bucket ） 内或同地域的Bucket之间拷贝文件（Object）。

  ## Examples

      iex> Aliyun.Oss.Object.copy_object({"source-bucket", "source-object"}, {"target-bucket", "target-object"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CopyObjectResult" => %{
              "ETag" => "\"D2D50000000000000000000000000000\"",
              "LastModified" => "2019-02-27T09:21:13.000Z"
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec copy_object({String.t(), String.t()}, {String.t(), String.t()}, map()) :: {:error, error()} | {:ok, Response.t()}
  def copy_object({source_bucket, source_object}, {target_bucket, target_object}, headers \\ %{}) do
    headers = Map.put(headers, "x-oss-copy-source", "/#{source_bucket}/#{source_object}")
    put_object(target_bucket, target_object, "", headers)
  end


  @doc """
  通过PutObjectTagging接口设置或更新对象的标签（Object Tagging）。

  ## Examples

      iex> Aliyun.Oss.Object.put_object_tagging("some-bucket", "some-object", [{"key1", "value1"}, {:key2, "value2}])
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <Tagging>
    <TagSet>
      <%= for {key, value} <- tags do %>
        <Tag>
          <Key><%= key %></Key>
          <Value><%= value %></Value>
        </Tag>
      <% end %>
    </TagSet>
  </Tagging>
  """
  @spec put_object_tagging(String.t(), String.t(), [{any(), any()}, ...]) :: {:error, error()} | {:ok, Response.t()}
  def put_object_tagging(bucket, object, tags) do
    xml_body = EEx.eval_string(@body_tmpl, [tags: tags])
    put_object(bucket, object, xml_body, %{}, %{"tagging" => nil})
  end


  @doc """
  AppendObject接口用于以追加写的方式上传Object。

  ## Examples

      iex> Aliyun.Oss.Object.append_object("some-bucket", "some-object", "CONTENT", 0)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 05:57:23 GMT"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C0000000000000000000000"},
            {"ETag", "\"B38D0000000000000000000000000000\""},
            {"x-oss-next-append-position", "10"},
            {"x-oss-hash-crc64ecma", "8000000000000000000"},
            {"x-oss-server-time", "17"}
          ]
        }
      }
  """
  @spec append_object(String.t(), String.t(), String.t(), integer(), map()) :: {:error, error()} | {:ok, Response.t()}
  def append_object(bucket, object, body, position, headers \\ %{}) do
    post_object(bucket, object, body, headers, %{"append" => nil, "position" => position})
  end

  @doc """
  RestoreObject接口用于解冻归档类型（Archive）的文件（Object）。

  ## Examples

      iex> Aliyun.Oss.Object.restore_object("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:38:21 GMT"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C7000000000000000000000"},
            {"x-oss-server-time", "7"}
          ]
        }
      }
  """
  @spec restore_object(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def restore_object(bucket, object) do
    post_object(bucket, object, "", %{}, %{"restore" => nil})
  end


  @doc """
  DeleteObject用于删除某个文件（Object）。

  ## Examples

      iex> Aliyun.Oss.Object.delete_object("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec delete_object(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def delete_object(bucket, object, sub_resources \\ %{}) do
    Service.delete(bucket, object, sub_resources: sub_resources)
  end

  @doc """
  DeleteMultipleObjects接口用于删除同一个存储空间（Bucket）中的多个文件（Object）。

  ## Options

    - `:encoding_type` - Accept value: `:url`
    - `:quiet` - Set `true` to enable the quiet mode, default is `false`

  ## Examples

      iex> Aliyun.Oss.Object.delete_multiple_objects("some-bucket", ["object1", "object2"])
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "DeleteResult" => %{
              "Deleted" => [%{"key" => "object1"}, %{"key" => "object2"}]
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <Delete>
    <Quiet><%= quiet %></Quiet>
    <%= for object <- objects do %>
      <Object><Key><%= object %></Key></Object>
    <% end %>
  </Delete>
  """
  @spec delete_multiple_objects(String.t(), [String.t()], [encoding_type: :url, quiet: boolean()]) :: {:error, error()} | {:ok, Response.t()}
  def delete_multiple_objects(bucket, objects, options \\ []) do
    headers = case options[:encoding_type] do
      :url -> %{"encoding-type" => "url"}
      _ -> %{}
    end

    quiet = Keyword.get(options, :quiet, false)
    body = EEx.eval_string(@body_tmpl, [quiet: quiet, objects: objects])

    Service.post(bucket, nil, body, headers: headers, sub_resources: %{"delete" => nil})
  end


  @doc """
  通过DeleteObjectTagging删除指定对象的标签。

  ## Examples

      iex> Aliyun.Oss.Object.delete_object_tagging("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec delete_object_tagging(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def delete_object_tagging(bucket, object) do
    delete_object(bucket, object, %{"tagging" => nil})
  end


  @doc """
  签名 Post Policy 返回签名字符串及编码后的 policy

  ## Examples

      iex> policy = %{
      ...>  "conditions" => [
      ...>    ["content-length-range", 0, 10485760],
      ...>    %{"bucket" => "ahaha"},
      ...>    %{"A" => "a"},
      ...>    %{"key" => "ABC"}
      ...>  ],
      ...>  "expiration" => "2013-12-01T12:00:00Z"
      ...>}
      iex> Aliyun.Oss.Object.sign_post_policy(policy)
      %{
        policy: "eyJjb25kaXRpb25zIjpbWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsMCwxMDQ4NTc2MF0seyJidWNrZXQiOiJhaGFoYSJ9LHsiQSI6ImEifSx7ImtleSI6IkFCQyJ9XSwiZXhwaXJhdGlvbiI6IjIwMTMtMTItMDFUMTI6MDA6MDBaIn0=",
        signature: "W835KpLsL6k1/oo28RcsEflB6hw="
      }
  """
  @spec sign_post_policy(map(), String.t()) :: %{policy: String.t(), signature: String.t()}
  def sign_post_policy(%{} = policy, key \\ Aliyun.Oss.Config.access_key_secret()) do
    encoded_policy = policy |> Jason.encode!() |> Base.encode64()

    %{
      policy: encoded_policy,
      signature: Aliyun.Util.Sign.sign(encoded_policy, key)
    }
  end


  defp post_object(bucket, object, body, headers, sub_resources) do
    Service.post(bucket, object, body, headers: headers, sub_resources: sub_resources)
  end
end
