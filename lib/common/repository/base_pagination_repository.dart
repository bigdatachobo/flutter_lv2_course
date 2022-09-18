import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/model/model_with_id.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';

import '../model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    //  쿼리 추가할때
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
