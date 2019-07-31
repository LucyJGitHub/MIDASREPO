     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Initialisation programfor CER069')            *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  SD000825 - Initialisation program for CER069                 *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069  *CREATE    Date 03Jul14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069 - German Tax Enhancement                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *       LR      LAST RECORD                                     *
      *       U7      DATABASE ERROR                                  *
      *       U8      DATABASE ERROR                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure

     D SDACTX        E DS                  EXTNAME(SDACTXPD)
      **  External DS for customer details by country of tax


     D DLNO            S              6S 0
     D CNUM            S              6
     D BRCA            S              3
     D TAXI            S              1
     D ATCNUM          S              6
     D ATCCY           S              3
     D ATACSQ          S              2S 0
     D ATBRCA          S              3
     D ATACOD          S             10S 0
     D ATITAX          S              1
     D JATP            S              1
     D WRun            S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C/exec sql
     C+ open DealsDC
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DealsDC
     C+ into
     C+   :DLNO
     C+  ,:CNUM
     C+  ,:BRCA
     C+  ,:TAXI
     C/end-exec


     C                   DOW       %Subst(SQLState:1:2) <> '02'

     C/exec SQL
     C+  select
     C+    E5JATP
     C+  into
     C+    :JATP
     C+  from SDACUSPD
     C+  where
     C+    E5CUST = :CNUM
     C/end-exec

     C                   IF        SQLCOD = 0 AND (JATP = 'I' OR
     C                               JATP = 'Y')
     C                   CALL      'AOACTXR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      CNUM          PCNUM             6
     C                   PARM      BRCA          PBRCA             3
     C     SDACTX        PARM      SDACTX        DSFDY
     C                   IF        PRTCD = *BLANKS AND AXETXS <> ' '
     C/exec SQL
     C+  update DEALSDC
     C+  set TAXI = 'A'
     C+  where DLNO = :DLNO
     C/end-exec
     C                   ENDIF
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DealsDC
     C+ into
     C+   :DLNO
     C+  ,:CNUM
     C+  ,:BRCA
     C+  ,:TAXI
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DealsDC
     C/end-exec


      ** Account extension details

     C/exec sql
     C+ open Account
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Account
     C+ into
     C+   :ATCNUM
     C+  ,:ATCCY
     C+  ,:ATACSQ
     C+  ,:ATBRCA
     C+  ,:ATACOD
     C+  ,:ATITAX
     C/end-exec


     C                   DOW       %Subst(SQLState:1:2) <> '02'

     C/exec SQL
     C+  select
     C+    E5JATP
     C+  into
     C+    :JATP
     C+  from SDACUSPD
     C+  where
     C+    E5CUST = :ATCNUM
     C/end-exec

     C                   IF        SQLCOD = 0 AND (JATP = 'I' OR
     C                               JATP = 'Y')
     C                   CALL      'AOACTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ATCNUM        PCNUM
     C                   PARM      ATBRCA        PBRCA
     C     SDACTX        PARM      SDACTX        DSFDY
     C                   IF        PRTCD = *BLANKS AND AXETXS <> ' '
     C/exec SQL
     C+  update ACCNTBXC
     C+  set ATITAX = 'A'
     C+  where ATCNUM = :ATCNUM and
     C+        ATBRCA = :ATBRCA and
     C+        ATCCY  = :ATCCY   and
     C+        ATACOD = :ATACOD and
     C+        ATACSQ = :ATACSQ
     C/end-exec
     C                   ENDIF
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from Account
     C+ into
     C+   :ATCNUM
     C+  ,:ATCCY
     C+  ,:ATACSQ
     C+  ,:ATBRCA
     C+  ,:ATACOD
     C+  ,:ATITAX
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Account
     C/end-exec

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C/exec sql
     C+ declare DealsDC Scroll Cursor
     C+  for select
     C+     DLNO
     C+    ,CNUM
     C+    ,BRCA
     C+    ,TAXI
     C+  from DEALSDC
     C+  where RECI = 'D'
     C+  order by
     C+     DLNO
     C/end-exec


     C/exec sql
     C+ declare Account Scroll Cursor
     C+  for select
     C+     ATCNUM
     C+    ,ATCCY
     C+    ,ATACSQ
     C+    ,ATBRCA
     C+    ,ATACOD
     C+    ,ATITAX
     C+  from ACCNTBXC
     C+  order by
     C+     ATCNUM
     C+    ,ATBRCA
     C+    ,ATCCY
     C+    ,ATACOD
     C+    ,ATACSQ
     C/end-exec


     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
