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
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 06Oct2011             *
      *                 HVB011   *CREATE   Date 06Oct2011             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP Enhancements to Midas Plus level.     *
      *  HVB011   - Target Balance Cash Pooling                       *
      *           - Retrieve record from UDF file T_GZAMADEX          *
      *****************************************************************
      *
     D GZAMAD        E DS                  ExtName(T_GZAMADEX) prefix(A_)
     D PAMAD           DS           100
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
     c+ into :GZAMAD
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
     C                   If        (SQLCOD <> 0)
     C                   Move      '*RNF'        PRTN
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
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
     C                   Move      '*ERROR'      PRTN
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
