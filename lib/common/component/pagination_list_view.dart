import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/model/model_with_id.dart';
import 'package:flutter_lv2_course/common/provider/pagination_provider.dart';
import 'package:flutter_lv2_course/common/utils/pagination_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;

  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: Text('다시 시도'),
          )
        ],
      );
    }

    // 나머지 상태 클래스들은 CursorPagination의 child임
    // CursorPagination
    // CursorPaginationFetchingMore extends CursorPagination
    // CursorPaginationRefetching extends CursorPagination

    final cp = state as CursorPagination<T>;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(widget.provider.notifier).paginate(
                  forceRefetch: true,
                );
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemCount:
                cp.data.length + 1, // 마지막 스크롤 부분에 데이터 불러올때 로딩화면 보여주기 위해 +1을 더함
            itemBuilder: (_, index) {
              if (index == cp.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Center(
                    child: cp is CursorPaginationFetchingMore
                        ? const CircularProgressIndicator()
                        : const Text('마지막 데이터 입니다. ㅠㅜ'),
                  ),
                );
              }

              final pItem = cp.data[index];

              return widget.itemBuilder(
                context,
                index,
                pItem,
              );
            },
            separatorBuilder: (_, index) {
              return const SizedBox(height: 16.0);
            },
          ),
        ));
  }
}
