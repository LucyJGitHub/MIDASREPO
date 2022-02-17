     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Dropped Participant Contribution History')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  LE0464 -  Drop Participant's Contribution History Records    *
      *                                                               *
      *  Function:  This program will remove all Participants'        *
      *             Contribution History records linked to all        *
      *             Primary Facilities which have been dropped from   *
      *             the Facilities file                               *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR756564           Date 17May11               *
      *                 CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15159           Date 26Oct07               *
      *                 BUG13152           Date 25Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 10May06               *
      *                 BUG10716           Date 27Feb06               *
      *                 BUG10510           Date 14Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106  *CREATE    Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR756564 - LEC0464 00001 DBERR 002 in SDCURRPD.              *
      *             (Child: AR756565)                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15159 - Do not call AOBRCHR1 if branch is blank.          *
      *             Applied fix BUG14607. Codes already done by 13152.*
      *  BUG13152 - Do not call AOBRCHR1 if branch is blank           *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG10716 - Recompiled due to changes in LEPCHSPD.            *
      *  BUG10510 - Recompiled due to changes in LEPCHSPD.            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *  SrProcessPrint - Process printing of dropped participant     *
      *  SrPrntBrch - Print per branch                                *
      *  SrWriteP1  - Write records                                   *
      *  SrWrtHeader- Print header                                    *
      *  SrDelDrop  - Delete dropped participant history              *
      *  SrRtvCurr  - Retrieve facility currency                      *
      *  SrWP1End   - Print Footer                                    *
      *  ZSEdit     - Call to ZSEDIT                                  *
      *  AOCURR     - Call to AOCURRR0                                *
      *  *INZSR     - Initial routine                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+

      ** Midas MM Participants Contribution History
     FLEPCHSL0  UF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Closed/reversed facilities
     FPEFCLFL1  UF   E           K DISK    INFSR(*PSSR) RENAME(FCLTYFMF:FCLTYX)
     F                                     PREFIX(Y)

      ** Midas LE Customer lending facility file
     FFCLTY     IF   E           K DISK    INFSR(*PSSR) PREFIX(X)

      ** Dropped Participant Contribution History
     FLE0464P1  O    E             PRINTER INFDS(SPOOL1) INFSR(*PSSR)
     F                                     USROPN

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** File Information Data Structure for LE0464P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D WkPPrFacility   DS
     D**WkPrevPMFC             1      6  0                                                   CSD027A
     D  WkPrevPMFC             1      6                                                      CSD027A
     D  WkSep1                 7      7    INZ('-')
     D  WkPrevPMFT             8     10  0
     D  WkSep2                11     11    INZ('-')
     D  WkPrevPMFN            12     13  0

     D WkPartFal       DS
     D**WkPTFC**               1      6  0                                                   CSD027A
     D  WkPTFC                 1      6                                                      CSD027A
     D  WkSep1a                7      7    INZ('-')
     D  WkPTFT                 8     10  0
     D  WkSep2a               11     11    INZ('-')
     D  WkPTFN                12     13  0
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+

     D WDIFLN1         S              3  0 INZ(0)
     D WkPrevEVDT      S                   LIKE(EVDT)
     D WkPrevPRTR      S                   LIKE(PRTR)
     D WkPrintFlag     S              1A   INZ('N')
     D WkDtlFlag       S              1A   INZ('N')
     D WkPrevPMBR      S                   LIKE(PMBR)

      ** parameters for AOBANKRO

     D PRTCD           S              7A
     D POPTN           S              7A

      ** Calling parameters for ZDATE2
     D PDayNo          S              5  0 INZ(0)
     D PDtFmt          S              1    INZ(*BLANKS)
     D PDyMonYr        S              7    INZ(*BLANKS)
     D PError          S              1A   INZ(*BLANKS)
     D PMidasDt        S              6  0
     D PCCY            S              3A
     D PBranch         S              3A

      ** ZSEDIT parameters
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A

      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Read all records from LEPCHSL0

     C     *LOVAL        SETLL     LEPCHSL0

     C                   READ      LEPCHSL0
     C                   DOW       NOT %EOF(LEPCHSL0)

      ** Process printing

     C                   EXSR      SrProcessPrint

     C                   READ      LEPCHSL0
     C                   ENDDO

      ** Print Footer

     C                   IF        WkDtlFlag = 'N'
     C                   OPEN      LE0464P1
     C                   EVAL      BRCA = *BLANKS
     C                   EXSR      SrWrtHeader
     C                   EVAL      *IN80 = *ON
     C                   EVAL      WkPrintFlag = 'Y'
     C                   ENDIF

     C                   EXSR      SrWp1End

      ** Program wrap up

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcessPrint - Process printing of dropped participant      *
      *                  contribution history records                 *
      *                                                               *
      *****************************************************************
     C     SrProcessPrintBEGSR

     C                   EVAL      PRIMEFACT  = *BLANKS

     C                   IF        PMFC <> WkPrevPMFC OR
     C                             PMFT <> WkPrevPMFT OR
     C                             PMFN <> WkPrevPMFN

      ** Check if existing in Facilities Table

     C     DFCLKY        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)

      ** Store current Prime Facility to previous variable for
      ** referencing later

     C                   EVAL      WkPrevPMFC = PMFC
     C                   EVAL      WkPrevPMFT = PMFT
     C                   EVAL      WkPrevPMFN = PMFN

     C                   EVAL      PRIMEFACT = WkPPrFacility

     C                   EXSR      SrPrntBrch

     C                   ENDIF

     C                   ELSE

     C                   EXSR      SrPrntBrch

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrntBrch - Print per branch                                *
      *                                                               *
      *****************************************************************
     C     SrPrntBrch    BEGSR

     C                   IF        PMBR <> WkPrevPMBR

      ** Print Footer

     C                   EXSR      SrWp1End

      ** Open printer file

     C                   OPEN      LE0464P1
     C                   ENDIF

      ** Print report

     C                   EXSR      SrWriteP1

      ** Drop participant distribution history

     C                   EXSR      SrDelDrop

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteP1 - Write the participants contribution history      *
      *              records that must be removed                     *
      *                                                               *
      *****************************************************************
     C     SrWriteP1     BEGSR

     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1  <= 2 OR WkPrintFlag = 'N'
     C                   EXSR      SrWrtHeader
     C                   ENDIF

     C                   IF        PTFC <> WkPTFC   or PTFT <> WkPTFT
     C                             or PTFN <> WkPTFN or PRIMEFACT <> *BLANKS
     C
     C                   EVAL      WkPTFC = PTFC
     C                   EVAL      WkPTFT = PTFT
     C                   EVAL      WkPTFN = PTFN
     C                   EVAL      PARTIFACT = WkPartFal
     C                   ELSE
     C                   EVAL      PARTIFACT = *BLANKS
     C                   ENDIF

     C                   IF        PRTR <> WkPrevPRTR or PARTIFACT <> *BLANKS
     C                   EVAL      WkPrevPRTR = PRTR
     C                   SELECT
     C                   WHEN      PRTR = 'P'
     C                   EVAL      PARTITYPE = 'FUND PART'
     C                   WHEN      PRTR = 'S'
     C                   EVAL      PARTITYPE = 'SUB PART '
     C                   WHEN      PRTR = 'R'
     C                   EVAL      PARTITYPE = 'RISK PART'
     C                   WHEN      PRTR = 'I'
     C                   EVAL      PARTITYPE = 'INT PART '
     C                   ENDSL
     C                   ELSE
     C                   EVAL      PARTITYPE = *BLANKS
     C                   ENDIF

     C                   IF        EVDT <> WkPrevEVDT or PARTITYPE <> *BLANKS
     C                   EVAL      WKPrevEVDT = EVDT
     C                   CALL      'ZDATE2'
     C                   PARM      EVDT          PDayNo
     C                   PARM      BJDFIN        PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDyMonYr

     C                   EVAL      EVENTDATE = PDyMonYr
     C                   ELSE
     C                   EVAL      EVENTDATE = *BLANKS
     C                   ENDIF

     C                   MOVE      SEQN          SEQUENCE

      ** Prime Facility Amount

     C                   EVAL      ZFLD15 = PMFA
     C                   EXSR      ZSEdit
     C                   EVAL      FACTAMT = ZOUT21

      ** Share Percentage

     C                   EVAL      SHAREPRCNT = SHPC

      ** Share Amount

     C                   EVAL      ZFLD15 = SHAM
     C                   EXSR      ZSEdit
     C                   EVAL      SHAREAMT = ZOUT21

      ** Write P1 Header if required

     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1 <= 2
     C                   EXSR      SrWrtHeader
     C                   ENDIF

     C                   EVAL      WkPrintFlag = 'Y'
     C                   EVAL      WkDtlFlag = 'Y'

      ** Write detail

     C                   WRITE     DETFCLT

      ** Save facility branch and set as previous branch

     C                   EVAL      WkPrevPMBR = PMBR


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWrtHeader - Print Header                                   *
      *                                                               *
      *****************************************************************
     C     SrWrtHeader   BEGSR

     C                   IF        PMBR <> *BLANKS                                          BUG13152
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PMBR          PBRANCH
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRTCD <> *BLANKS

      ** Data base error in file SDBRCHPD

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PMBR
     C                   EVAL      DBASE  = 3
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      BRCA = PMBR
     C                   EVAL      BRNM = A8BRNM
     C                   ENDIF
     C                   ENDIF                                                              BUG13152
     C                   WRITE     HEADER

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWP1End - Print Footer                                      *
      *                                                               *
      *****************************************************************
     C     SrWP1End      BEGSR

     C                   IF        WkPrintFlag = 'Y'

     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1 <= 4
     C                   EXSR      SrWrtHeader
     C                   ENDIF

     C                   WRITE     TRAILPY

      ** Close printer file

     C                   CLOSE     LE0464P1

     C                   EVAL      WkPrintFlag = 'N'

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelDrop - Drop participant distribution history            *
      *                                                               *
      *****************************************************************
     C     SrDelDrop     BEGSR

     C                   DELETE    LEPCHSD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvCurr - Retrieve Facility Currency                       *
      *                                                               *
      *****************************************************************
     C     SrRtvCurr     BEGSR

     C*****PFCLTY        CHAIN     PEFCLFL1                                                 AR756564
     C     PFCLTY        CHAIN     PEFCLFL1                           90                    AR756564
     C                   IF        *IN90 = *OFF                                             AR756564
     C                   EVAL      PCCY = YFCCY                                             AR756564
     C                   EXSR      AOCURR                                                   AR756564
     C                   EVAL      ZDECS = A6NBDP                                           AR756564
     C                   ELSE                                                               AR756564
     C                   EVAL      ZDECS = 0                                                AR756564
     C                   ENDIF                                                              AR756564

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZSEdit - Call to 'ZSEDIT'                                    *
      *                                                               *
      *****************************************************************
     C     ZSEdit        BEGSR

     C**********         EXSR      AOCURR                                                   AR756564
     C**********         EVAL      ZDECS = A6NBDP                                           AR756564
     C                   EXSR      SrRtvCurr                                                AR756564

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C**********         PARM      A6NBDP        ZDECS                                      AR756564
     C                   PARM                    ZDECS                                      AR756564
     C                   PARM      *BLANK        ZECODE
     C                   PARM                    ZOUT21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AOCURR - Call to AOCURRR0                                    *
      *                                                               *
      *****************************************************************
     C     AOCURR        BEGSR

      ** Retrieve facility currency

     C**********         EXSR      SrRtvCurr                                                AR756564

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C**********         PARM      YFCCY         PCCY                                       AR756564
     C                   PARM                    PCCY                                       AR756564
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        (PRTCD <> *BLANKS)

      ** Data base error in file SDCURRPD

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  PCCY
     C                   EVAL      DBASE  =  2
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey  = *BLANKS
     C                   EVAL      DbPGM  = *BLANKS
     C                   EVAL      DbPGM  = 'LE0464'
     C                   EVAL      Dbase  = *ZERO
     C                   OUT       LDA

     C     DFCLKY        KLIST
     C                   KFLD                    PMFC
     C                   KFLD                    PMFT
     C                   KFLD                    PMFN

     C     PFCLTY        KLIST
     C                   KFLD                    PMBR
     C                   KFLD                    PMFC
     C                   KFLD                    PMFT
     C                   KFLD                    PMFN

      ** Get Bank ICD

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2005
