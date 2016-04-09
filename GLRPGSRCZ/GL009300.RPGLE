     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Submit Processing in COB')
      *****************************************************************
      *                                                               *
      *  Midas     -  General Ledger Module                           *
      *                                                               *
      *  GL009300  -  Midas GL Account Transfer Submit Job for        *
      *               Processing in COB                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27670           Date 13May10               *
      *  Prev Amend No. CGL114A            Date 12Mar10               *
      *                 BUG27219           Date 16Mar10               *
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27670 - Do not allow to run ATU during end of year COB    *
      *  CGL114A - CCR Interest Capitalisation                        *
      *  BUG27219- Format for message IDs in GBGLUSRMSG are for       *
      *            non-core                                           *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *                                                               *
      *****************************************************************
      *  Indicator    Description                                     *
      *  ~~~~~~~~~    ~~~~~~~~~~~                                     *
      *  10           SFLEND for message file                         *
      *                                                               *
      *  20           Record Not Found                                *
      *  21           File Error Occurred                             *
      *  22           Start/End Of File Reached                       *
      *  25           Table/Array Lookup                              *
      *                                                               *
      *  50           Protect Input fields.                           *
      *  51           Error on Batch Number.                          *
      *  52           Error on Batch Item.                            *
      *  53           Error on Department Code.                       *
      *  54           Error on Sweep Run Type.                        *
      *  55           Error on Transaction Type Cr.                   *
      *  56           Error on Transaction Type Dr.                   *
      *  57           Error on Narrative Description.                 *
      *  58           PC on Batch Number.                             *
      *  59           PC on Department Code.                          *
      *  60           PC on Transaction Type Cr.                      *
      *  61           PC on Transaction Type Dr.                      *
      *  62           Error on Narrative Code Cr.                     *
      *  63           Error on Narrative Code Dr.                     *
      *  64           PC on Narrative Code Cr.                        *
      *  65           PC on Narrative Code Dr.                        *
      *                                                               *
      *  U7           Database Errors                                 *
      *                                                               *
      *-------------------------------------------------------------- *
      *  Routine      Description                                     *
      *  ~~~~~~~      ~~~~~~~~~~~                                     *
      *  PFK03        Process Function Key 03 (Exit)                  *
      *  PFK05        Process Function Key 05 (Refresh)               *
      *  PFK12        Process Function Key 12 (Previous Screen)       *
      *                                                               *
      *  PDFD1        Process Display Format - Detail (D1)            *
      *                                                               *
      *  XSDFD1       Set Display Format - Detail (D1)                *
      *                                                               *
      *  XCPMSQ       Clear Messages from Program Message Queue       *
      *  XSPMSQ       Send Messages to Program Message Queue          *
      *                                                               *
      *  XVDFD1       Validate Detail Screen Input                    *
      *                                                               *
      *  *PSSR        Database Error Routine                          *
      *  *INZSR       Initial Routine                                 *
      *  @DEFN        Definitions, datastructures, dataareas, etc.    *
      *                                                               *
      *---------------------------------------------------------------*
      *  File         Description                                     *
      *  ~~~~         ~~~~~~~~~~~                                     *
      *  GL009300DF   Midas GL Posting Interface Display File         *
      *                                                               *
      *****************************************************************
 
     F/EJECT
 
     FGL009300DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(D@WKS)
 
     FGLSLACL4  IF   E           K DISK    INFSR(*PSSR)
 
     FGLIPDFPD  IF   E           K DISK    INFSR(*PSSR)                                      CGL114A
                                                                                             CGL114A
     FGLATULPD  UF A E           K DISK    INFSR(*PSSR)
 
     D/EJECT
 
     D LDA           E DS                  EXTNAME(LDA)
 
      ** Definition: File information Feedback.
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D PSDS           SDS
 
      ** Definition: Program status.
 
     D  @PGM                   1     10
     D  @JOB                 244    253
     D  @USER                254    263
     D  @JOBN                264    269S 0
     D  @TIME                282    287S 0
 
      * Definition: Workstation status.
 
     D D@WKS           DS
     D  D@0256                 1    256
     D  D@0004               257    260
     D  D@FMTN               261    270
     D  D@0099               271    369
     D  D@CRSR               370    371B 0
 
      ** Definition: First DS for Access Programs, Short Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Definition: Second DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * Definition: Bank Details Accessed Via Access Program.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D ACCTFR          DS
     D  REQD                   1      1
 
     D RUNDAT          DS
     D  MBIN                  13     13
 
     D ATCRTD          DS
     D  DDMMM                  1      5
     D  YYYY                   6      9
 
     ** ZA0140 parameters
 
     D P1DAYN          S              5  0
     D P1DFMT          S              1
     D P1DATE          S              6  0
     D P1DATA          S              7
     D P1RTN           S              1
     D P1DAT8          S              8  0
 
     DATNARR_YN        C                   'ACCTFR Before Image: Y  ACCFR After-
     D                                       Image: N'
     DATNARR_NY        C                   'ACCTFR Before Image: N  ACCFR After-
     D                                       Image: Y'
     DCOUNT            S             10S 0 INZ(*ZERO)
 
     C/EJECT
 
      ** Main Processing Control.
 
     C     *INLR         DOWEQ     '0'
 
     C                   EXSR      XCPMSQ
 
     C     *INKC         CASEQ     *ON           PFK03
     C     *INKE         CASEQ     *ON           PFK05
     C     *INKL         CASEQ     *ON           PFK12
     C     *INKV         CASEQ     *ON           PFK21
     C     D@FMTN        CASEQ     'GL009300D1'  PDFD1
     C                   CAS                     XSDFD1
     C                   ENDCS
     C  NLR              READ      GL009300DF                             LR
     C                   ENDDO
 
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PFK03: Process Function Key 3 - Exit                         *
      *                                                               *
      *****************************************************************
     C     PFK03         BEGSR
 
     C                   MOVE      *ON           *INLR
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PFK05: Process Function Key 5 - Refresh Screen               *
      *                                                               *
      *****************************************************************
     C     PFK05         BEGSR
 
     C                   Z-ADD     *ZERO         WKERR
     C                   MOVEA     '0000000'     *IN(51)
     C                   MOVEA     '1000'        *IN(58)
     C                   EXSR      XSDFD1
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PFK12: Process Function Key 12 - Previous Screen             *
      *                                                               *
      *****************************************************************
     C     PFK12         BEGSR
 
     C                   Z-ADD     *ZERO         WKERR
     C                   MOVE      *ON           *INLR
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PFK21: Process Function Key 21 - Print Accounts              *
      *                                                               *
      *****************************************************************
     C     PFK21         BEGSR
 
      ** Call FC0040X to report movements
 
     C                   CALL      'FC0040X'                            90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      'GL000572'    P@RNAM           10
     C                   PARM      'GLC000572'   P@COTT           10
     C                   PARM      '10001'       P@CSEQ            5
     C                   PARM      *BLANKS       P@CLPM          100
     C                   PARM      MBIN          P@MBIN            1
     C                   PARM      'S'           P@LVL             1
     C                   PARM      *BLANKS       P@ETTY            3
 
     C     *IN90         IFEQ      *ON
     C     P@RTCD        ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVE      'FC0040X '    DBKEY
     C                   MOVEL     @PGM          DBPGM
     C                   Z-ADD     005           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      **********         MOVEL     'XX00052'     P@MSGI                                     BUG27219
     C                   MOVEL     'ATU0052'     P@MSGI                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   EXSR      XSDFD1
     C                   END
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PDFD1: Process Display Format - Detail (D1)                  *
      *                                                               *
      *****************************************************************
     C     PDFD1         BEGSR
 
      ** Process Detail Screen.
 
     C                   MOVEA     '0000000'     *IN(51)
     C                   MOVEA     '0000'        *IN(58)
     C                   MOVE      *BLANKS       P@MSGI
 
      ** Validate Input
 
     C                   EXSR      XVDFD1
 
     C     BDDICR        IFEQ      'Y'                                                       CGL114A
     C     SREQD         IFEQ      'Y'                                                       CGL114A
     C                   MOVE      ' '           PRTCD             1                         CGL114A
     C                   MOVE      'C'           PRQCD             1                         CGL114A
     C                   MOVE      *BLANKS       PUCTR                                       CGL114A
     C                   CALL      'GL019600'                                                CGL114A
     C                   PARM                    PRTCD                                       CGL114A
     C                   PARM                    PRQCD                                       CGL114A
     C                   PARM                    PUCTR                                       CGL114A
     C     PRTCD         IFEQ      'F'                                                       CGL114A
     C                   MOVEL     'ATU0061'     P@MSGI                                      CGL114A
     C                   EXSR      XSPMSQ                                                    CGL114A
     C                   ADD       1             WKERR                                       CGL114A
     C                   ENDIF                                                               CGL114A
     C                   ENDIF                                                               CGL114A
     C     SREQD         IFEQ      'N'                                                       CGL114A
     C     REQD          ANDEQ     'Y'                                                       CGL114A
     C                   MOVE      ' '           PRTCD             1                         CGL114A
     C                   MOVE      'W'           PRQCD             1                         CGL114A
     C                   MOVE      *BLANKS       PUCTR             6                         CGL114A
      *                                                                                      CGL114A
     C                   CALL      'GL019600'                                                CGL114A
     C                   PARM                    PRTCD                                       CGL114A
     C                   PARM                    PRQCD                                       CGL114A
     C                   PARM                    PUCTR                                       CGL114A
     C     PRTCD         IFEQ      'F'                                                       CGL114A
     C                   MOVEL     'ATU0065'     P@MSGI                                      CGL114A
     C                   EXSR      XSPMSQ                                                    CGL114A
     C                   ADD       1             WKERR                                       CGL114A
     C                   ENDIF                                                               CGL114A
     C                   ENDIF                                                               CGL114A
     C                   ENDIF                                                               CGL114A
                                                                                             CGL114A
      ** If there are any errors, redisplay detail screen,
      ** otherwise update the file.
 
     C     WKERR         IFEQ      *ZERO
     C     SREQD         IFNE      REQD
     C                   MOVE      SREQD         REQD
     C                   OUT       ACCTFR
 
      ** If ACCTFR value has changed, log the details to PF/GLATULPD
 
     C                   EXSR      LOG_ACCTFR
 
      ** Submit request for utility to run in the close of business
 
     C                   IF        SREQD = 'Y'
     C                   EXSR      SRCobRequest
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      XCPMSQ
                                                                                             CGL114A
     C     PRTCD         IFEQ      'C'                                                       CGL114A
                                                                                             CGL114A
     C     SREQD         IFEQ      'Y'                                                       CGL114A
     C                   MOVEL     'ATU0063'     P@MSGI                                      CGL114A
     C                   ELSE                                                                CGL114A
     C                   MOVEL     'ATU0064'     P@MSGI                                      CGL114A
     C                   ENDIF                                                               CGL114A
                                                                                             CGL114A
     C                   EVAL      P@MDTA = PUCTR                                            CGL114A
      *                                                                                      CGL114A
     C                   EXSR      XSPMSQ                                                    CGL114A
     C                   WRITE     GL009300H1                                                CGL114A
     C                   WRITE     GL009300F1                                                CGL114A
     C                   WRITE     MSGCTL                                                    CGL114A
     C                   WRITE     GL009300D1                                                CGL114A
     C     *LOCK         IN        ACCTFR                                                    CGL114A
     C                   LEAVESR                                                             CGL114A
     C                   ENDIF                                                               CGL114A
 
     C                   MOVE      *ON           *INLR
     C                   ELSE
     C                   WRITE     GL009300H1
     C                   WRITE     GL009300F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL009300D1
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSDFD1: Set Display Format - Detail Screen (D1)              *
      *                                                               *
      *****************************************************************
     C     XSDFD1        BEGSR
 
      ** Display Detail Screen.
 
     C                   WRITE     GL009300H1
     C                   WRITE     GL009300F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL009300D1
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XVDFD1: Validate Detail Screen Input                         *
      *                                                               *
      *****************************************************************
     C     XVDFD1        BEGSR
 
     C                   Z-ADD     0             WKERR             9 0
 
      ** Validate 'Branch Code'. Must not be blank and must be valid.
 
     C     SREQD         IFNE      'Y'
     C     SREQD         ANDNE     'N'
      **********         MOVEL     'XX00026'     P@MSGI                                     BUG27219
     C                   MOVEL     'ATU0026'     P@MSGI                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN61
     C                   END
                                                                                             CGL114A
     C     SREQD         IFEQ      REQD                                                      CGL114A
     C                   MOVEL     'ATU0066'     P@MSGI                                      CGL114A
     C                   EXSR      XSPMSQ                                                    CGL114A
     C                   ADD       1             WKERR                                       CGL114A
     C                   END                                                                 CGL114A
                                                                                            BUG27670
     C     BJEYD         IFLT      BJDNWD                                                   BUG27670
     C     SREQD         ANDEQ     'Y'                                                      BUG27670
     C                   MOVEL     'ATU0067'     P@MSGI                                     BUG27670
     C                   EXSR      XSPMSQ                                                   BUG27670
     C                   ADD       1             WKERR                                      BUG27670
     C                   ENDIF                                                              BUG27670
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XCPMSQ: Clear Program Message Queue                          *
      *                                                               *
      *****************************************************************
     C     XCPMSQ        BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      @PGM          P@PMSQ
     C                   PARM      '*SAME'       P@PMSL
 
     C                   MOVEA     '00000000'    *IN(61)
     C                   MOVEA     '00000'       *IN(69)
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSPMSQ: Send Messages to Program Message Queue               *
      *                                                               *
      *****************************************************************
     C     XSPMSQ        BEGSR
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      @PGM          P@PMSQ           10
     C                   PARM      '*SAME'       P@PMSL            5
     C                   PARM                    P@MSGI            7
     C                   PARM      'GLUSRMSG'    P@MSGF           10
     C                   PARM                    P@MDTA          132
     C                   PARM      '*INFO'       P@MTYP            7
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  LOG_ACCTFR: If ACCTFR value has changed, log the details to  *
      *              PF/GLATULPD                                      *
      *                                                               *
      *****************************************************************
     C     LOG_ACCTFR    BEGSR
 
      ** Creation Date in DDMMMYYYY (ATCRTD)
 
     C                   EVAL      DDMMM = %SUBST(BJMRDT:1:5)
 
      ** Narrative (ATNARR i.e. 'ACCTFR Before Image: x ACCTFR After Image: z'
      **            where x - value of ACCTFR before update;
      **            where z - value of ACCTFR after update)
 
     C                   IF        REQD = 'Y'
     C                   EVAL      ATNARR = ATNARR_NY
     C                   ELSE
     C                   EVAL      ATNARR = ATNARR_YN
     C                   ENDIF
 
      ** Job Name (ATJOB)
 
     C                   EVAL      ATJOB = @JOB
 
      ** User Name (ATUSER)
 
     C                   EVAL      ATUSER = @USER
 
      ** Job Number (ATJOBN)
 
     C                   MOVEL     @JOBN         ATJOBN
 
      **  Date in Number of Days (ATORED)
 
     C                   EVAL      ATORED = BJRDNB
 
      ** Current Time in HHMM (ATTIME)
 
     C                   MOVEL     @TIME         ATTIME
 
      ** Timestamp (ATTMST)
 
     C                   EVAL      ATTMST = %TimeStamp
 
      ** Write details to PF/GLATULPD
 
     C                   WRITE     GLATULD0
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCobRequest - Request Account Transfer to run in COB        *
      *                                                               *
      *****************************************************************
     C     SRCobRequest  BEGSR
 
     C                   CALL      'CB000104'
     C                   PARM      'ACCTFR'      P@COTT
     C                   PARM      '10001'       P@CSEQ
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR: Initial Routine                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Clear Error Reference Fields in LDA.
 
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
     C                   MOVEL     @PGM          DBPGM
     C                   OUT       LDA
 
      ** Retrieve Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVE      @OPTN         DBKEY
     C                   MOVEL     @PGM          DBPGM
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   END
 
     C                   MOVE      BJMRDT        SCDAT#
 
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
     C     *LOCK         IN        ACCTFR
     C                   MOVEL     REQD          SREQD
 
      ** Access Midas Rundate from data area RUNDAT
 
     C     *LOCK         IN        RUNDAT
 
      ** Initialise parameters, work fields, etc.
 
     C                   MOVE      *ON           *IN10
     C                   MOVE      *ON           *IN80
 
     C                   READ      GLIPDFPD                             2122                 CGL114A
                                                                                             CGL114A
     C     *IN21         IFEQ      '1'                                                       CGL114A
     C     *IN22         OREQ      '1'                                                       CGL114A
     C     *LOCK         IN        LDA                                                       CGL114A
     C                   MOVEL     'GLIPDFPD'    DBFILE                                      CGL114A
     C                   MOVE      @OPTN         DBKEY                                       CGL114A
     C                   MOVEL     @PGM          DBPGM                                       CGL114A
     C                   Z-ADD     004           DBASE                                       CGL114A
     C                   OUT       LDA                                                       CGL114A
                                                                                             CGL114A
     C                   EXSR      *PSSR                                                     CGL114A
                                                                                             CGL114A
     C                   END                                                                 CGL114A
                                                                                             CGL114A
      ** Get total count of 'Accounts to be Transferred'
 
     C                   EVAL      COUNT = 0
     C     *LOVAL        SETLL     GLSLACD0
     C                   READ      GLSLACD0                               99
     C                   DOW       NOT %EOF
     C                   IF        SLSTAT = 'CR'
     C                   EVAL      COUNT = COUNT + 1
     C                   ENDIF
     C                   READ      GLSLACD0                               99
     C                   ENDDO
 
     C                   EVAL      ACTRAN = %EDITC(COUNT:'J')
 
     C                   CALL      'ZA0140'
     C                   PARM      BJRDNB        P1DAYN
     C                   PARM      BJDFIN        P1DFMT
     C                   PARM                    P1DATE
     C                   PARM                    P1DATA
     C                   PARM                    P1RTN
     C                   PARM                    P1DAT8
 
     C                   IF        P1RTN = '0'
     C                   MOVEL     P1DAT8        YYYY
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR: Error Handling                                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not been called yet
 
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   END
 
      ** If *PSSR already run, then just end the program here
 
     C                   SETON                                            LR
     C                   RETURN
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  @DEFN: Definition Routine  (Not Called)                      *
      *                                                               *
      *****************************************************************
     C     @DEFN         BEGSR
 
      ** Define Data Areas
 
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  ACCTFR
     C     *DTAARA       DEFINE                  RUNDAT
 
      ** Define Variables.
 
     C     *LIKE         DEFINE    @OPTN         WKOPTN
 
     C                   ENDSR
