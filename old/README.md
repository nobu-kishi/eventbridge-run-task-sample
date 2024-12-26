## 概要

- EventBridgeからECSタスクを実行するTerraform

## アーキテクチャ図

TODO:

## ディレクトリ構成


```
.
├── envs
│   └── dev
│       ├── data.tf
│       ├── main.tf
│       ├── terraform.tf
│       ├── terraform.tfvars
│       └── variable.tf
└── modules
    ├── common
    │   └── ecs-task
    │       ├── data.tf
    │       ├── local.tf
    │       ├── main.tf
    │       ├── output.tf
    │       └── variable.tf
    ├── ecs_task_for_s3
    │   ├── local.tf
    │   ├── main.tf
    │   └── variable.tf
    └── ecs_task_for_scheduled
        ├── local.tf
        ├── main.tf
        └── variable.tf
```

## 設定例

### 【例】rule_config　

| **変数名**    | **フィールド名**       | **詳細**                                                       | **例**              |
| ------------- | ---------------------- | -------------------------------------------------------------- | ------------------- |
| `rule_config` |                        | -                                                              | -                   |
|               | `s3_object_key_filter` | S3バケット内のオブジェクトキーをフィルタリングする条件リスト。 | -                   |
|               | └─`prefix`             | フィルタ対象のS3オブジェクトキーの接頭辞。                     | `"aaa/"`, `"bbb/"`  |
|               | `command_args`         | ECSタスク内で実行されるコマンドと引数のリスト。                | `["echo", "hello"]` |
|               |                        |                                                                |                     |

#### 【注釈】`rule_config[<配列キー>]`
  - `rule_config[<配列キー>]`は、**ルール名のSuffix**として機能します。
  - <配列キー>は、一意な名称にしてください（例: `rule1`, `rule2`）。
  - この識別子に基づいて、複数のルールを個別に定義できます。


例
```
rule_config = {
  rule1 = {
    s3_object_key_filter = [
      prefix = <S3のPrefix>
    ]
    command_args = [ <ECSタスクで実行するコマンド配列> ]
  }
  rule2 = {
    s3_object_key_filter = [
      prefix = <S3のPrefix>
    ]
    command_args = [ <ECSタスクで実行するコマンド配列> ]
  }
}
```

### 【例】schedule_config

## 参考

schedule_expression
https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/schedule-types.html

command_args
https://docs.docker.jp/engine/reference/builder.html#cmd

