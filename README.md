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

## 【前提】tfvars

TODO:

---

## rule_configの設定説明

### 概要

| **変数名**    | **フィールド名**       | **詳細**                                                                                                  | **例**                                   |
| ------------- | ---------------------- | --------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `rule_config` |                        | 複数のルールを管理するための変数。                                                                        | -                                        |
|               | `s3_object_key_filter` | S3バケット内のオブジェクトキーをフィルタリングする条件リスト。                                            | -                                        |
|               | └─`prefix`             | フィルタ対象のS3オブジェクトキーの接頭辞。                                                                | `"images/"`, `"docs/"`                   |
|               | `command_args`         | ECSタスク内で実行されるコマンドと引数のリスト。（詳細は[command_argsの設定方法](#command_argsの設定方法) | `["echo", "processing images and docs"]` |


#### 注釈

- `rule_config[<配列キー>]`
  - `<配列キー>`は、**ルール名のSuffix**として機能します。
  - ルールを識別するための一意な名称を設定してください（例: `rule1`, `rule2`）。
  - 複数のルールを定義する場合は、`<配列キー>`を追加してください。

### 設定例

以下に`rule_config`の具体例を示す。

```hcl
rule_config = {
  rule1 = {
    s3_object_key_filter = [
      { prefix = "images/" },  # images/ で始まるオブジェクトを対象
      { prefix = "docs/" }  # docs/ で始まるオブジェクトを対象
    ]
    command_args = [
      "echo", "processing images and docs"  # タスクで実行されるコマンド
    ]
  }
  rule2 = {
    s3_object_key_filter = [
      { prefix = "logs/" }  # logs/ で始まるオブジェクトを対象
    ]
    command_args = [
      "cat", "/tmp/logs"  # タスクで実行されるコマンド
    ]
  }
}
```

---

## schedule_configの設定説明

### 概要

| **変数名**        | **フィールド名**      | **詳細**                                                                                                   | **例**                                           |
| ----------------- | --------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `schedule_config` |                       | 複数のスケジュールを管理するための変数。                                                                   | -                                                |
|                   | `schedule_expression` | スケジュールを指定する式。cron式またはレート式が使用可能。                                                 | `"cron(0 0 ? * MON-FRI *)"`, `"rate(5 minutes)"` |
|                   | `command_args`        | ECSタスク内で実行されるコマンドと引数のリスト。（詳細は[command_argsの設定方法](#command_argsの設定方法)） | `["echo", "hello"]`                              |

#### 注釈

- `schedule_config[<配列キー>]`
  - `<配列キー>`は、**スケジュール名のSuffix**として機能します。
  - スケジュールを識別するための一意な名称を設定してください（例: `schedule1`, `schedule2`）。
  - **`schedule_expression`** では以下の形式が使用可能：
    - **cron式**: cron形式でスケジュールを指定（例: `cron(0 0 ? * MON-FRI *)`）。
    - **レート式**: 定期的に繰り返す処理を指定（例: `rate(5 minutes)`）。
  - 複数のスケジュールを定義する場合は、`<配列キー>`を追加してください。

### スケジュール式の形式

1. **cron式**

- 特定の時間や曜日に基づいたスケジュールを指定する。
- 例: 
  - `"cron(0 0 ? * MON-FRI *)"`: 平日（Monday～Friday）の毎日0時に実行。
  - `"cron(15 10 ? * * *)"`: 毎日10時15分に実行。
- 詳細は[AWS Cron式ガイド](https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/schedule-types.html#cron-based)を参照。

2. **レート式**

- 一定間隔で繰り返すスケジュールを指定する。
- 例:
  - `"rate(5 minutes)"`: 5分ごとに実行。
  - `"rate(1 day)"`: 毎日実行。
- 詳細は[AWS レート式ガイド](https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/schedule-types.html#rate-based)を参照。

### 設定例

以下に`schedule_config`の具体例を示す。

```hcl
schedule_config = {
  schedule1 = {
    schedule_expression = "cron(0 0 ? * MON-FRI *)"  # 平日0時に実行されるスケジュール
    command_args = [
      "echo", "hello"  # タスクで実行されるコマンド
    ]
  }
  schedule2 = {
    schedule_expression = "rate(5 minutes)"  # 5分ごとに実行されるスケジュール
    command_args = [
      "echo", "repeating task"  # タスクで実行されるコマンド
    ]
  }
}
```

---

## command_argsの設定方法

### 概要

- `command_args`は、ECSタスク内で実行されるコマンドとその引数をリスト形式で指定する。
  - Dockerfileの`CMD`に相当する。（詳細は、[Docker公式 CMD](https://docs.docker.jp/engine/reference/builder.html#cmd)）を参照）
- ECSタスクを実行する際、command_argsで指定した値はコンテナのエントリーポイントで定義されたコマンドに渡される。
  - エントリーポイントが設定されていない場合、command_args自体が実行される。

### 設定例

以下に、`command_args`の設定例を示す。

#### 基本例

```sh
command_args = ["echo", "hello"]
```

```sh
command_args = ["/bin/bash", "/sh/hoge.sh"]
```

#### 応用例

```sh
command_args = ["/bin/bash", "-c", "echo 実行結果: $(/sh/hoge.sh)"]
```