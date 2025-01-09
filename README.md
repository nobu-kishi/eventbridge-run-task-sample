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

## rule_listの設定

- 複数のルールを管理するための変数。
- リスト要素を追加することで、複数ルールを定義する。

### 設定項目

| **項目名**             | **詳細**                                                                                                                                                       |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `identifier`           | ルール名に使用する識別子。EventBridgeの制約上、ルール名は一意な名称を付与する必要がある。                                                                      |
| `s3_object_key_filter` | S3にファイルがアップロードされた際、特定のディレクトリやファイル形式に対してイベントを起動する条件を指定。<br>`prefix`,`suffix`,`wildcard`を使用して指定する。 |
| `command_args`         | ECSタスク内で実行されるコマンドと引数のリスト。（詳細は[command_argsの設定方法](#command_argsの設定方法)）                                                     |

#### 補足

- `s3_object_key_filter`は、EventBrridgeルールを設定するための**イベントパターン**の一部です。
- イベントパターンで使用できる演算子の詳細は、AWS公式ドキュメントをご参照ください。

https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-pattern-operators.html

### 設定例

以下に`rule_list`の具体例を示す。

```hcl
rule_list = [
  {
    identifier = "rule1"
    s3_object_key_filter = [
      { prefix = "images/" },  # images/ で始まるオブジェクトを対象
      { prefix = "docs/" }  # docs/ で始まるオブジェクトを対象
    ]
    command_args = [ "echo", "hello rule1" ]  # タスクで実行されるコマンド
  },
  {
    identifier = "rule2"
    s3_object_key_filter = [
      { prefix = "logs/" }  # logs/ で始まるオブジェクトを対象
    ]
    command_args = [ "echo", "hello rule2" ]  # タスクで実行されるコマンド
  }
]
```

---

## schedule_listの設定

- 複数のスケジュールを管理するための変数。

### 設定項目

| **項目名**            | **詳細**                                                                                                   |
| --------------------- | ---------------------------------------------------------------------------------------------------------- |
| `identifier`          | スケジュール名に使用する識別子。EventBridgeの制約上、スケジュール名は一意な名称を付与する必要がある。      |
| `schedule_expression` | スケジュールを指定する式。cron式またはレート式が使用可能。                                                 |
| `command_args`        | ECSタスク内で実行されるコマンドと引数のリスト。（詳細は[command_argsの設定方法](#command_argsの設定方法)） |

#### 補足

1. **cron式**
     - 特定の時間や曜日に基づいたスケジュールを指定する。
     - [AWS公式 Cron式](https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/schedule-types.html#cron-based)
2. **レート式**
     - 一定間隔で繰り返すスケジュールを指定する。
     - [AWS公式 レート式](https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/schedule-types.html#rate-based)

### 設定例

以下に`schedule_list`の具体例を示す。

```hcl
schedule_list = [
  {
    identifier          = "schedule1"
    schedule_expression = "cron(0 0 ? * MON-FRI *)"  # 平日0時に実行されるスケジュール
     command_args = [ "echo", "hello schedule1" ]  # タスクで実行されるコマンド
  },
  {
    identifier          = "schedule2"
    schedule_expression = "cron(0 0 ? * MON *)"  # 5分ごとに実行されるスケジュール
    command_args = [ "echo", "hello schedule2" ]  # タスクで実行されるコマンド
  }
]
```

---

## command_argsの設定

### 概要

- `command_args`の設定は、Dockerfileの`CMD`に相当する。
- 詳細は、[Docker公式 CMD](https://docs.docker.jp/engine/reference/builder.html#cmd)を参照。
- コンテナ内の環境変数を利用したい場合、[応用例](#応用例)形式で設定すること。

### 設定例

以下に、`command_args`の設定例を示す。

#### 基本例

- Dockerfileの**シェル形式**に相当する設定方法

```sh
command_args = ["echo", "hello"]
```

```sh
command_args = ["/bin/bash", "/sh/hoge.sh"]
```

#### 応用例

- Dockerfileの**exec形式**に相当する設定方法

```sh
command_args = ["/bin/bash", "-c", "echo 実行結果: $(/sh/hoge.sh $HOME)"]
```