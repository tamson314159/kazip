alias Kazip.Articles.Article
alias Kazip.Repo
alias Kazip.Accounts.Account

user1 =
  %Account{
    email: "user01@sample.com",
    hashed_password: Pbkdf2.hash_pwd_salt("user01999")
  }

user2 =
  %Account{
    email: "user02@sample.com",
    hashed_password: Pbkdf2.hash_pwd_salt("user02999")
  }

[user1, user2] =
  [user1, user2]
  |> Enum.map(&Repo.insert!/1)

article1 =
  %Article{
    title: "時間管理のライフハック",
    body: """
    ## 目標を明確にする

    * 短期的な目標と長期的な目標を設定しましょう。
    * 目標は、自分の価値観や興味に合ったものである必要があります。
    * 目標は具体的で、測定可能で、達成可能で、関連性があり、期限を定めてください。
    * 目標は、自分にとって重要なものである必要があります。
    * 目標は、自分にとってチャレンジングなものである必要があります。

    ## タスクを分解する

    大きなタスクを分解することで、より管理しやすくなります。また、タスクを分解することで、達成感を得ることができ、モチベーションの維持にもつながります。

    ## 優先順位をつける

    すべてのタスクに同じように時間をかけるのは、効率的ではありません。重要なタスクに優先順位をつけることで、時間の無駄を防ぐことができます。

    ## 休憩をとる

    長時間、集中していると、ミスや疲労が蓄積されます。適度に休憩をとることで、集中力を維持し、効率的に作業を行うことができます。

    ## ツールを活用する

    時間管理を効率的に行うために、ツールを活用することも有効です。タスク管理ツールや時間管理アプリなど、さまざまなツールが無料で提供されています。

    時間管理は、一朝一夕に身につくものではありません。しかし、今回ご紹介したライフハックを参考にすることで、時間管理スキルを向上させることができます。ぜひ、参考にしてみてください。
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user1.id
  }

article2 =
  %Article{
    title: "家事の効率的なこなし方：時短テクニックとアイデア",
    body: """

    家事は誰もが避けて通れないものですが、効率的にこなすことで時間を節約し、ストレスを軽減することができます。ここでは、家事を効率的にこなすための時短テクニックとアイデアをご紹介します。

    ## 1. タスクの優先順位を設定する

    家事は多岐にわたるため、まずは優先順位を設定しましょう。毎日必要なタスクと週に数回行うタスクを明確に区別し、計画的に取り組むことで効率が向上します。

    ## 2. ルーティンを作成する

    家事を無理なくこなすためには、ルーティンを作成することが大切です。特定の曜日に特定のタスクを割り当てることで、やるべきことを忘れずに効率的に進めることができます。

    ## 3. 片付けの習慣を身につける

    物を使用したらすぐに元の場所に戻す習慣を身につけることで、家が整然と保たれます。日々の小さな片付けが、大掃除を減らし効率的な家事をサポートします。

    ## 4. 使い捨て品を活用する

    キッチンやトイレなどで使い捨てのアイテムを活用することで、洗い物や掃除の手間を軽減できます。ただし、環境に配慮しながら選ぶことを忘れずに。

    ## 5. 調理を効率化する

    料理の時間を短縮するために、下ごしらえを一度にまとめて行ったり、週に一度大量に調理して冷凍しておくことを検討しましょう。また、簡単なレシピや調理器具を上手に活用することもポイントです。

    ## 6. チームワークを活用する

    家事は一人で行う必要はありません。家族やルームメイトとタスクを分担することで、負担を軽減し効率的な家事を実現できます。

    ## まとめ

    家事を効率的にこなすためには、計画的な取り組みと工夫が重要です。これらの時短テクニックとアイデアを取り入れて、家事のストレスを軽減し、充実した生活を送りましょう。
    """,
    submit_date: Date.utc_today(),
    status: 0,
    account_id: user1.id
  }

articles = [
  %Article{
    title: "user02の下書き記事",
    body: "下書き記事です。",
    submit_date: Date.utc_today(),
    status: 0,
    account_id: user2.id
  },
  %Article{
    title: "user02の公開記事",
    body: "公開記事です。",
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user2.id
  },
  %Article{
    title: "user02の限定記事",
    body: "限定記事です。",
    submit_date: Date.utc_today(),
    status: 2,
    account_id: user2.id
  }
]

[article1, article2] ++ articles |> Enum.map(&Repo.insert!/1)
