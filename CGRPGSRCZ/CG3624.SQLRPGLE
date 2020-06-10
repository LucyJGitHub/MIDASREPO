     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD054955
/*STD *  RPGSQLMOD                                                    *                     MD054955
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD054955
/*EXI *  TEXT('Midas CG System field conversion')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3624 - System Field Conversion                             *
      *                                                               *
      *  Function:  This program allows conversion for a system       *
      *             field to be defined. It will also allow the       *
      *             grouping of several conversions.                  *
      *                                                               *
      *  Called By: CG3623 - Common Data Extract Name Maintenance     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1.                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Chain to CGRDECL0                               *
      *    02         Error in Element Name Field                     *
      *    03         Error in Group Name Field                       *
      *    04         Element Name Field Protected                    *
      *    05         Group Name Field Protected                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT - Program Initialisation                              *
      *  SRVALD - Validating Schema Name Field                        *
      *  SRUPDT - Update CGRDECPD                                     *
      *  *INZSR - Initialise                                          *
      *  *PSSR  - Error processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F*CGRDECL0* UF A E           K DISK    INFSR(*PSSR)                                    MD054955
     F**********                           COMMIT                                           MD054955
     FCG3624DF  CF   E             WORKSTN

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Data Area giving Installation Control Details
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D MsgidAr         S              7    DIM(25)
     D Msgid           S              7    DIM(25)

      ** First Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure to hold file details
     D*RecDets       E DS                  EXTNAME(CGRDECPD)                                MD054955
     D RecDets       E DS                  EXTNAME(CGRDEJW0)                                MD054955
     D                                     PREFIX(X)                                        MD054955
     D*WRecDets        DS           165                                                     MD054955
     D WRecDets        DS           166                                                     MD054955
     D*WRecDets2       DS           165                                                     MD054955
     D WRecDets2       DS           166                                                     MD054955

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D C               S              2  0
     D X               S              2  0
     D Idx             S              2  0
     D PMsgFile        S             10
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
     D PSysField       S             10
     D PSysFldDesc     S             30
     D PElement        S             30
     D PSelOption      S              1
     D PFuncKey        S              2
     D PRTCD           S              7
     D POPTN           S              7
     D @RUN            S              1
     D WCGSyst         S             30
     D WCGSygp         S             30
     D WErrVar         S              1
     D WRecErr         S              1
     D WNewVar         S              1
     D WNewVar2        S              1
     D WSchema         S             30
     D WGroupNam       S             30
     D WSystem         S              4
     D WSyst           S            111
     D WSystGP         S              4
     D CGRDEC        E DS                  EXTNAME(CGRDEJW0)                                MD054955

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * Main Processing                                               *
      *****************************************************************
      *
      ** Perform Initialisation
      *
     C                   EXSR      SRINIT
      *
     C*****KSYST         CHAIN     CGRDECL0                           01                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDEC                                                                        MD054955
     C+ from CGRDEJW0                                                                       MD054955
     C+ where CGTYPE = :WSystem and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955

     C                   EVAL      WCGSyst = CGNWFD
     C                   EVAL      #0ELEM = CGNWFD
     C**********         IF        *IN01 = *OFF                                             MD054955
     C                   IF        SQLCODE = 0                                              MD054955
     C                   EVAL      WNewVar = 'N'
     C                   EVAL      RecDets = CGRDEC                                         MD054955
     C                   EVAL      WRecDets = RecDets

     C**********         UNLOCK    CGRDECL0                             90                  MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C******LOCK         IN        LDA                                                      MD054955
     C**********         Z-ADD     02            DBASE                                      MD054955
     C**********         MOVEL     'CGRDECPD'    DBFILE                                     MD054955
     C**********         MOVEL     '*UNLOCK'     DBKEY                                      MD054955
     C**********         OUT       LDA                                                      MD054955
     C**********         EXSR      *PSSR                                                    MD054955
     C**********         ENDIF                                                              MD054955
     C                   ENDIF
      *
     C*****KSYGP         CHAIN     CGRDECL0                           01                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDEC                                                                        MD054955
     C+ from CGRDEJW0                                                                       MD054955
     C+ where CGTYPE = :WSystGP and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955

     C                   EVAL      WCGSygp = CGNWFD
     C**********         IF        *IN01 = *OFF                                             MD054955
     C                   IF        SQLCODE = 0                                              MD054955
     C                   EVAL      WNewVar2 = 'N'
     C                   EVAL      WGroupNam = CGNWFD
     C                   EVAL      #0GRPN = CGNWFD
     C                   EVAL      RecDets = CGRDEC                                         MD054955
     C                   EVAL      WRecDets2 = RecDets

     C**********         UNLOCK    CGRDECL0                             90                  MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C******LOCK         IN        LDA                                                      MD054955
     C**********         Z-ADD     03            DBASE                                      MD054955
     C**********         MOVEL     'CGRDECPD'    DBFILE                                     MD054955
     C**********         MOVEL     '*UNLOCK'     DBKEY                                      MD054955
     C**********         OUT       LDA                                                      MD054955
     C**********         EXSR      *PSSR                                                    MD054955
     C**********         EVAL      WNewVar = 'N'                                            MD054955
     C**********         ENDIF                                                              MD054955
     C                   ENDIF
      *
     C                   DOW       (WErrVar = 'Y' OR WRecErr = 'Y')
     C                             AND *INKC = *OFF
     C                             AND *INKL = *OFF
      *
      ** Write record format to display screen fields.
      *
     C                   WRITE     CG3624F0
     C                   WRITE     CG3624C0
      *
      ** Read record format
      *
     C                   READ      CG3624F0

     C                   RESET                   MsgIdAr
     C                   RESET                   MsgIdArr
      *
      ** Clear message subfile and error indicators
      *
     C                   IF        WRecErr = 'N'
     C                   CALL      'ZA0250'
     C                   ENDIF
     C                   EVAL      WErrVar = 'N'

     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *OFF

     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   EVAL      PFuncKey = '03'
      *
     C                   WHEN      *INKE = *ON
     C                   EVAL      #0ELEM = WSchema
     C                   EVAL      #0GRPN = WGroupNam
     C                   EVAL      WErrVar = 'Y'
      *
     C                   WHEN      *INKL = *ON
     C                   EVAL      PFuncKey = '12'
     C                   EVAL      PElement = WSchema
      *
     C                   WHEN      PSelOption <> 'E'
     C                   EXSR      SRVALD

     C                   ENDSL
     C                   ENDDO

     C                   EVAL      *INLR = *ON

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validating Element and Group Name Field             *
      *                                                               *
      *  Called by: Main Subroutine                                   *
      *                                                               *
      *  Calls: SRUPDT, CG3610, CG3611, AOCREPT                       *
      *                                                               *
      *****************************************************************
     C     SRVALD        BEGSR

     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      Idx = 0
     C                   EVAL      X = 1
     C                   EVAL      C = 1
     C                   RESET                   MsgIdAr

     C                   IF        #0ELEM <> *Blanks

     C                   CALLB     'CG3610'
     C                   PARM                    #0ELEM
     C                   PARM                    MsgIdAr
     C                   PARM      *Blanks       RetCodeOut

     C                   DOW       MsgIdAr(X) <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = MsgIdAr(X)
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   IF        RetCodeOut = *Blanks
     C                             AND WCGSyst <> #0ELEM

     C                   RESET                   MsgIdAr
     C                   EVAL      X = 1

     C                   CALLB     'CG3611'
     C                   PARM                    CGARGT
     C                   PARM      'SYST'        CGTYPE
     C                   PARM                    #0ELEM
     C                   PARM                    MsgIdAr
     C                   PARM                    RetCodeOut

     C                   DOW       MsgIdAr(X) <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = MsgIdAr(X)
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   ENDIF

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      *IN02 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      X = 1

     C                   IF        #0ELEM <> *Blanks
     C                             AND #0GRPN <> *Blanks

     C                   IF        #0ELEM = #0GRPN
     C                   EVAL      *IN03 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'CGD2582'
     C                   ENDIF

     C                   RESET                   MsgIdAr
     C                   EVAL      X = 1

     C                   CALLB     'CG3610'
     C                   PARM                    #0GRPN
     C                   PARM                    MsgIdAr
     C                   PARM      *Blanks       RetCodeOut

     C                   DOW       MsgIdAr(X) <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = MsgIdAr(X)
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   IF        RetCodeOut = *Blanks
     C                             AND WCGSygp <> #0GRPN

     C                   RESET                   MsgIdAr
     C                   EVAL      X = 1

     C                   CALLB     'CG3611'
     C                   PARM                    CGARGT
     C                   PARM      'SYGP'        CGTYPE
     C                   PARM                    #0GRPN
     C                   PARM                    MsgIdAr
     C                   PARM                    RetCodeOut

     C                   DOW       MsgIdAr(X) <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = MsgIdAr(X)
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   ENDIF

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      *IN03 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      PMsgFile = 'CGUSRMSG'
     C                   IF        Idx <> 0

     C                   DOW       C <= 25 AND
     C                             MsgIdArr(C) <> *Blanks
     C                   MOVEL     *Blanks       MsgId
     C                   MOVEL     MsgIdArr(C)   MsgId
     C                   EXSR      SRSNDMSG
     C                   ADD       1             C
     C                   ENDDO

     C                   EVAL      WErrVar = 'Y'

     C                   ENDIF

     C                   IF        #0ELEM = *Blanks
     C                             AND #0GRPN <> *Blanks
     C                   EVAL      WErrVar = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   EVAL      MsgID = 'CGD2579'
     C                   EVAL      PMsgFile = 'CGUSRMSG'
     C                   EXSR      SRSNDMSG
     C                   ENDIF

     C                   IF        WErrVar <> 'Y'
     C                   EXSR      SRUPDT
     C                   IF        WRecErr <> 'Y'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDT - Update CGRDECPD                                     *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUPDT        BEGSR

     C                   IF        WNewVar = 'Y'
     C                   IF        #0ELEM <> *Blanks
     C                   EVAL      CGARGT = #0SYST
     C                   EVAL      CGTYPE = 'SYST'
     C                   EVAL      CGNWFD = #0ELEM

     C**********         WRITE     CGRDECD0                             90                  MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGRDEBTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CGARGT                                                                            MD054955
     C+  ,CGTYPE                                                                            MD054955
     C+  ,CGNWFD                                                                            MD054955
     C+  ,CGMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CGARGT                                                                           MD054955
     C+  ,:CGTYPE                                                                           MD054955
     C+  ,:CGNWFD                                                                           MD054955
     C+  ,'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGRDEXTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CGARGT                                                                            MD054955
     C+  ,CGTYPE                                                                            MD054955
     C+  ,CGNWFD                                                                            MD054955
     C+  ,CGMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CGARGT                                                                           MD054955
     C+  ,:CGTYPE                                                                           MD054955
     C+  ,:CGNWFD                                                                           MD054955
     C+  ,'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
     C                   EVAL      MsgId = 'Y2U0004'
     C                   EXSR      SRRecErr

     C                   ELSE
     C                   EVAL      PElement = #0ELEM
     C                   ENDIF
     C                   ENDIF

     C                   ELSE

     C*****KSYST         CHAIN     CGRDECL0                           90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDEC                                                                        MD054955
     C+ from CGRDEJW0                                                                       MD054955
     C+ where CGTYPE = :WSystem and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955

     C**********         IF        *IN90 = '1'                                              MD054955
     C                   IF        SQLCODE = 100                                            MD054955
     C                   EVAL      MsgId = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE

     C                   EVAL      RecDets = CGRDEC                                         MD054955
     C                   IF        RecDets <> WRecDets

     C**********         UNLOCK    CGRDECL0                             90                  MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C******LOCK         IN        LDA                                                      MD054955
     C**********         Z-ADD     04            DBASE                                      MD054955
     C**********         MOVEL     'CGRDECPD'    DBFILE                                     MD054955
     C**********         MOVEL     '*UNLOCK'     DBKEY                                      MD054955
     C**********         OUT       LDA                                                      MD054955
     C**********         EXSR      *PSSR                                                    MD054955
     C**********         ENDIF                                                              MD054955

     C                   EVAL      MsgId = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE

     C                   SELECT

     C                   WHEN      #0ELEM = *Blanks
     C                             AND CGNWFD <> *Blanks
     C                   EVAL      PElement = *Blanks
     C**********         DELETE    CGRDECL0                             90                  MD054955
     C/EXEC SQL                                                                             MD054955
     C+ delete from CGRDEBTD                                                                MD054955
     C+ where CGTYPE = :WSystem and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ delete from CGRDEXTD                                                                MD054955
     C+ where CGTYPE = :WSystem and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
     C                   EVAL      MsgId = 'Y2U0004'
     C                   EXSR      SRRecErr
     C                   ENDIF

     C                   WHEN      #0ELEM <> *Blanks
     C                   EVAL      PElement = #0ELEM
     C                   EVAL      CGNWFD = #0ELEM
     C***********        UPDATE    CGRDECD0                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDEXTD set                                                                 MD054955
     C+ CGNWFD = :CGNWFD                                                                    MD054955
     C+ where CGTYPE = :WSystem and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        WNewVar2 = 'Y'
     C                   IF        #0GRPN <> *Blanks
     C                   EVAL      CGARGT = #0SYST
     C                   EVAL      CGTYPE = 'SYGP'
     C                   EVAL      CGNWFD = #0GRPN

     C**********         WRITE     CGRDECD0                             90                  MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGRDEBTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CGARGT                                                                            MD054955
     C+  ,CGTYPE                                                                            MD054955
     C+  ,CGNWFD                                                                            MD054955
     C+  ,CGMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CGARGT                                                                           MD054955
     C+  ,:CGTYPE                                                                           MD054955
     C+  ,:CGNWFD                                                                           MD054955
     C+  ,'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGRDEXTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CGARGT                                                                            MD054955
     C+  ,CGTYPE                                                                            MD054955
     C+  ,CGNWFD                                                                            MD054955
     C+  ,CGMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CGARGT                                                                           MD054955
     C+  ,:CGTYPE                                                                           MD054955
     C+  ,:CGNWFD                                                                           MD054955
     C+  ,'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
     C                   EVAL      MsgId = 'Y2U0004'
     C                   EXSR      SRRecErr
     C                   ENDIF
     C                   ENDIF

     C                   ELSE

     C*****KSYGP         CHAIN     CGRDECL0                           90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDEC                                                                        MD054955
     C+ from CGRDEJW0                                                                       MD054955
     C+ where CGTYPE = :WSystGP and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955

     C**********         IF        *IN90 = '1'                                              MD054955
     C                   IF        SQLCODE = 100                                            MD054955
     C                   EVAL      MsgId = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE

     C                   EVAL      RecDets = CGRDEC                                         MD054955
     C                   IF        RecDets <> WRecDets2

     C**********         UNLOCK    CGRDECL0                             90                  MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C******LOCK         IN        LDA                                                      MD054955
     C**********         Z-ADD     05            DBASE                                      MD054955
     C**********         MOVEL     'CGRDECPD'    DBFILE                                     MD054955
     C**********         MOVEL     '*UNLOCK'     DBKEY                                      MD054955
     C**********         OUT       LDA                                                      MD054955
     C**********         EXSR      *PSSR                                                    MD054955
     C**********         ENDIF                                                              MD054955

     C                   EVAL      MsgId = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE

     C                   SELECT

     C                   WHEN      #0GRPN = *Blanks
     C                             AND CGNWFD <> *Blanks
     C**********         DELETE    CGRDECL0                             90                  MD054955
     C/EXEC SQL                                                                             MD054955
     C+ delete from CGRDEBTD                                                                MD054955
     C+ where CGTYPE = :WSystGP and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ delete from CGRDEXTD                                                                MD054955
     C+ where CGTYPE = :WSystGP and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955
     C**********         IF        *IN90 = '1'                                              MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
     C                   EVAL      MsgId = 'Y2U0004'
     C                   EXSR      SRRecErr
     C                   ENDIF

     C                   WHEN      #0GRPN <> *Blanks
     C                   EVAL      PElement = #0ELEM
     C                   EVAL      CGNWFD = #0GRPN
     C***********        UPDATE    CGRDECD0                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDEXTD set                                                                 MD054955
     C+ CGNWFD = :CGNWFD                                                                    MD054955
     C+ where CGTYPE = :WSystGP and CGARGT = :WSyst                                         MD054955
     C/END-EXEC                                                                             MD054955

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDMSG - Send error message                                *
      *                                                               *
      *  Called by: Main Subroutine                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     SRSNDMSG      BEGSR

     C                   CALL      'AOCREPT'
     C                   PARM                    MsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecErr - Process errors in record-accessing                *
      *                                                               *
      *  Called by: Main Subroutine                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     SRRecErr      BEGSR

     C                   EVAL      *IN04 = '1'
     C                   EVAL      *IN05 = '1'
     C                   EVAL      WRecErr = 'Y'
     C                   EVAL      PSelOption = 'E'
     C                   EVAL      PMsgFile = 'Y2USRMSG'
     C                   EXSR      SRSNDMSG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation             *
      *                                                               *
      *  Called by: Main Subroutine                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Initialise all screen fields, indicators and function keys.
      *
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0PGM = '*'
      *
     C                   EVAL      #0SYST = *Blanks
     C                   EVAL      #0SYSD = *Blanks
     C                   EVAL      #0ELEM = *Blanks
     C                   EVAL      #0GRPN = *Blanks
      *
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN04 = *OFF
     C                   EVAL      *IN05 = *OFF
      *
     C                   EVAL      PFuncKey = *Blanks
      *
     C                   EVAL      WSchema = PElement
      *
      ** Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      ** Protect Element Name Field
      *
     C                   IF        PSelOption = 'E'
     C                   EVAL      *IN04 = *ON
     C                   EVAL      *IN05 = *ON
     C                   ENDIF
      *
      **  Initialise Variables
      *
     C                   EVAL      WErrVar = 'Y'
     C                   EVAL      WNewVar = 'Y'
     C                   EVAL      WNewVar2 = 'Y'
     C                   EVAL      WRecErr = 'N'
      *
     C                   EVAL      WSystem = 'SYST'
     C                   EVAL      WSyst = PSysField
     C                   EVAL      WSystGP = 'SYGP'
      *
     C                   EVAL      #0SYST = PSysField
     C                   EVAL      #0SYSD = PSysFldDesc
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: AOBANKR0                                              *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    PSysField
     C                   PARM                    PSysFldDesc
     C                   PARM                    PElement
     C                   PARM                    PSelOption
     C                   PARM                    PFuncKey
      *
     C     KSYST         KLIST
     C                   KFLD                    WSystem
     C                   KFLD                    WSyst
      *
     C     KSYGP         KLIST
     C                   KFLD                    WSystGP
     C                   KFLD                    WSyst
      *
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2002
