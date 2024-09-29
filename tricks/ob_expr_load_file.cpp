/**
 * Copyright (c) 2021 OceanBase
 * OceanBase CE is licensed under Mulan PubL v2.
 * You can use this software according to the terms and conditions of the Mulan PubL v2.
 * You may obtain a copy of Mulan PubL v2 at:
 *          http://license.coscl.org.cn/MulanPubL-2.0
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PubL v2 for more details.
 */

#define USING_LOG_PREFIX SQL_ENG

#include "lib/oblog/ob_log.h"
#include "sql/engine/expr/ob_expr_load_file.h"
#include "objit/common/ob_item_type.h"
#include "sql/session/ob_sql_session_info.h"
#include "lib/oblog/ob_log.h"
#include "sql/resolver/ob_resolver_utils.h"
// #include "sql/engine/cmd/ob_load_data_file_reader.h"

namespace oceanbase
{
using namespace common;
using namespace common::number;
namespace sql
{

ObExprLoadFile::ObExprLoadFile(ObIAllocator &alloc)
    : ObFuncExprOperator(alloc, T_FUN_LOAD_FILE, N_LOAD_FILE, 1, VALID_FOR_GENERATED_COL, NOT_ROW_DIMENSION)
{
}

ObExprLoadFile::~ObExprLoadFile()
{
}

int ObExprLoadFile::calc_result_type1(ObExprResType &type, 
                                ObExprResType &type1,
                                common::ObExprTypeCtx &type_ctx) const
{
  UNUSED(type_ctx);
  int ret = OB_SUCCESS;

  return ret;
}

int ObExprLoadFile::eval_load_file(const ObExpr &expr, ObEvalCtx &ctx,
                                    ObDatum &expr_datum)
{
	LOG_TRACE("eval_load_file involked");
	int ret = OB_SUCCESS;
	ObDatum *file_path_datum = NULL;
	if (expr.arg_cnt_ != 1 || 
			OB_ISNULL(expr.args_) ||
			OB_ISNULL(expr.args_[0])) {
		ret = OB_ERR_UNEXPECTED;
		LOG_WARN("invalid expr args", K(expr.arg_cnt_), K(expr));
	} else if(OB_FAIL(expr.args_[0]->eval(ctx, file_path_datum)) ||
							OB_ISNULL(file_path_datum)){
		ret = OB_ERR_UNEXPECTED;
		LOG_WARN("eval arg failed", K(ret), K(expr.args_[0]));
	} else {
		ObString file_path = file_path_datum->get_string();
		if (file_path.empty()) {
			LOG_TRACE("file path is empty");
		} else {
			char *full_path_buf = nullptr;
      char *actual_path = nullptr;
      ObString secure_file_priv;
			ObEvalCtx::TempAllocGuard tmp_alloc_g(ctx);
  		common::ObArenaAllocator &tmp_allocator = tmp_alloc_g.get_allocator();
      if (OB_ISNULL(full_path_buf = static_cast<char *>(tmp_allocator.alloc(MAX_PATH_SIZE)))) {
        ret = OB_ALLOCATE_MEMORY_FAILED;
        LOG_WARN("fail to allocate memory", K(ret));
      } else  if (OB_ISNULL(actual_path = realpath(file_path.ptr(), full_path_buf))) {
        ret = OB_FILE_NOT_EXIST;
        LOG_WARN("file not exist", K(ret), K(file_path));
      } else if (OB_FAIL(ctx.exec_ctx_.get_my_session()->get_secure_file_priv(secure_file_priv))) {
        LOG_WARN("failed to get secure file priv", K(ret));
      } else if (OB_FAIL(ObResolverUtils::check_secure_path(secure_file_priv, actual_path))) {
        LOG_WARN("failed to check secure path", K(ret), K(secure_file_priv), K(actual_path));
      } 	
						// if(OB_FAIL(ObFileReader::open(file_path->get_string(), ctx))){
						//     LOG_WARN("open file failed", K(ret), K(file_path->get_string()));
						// }
				
		}
			
			
	}
	

	return ret;
}

int ObExprLoadFile::cg_expr(ObExprCGCtx &expr_cg_ctx, const ObRawExpr &raw_expr,
                       ObExpr &rt_expr) const
{
  int ret = OB_SUCCESS;
	LOG_TRACE("cg eval_load_file involked");
  UNUSED(expr_cg_ctx);
  UNUSED(raw_expr);
  rt_expr.eval_func_ = ObExprLoadFile::eval_load_file;
  return ret;
}

} /* sql */
} /* oceanbase */