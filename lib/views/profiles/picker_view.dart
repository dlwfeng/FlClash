import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/widgets/chip_title.dart';
import 'package:material_ui/material_ui.dart';

const _infoGap = 4.0;
const profileItemMinWidth = 300.0;
double profilePickerItemHeight(BuildContext context) {
  final measure = MeasureScope.of(context);
  return measure.textHeight(AppTextStyle.headline) + _infoGap + measure.textHeight(AppTextStyle.footnote) + 2 * listRowVerticalPadding;
}
int getProfilesColumns(double width, {required double spacing, double minItemWidth = profileItemMinWidth}) => ((width + spacing) / (minItemWidth + spacing)).floor().clamp(1, 3);

class ProfilesGridView extends StatefulWidget {
  const ProfilesGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.selectedIndex,
    required this.spacing,
    required this.revealsSelected,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int selectedIndex;
  final double spacing;
  final bool revealsSelected;

  @override
  State<ProfilesGridView> createState() => ProfilesGridViewState();
}

class ProfilesGridViewState extends State<ProfilesGridView> {
  static const _horizontalPadding = 16.0;

  late final ScrollController _controller;
  var _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = sheetScrollController(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed ||
        !widget.revealsSelected ||
        !PageActivityScope.isActiveOf(context)) {
      return;
    }
    _revealed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  EdgeInsets get _padding => EdgeInsets.only(
    left: _horizontalPadding,
    right: _horizontalPadding,
    top: context.contentTopPadding,
    bottom: 16 + context.bottomInset,
  );

  int _columnsFor(double width) => getProfilesColumns(
    width - _horizontalPadding * 2,
    spacing: widget.spacing,
    minItemWidth: profileItemMinWidth.ap(context),
  );

  void _revealSelected() {
    if (!mounted || !_controller.hasClients) {
      return;
    }
    final index = widget.selectedIndex;
    if (index == -1) {
      return;
    }
    final position = _controller.position;
    final padding = _padding;
    final height = profilePickerItemHeight(context);
    final row = index ~/ _columnsFor(context.size!.width);
    final atTop = row * (height + widget.spacing);
    final atBottom =
        atTop + padding.vertical + height - position.viewportDimension;
    if (position.pixels >= atBottom && position.pixels <= atTop) {
      return;
    }
    _controller.jumpTo(
      ((atTop + atBottom) / 2).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidthBuilder(
      builder: (_, width) {
        return GridView.builder(
          key: const PageStorageKey('profiles'),
          controller: _controller,
          padding: _padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnsFor(width),
            mainAxisSpacing: widget.spacing,
            crossAxisSpacing: widget.spacing,
            mainAxisExtent: profilePickerItemHeight(context),
          ),
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
        );
      },
    );
  }
}

class ProfilePickerItemView extends StatelessWidget {
  const ProfilePickerItemView({super.key, required this.id, required this.title, required this.subtitle,
    required this.expire, required this.isSelected, required this.trailing, required this.menuItems, required this.onSelect});
  final Object id;
  final String title, subtitle;
  final DateTime? expire;
  final bool isSelected;
  final Widget trailing;
  final List<CommonPopupMenuItem>? menuItems;
  final VoidCallback onSelect;
  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      menuItems: menuItems,
      child: CommonCard(
        enterActionsOnRight: true,
        radius: AppCorner.xl,
        isSelected: isSelected,
        onPressed: () {
          onSelect();
        },
        child: ListItem(
          key: ValueKey(id),
          minTileHeight: profilePickerItemHeight(context),
          minVerticalPadding: listRowVerticalPadding,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              trailing,
              if (isSelected) const SelectionBadge(size: 24),
            ],
          ),
          title: ProfileCardTitleView(title: title, expire: expire, subtitle: subtitle),
        ),
      ),
    );
  }
}
class ProfileCardTitleView extends StatelessWidget {
  const ProfileCardTitleView({
    super.key,
    required this.title,
    required this.expire,
    required this.subtitle,
  });

  final String title;
  final DateTime? expire;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipTitle(
          title: title,
          expire: expire,
          style: AppTextStyle.headline.of(context),
        ),
        const SizedBox(height: _infoGap),
        Text(
          subtitle,
          style: AppTextStyle.footnote.of(context).toLighter,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

