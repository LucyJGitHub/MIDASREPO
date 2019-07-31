     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG System fields maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3623 - System Fields Maintenance                           *
      *                                                               *
      *  Function:  This program lists in alphabetical order all the  *
      *             RDEs for group set 'SYSTEM'.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    11         End of file/No record found                     *
      *    12         End of file/No record found                     *
      *    41         Subfile Display                                 *
      *    42         Subfile Clear                                   *
      *    43         Subfile Next change                             *
      *    44         Display Attributes of Position field #0POSI     *
      *    45         Display Attributes of Selection field #0SELE    *
      *    47         Subfile End                                     *
      *    48         Enable/Disable RollUp key                       *
      *    49         RollUp key has been pressed                     *
      *    50         No Details to Process                           *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRBUILD - Build subfile                                      *
      *  SRERROR - Handles error messages                             *
      *  SRRFRSH - Refresh subfile                                    *
      *  SRRVIEW - Position subfile on RDE entered                    *
      *  SRVALD  - Validate Selection Option entered                  *
      *                                                               *
      *  *INSZR  - Initialisation routine                             *
      *  *PSSR   - Program Error Processing Subroutine                *
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
 
     FCGRASCL1  IF   E           K DISK    INFSR(*PSSR)
     FCGRDECL0  IF   E           K DISK    INFSR(*PSSR)
     FCG3623DF  CF   E             WORKSTN
     F                                     SFILE(CG3623S0:Wrrn)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PReturnCode     S             10
     D PSysFld         S             10
     D PSysFldDes      S             30
     D PSelect         S              1
     D PElemName       S             30
     D PFuncKey        S              2
     D PRtcd           S              7
     D POptn           S              7
     D PMsgID          S              7
     D PMsgFile        S             10
     D PMsgData        S            244
     D PText1          S            132
     D PText2          S            512
     D PRtnCode        S              7
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
 
     D WGrpS           S              6    INZ(*BLANKS)
     D WPointer        S             10    INZ(*BLANKS)
     D WError          S              1    INZ(*BLANKS)
     D WCall39         S              1    INZ(*BLANKS)
     D WSave           S             60    INZ(*BLANKS)
     D WRun            S              1    INZ(*BLANKS)
     D WSflCtr         S              1S 0 INZ(0)
     D WrkRrn          S              4S 0 INZ(0)
     D Wrrn            S              4S 0 INZ(0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Clear subfile
 
     C                   EVAL      *IN42 = '1'
     C                   WRITE     CG3623C0
     C                   EVAL      *IN42 = '0'
 
     C     WGrpS         CHAIN     CGRASCL1                           11
 
      ** If a 'SYSTEM' record is found, build subfile.
 
     C                   IF        *IN11 = '0'
     C                   EXSR      SRBUILD
 
      ** If no record found, send message 'No Details To Display'.
 
     C                   ELSE
     C                   EVAL      *IN41 = '0'
     C                   EVAL      *IN48 = '1'
     C                   EVAL      *IN50 = '1'
     C                   EVAL      PMsgID = 'CGD2580'
     C                   EXSR      SRERROR
     C                   ENDIF
 
      ** Display screen while F3 is not pressed.
 
     C                   DOW       PFuncKey <> '03'
 
     C                   WRITE     CG3623F0
     C                   WRITE     CG3623F1
     C                   WRITE     CG3623C1
     C                   EXFMT     CG3623C0
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = '1'
     C                   MOVEA     '00'          *IN(44)
     C                   EVAL      *IN48 = '0'
 
     C                   SELECT
 
      ** F3 pressed
 
     C                   WHEN      *INKC = '1'
     C                   EVAL      PFuncKey = '03'
 
      ** F5 pressed
 
     C                   WHEN      *INKE = '1'
     C                   EXSR      SRRFRSH
 
      ** Rollup
 
     C                   WHEN      *IN49 = '1'
     C                   EXSR      SRBUILD
 
      ** No details processed
 
     C                   WHEN      *IN50 = '1'
     C                   ITER
 
     C                   OTHER
 
     C                   IF        #0POSI <> *BLANKS AND #0POSI <> WSave
     C                   EXSR      SRRVIEW
     C                   ELSE
     C                   EXSR      SRVALD
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBUILD - Build subfile one page at a time                   *
      *                                                               *
      *  Called by: Main, SRRFRSH                                     *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRBUILD       BEGSR
 
     C                   EVAL      Wrrn = WrkRrn
     C                   EVAL      WSflCtr = 0
     C                   MOVEA     '00'          *IN(47)
 
      ** Fill subfile until one page is full or until all
      ** 'SYSTEM' records are written to subfile.
 
     C                   DOW       *IN11 = '0' AND WSflCtr < 7
 
     C                   ADD       1             WSflCtr
     C                   ADD       1             Wrrn
     C                   EVAL      WrkRrn = Wrrn
     C                   EVAL      #0SFRN = Wrrn
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0SRDE = RARDE
     C                   EVAL      #0DESC = RADESC
 
      ** If system field doesn't exist in CGRDECPD,
      ** set Element Name to '*UNDEFINED'.
 
     C                   EVAL      CGTYPE = 'SYST'
     C                   EVAL      CGARGT = RARDE
 
     C     KRDEC         CHAIN     CGRDECD0                           12
 
     C                   IF        *IN12 = '1'
     C                   EVAL      #0ELEM = PText1
     C                   ELSE
     C                   EVAL      #0ELEM = CGNWFD
     C                   ENDIF
 
      ** Write to subfile
 
     C                   WRITE     CG3623S0
 
     C     WGrpS         READE     CGRASCL1                               11
 
      ** If all records have been written, disable Rollup.
 
     C                   IF        *IN11 = '1'
     C                   MOVEA     '11'          *IN(47)
     C                   ENDIF
 
      ** Save location of file pointer.
 
     C                   EVAL      WPointer = RARDE
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Selection Option entered                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRERROR, CG3624                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
     C                   EVAL      WError = 'N'
     C                   EVAL      WCall39 = 'N'
 
     C                   READC     CG3623S0                               12
 
      ** Validate selection field while not EOF
 
     C                   DOW       *IN12 = '0'
 
      ** Selection field must be 'A', 'E', or blanks.
 
     C                   IF        #0SELE <> 'A' AND #0SELE <> 'E'
     C                             AND #0SELE <> *BLANKS
     C                   IF        WError = 'N'
     C                   EVAL      #0SFRN = Wrrn
     C                   ENDIF
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN45 = '1'
     C                   ENDIF
 
      ** If selection field is 'A' or 'E', prepare call to module CG3624.
 
     C                   IF        #0SELE = 'A' OR #0SELE = 'E'
     C                   EVAL      WCall39 = 'Y'
     C                   ENDIF
 
      ** Update subfile record with indicator for SFLNXTCHG set to on.
 
     C                   EVAL      *IN43 = '1'
     C                   UPDATE    CG3623S0
     C                   EVAL      *IN43 = '0'
     C                   EVAL      *IN45 = '0'
 
     C                   READC     CG3623S0                               12
 
     C                   ENDDO
 
     C                   SELECT
 
      ** Send error message 'Selection Option must be A, E or blank'.
 
     C                   WHEN      WError = 'Y'
     C                   EVAL      PMsgID = 'CGD2562'
     C                   EXSR      SRERROR
 
      ** Call CG3624 while there are valid selected records,
      ** and until F3 or F12 is returned.
 
     C                   WHEN      WCall39 = 'Y'
     C                   EVAL      PFuncKey = *BLANKS
 
     C                   DOU       *IN12 = '1' OR PFuncKey <> *BLANKS
     C                   READC     CG3623S0                               12
 
     C                   IF        *IN12 = '0' AND (#0SELE = 'A'
     C                             OR #0SELE = 'E')
     C                   IF        #0ELEM = PText1
     C                   EVAL      #0ELEM = *BLANKS
     C                   ENDIF
     C                   CALLB     'CG3624'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      #0SRDE        PSysFld
     C                   PARM      #0DESC        PSysFldDes
     C     #0ELEM        PARM      #0ELEM        PElemName
     C                   PARM      #0SELE        PSelect
     C                   PARM      *BLANKS       PFuncKey
 
     C                   IF        #0ELEM = *BLANKS
     C                   EVAL      #0ELEM = PText1
     C                   ENDIF
 
     C                   EVAL      #0SFRN = Wrrn
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      *IN43 = '1'
     C                   UPDATE    CG3623S0
     C                   EVAL      *IN43 = '0'
     C                   ENDIF
 
     C                   ENDDO
 
      ** If user just pressed Enter without positioning/selecting
      ** any record, display 1st page of subfile.
 
     C                   OTHER
     C                   EVAL      #0SFRN = 1
     C                   IF        #0POSI = *BLANKS
     C                   EXSR      SRRFRSH
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRVIEW - Position subfile on RDE entered                    *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRERROR, SRRFRSH                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRVIEW       BEGSR
 
     C                   EVAL      WSave = #0POSI
     C                   EVAL      RARDE = #0POSI
 
      ** Search file for RDE indicated.
 
     C     KRASC         SETLL     CGRASCL1
     C     WGrpS         READE     CGRASCL1                               11
 
      ** If no record is read, send error message 'No Details To Display'.
 
     C                   IF        *IN11 = '1'
     C                   EVAL      *IN41 = '0'
     C                   EVAL      *IN44 = '1'
     C                   EVAL      *IN48 = '1'
     C                   EVAL      PMsgID = 'CGD2580'
     C                   EVAL      WSave = *BLANKS
     C                   EXSR      SRERROR
 
     C                   EVAL      RARDE = WPointer
     C     KRASC         CHAIN     CGRASCL1                           11
 
      ** Else, build subfile starting from record retrieved.
 
     C                   ELSE
 
      ** Clear subfile
 
     C                   EVAL      *IN42 = '1'
     C                   WRITE     CG3623C0
     C                   EVAL      *IN42 = '0'
     C                   EVAL      WrkRrn = 0
 
     C     KRASC         CHAIN     CGRASCL1                           11
     C                   EXSR      SRBUILD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRFRSH - Refresh subfile                                    *
      *                                                               *
      *  Called by: Main, SRRVIEW                                     *
      *                                                               *
      *  Calls    : SRBUILD                                           *
      *                                                               *
      *****************************************************************
 
     C     SRRFRSH       BEGSR
 
      ** Clear subfile
 
     C                   EVAL      *IN42 = '1'
     C                   WRITE     CG3623C0
     C                   EVAL      *IN42 = '0'
 
     C                   EVAL      WrkRrn = 0
     C                   EVAL      #0POSI = *BLANKS
     C                   EVAL      WSave = *BLANKS
 
     C     WGrpS         CHAIN     CGRASCL1                           11
 
     C                   EXSR      SRBUILD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERROR - Handles error messages                             *
      *                                                               *
      *  Called by: SRVALD, SRRVIEW                                   *
      *                                                               *
      *  Calls    : AOCREPT                                           *
      *                                                               *
      *****************************************************************
 
     C     SRERROR       BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
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
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0                                          *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KRDEC         KLIST
     C                   KFLD                    CGTYPE
     C                   KFLD                    CGARGT
 
     C     KRASC         KLIST
     C                   KFLD                    WGrpS
     C                   KFLD                    RARDE
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Initialise fields and indicators
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcPgm
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
      ** Extract message '*UNDEFINED' via CLP CGC0100.
 
     C                   CALL      'CGC0100'
     C                   PARM      'CGD2583'     PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgData
     C                   PARM      *BLANKS       PText1
     C                   PARM      *BLANKS       PText2
     C                   PARM      *BLANKS       PRtnCode
 
      ** Database error if message id does not exist.
 
     C                   IF        PRtnCode = '*NRF   '
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = PMsgFile
     C                   EVAL      DBKEY = PMsgID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0POSI = *BLANKS
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0SRDE = *BLANKS
     C                   EVAL      #0DESC = *BLANKS
     C                   EVAL      #0ELEM = *BLANKS
     C                   EVAL      WGrpS = 'SYSTEM'
     C                   EVAL      #0SFRN = 1
     C                   EVAL      *IN41 = '1'
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *  Called by: *INZSR                                                *
      *                                                                   *
      *  Calls    : DBERRCTL                                              *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
