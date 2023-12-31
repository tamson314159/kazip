alias Kazip.Articles.Article
alias Kazip.Repo
alias Kazip.Accounts.Account
alias Kazip.Articles.Category

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

[c1, c2, c3, c4, _c5, _c6, _c7, _c8, c9] =
  ["家事全般", "掃除", "洗濯", "料理", "片付け", "育児", "園芸", "買い物", "その他"]
  |> Enum.map(&%Category{name: &1})
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
    account_id: user1.id,
    category_id: c1.id
  }

article2 =
  %Article{
    title: "家事の効率的なこなし方：時短テクニックとアイデア",
    body: """

    家事は誰もが避けて通れないものですが、効率的にこなすことで時間を節約し、ストレスを軽減することができます。ここでは、家事を効率的にこなすための時短テクニックとアイデアをご紹介します。
    家事は誰もが避けて通れないものですが、効率的にこなすことで時間を節約し、ストレスを軽減することができます。ここでは、家事を効率的にこなすための時短テクニックとアイデアをご紹介します。

    ## 1. タスクの優先順位を設定する
    ## 1. タスクの優先順位を設定する

    家事は多岐にわたるため、まずは優先順位を設定しましょう。毎日必要なタスクと週に数回行うタスクを明確に区別し、計画的に取り組むことで効率が向上します。
    家事は多岐にわたるため、まずは優先順位を設定しましょう。毎日必要なタスクと週に数回行うタスクを明確に区別し、計画的に取り組むことで効率が向上します。

    ## 2. ルーティンを作成する
    ## 2. ルーティンを作成する

    家事を無理なくこなすためには、ルーティンを作成することが大切です。特定の曜日に特定のタスクを割り当てることで、やるべきことを忘れずに効率的に進めることができます。
    家事を無理なくこなすためには、ルーティンを作成することが大切です。特定の曜日に特定のタスクを割り当てることで、やるべきことを忘れずに効率的に進めることができます。

    ## 3. 片付けの習慣を身につける
    ## 3. 片付けの習慣を身につける

    物を使用したらすぐに元の場所に戻す習慣を身につけることで、家が整然と保たれます。日々の小さな片付けが、大掃除を減らし効率的な家事をサポートします。
    物を使用したらすぐに元の場所に戻す習慣を身につけることで、家が整然と保たれます。日々の小さな片付けが、大掃除を減らし効率的な家事をサポートします。

    ## 4. 使い捨て品を活用する
    ## 4. 使い捨て品を活用する

    キッチンやトイレなどで使い捨てのアイテムを活用することで、洗い物や掃除の手間を軽減できます。ただし、環境に配慮しながら選ぶことを忘れずに。
    キッチンやトイレなどで使い捨てのアイテムを活用することで、洗い物や掃除の手間を軽減できます。ただし、環境に配慮しながら選ぶことを忘れずに。

    ## 5. 調理を効率化する
    ## 5. 調理を効率化する

    料理の時間を短縮するために、下ごしらえを一度にまとめて行ったり、週に一度大量に調理して冷凍しておくことを検討しましょう。また、簡単なレシピや調理器具を上手に活用することもポイントです。
    料理の時間を短縮するために、下ごしらえを一度にまとめて行ったり、週に一度大量に調理して冷凍しておくことを検討しましょう。また、簡単なレシピや調理器具を上手に活用することもポイントです。

    ## 6. チームワークを活用する
    ## 6. チームワークを活用する

    家事は一人で行う必要はありません。家族やルームメイトとタスクを分担することで、負担を軽減し効率的な家事を実現できます。
    家事は一人で行う必要はありません。家族やルームメイトとタスクを分担することで、負担を軽減し効率的な家事を実現できます。

    ## まとめ
    ## まとめ

    家事を効率的にこなすためには、計画的な取り組みと工夫が重要です。これらの時短テクニックとアイデアを取り入れて、家事のストレスを軽減し、充実した生活を送りましょう。
    """,
    submit_date: Date.utc_today(),
    status: 0,
    account_id: user1.id,
    category_id: c1.id
  }

article3 =
  %Article{
    title: "掃除のライフハック: 効率的で楽しい家事タイム",
    body: """
    家事の中でも特に時間とエネルギーが必要な掃除を、効率的かつ楽しいものにするためのライフハックを紹介します。忙しい日々でも、これらの方法を取り入れて、家を清潔で快適な空間に保ちましょう！

    ## 1. ゾーンごとのアプローチ

    - **部屋ごとに計画**: 各部屋を掃除する際、一度に複数の部屋を行き来するのではなく、1つの部屋に集中して掃除を行うことで、効果的に進められます。

    ## 2. タイマーを活用した5分間集中

    - **5分間タイマー**: タスクを5分間だけ集中して行うことで、気が重くならずに取り組めます。例えば、机の上の整理や棚のほこり取りなどに効果的です。

    ## 3. 片付けルーティンを確立

    - **毎日の習慣化**: 毎日少しずつ掃除をする習慣を身につけることで、大掃除の負担を軽減できます。床拭きや洗濯機のフィルター清掃など、日常的なタスクを設定しましょう。

    ## 4. マルチタスキングの魔法

    - **掃除中に学ぶ**: オーディオブックやポッドキャストを聴きながら掃除をすることで、同時に学びを得ることができます。

    ## 5. クリーンアップを楽しむ

    - **音楽でモチベーションアップ**: お気に入りの音楽を流しながら掃除を行うと、作業が楽しく感じられることでしょう。

    ## 6. 整理整頓のコツ

    - **物の定位置**: 使用後に物を元の場所に戻す習慣を身につけることで、散らかりを防ぎます。特にキッチンやリビングで効果的です。

    ## 7. グループで楽しむ掃除

    - **家族チーム**: 家族やルームメイトと一緒に掃除を行うことで、作業が楽しくなり、助け合って効率的に進められます。

    これらの掃除のライフハックを実践して、家事の時間を効果的に活用しましょう。清潔な環境で過ごすことは、心地よい生活をもたらします！

    ---
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user1.id,
    category_id: c2.id
  }

articles = [
  %Article{
    title: "user02の下書き記事",
    body: "下書き記事です。",
    submit_date: Date.utc_today(),
    status: 0,
    account_id: user2.id,
    category_id: c9.id
  },
  %Article{
    title: "家事マスターになるための5つのステップ",
    body: "",
    submit_date: Date.utc_today(),
    status: 0,
    account_id: user1.id,
    category_id: c9.id
  },
  %Article{
    title: "user02の限定記事",
    body: "限定記事です。",
    submit_date: Date.utc_today(),
    status: 2,
    account_id: user2.id,
    category_id: c9.id
  },
  %Article{
    title: "家事のライフハック: 効率的で楽しい家事の秘訣",
    body: """
    家事は日常生活の一部ですが、時には面倒くさい作業に感じることもあります。しかし、ちょっとした工夫やライフハックを取り入れることで、家事をより効率的で楽しいものにすることができます。この記事では、家事をスムーズにこなすためのいくつかのヒントをご紹介します。

    ## 1. タイマーを活用する

    家事は時間を効果的に使うことが重要です。タイマーを活用して、作業を時間制限内で完了するようにしましょう。例えば、洗濯機をセットしている間に、他の家事を進めることができます。これにより、待ち時間を有効活用できます。

    ## 2. 家事を楽しむプレイリストを作成する

    音楽は家事を楽しくする一つの方法です。お気に入りのプレイリストを作成し、家事の合間に音楽を楽しんでください。音楽を聴きながら家事をすることで、作業がより軽快に感じられます。

    ## 3. 家族と協力する

    家事を一人で抱え込む必要はありません。家族と協力し、タスクを分担しましょう。子供たちにも家事の一部を任せることで、負担が軽減されます。チームワークを大切にしましょう。

    ## 4. 家事用具を効果的に整理する

    キッチンや洗濯室などの家事用具を効果的に整理することで、作業がスムーズに進みます。使いやすい収納システムを導入し、必要なものがすぐに手に入るようにしましょう。

    ## 5. 定期的なクリーンアップ

    定期的なクリーンアップを怠らないようにしましょう。家事の途中で少しずつ片付ける習慣をつけることで、後で大掃除をする必要が減ります。

    家事は日常生活の一部ですが、工夫次第で効率的で楽しいものにすることができます。上記のヒントを参考にして、家事をストレスなくこなし、より充実した生活を送りましょう。
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user2.id,
    category_id: c1.id
  },
  %Article{
    title: "掃除のアドバイス: 効率的で徹底的なクリーニングの秘訣",
    body: """
    家を清潔に保つことは、健康的で快適な生活を送るために重要です。しかし、掃除が面倒くさい作業に感じることもあります。そこで、この記事では掃除を効率的で徹底的に行うためのアドバイスをご紹介します。

    ## 1. プランを立てる

    掃除を効果的に行うためには、計画を立てることが大切です。どの部屋から始めるか、どの順番でタスクを進めるかを考え、リストを作成しましょう。これにより、タスクが整理され、見通しが良くなります。

    ## 2. 必要な道具を用意する

    掃除のために必要な道具やクリーニング用具を事前に用意しましょう。これにより、掃除中に何度も道具を取りに行く手間が省けます。バケツ、モップ、ほうき、ぞうきんなどが揃っていることを確認しましょう。

    ## 3. 部屋ごとにセクションを分ける

    大きな部屋を一度に掃除しようとせず、部屋をセクションに分けましょう。例えば、リビングルームのソファーエリア、テレビエリア、ダイニングエリアなどを個別に掃除します。これにより、集中力を保ちやすくなります。

    ## 4. 一つのタスクに集中する

    掃除の際には、一つのタスクに集中しましょう。例えば、床掃除をしている間は床に集中し、他のことに気を取られないようにします。これにより、効率的にクリーニングができます。

    ## 5. 頻繁なメンテナンス

    掃除を効率的に行うためには、頻繁なメンテナンスが必要です。毎日少しずつ掃除を行い、汚れやほこりがたまらないようにしましょう。これにより、大掃除の頻度を減らすことができます。

    掃除は多くの人にとって面倒くさい作業かもしれませんが、上記のアドバイスを実践することで、効率的で徹底的なクリーニングを楽しむことができます。清潔な環境で生活することは、健康と幸福につながることを忘れずに、定期的な掃除を続けましょう
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user2.id,
    category_id: c2.id
  },
  %Article{
    title: "洗濯のプロに学ぶ！効率的な洗濯術",
    body: """
    洗濯は日常生活の一部ですが、面倒くささや手間を感じることもあります。しかし、洗濯を効率的に行う方法を知っていれば、その負担を軽減できます。この記事では、洗濯のプロから学んだ効率的な洗濯術を紹介します。

    ## 1. 洗濯物を仕分ける

    洗濯を始める前に、洗濯物を仕分けましょう。白いもの、カラフルなもの、デリケートなものなど、種類別に分けることで、色の混ざり合いやダメージを防げます。また、洗濯機の容量を最大限に活用しましょう。

    ## 2. 適切な洗剤と温度を選ぶ

    洗濯物の種類に合った洗剤と温度を選びましょう。汚れがひどい場合は高温で洗う必要がありますが、デリケートな衣類は低温設定を選びます。また、適切な洗剤の量を守りましょう。過剰な洗剤の使用は洗濯物に残ることがあります。

    ## 3. 洗濯機のメンテナンス

    洗濯機自体も定期的なメンテナンスが必要です。洗濯槽をきれいに保ち、フィルターや排水口を定期的に清掃しましょう。これにより、洗濯機の寿命を延ばし、洗濯物の品質を維持できます。

    ## 4. 乾燥機を賢く使う

    乾燥機を使用する場合は、適切な温度設定を選び、洗濯物を均等に配置しましょう。大きなアイテムは小さなものと一緒に乾燥させないようにし、エネルギーを節約しましょう。また、乾燥が完了したらできるだけ早く取り出し、シワを防ぎます。

    ## 5. 洗濯物をたたむ

    洗濯物を取り出したら、できるだけ早くたたみましょう。たたんだ洗濯物はしわになりにくく、整理がしやすくなります。また、家族の洗濯物を各自の部屋に戻すことで、整理が楽になります。

    洗濯は日常生活の必要な作業ですが、上記のアドバイスを実践することで、効率的に行い、洗濯物を品質良く保つことができます。清潔な衣類は快適な生活の一部ですので、洗濯のプロのヒントを参考にしてみてください。
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user1.id,
    category_id: c3.id
  },
  %Article{
    title: "卵焼きのレシピ",
    body: """
    ### 材料
    - 卵 2個
    - 醤油 小さじ1
    - 砂糖 小さじ1
    - 塩 ひとつまみ
    - サラダ油 適量

    ### 作り方
    1. 卵をボウルに割り、よく混ぜます。
    2. 小さじ1の醤油、小さじ1の砂糖、ひとつまみの塩を加え、よく混ぜます。
    3. フライパンにサラダ油を引き、中火にかけます。
    4. 卵液を流し入れ、広げます。半熟になったら巻きます。
    5. ご飯の上にのせて、お好みでネギや紅しょうがをトッピングして完成です。

    簡単な卵焼きのレシピです。ぜひお試しください！
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user1.id,
    category_id: c4.id
  },
  %Article{
    title: "豆腐と野菜のカレー",
    body: """
    ### 材料
    - 300g 豆腐（シルク豆腐がおすすめ）
    - 1個 にんじん（薄切り）
    - 1個 ジャガイモ（小さめのサイコロ切り）
    - 1個 タマネギ（みじん切り）
    - 2個 トマト（みじん切り）
    - 2カップ 野菜スープ
    - 2大さじ カレー粉
    - 1大さじ オリーブオイル
    - 塩と胡椒（お好みで調整）
    - ご飯（サービング用）

    ### 作り方
    1. フライパンにオリーブオイルを熱し、タマネギを炒めます。
    2. タマネギが透明になったら、カレー粉を加えてさらに炒め、香りを引き立てます。
    3. にんじん、ジャガイモ、トマトを加え、野菜が少し柔らかくなるまで炒めます。
    4. 豆腐を加え、野菜と調味料と組み合わせます。
    5. 野菜スープを注ぎ入れ、全体が均一に混ざるように煮ます。必要に応じて水を追加して濃度を調整します。
    6. 塩と胡椒で味を調整し、カレーが煮えたら火を止めます。
    7. ご飯の上にカレーを盛り付けて、お好みでハーブやナッツをトッピングします。

    これで、美味しい豆腐と野菜のカレーが完成です。健康的で満足感のある一品です。お楽しみください！
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user2.id,
    category_id: c4.id
  },
  %Article{
    title: "家事を効率化しよう！具体的な家事のコツ",
    body: """
    家事は日常生活の一部であり、効率的にこなすことで時間とストレスを節約できます。以下は、具体的な家事のコツです。

    ## 1. キッチンをスッキリ整理

    - 調理器具や調味料は使いやすい場所に配置しましょう。
    - 頻繁に使うアイテムはカウンタートップに置き、目につく場所に保管しましょう。
    - ゴミ箱は調理エリアに近く、使い終わったものはすぐに捨てましょう。

    ## 2. 洗濯を効率的に

    - 洗濯を始める前に洗濯物を仕分けましょう。色別、生地別に分けることで生地の劣化を防ぎます。
    - 洗剤の量を正確に測り、過剰な洗剤の使用を避けましょう。
    - 乾燥機を使う際は、類似の生地を一緒に乾燥させ、乾燥時間を短縮します。

    ## 3. 掃除を効果的に

    - ルーチン的に掃除を行い、汚れがたまりにくいようにしましょう。
    - 汚れた場所を見つけたら、すぐに対処しましょう。シンクやカウンターの汚れ、床の掃除など、小さなことから始めましょう。
    - 掃除道具を整理し、使いやすい場所に保管しましょう。

    ## 4. 家族と協力

    - 家事を家族と協力して行いましょう。タスクを分担し、負担を軽減します。
    - 子供たちにも家事の一部を担当させ、家族全体で協力の意識を高めましょう。

    ## 5. リラックスタイムを設ける

    - 家事に費やす時間の中に、リラックスタイムを組み込みましょう。コーヒーブレイクや読書の時間など、自分自身を癒す時間を大切にしましょう。

    これらの具体的なコツを実践することで、家事をより効率的に行い、快適な生活を楽しむことができます。日々の家事を工夫して、時間とエネルギーを節約しましょう。
    """,
    submit_date: Date.utc_today(),
    status: 1,
    account_id: user1.id,
    category_id: c1.id
  },
  %Article{
    title: "快適な生活を築くための家事の魔法",
    body: """
    家事は日常生活に欠かせない一部ですが、時には無駄な時間とエネルギーを消費することがあります。しかし、効果的なアプローチを取ることで、家事を魔法のように簡単にこなすことができます。ここでは、快適な生活を築くための家事の魔法のステップを紹介します。

    ## 1. 魔法の杖：計画と優先順位

    快適な生活を築くためには、計画が不可欠です。週ごとに家事のリストを作成し、タスクを優先順位付けしましょう。これにより、何をすべきかが明確になり、無駄な時間の浪費を防ぎます。

    ## 2. 魔法の呪文：タイマーを使う

    タイマーは家事を効率的にこなすための呪文のようなものです。15分から30分の短い集中作業セッションを設け、その後休憩を取ることで、作業の効率が向上します。

    ## 3. 魔法の共犯者：家族との協力

    家事は一人でやる必要はありません。家族と協力し、タスクを分担しましょう。子供たちにも家事の一部を任せることで、家族全体で協力の意識を高めます。

    ## 4. 魔法の収納術：整理整頓

    整理整頓は快適な生活の鍵です。使わないものを処分し、物の場所を確保しましょう。整理整頓された環境は、心地よい生活をサポートします。

    ## 5. 魔法のリラックス：自己ケア

    家事をこなす中で、自分へのリラックスタイムも大切にしましょう。コーヒーブレイク、読書、ヨガ、あるいは好きな趣味に時間を充てることで、ストレスを軽減し、快適な生活を楽しむことができます。

    家事は魔法のように快適な生活を築く手助けとなります。これらの魔法のステップを実践して、家事を楽しんで、快適な生活を手に入れましょう。
    """,
    submit_date: Date.utc_today(),
    status: 2,
    account_id: user1.id,
    category_id: c1.id
  }
]

([article1, article2, article3] ++ articles) |> Enum.map(&Repo.insert!/1)
