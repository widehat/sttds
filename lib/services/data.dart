import 'dart:math';
import 'package:sttds/model/itemmodel.dart';

String getRandomText({int minLength = 5, int lengthVariation = 20}) {
  const String loremIpsumText =
      "Lorem Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?";
  int length = minLength + Random.secure().nextInt(lengthVariation);
  int start = Random.secure().nextInt(loremIpsumText.length - length - 1);
  return loremIpsumText.substring(start, start + length).trim();
}

String getSampleData1() {
  return '[{"id":"mdzbl5buye6rpqu7wpjweblk","nm":"Sample Data 1","nb":"This is sample data only.\\nTo add this data set click Import Sample Data 1 from the main menu.","children":[{"id":"die5kgj34uefap9nbvkedybv","nm":"Home","children":[{"id":"y4rkia050y311a70tbr5rl4i","nm":"TV","children":[{"id":"5g0qumw2qrsanrda1pm438b8","nm":"Parental Security Key","vl":"6733"}]}]},{"id":"3weunpihi7ym25l9q74296lm","nm":"Other","children":[{"id":"zer98fr28hvqcvw7x1q3icmt","nm":"QPR FC","children":[{"id":"6f1rabgbv9doopyt0plifqrl","nm":"Location","vl":"bingmaps:?cp=51.509323~-0.231929&lvl=18"},{"id":"8wvbt9k2fq7tgjhg5r7efvos","nm":"Ticket Email Address","vl":"name@host.domain"},{"id":"5p95byy34hvsc8a36ep54p71","nm":"Ticket Password","vl":"QQ6mCD9zg3u","oz":"2"},{"id":"psy550c8zbxhemtqu1gw9mz0","nm":"Web Site","vl":"http://www.qpr.co.uk"}]}]},{"id":"f39ytcg90s5oa4a6kvtcrtam","nm":"Random stuff","children":[{"id":"h1vvy5rx2076pp8bnwbezvfi","nm":"Email","vl":"mailto://richard@widehat.com"},{"id":"am6ttvgv3nkuyft62xerzf27","nm":"Map Reference - Bing Maps","vl":"bingmaps:?cp=51.509323~-0.231929&lvl=18"},{"id":"sax386siy34iv28i6kt5yabh","nm":"Map Reference - Google Maps","vl":"https://www.google.com/maps/@51.509259,-0.232036,18z"},{"id":"3f2ittw8agrmc28enoos5hm4","nm":"Password","vl":"cvjHM6zcsu","oz":"2"},{"id":"1b52urlicznn26cjlffuvvpx","nm":"Sms","vl":"sms:07777..."},{"id":"9pcs6ydbyxj7clxyi3gu5tkx","nm":"Telephone","vl":"tel:020..."},{"id":"r87fd4a47jw63jnak8891tbx","nm":"Web","vl":"http://bbc.co.uk/news"}]},{"id":"js5akuodavo3ubw98dgjgb0i","nm":"Services","children":[{"id":"caigj3gy4c8se2edxrtqy0hz","nm":"Lottery","children":[{"id":"kbg1lu1v6cvykqeu306p0jhf","nm":"Email Address","vl":"alternatename@host.domain"},{"id":"jymijh1ovsno35gja5bmtzcz","nm":"Memorable Word","vl":"London1990","oz":"2"},{"id":"vsx5fpvnha4x2ihdd8uig101","nm":"Password","vl":"u7%CHP#MumC4","oz":"2"},{"id":"2nd8fntflcqi5mx9g4f148r5","nm":"Questions","children":[{"id":"zmbgjorkhcrkkxm4ffelpjcu","nm":"Username","vl":"Richard"},{"id":"a9qsr91bd0m3alfenxl6k0l1","nm":"What is the name of your first school?","vl":"Riverside"},{"id":"hljaxqiltoxckr2qmlqcis6w","nm":"What street did you first live in?","vl":"The Avenue"},{"id":"okms0xvxafb73j8gzfj2yvra","nm":"What was your town of birth?","vl":"London"}]},{"id":"2h70t27e1nnyy7tcqj3772dw","nm":"web site","vl":"http://www.national-lottery.co.uk"}]},{"id":"9517wgfbo25my2z1nv1x5h0x","nm":"The OR Society","children":[{"id":"us9gco75j2kf00fr3qu9gzdjp","nm":"Password","vl":"bvkTcXgLMVjV","oz":"2"},{"id":"dngkmisl7vtog97rsry3ep4c","nm":"Username","vl":"name@host.domain"},{"id":"yqdnrj5ns7822qrca00p9mpo","nm":"Web site","vl":"http://theorsociety.com"}]}]},{"id":"b23ptyrb8hb14a90c65iv49r","nm":"Work","children":[{"id":"8g533ls9s9glbia1mhnlckyx","nm":"Security Camera","children":[{"id":"3pdnbunt9xjh8zsdeb5pw3i7","nm":"Password","vl":"N9xE68KFv65n","oz":"2"},{"id":"p3ki7c956bmlxw836n2yi61s","nm":"Username","vl":"fj43"},{"id":"uifwrdp4fb0w4b60dcngb3ux","nm":"URL","vl":"http://cctc.w12.local"}]},{"id":"twzvvw4kgw8tw5jf1juwajql","nm":"Door Security Alarm","children":[{"id":"3ltkxfnrmjc1r3gjgfv5vy6s","nm":"Code","vl":"6352"}]}]}]}]';
}

ItemModel getRandomNode() {
  ItemModel node;
  int type = Random.secure().nextInt(6);
  if (type == 0) {
    node = ItemModel(
      nm: getRandomText(),
    );
  } else if (type == 1) {
    node = ItemModel(
      nm: getRandomText(),
      vl: getRandomText(),
    );
  } else if (type == 2) {
    node = ItemModel(
      nm: getRandomText(),
      vl: getRandomText(),
      op: -1,
    );
  } else if (type == 3) {
    node = ItemModel(
      nm: getRandomText(),
      vl: getRandomText(),
      nb: getRandomText(),
    );
  } else if (type == 4) {
    node = ItemModel(
      nm: getRandomText(),
      nb: getRandomText(),
    );
  } else {
    node = ItemModel(
      nm: getRandomText(),
      vl: getRandomText(),
      op: Random.secure().nextInt(3) - 1,
      nb: getRandomText(),
    );
  }
  return node;
}

Future<List<ItemModel>> getDataList() async {
  List<ItemModel> itemList = [];

  ItemModel parentLevel0;
  parentLevel0 = ItemModel(
    nm: 'Sample Data 2',
    nb: 'This is sample data only.\nTo add this data set click Import Sample Data 1 from the main menu.',
    vl: "",
  );

  parentLevel0.addChild(getControl());
  parentLevel0.addChild(getHierarchy());
  parentLevel0.addChild(getList());
  itemList.add(parentLevel0);

  // sort itemList by sorting children recursively from a given node
  sortList(itemList[0]);

  return itemList;
}

void sortList(ItemModel node) {
  node.sortChildren();
  for (int i = 0; i < node.children.length; i++) {
    sortList(node.children[i]);
  }
}

ItemModel getControl() {
  ItemModel node, childNode;

  node = ItemModel(
      nm: 'Control',
      nb: 'Set of various combinations of Title, Data and Note to test UI, the structure is fixed the data is regenerated each time the app runs');
  childNode = ItemModel(
    nm: 'Title Only',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 5,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 45,
      lengthVariation: 5,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 90,
      lengthVariation: 10,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Title & Data',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Title & Data (always hide)',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Title & Data & Note',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 0,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 0,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 0,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Title & Data (always hide) & Note',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: -1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Title & Data (always show) & Note',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    op: 1,
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Title & Note',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 10,
      lengthVariation: 90,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Long Title',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 600,
      lengthVariation: 200,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 600,
      lengthVariation: 200,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Long Data',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 600,
      lengthVariation: 200,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    vl: '${getRandomText(
      minLength: 600,
      lengthVariation: 200,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Long Note',
  );
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 600,
      lengthVariation: 200,
    )}',
  ));
  childNode.addChild(ItemModel(
    nm: '${getRandomText(
      minLength: 5,
      lengthVariation: 15,
    )}',
    nb: '${getRandomText(
      minLength: 600,
      lengthVariation: 200,
    )}',
  ));
  node.addChild(childNode);

  childNode = ItemModel(
    nm: 'Mixture',
  );
  for (int i = 0; i < 20; i++) {
    childNode.addChild(getRandomNode());
  }
  node.addChild(childNode);

  return node;
}

ItemModel getHierarchy() {
  ItemModel node;
  int maximumLevelDepth = 12;

  // create top node
  node = ItemModel(
    nm: 'Hierarchy',
    nb: 'Random set of hierarchical data, both structure and data is regenerated each time the app runs',
  );
  // assume four children
  for (int i = 0; i < 4; i++) {
    // for each child create a node with a random number of children
    node.addChild(createRandomNode(0, maximumLevelDepth));
  }
  return node;
}

ItemModel createRandomNode(int level, int maximumLevelDepth) {
  ItemModel node;
  int childCount;

  // initialise this node with a title
  node = ItemModel(
    nm: getRandomText(
      minLength: 5,
      lengthVariation: 15,
    ),
  );
  // determine if this node has children
  if (Random.secure().nextInt(maximumLevelDepth) > level) {
    // then determine the number of children
    childCount = 1 + Random.secure().nextInt(3);
    for (int i = 0; i < childCount; i++) {
      // for each child create a node with a random number of children
      node.addChild(createRandomNode(level + 1, maximumLevelDepth));
    }
  } else {
    // no children so simply add a value
    node.vl = getRandomText(
      minLength: 5,
      lengthVariation: 15,
    );
  }
  return node;
}

ItemModel getList() {
  ItemModel parentLevel1;
  ItemModel parentLevel2;
  ItemModel parentLevel3;

  parentLevel1 = ItemModel(
    nm: 'List',
    nb: 'Long data list, 500 nodes, each node consists of the same subtree structure but with randsom data, this structure is fixed',
  );
  for (int i = 1; i <= 500; i++) {
    parentLevel2 = ItemModel(nm: 'Item - $i');
    parentLevel2.addChild(ItemModel(
        nm: getRandomText(
          minLength: 5,
          lengthVariation: 2,
        ),
        vl: getRandomText()));
    parentLevel2.addChild(ItemModel(
        nm: getRandomText(
          minLength: 10,
          lengthVariation: 2,
        ),
        vl: getRandomText()));
    parentLevel3 = ItemModel(
        nm: getRandomText(
      minLength: 25,
      lengthVariation: 2,
    ));
    parentLevel3.addChild(ItemModel(
        nm: getRandomText(
          minLength: 5,
          lengthVariation: 15,
        ),
        vl: getRandomText()));
    parentLevel3.addChild(ItemModel(
        nm: getRandomText(
          minLength: 5,
          lengthVariation: 15,
        ),
        vl: getRandomText()));
    parentLevel2.addChild(parentLevel3);
    parentLevel1.addChild(parentLevel2);
  }

  return parentLevel1;
}
