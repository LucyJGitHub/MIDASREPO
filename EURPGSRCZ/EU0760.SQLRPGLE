     H DEBUG
     H DFTACTGRP(*NO) ACTGRP(*CALLER)
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas EU Account closure request SQL')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  EU0760 - Midas EU Account closure request - SQL              *
      *                                                               *
      *    (c) Finastra LTD 2020                                      *
      *                                                               *
      *  Last Amend No. CGL196  *CREATE    Date 07Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL196 - Account Mapping Stopped Cheques Processing          *
      *                                                               *
      *****************************************************************

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.
     D/COPY GPCPYSRCG,STD_D_SPEC
      **------------------------------------------------------------------

      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+

     D PARM1           DS
      ** Branch Name
     D  CXBRCA                 1      3
      ** Customer Number
     D  CXCNUM                 4      9
      ** Currency
     D  CXCCY                 10     12
      ** Account Code
     D  CXACOD                13     22
      ** Account Sequence
     D  CXACSQ                23     24
      ** Cheque Ref. No.
     D  CXSTCR                25     27
      ** Account Number
     D  CXACNO                28     37

     D PARM2           DS
      ** New Currency
     D  CXCCY2                 1      3

     D PARM3           DS
      ** Return code
     D  RetCd                  1      7
     D
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D
      /COPY GPCPYSRCG,PSDS

     D* --------------------------------------------------
     D* Prototypes
     D* --------------------------------------------------

     D wJMSEntries     S              1S 0 Inz
     D wSTCQEntries    S              1S 0 Inz
     D CXACODTrimmed   S             10A   Inz
     D CXACSQTrimmed   S              2A   Inz
     D CXSTCRTrimmed   S              3A   Inz
     D zoneName        S             10A   Inz
     D Recursive       S              1A

      *  Entry Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
     C                   PARM                    PARM3

      * Retrieve Zone ID
     C                   IN        SDSTAT

     C                   EVAL      wJMSEntries = 0
     C                   EVAL      wSTCQEntries = 0

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

      * Update the Zone extension table

     C                   EVAL      CXACODTrimmed = %triml(CXACOD: '0')
     C                   EVAL      CXACSQTrimmed = %triml(CXACSQ: '0')
     C                   EVAL      CXSTCRTrimmed = %triml(CXSTCR: '0')

     C/exec SQL
     C+ select count(*) into :wJMSEntries from V_RESTCQQD
     C+    where BRCA = :CXBRCA and
     C+          CNUM = :CXCNUM and
     C+          CCY  = :CXCCY  and
     C+          ACOD = :CXACODTrimmed and
     C+          ACSQ = :CXACSQTrimmed and
     C+          STCR = :CXSTCRTrimmed
     C/end-exec

     C                   If        SQLCODE <> 0 or wJMSEntries <> 1
     C                   Eval      RetCd = '*ERROR'
     C                   ExSr      *PSSR
     C                   EndIf

     C/exec SQL
     C+ update V_RESTCQQD
     C+    set   CCY  = :CXCCY2
     C+    where BRCA = :CXBRCA and
     C+          CNUM = :CXCNUM and
     C+          CCY  = :CXCCY  and
     C+          ACOD = :CXACODTrimmed and
     C+          ACSQ = :CXACSQTrimmed and
     C+          STCR = :CXSTCRTrimmed
     C/end-exec

     C                   If        SQLCODE <> 0
     C                   Eval      RetCd = '*ERROR'
     C                   ExSr      *PSSR
     C                   EndIf

      * Update the GP extension table

     C/exec SQL
     C+ select zozone into :zoneName from GPZONEL2
     C+    where zomsys = :LIBR
     C/end-exec

     C                   If        SQLCODE <> 0
     C                   Eval      RetCd = '*ERROR'
     C                   ExSr      *PSSR
     C                   EndIf

     C/exec SQL
     C+ select count(*) into :wSTCQEntries from T_GZSTCQEX
     C+    where CNUM = :CXCNUM and
     C+          CCY  = :CXCCY  and
     C+          ACOD = :CXACOD and
     C+          ACSQ = :CXACSQ and
     C+          STCR = :CXSTCR and
     C+          ACNO = :CXACNO and
     C+          BRCA = :CXBRCA and
     C+          CUSTZONE = :zoneName
     C/end-exec

     C                   If        SQLCODE <> 0 or wSTCQEntries <> 1
     C                   Eval      RetCd = '*ERROR'
     C                   ExSr      *PSSR
     C                   EndIf

     C/exec SQL
     C+ update T_GZSTCQEX
     C+    set   CCY  = :CXCCY2
     C+    where CNUM = :CXCNUM and
     C+          CCY  = :CXCCY  and
     C+          ACOD = :CXACOD and
     C+          ACSQ = :CXACSQ and
     C+          STCR = :CXSTCR and
     C+          ACNO = :CXACNO and
     C+          BRCA = :CXBRCA and
     C+          CUSTZONE = :zoneName
     C/end-exec

     C                   If        SQLCODE <> 0
     C                   Eval      RetCd = '*ERROR'
     C                   ExSr      *PSSR
     C                   EndIf

      * Normal Termination
     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
