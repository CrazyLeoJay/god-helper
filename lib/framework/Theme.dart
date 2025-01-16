/// 主题
/// 每个主题都应该指定作者，如果没有特别说明，则表示该主题是开发者创建
enum AppTheme {
  DEFAULT,
  DIE(author: Authors.orphanNo_005);

  final Authors author;

  const AppTheme({this.author = Authors.leoJay});
}

/// 作者
enum Authors {
  leoJay(Author("leojay", "crazyleojay@163.com", "https://www.leojay.site/", "https://github.com/CrazyLeoJay")),
  orphanNo_005(Author("Orphan No.005", "yangzhuozi11@gamil.com", "", "https://github.com/TableIcy")),
  ;

  final Author author;

  const Authors(this.author);
}

/// 作者描述
class Author {
  final String name;
  final String email;
  final String website;
  final String github;

  const Author(this.name, this.email, this.website, this.github);
}
