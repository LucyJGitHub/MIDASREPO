     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Non-RC Facility Upd for Maturing MM Loans')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000031 - Non-Revolving Credit Facility Update for Maturing *
      *             Money Market Loans                                *
      *                                                               *
      *  Function: This program updates non-revolving credit          *
      *  (COB)     facilities for MM loans maturity . The facility    *
      *            amount is adjusted to take account of the new      *
      *            amount outstanding. The program extracts details   *
      *            from the PF/HISACT                                 *
      *                                                               *
      *  Called By: LERC20                                            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. AR674226           Date 04Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE041             Date 11Oct04               *
      *                 BUG3282 *CREATE    Date 17Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  BUG3282 - Non-RVCR facility amount reduction for maturing    *
      *            MM loans                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FHISACTL2  IF   E           K DISK    RENAME(HISACTF:HISACTF2)
     F                                     PREFIX(H1)
      ** Midas LE Facility amendment history action

     FHISACTL3  IF   E           K DISK
      ** Midas LE Facility RVCR amendment history action

     FFCLTY     UF   E           K DISK
     F                                     IGNORE(FCLTYHHF)
      ** Midas LE Customer Lending facility file

     FPEFCLFL1  IF   E           K DISK    RENAME(FCLTYFMF:FCLTYFMP)
     F                                     PREFIX(PE)
      ** Midas LE Closed/reversed facilities

     FLECARDPD  O    E             DISK    USROPN
      ** Credit Agreement Reduction Extract File
                                                                                              CLE041
     FLETRAGL0  IF   E           K DISK                                                       CLE041
      ** Tranche-Aggregate Facility Relationship by Tranche                                   CLE041
                                                                                              CLE041
     FLEAGRDPD  O    E             DISK    USROPN                                             CLE041
      ** Aggregate Facility Reduction Extract table                                           CLE041

     FLE000031P1O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN50)
     F                                     USROPN
      ** Midas LE Non-RVCR Facility Update - Printer

     FLE000031AUO    E             PRINTER
      ** Midas LE Non-RVCR Facility Update - Audit

      /EJECT

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      /SPACE 3

     D PSDS           SDS
     D  JOB                  244    253
     D  WSID                 244    246
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID.

     D WkNewK          DS
     D**HACNUM**               1      6  0                                                    CSD027
     D  HACNUM                 1      6                                                       CSD027
     D  HAFacT                 7      9  0
     D  HAFcNo                10     11  0
     D  HAFCTY                 7     11  0
      ** Facility Reference Data Structure.

     D WkPrvK          DS
     D**PFCUS***               1      6  0                                                    CSD027
     D  PFCUS                  1      6                                                       CSD027
     D  PFTYP                  7      9  0
     D  PFSEQ                 10     11  0
      ** Previous Facility Reference Data Structure.

     D                 DS
     D  OFAMT                  1     13  0
     D  OFAM1                  1     13  1
     D  OFAM2                  1     13  2
     D  OFAM3                  1     13  3
      ** Old Facility Amount.

     D                 DS
     D  RFAMT                  1     13  0
     D  RFAM1                  1     13  1
     D  RFAM2                  1     13  2
     D  RFAM3                  1     13  3
      ** Reduced Facility Amount.

     D                 DS
     D  DFAMT                  1     13  0
     D  DFAM1                  1     13  1
     D  DFAM2                  1     13  2
     D  DFAM3                  1     13  3
      ** Difference in Facility Amount.

     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      ** File Information Data Structure.

     D RUNDAT        E DS
     D  MBIN         E                     EXTFLD(AGMBIN)
      ** RUNDAT Data Area.

     D LDA           E DS                  EXTNAME(LDA)
      ** Local Data Area.

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRNM         E                     EXTFLD(A8BRNM)
      ** Branch Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structures for SAR Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs.

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access programs.

     D WRtCd           S              7
     D WOptn           S              7
     D WSard           S              6
     D WkProcAc        S              1
     D WkRVCR          S              1
     D CLE005          S              1
     D KFRcdT          S              1
     D WkFAmt          S             13  0
     D WRKTOT          S             18  0
     D RCOUNT          S              5  0
     D SENTY           S              3
     D ZSERR           S              1
     D STRBRC          S              3
     D ZSNUM           S              6  0
     D SEQ             S              5
     D WTMFT           S              3  0
     D WTMFN           S              2  0
     D WTMRC           S              1
     D WRUN            S              1
     D BIS@            S             80

      /EJECT

      ** Main Processing
      *
      ** Perform Initialisation.
     C                   EXSR      SRInit

      ** Perform Detail Processing.
     C                   EXSR      SRProcess

      ** Program Termination.
     C                   EXSR      SRTerm
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************

     C     SRInit        BEGSR

      ** Define LDA.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'LE000031'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA

      ** Define RUNDAT.
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Set up copyright statement.
     C                   MOVEA     CPY@          BIS@

      ** Initialise Sequence No. for RCF to blanks
     C                   MOVE      *BLANKS       SEQ
     C                   MOVE      'A'           KFRcdT
     C                   Z-ADD     0             WkFAmt
     C                   Z-ADD     0             ZFAMTO
     C                   Z-ADD     0             ZFAMTR
     C                   Z-ADD     0             ZFAMTD
     C                   Z-ADD     0             RCOUNT
     C                   Z-ADD     0             RPTDET

     C                   IF        MBIN = 'Y'
     C                   MOVE      *ON           *IN02
     C                   ENDIF

      ** Key list for LF/FCLTY
     C     KLFcltA       KLIST
     C                   KFLD                    HACNUM
     C                   KFLD                    HAFacT
     C                   KFLD                    HAFcNo
     C                   KFLD                    KFRcdT

     C     KLFcltB       KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    HACNUM
     C                   KFLD                    HAFacT
     C                   KFLD                    HAFcNo
                                                                                              CLE041
      ** Key list for LF/LETRAGL0                                                             CLE041
     C     KLFclt1       KLIST                                                                CLE041
     C                   KFLD                    CNUM                                         CLE041
     C                   KFLD                    FACT                                         CLE041
     C                   KFLD                    FCNO                                         CLE041

      ** Access bank specific details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRtCd
     C                   PARM      '*FIRST '     WOptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     '*READ   '    DBKEY
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if SAR CLE005 is switched *ON
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRtCd
     C                   PARM      '*KEY   '     WOptn
     C                   PARM      'CLE005 '     WSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        WRtCd = *BLANKS
     C                   EVAL      CLE005 = 'Y'
     C                   ELSE
     C                   EVAL      CLE005 = 'N'
     C                   IF        WRtCd <> '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     'CLE005  '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      ** If CLE005 is switched on, open LECARDPD.
     C                   IF        CLE005 = 'Y'
     C                   OPEN      LECARDPD
     C                   ENDIF
                                                                                              CLE041
      ** Open Aggregate Facility Reduction Extract table                                      CLE041
     C                   OPEN      LEAGRDPD                                                   CLE041

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Detail processing subroutine                     *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR

      ** Read LF/HISACTL3 until EOF.
     C                   READ      HISACTL3                               10

     C                   DOW       *IN10 = *OFF

     C                   EVAL      WkProcAc = 'N'

     C                   IF        HAACTN = 'M1'

     C**********         EVAL      WkProcAc = 'Y'                                             CLE041

     C                   IF        WkPrvK <> WkNewK

      ** On change of PF/HISACT facility reference - update facility
      ** (except first read) and access new facility details.
     C                   IF        WkFAmt <> *ZEROS
     C                   EXSR      SRUpdFac
     C                   ENDIF

     C                   EVAL      WkPrvK = WkNewK

      ** Check if facility is live and is not a credit agreement
     C                   EXSR      SRChkFclt
     C                   ENDIF

     C                   ENDIF

     C                   IF        WkProcAc = 'Y'
     C                             AND HAACTN = 'M1'                                          CLE041

      ** Retrieve latest revolving credit indicator for the current facility
     C                   EVAL      WkRVCR = HARCIN
     C                   EXSR      SRRtvRVCR

      ** Only process action if facility is a non-revolving credit
     C                   IF        WkRVCR = 'N'
     C                   ADD       1             RCOUNT
     C                   ADD       HAAAMT        WkFAmt
     C                   ENDIF                                                                CLE041

      ** If CLE005 is switched on and Tranche/Credit Agreement indicator = 'TR',
      ** write to LECARDPD
     C                   IF        TRCA = 'TR' AND CLE005 = 'Y'
     C                   EXSR      SRMove
     C                   WRITE     LECARDPF

      ** Restore the previous values of FACT, FCNO, RECI
     C                   Z-ADD     WTMFT         FACT
     C                   Z-ADD     WTMFN         FCNO
     C                   MOVE      WTMRC         RECI
                                                                                              CLE041
      ** Access aggregate facilities affected by the tranche                                  CLE041
     C     KLFclt1       SETLL     LETRAGL0                                                   CLE041
     C     KLFclt1       READE     LETRAGL0                               14                  CLE041
     C                   DOW       *IN14 = *OFF                                               CLE041
                                                                                              CLE041
      ** write to LEAGRDPD                                                                    CLE041
     C                   EXSR      SRMoveAG                                                   CLE041
     C                   WRITE     LEAGRDD0                                                   CLE041
     C     KLFclt1       READE     LETRAGL0                               14                  CLE041
     C                   ENDDO                                                                CLE041
                                                                                              CLE041
     C                   ENDIF

     C**********         ENDIF                                                                CLE041

     C                   ENDIF

      ** Read next LF/HISACTL3
     C                   READ      HISACTL3                               10

     C                   ENDDO

      ** At EOF update final facility (if there is one). WkFAmt will not
      ** have been re-set as SR/SRUpdFac was never called - DOWEQ loop
      ** not re-entered at EOF.
     C                   IF        WkFAmt <> *ZEROS
     C                   EXSR      SRUpdFac
     C                   ENDIF

     C                   EXSR      SRUpdTrlr

      ** Output audit report.
     C                   WRITE     LE000031AH
     C     RPTDET        IFEQ      *ZEROS
     C                   WRITE     LE000031A1
     C                   ELSE
     C                   WRITE     LE000031A2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************                       CLE041
      /EJECT                                                                                  CLE041
      *****************************************************************                       CLE041
      *                                                               *                       CLE041
      * SRMoveAG - Move fields to file fields of LEAGRDPD             *                       CLE041
      *                                                               *                       CLE041
      *****************************************************************                       CLE041
     C     SRMoveAG      BEGSR                                                                CLE041
                                                                                              CLE041
     C                   EVAL      AHRECI = 'D'                                               CLE041
     C                   EVAL      AHAGBR = AGAGBR                                            CLE041
     C                   EVAL      AHAGNM = AGAGNM                                            CLE041
     C                   EVAL      AHAGFT = AGAGFT                                            CLE041
     C                   EVAL      AHAGFN = AGAGFN                                            CLE041
     C                   EVAL      AHTRBR = BRCA                                              CLE041
     C                   EVAL      AHTRNM = CNUM                                              CLE041
     C                   EVAL      AHTRFT = FACT                                              CLE041
     C                   EVAL      AHTRFN = FCNO                                              CLE041
     C                   EVAL      AHTRCY = FCCY                                              CLE041
     C                   EVAL      AHTRRC = WkRVCR                                            CLE041
     C                   EVAL      AHRAMT = HAAAMT                                            CLE041
     C                   EVAL      AHVDAT = HADATE                                            CLE041
     C                   EVAL      AHAMTP = HAACTN                                            CLE041
     C**********         EVAL      AHLOAN = 0                                          CLE041 CLE148
     C                   EVAL      AHLOAN = *BLANKS                                           CLE148
     C                   EVAL      AHDEAL = HADEAL                                            CLE041
     C                   EVAL      AHUSEQ = 0                                                 CLE041
     C                   EVAL      AHMTID = 0                                                 CLE041
                                                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkFclt - Subroutine to check if facility defined in the    *
      *             facilities file and is not a credit agreement     *
      *                                                               *
      *****************************************************************
     C     SRChkFclt     BEGSR

     C     KLFcltA       CHAIN     FCLTY                              11

      ** Check if facility read is defined in the facilities files
     C                   IF        *IN11 = *ON
     C     KLFcltB       CHAIN     PEFCLFL1                           12

      ** If not defined in live facilities file, check in closed/reversed
      ** facilities file
     C                   IF        *IN12 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     WkNewK        DBKEY
     C                   MOVE      'PEFCLFL1'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WkProcAc = 'N'
     C                   ENDIF

     C                   ELSE

     C                   IF        TRCA <> 'CA'
     C                   EVAL      WkProcAc = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvRVCR - Subroutine that retrieves the revolving credit    *
      *             indicator on the date of the transaction          *
      *                                                               *
      *****************************************************************
     C     SRRtvRVCR     BEGSR
      *
     C     *LOVAL        SETLL     HISACTL2
     C                   READ      HISACTL2                               73

     C                   DOW       *IN73 = *OFF
     C                   IF        H1HAACTN = 'RC' AND H1HADATE = BJRDNB
     C                   EVAL      WkRVCR = H1HARCIN
     C                   ENDIF
     C                   READ      HISACTL2                               73
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdTrlr - Subroutine that updates Trailer File FCLTYZZ      *
      *                                                               *
      *****************************************************************
     C     SRUpdTrlr     BEGSR

     C                   IF        RCOUNT <> *ZEROS
     C                   READ      FCLTYZZF                               13

     C                   IF        *IN13 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '*READ   '    DBKEY
     C                   MOVE      'FCLTYZZ '    DBFILE
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Adjust both the value before and the values after for the
      ** the total amount reduced.
     C     VLBF          MULT      1000          WRKTOT
     C                   ADD       VLBL          WRKTOT
     C     WRKTOT        SUB       ZFAMTD        WRKTOT
     C     WRKTOT        DIV       1000          VLBF
     C                   MVR                     VLBL
     C     VLAF          MULT      1000          WRKTOT
     C                   ADD       VLAL          WRKTOT
     C     WRKTOT        SUB       ZFAMTD        WRKTOT
     C     WRKTOT        DIV       1000          VLAF
     C                   MVR                     VLAL
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   UPDATE    FCLTYZZF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRUpdFac - Update non-revolving credit facility records.      *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdFac      BEGSR

      ** Update facility file.
     C                   Z-ADD     FAMT          OFAMT
     C                   ADD       FAMT          ZFAMTO
     C                   SUB       WkFAmt        FAMT

     C                   IF        FAMT <= 0
     C     OFAMT         SUB       1             WkFAmt
     C                   Z-ADD     1             FAMT
     C                   ENDIF
     C                   Z-ADD     FAMT          RFAMT
     C                   ADD       FAMT          ZFAMTR
     C                   Z-ADD     WkFAmt        DFAMT
     C                   ADD       WkFAmt        ZFAMTD
     C                   UPDATE    FCLTYFMF

      ** Access facility currency details.
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     WRtCd
     C                   PARM      '*KEY   '     WOptn
     C                   PARM                    FCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     FCCY          DBKEY
     C                   MOVE      'SDCURRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      *OFF          *IN03                                        CLE041
     C                   MOVE      *OFF          *IN04                                        CLE041
     C                   MOVE      *OFF          *IN05                                        CLE041
     C                   MOVE      *OFF          *IN06                                        CLE041
                                                                                              CLE041
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   MOVE      *ON           *IN03
     C                   WHEN      A6NBDP = 1
     C                   MOVE      *ON           *IN04
     C                   WHEN      A6NBDP = 2
     C                   MOVE      *ON           *IN05
     C                   OTHER
     C                   MOVE      *ON           *IN06
     C                   ENDSL

      ** Access branch details if multibranching system and change of
      ** branch code.
     C                   IF        BRCA <> STRBRC
     C                   IF        MBIN = 'Y'
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    WRtCd
     C                   PARM      '*KEY    '    WOptn
     C                   PARM                    BRCA
     C     SDBRCH        PARM      SDBRCH        DSFDY

     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     BRCA          DBKEY
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

      ** Write Trailer if spool file is already open.
     C     *IN08         IFEQ      '1'
     C                   WRITE     LE000031T1
     C                   ENDIF

      ** Close and Open spool file for next branch.
     C                   CLOSE     LE000031P1
     C                   OPEN      LE000031P1
     C                   Z-ADD     0             PAGE

      ** Set On Spool file open flag.
     C                   MOVE      *ON           *IN08

      ** Ensure Report Spool File recorded by RCF.
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      BRCA          SENTY
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

     C                   IF        ZSERR = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF

      ** Store Branch Code to allow for next check of level break.
     C                   MOVE      BRCA          STRBRC

      ** Write Header.
     C                   WRITE     LE000031H1

     C                   ENDIF

      ** If Overflow then Write Header.
     C                   IF        *IN50 = *ON
     C                   WRITE     LE000031H1
     C                   ENDIF

      ** Write Detail record on report.
     C                   WRITE     LE000031D1
     C                   ADD       1             RPTDET
     C                   Z-ADD     0             WkFAmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Move fields to file fields of LECARDPD               *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR

      ** Save the values of FACT and FCNO.
     C                   Z-ADD     FACT          WTMFT
     C                   Z-ADD     FCNO          WTMFN
     C                   MOVE      RECI          WTMRC

     C                   MOVE      CNUM          TRNM
     C                   MOVE      FACT          TRFT
     C                   MOVE      FCNO          TRFN
     C                   MOVE      FCCY          TRCY
     C                   MOVE      'D'           RECI
     C                   MOVE      CANM          FCUS
     C                   MOVE      CAFT          FACT
     C                   MOVE      CAFN          FCNO
     C                   Z-ADD     HAAAMT        RAMT
     C                   MOVE      HADATE        VDAT
     C                   MOVE      WkRVCR        TRRC                                         CLE041

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception processing.                        *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      ** Ensure dump is executed only once.
     C                   IF        WRUN = *BLANK
     C                   MOVE      'Y'           WRUN
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   DUMP

      ** Produce error report
     C                   WRITE     LE000031AH
     C                   WRITE     DBFMTAU

     C                   EXSR      SRTerm
     C                   ENDIF

      ** Exit program.
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTerm - Program termination subroutine                       *
      *                                                               *
      *****************************************************************
      *
     C     SRTerm        BEGSR

      ** End Program and Return.
     C                   MOVE      *ON           *INLR
     C                   RETURN

     C                   ENDSR
      ********************************************************************
** CPY@   Object Copyright
(c) Finastra International Limited 2004
