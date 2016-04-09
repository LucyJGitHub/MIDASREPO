      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPGLE)                                 *
      *                                                               *
      *  ZFRELNLE - SR. to format the 20A portfolio management        *
      *             line description for retail                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD021155 *REWRITE  Date 10Jul13               *
      *  Prev Amend No. CGL120     *CREATE Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - Header box not correct                            *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *  Format: 999999XXX888877YYY                                   *
      *                                                               *
      *       999999 = Customer Number                                *
      *       XXX    = Currency Code                                  *
      *       8888   = Account Code                                   *
      *       77     = Account Sequence                               *
      *       YYY    = Branch                                         *
      *                                                               *
      *  Input Fields                                                 *
      *       ZCNUM   60     Customer Number                          *
      *       ZCCY    3A     Currency Code                            *
      *       ZACOD  100     Account Code                             *
      *       ZACSQ   20     Account Sequence                         *
      *       ZBRCA   3A     Branch                                   *
      *                                                               *
      *  Output Fields                                                *
      *       ZLIN   26A     Line Description                         *
      *                                                               *
      *  Array Used                                                   *
      *       ZLI    26      Elements, each 1 character long          *
      *                                                               *
      *****************************************************************
 
     C     ZFRELN        BEGSR
 
      ** Clear line description
 
     C                   MOVEA     *BLANKS       ZLI
 
      ** Move customer number to line description
 
     C                   MOVE      ZCNUM         ZWRKA6            6
     C                   MOVEA     ZWRKA6        ZLI(01)
 
      ** Move currency to line description
 
     C                   MOVEA     ZCCY          ZLI(07)
 
      ** Move account code to line description
 
     C                   MOVE      ZACOD         ZWRKA4           10
     C                   MOVEA     ZWRKA4        ZLI(10)
 
      ** Move account sequence to line description
 
     C                   MOVE      ZACSQ         ZWRKA2            2
     C                   MOVEA     ZWRKA2        ZLI(20)
     C                   MOVEA     ZBRCA         ZLI(22)
 
      ** Set all fields to blanks or zeros
 
     C                   Z-ADD     *ZEROS        ZCNUM             6 0
     C                   MOVE      *BLANKS       ZCCY              3
     C                   Z-ADD     *ZEROS        ZACOD            10 0
     C                   Z-ADD     *ZEROS        ZACSQ             2 0
     C                   MOVE      *BLANKS       ZBRCA             3
 
     C                   MOVEA     ZLI           ZLIN             26
 
     C                   ENDSR
