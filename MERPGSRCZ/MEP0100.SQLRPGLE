     *************** Beginning of data ********************************************************
     H DEBUG
      *****************************************************************
/*STD *  RPGSQLMOD                                                   *
/*EXI *  TEXT('Midas ME Program to access record from T_GZAMADEX')   *
      *****************************************************************
      *                                                               *
      *  MEP0100 - Midas Program to access record from T_GZAMADEX     *
      *                                                               *
      *  Function: This program binds the modules that retrieves      *
      *            record from UDF file for Accounts                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD059770           Date 21Sep22               *
      *  Prev Amend No. MD031937           Date 13Jan15               *
      *                 AR856737           Date 06Oct2011             *
      *                 HVB011   *CREATE   Date 06Oct2011             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059770 - ME_FT_IMM is in MSGW                              *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP Enhancements to Midas Plus level.     *
      *  HVB011   - Target Balance Cash Pooling                       *
      *           - Retrieve record from UDF file T_GZAMADEX          *
      *****************************************************************
      *
     D GZAMAD        E DS                  ExtName(T_GZAMADEX) prefix(A_)
     D PAMAD           DS           100
      *                                                                                     MD059770
     D NULLINDS        S              5I 0 DIM(99)                                          MD059770
      *
     C     *ENTRY        PLIST
     C                   Parm                    PRTN              5
     C                   Parm                    PBRCH             3
     C                   Parm                    PCUST             6
     C                   Parm                    PCCY              3
     C                   Parm                    PACOD            10
     C                   Parm                    PACSQ             2
     C                   Parm                    PAMAD           100
      *
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
     C                   Eval      GZAMAD = *Blanks
      *
      ** To release file after the program ended.
     C/EXEC SQL
     C+ set option CLOSQLCSR = *ENDMOD
     C/END-EXEC
      *
      *
      *
     C/EXEC SQL
     C+ set option commit=*none,
     C+            datfmt=*iso
     C/END-EXEC
      *
      ** Select record from Account Maintance UDF file
      *
     C/EXEC SQL
     c+ select  *
     c***+*into*:GZAMAD                                                                     MD059770
     c+ into :GZAMAD :NULLINDS                                                              MD059770
     c+ from T_GZAMADEX
     c+   where DDBRCA = :PBRCH
     c+   and   substr(DDCUSN,5,6) = :PCUST
     c+   and   DDCCY = :PCCY
     c+   and   DDACOD = :PACOD
     c+   and   DDACSQ = :PACSQ
     c/END-EXEC
      *
      *  Check for successful completion
      *
     C**********         If        (SQLCOD <> 0)                                            MD059770
     C**********         Move      '*RNF'        PRTN                                       MD059770
     C**********         If        (%SUBST(SQLSTATE:1:2) <> '02')                           MD059770
      *                                                                                     MD059770
     C                   IF        SQLCOD = 100                                             MD059770
     C                   EVAL      PRTN = '*RNF'                                            MD059770
     C                   EXSR      *PSSR                                                    MD059770
      *                                                                                     MD059770
     C                   ELSE                                                               MD059770
     C                   IF        SQLCOD < 0                                               MD059770
     C                   EVAL      PRTN = '*ERR'                                            MD059770
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
      *
     C     SQLCOD        Ifeq      0
     C                   MoveL     GZAMAD        PAMAD
     C                   EndIf
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C**********         Move      '*ERROR'      PRTN                                       MD059770
      *
     C     RunBefore     IFEQ      *BLANKS

     C                   MOVE      'Y'           RunBefore         1

     C                   DUMP
     C                   ENDIF

     C                   SETON                                        LRU7U8
     C                   RETURN
      *
     C                   ENDSR
      *
