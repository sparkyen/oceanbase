    // type.set_type(ObLongTextType);
  // type.set_collation_type(CS_TYPE_UTF8MB4_GENERAL_CI);
  // type.set_collation_level(CS_LEVEL_IMPLICIT);
  // type.set_accuracy(ObAccuracy::DDL_DEFAULT_ACCURACY[ObLongTextType]);
  // const int32_t mbmaxlen = 4;
  // type.set_length(OB_MAX_LONGTEXT_LENGTH / mbmaxlen);
  // type.set_collation_type(CS_TYPE_UTF8MB4_BIN);
  // type.set_collation_level(CS_LEVEL_IMPLICIT);
  // type.set_length(OB_MAX_LONGTEXT_LENGTH);
  // if (is_mysql_mode() && ob_is_text_tc(type.get_type())) {
  //   const int32_t mbmaxlen = 4;
  //   const int32_t default_text_length =
  //       ObAccuracy::DDL_DEFAULT_ACCURACY[type.get_type()].get_length() / mbmaxlen;
  //   // need to set a correct length for text tc in mysql mode
  //   type.set_length(default_text_length);
  // }


    // char *buf = nullptr;
		
    // ObLobLocator *lob_locator = nullptr;
    // if (OB_ISNULL(buf = static_cast<char*>(
    //                         tmp_allocator.alloc(file_path.length() + sizeof(ObLobLocator))))) {
    //   ret = OB_ALLOCATE_MEMORY_FAILED;
    //   LOG_WARN("Failed to allocate memory for lob locator", K(ret), K(file_path));
    // } else if(FALSE_IT(lob_locator = reinterpret_cast<ObLobLocator *> (file_path.ptr()))) {

    // } else if (OB_FAIL(lob_locator->init(file_path))) {
    //   STORAGE_LOG(WARN, "Failed to init lob locator", K(ret), K(file_path), KPC(lob_locator));
    // } else {
    //   expr_datum.set_lob_locator(*lob_locator);
    //   LOG_TRACE("return lob locator", KPC(lob_locator), K(file_path));
    // }
  // }