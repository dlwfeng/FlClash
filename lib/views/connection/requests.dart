import 'package:fl_clash/features/connection/feed_dependencies.dart';
import 'package:fl_clash/features/connection/feed_bindings.dart';
import 'package:fl_clash/features/connection/tracker_info_list.dart';
import 'package:fl_clash/features/connection/tracker_info_table.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsView extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const RequestsView({super.key, this.scrollController});

  @override
  ConsumerState<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends ConsumerState<RequestsView>
    with RouteMotionHoldMixin<RequestsView> {
  final _listController = TrackerInfoListController();
  late final ScrollController _scrollController;
  late final _physics = FollowEndScrollPhysics(
    isFollowing: () => _listController.value.autoScrollToEnd,
  );

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ??
        sheetScrollController(context, initialScrollOffset: double.maxFinite);
    _listController.setTrackerInfos(ref.read(requestsProvider).list);
    ref.listenManual(requestsProvider.select((state) => state.revision), (
      _,
      _,
    ) {
      updateRequestsThrottler();
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void updateRequestsThrottler() {
    feedThrottler.call('requests', () {
      if (!mounted) {
        return;
      }
      updateWhenRouteSettled(
        () => _listController.setTrackerInfos(ref.read(requestsProvider).list),
      );
    }, duration: renderThrottleDuration);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return CommonScaffold(
      title: appLocalizations.recentRequests,
      searchState: AppBarSearchState(onSearch: _listController.search),
      onKeywordsUpdate: _listController.updateKeywords,
      body: ValueListenableBuilder<TrackerInfosState>(
        valueListenable: _listController,
        builder: (context, state, _) {
          final requests = state.list;
          return NullStatusSwitcher(
            isEmpty: requests.isEmpty,
            isSearching: state.isSearching,
            nullStatus: NullStatus(
              label: appLocalizations.nullTip(appLocalizations.requests),
              illustration: NullStatusIllustration.requests,
            ),
            child: RecordTableFrame<TrackerInfo>(
              tableId: 'requests',
              items: requests,
              reverse: true,
              columnsOf: (width) =>
                  trackerInfoColumns(context, width: width, isLive: false),
              builder: (context, table, requests) => Align(
                alignment: Alignment.topCenter,
                child: FloatingScrollbar(
                  controller: _scrollController,
                  hintBuilder: (fraction) {
                    final index = (fraction * (requests.length - 1)).round();
                    return requests[index].start.showFull;
                  },
                  child: ScrollToEndBox(
                    controller: _scrollController,
                    enable: state.autoScrollToEnd,
                    onCancelToEnd: () {
                      _listController.setAutoScrollToEnd(false);
                    },
                    onResumeToEnd: () {
                      _listController.resumeAutoScrollToEnd(
                        ref.read(requestsProvider).list,
                      );
                    },
                    child: TrackerInfoList(
                      reverse: true,
                      shrinkWrap: true,
                      physics: _physics,
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        top: context.contentTopPadding,
                        bottom: 16 + context.bottomInset,
                      ),
                      trackerInfos: requests,
                      table: table,
                      detailTitle: appLocalizations.details(
                        appLocalizations.request,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
