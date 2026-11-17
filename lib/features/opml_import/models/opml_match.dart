import 'package:bunpod/bunpod.dart';

sealed class OpmlMatch {
  const OpmlMatch();
}

final class OpmlFound extends OpmlMatch {
  const OpmlFound(this.channel);

  final Channel channel;
}

final class OpmlSuggested extends OpmlMatch {
  const OpmlSuggested(this.options);

  final List<Channel> options;
}

final class OpmlMissing extends OpmlMatch {
  const OpmlMissing();
}
