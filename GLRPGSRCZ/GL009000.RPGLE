     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Default Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL009000 - GL Postings Interface (Default Area Maintenance)  *
      *                                                               *
      *  Function:  This program allows the user to perform           *
      *   (I/C)     maintenance of the GL Postings Interface defaults.*
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 MD039864           Date 02Aug16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27473           Date 21Apr10               *
      *                 CGL114A            Date 12Mar10               *
      *                 BUG27219           Date 16Mar10               *
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  MD039864 - Allow dummy entries not to be generated. If       *
      *             Posting Amount is zero, send warning message.     *
      *  BUG27473 - Error in retail account and transaction type      *
      *             default                                           *
      *  CGL114A - CCR Interest Capitalisation                        *
      *  BUG27219- Format for message IDs in GBGLUSRMSG are for       *
      *            non-core                                           *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *   25          Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
     FGL009000DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(D@WKS)
      *
     FGLIPDFPD  UF A E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
     D NT@             S             34    DIM(32)
     D NC@             S              2    DIM(32)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
     D/COPY ZSRSRC,ZALIGNZ1LE
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D N@NUMB          C                   CONST('0123456789')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D D@WKS           DS
      * Definition: Workstation status.
     D  D@0256                 1    256
     D  D@0004               257    260
     D  D@FMTN               261    270
     D  D@0099               271    369
     D  D@CRSR               370    371B 0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Definition: First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Definition: Second DS for Access Programs, Short Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Definition: Bank Details Accessed Via Access Program.
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * Definition: Branch Details Accessed Via Access Program.
 
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
      * Definition: Dept Details Accessed Via Access Program.
 
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      * Definition: Retail Details Accessed Via Access Program.
 
     D  DSBTNB                 1      3  0
      * Data Structure: Batch Number defined as a Zoned field
 
     D                 DS             3
      * Data Structure: Split 3 Char field for Numeric Validation.
     D  DSCHR3                 1      3
     D  D@PO1                  1      1
     D  D@PO2                  2      2
     D  D@PO3                  3      3
     D  D@PO12                 1      2
     D  D@PO23                 2      3
 
     D P@TRAT          DS
     D  @TRAT                  1      5  0
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WKERR           S              9  0
 
     ** Access Object Parameters
     D @RTCD           S              7
     D @OPTN           S              7
     D P@DPCD          S              3
 
     ** Message Queues Parameter
     D P@PMSQ          S             10
     D P@PMSL          S              5
     D P@MSGI          S              7
     D P@MSGF          S             10
     D P@MDTA          S            132
     D P@MTYP          S              7
 
     D WTRTY           S              5S 0
     D WTRAT           S              5S 0
     D WPSTA           S             13S 0
     D Warning         S              1                                                     MD039864
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   EVAL      @JOB = PSJobName                                          CGL114A
     C                   EVAL      @USER = PSUser                                            CGL114A
      *                                                                                      CGL114A
     C                   DOW       *INLR = '0'
     C                   EXSR      SrXCPMSQ
      *
      *
     C     *INKC         CASEQ     *ON           SrPFK03
     C     *INKE         CASEQ     *ON           SrPFK05
     C     *INKL         CASEQ     *ON           SrPFK12
      *
     C     D@FMTN        CASEQ     'GL009000D1'  SrPDFD1
     C                   CAS                     SrXSDFD1
     C                   ENDCS
      *
     C                   IF        *INLR = *OFF
     C                   READ      GL009000DF                             LR
     C                   ENDIF
     C                   ENDDO
     C                   Return
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPFK03 - Process Function Key 3 - Exit.                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrPFK03       BEGSR
 
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPFK05 - Process Function Key 5 - Refresh Screen.            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrXSDFD1                                               *
      *                                                               *
      *****************************************************************
     C     SrPFK05       BEGSR
 
     C                   EVAL      WKERR = *ZERO
     C                   MOVEA     '0000000'     *IN(51)
     C                   MOVEA     '1000'        *IN(58)
     C                   EXSR      SrXSDFD1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPFK12 - Process Function Key 12 - Previous Screen.          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrPFK12       BEGSR
 
     C                   EVAL      WKERR = *ZERO
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPDFD1 - Process Display Format - Detail (D1)                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrXVDFD1, SrXUIPDF, SrXCPMSQ                           *
      *                                                               *
      *****************************************************************
     C     SrPDFD1       BEGSR
 
     C                   MOVEA     '0000000'     *IN(51)
     C                   MOVEA     '0000'        *IN(58)
     C                   EVAL      P@MSGI = *BLANKS
 
      ** Validate Input
     C                   EXSR      SrXVDFD1
 
      * If there are any errors, redisplay detail screen,
      * otherwise update the file.
 
     C                   IF        WKERR = *ZERO
     C                             and Warning = ' '                                        MD039864
     C                   EXSR      SrXUIPDF
     C                   EXSR      SrXCPMSQ
     C                   EVAL      *INLR = *ON
     C                   ELSE
     C                   WRITE     GL009000H1
     C                   WRITE     GL009000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL009000D1
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXSDFD1 - Process Display Format - Detail Screen (D1)        *
      *                                                               *
      * Called by: SrPFK05                                            *
      *                                                               *
      * Calls: SrXRIPDF                                               *
      *                                                               *
      *****************************************************************
     C     SrXSDFD1      BEGSR
 
      * Set Data Area details.
 
     C                   EXSR      SrXRIPDF
 
     C                   EVAL      SCBRCH = BDBRCH
     C                   EVAL      SCTRTY = BDTRTY
     C                   EVAL      SCDPCD = BDDPCD
     C                   IF        BDTRAT = *ZERO                                           BUG27473
     C                   EVAL      SCTRAT = *BLANKS                                         BUG27473
     C                   ELSE                                                               BUG27473
     C                   MOVEL     BDTRAT        SCTRAT
     C                   ENDIF                                                              BUG27473
     C                   MOVEL     BDPSTA        SCPSTA
     C                   CALL      'ZEDIT'
     C                   PARM      SCPSTA        ZFIELD
     C                   PARM                    ZADEC
     C                   MOVEL     ZFIELD        SCPSTA
     C                   EVAL      SCDICR = BDDICR                                           CGL114A
     C                   EVAL      SCPNAR = BDPNAR
 
      * Display Detail Screen.
 
     C                   WRITE     GL009000H1
     C                   WRITE     GL009000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL009000D1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXVDFD1 - Validate Detail Screen Input                       *
      *                                                               *
      * Called by: SrPDFD1                                            *
      *                                                               *
      * Calls: SrXSPMSQ, SrXRBRCH                                     *
      *                                                               *
      *****************************************************************
     C     SrXVDFD1      BEGSR
 
     C                   EVAL      WKERR = 0
 
      * Validate 'Branch Code'. Must not be blank and must be valid.
 
     C                   IF        SCBRCH = *BLANKS
      **********         EVAL      P@MSGI = 'XX00013'                                       BUG27219
     C                   EVAL      P@MSGI = 'ATU0013'                                       BUG27219
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN61 = *ON
 
     C                   ELSE
     C                   EVAL      WKBRCH = SCBRCH
     C                   EXSR      SrXRBRCH
 
     C                   IF        @RTCD <> *BLANKS
      **********         EVAL      P@MSGI = 'XX00014'                                       BUG27219
     C                   EVAL      P@MSGI = 'ATU0014'                                       BUG27219
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
     C                   ENDIF
 
      * Validate 'Transaction Type'
 
     C                   MOVE      SCTRTY        WTRTY
 
     C                   IF        SCTRTY <> *BLANKS OR
     C                             WTRTY <> *ZEROS
     C                   TESTN                   SCTRTY               25
     C                   IF        *IN25 = *OFF
      **********         EVAL      P@MSGI = 'XX00053'                                       BUG27219
     C                   EVAL      P@MSGI = 'ATU0053'                                       BUG27219
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN55 = *ON
     C                   EVAL      *IN62 = *ON
 
     C                   ELSE
     C                   CALL      'AOTRNTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      WTRTY         @TRAT
     C                   PARM                    DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      P@MSGI = 'GLX0059'
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN55 = *ON
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Validate 'Department Code'
 
     C                   IF        SCDPCD <> *BLANKS
     C                   CALL      'AODEPTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C**********         PARM      SCDPCD        P@DPCD                                     BUG27473
     C     SCDPCD        PARM      SCDPCD        P@DPCD                                     BUG27473
     C                   PARM                    DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      P@MSGI = 'GLX0031'
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN56 = *ON
     C                   EVAL      *IN63 = *ON
     C                   ENDIF
     C                   ENDIF
 
      * Validate 'Dummy DR/CR Entries Transaction Type'
 
     C                   MOVE      SCTRAT        WTRAT
 
     C                   IF        SCTRAT <> *BLANKS OR
     C                             WTRAT <> *ZEROS
     C                   TESTN                   SCTRAT               25
     C                   IF        *IN25 = *OFF
      **********         EVAL      P@MSGI = 'XX00053'                                       BUG27219
     C                   EVAL      P@MSGI = 'ATU0053'                                       BUG27219
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN57 = *ON
     C                   EVAL      *IN64 = *ON
 
     C                   ELSE
     C                   CALL      'AOTRNTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      WTRAT         @TRAT
     C                   PARM                    DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      P@MSGI = 'GLX0059'
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN57 = *ON
     C                   EVAL      *IN64 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Validate 'Posting Amount'
 
     C                   MOVE      SCPSTA        WPSTA
 
     C                   IF        WPSTA = *ZEROS OR
     C                             SCPSTA = *BLANKS
      **********         EVAL      P@MSGI = 'XX00054'                                       BUG27219
     C**********         EVAL      P@MSGI = 'ATU0054'                                BUG27219 PHSFIX
     C                   IF        Warning = ' '                                            MD039864
     C                   EVAL      P@MSGI = 'ATU0068'                                       MD039864
     C                   EVAL      Warning = 'Y'                                            MD039864
     C                   EXSR      SrXSPMSQ
     C**********         ADD       1             WKERR                                      MD039864
     C                   EVAL      *IN58 = *ON
     C                   EVAL      *IN65 = *ON
     C                   ELSE                                                               MD039864
     C                   EVAL      Warning = ' '                                            MD039864
     C                   ENDIF                                                              MD039864
 
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     SCPSTA        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     13            ZADIG
     C                   EVAL      *IN99 = *OFF
     C                   EXSR      ZALIGN
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        WPSTA
 
     C                   IF        *IN99 = *ON
      **********         EVAL      P@MSGI = 'XX00054'                                       BUG27219
     C                   EVAL      P@MSGI = 'ATU0054'                                       BUG27219
     C                   EXSR      SrXSPMSQ
     C                   ADD       1             WKERR
     C                   EVAL      *IN58 = *ON
     C                   EVAL      *IN65 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Request for Capitalisation                                                 CGL114A
                                                                                             CGL114A
     C                   IF        SCDICR <> 'Y' AND                                         CGL114A
     C                             SCDICR <> 'N'                                             CGL114A
     C                   EVAL      P@MSGI = 'ATU0062'                                        CGL114A
     C                   EXSR      SrXSPMSQ                                                  CGL114A
     C                   ADD       1             WKERR                                       CGL114A
     C                   EVAL      *IN59 = *ON                                               CGL114A
     C                   EVAL      *IN66 = *ON                                               CGL114A
     C                   ENDIF                                                               CGL114A
                                                                                             CGL114A
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXUIPDF - Update GL Postings Interface - Default Details.    *
      *                                                               *
      * Called by: SrPDFD1                                            *
      *                                                               *
      * Calls: SrXRIPDF                                               *
      *                                                               *
      *****************************************************************
     C     SrXUIPDF      BEGSR
 
      * Retrieve Default data.
 
     C                   EXSR      SrXRIPDF
 
      * Set Default data details.
 
     C                   EVAL      BDBRCH = SCBRCH
     C                   EVAL      BDTRTY = SCTRTY
     C                   EVAL      BDTRAT = WTRAT
     C                   EVAL      BDDPCD = SCDPCD
     C                   EVAL      BDPSTA = WPSTA
     C                   EVAL      BDPNAR = SCPNAR
     C                   EVAL      BDDICR = SCDICR                                           CGL114A
     C
 
      * Update Default Data.
 
     C                   UPDATE    GLIPDFD0
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXRIPDF - Retrieve GL Postings Interface Defaults.           *
      *                                                               *
      * Called by: SrXSFD1, SrXUIPDF                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrXRIPDF      BEGSR
 
      * Retrieve GL Posting Interface Details.
 
     C     1             CHAIN     GLIPDFPD                           2021
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLIPDFPD'
     C                   EVAL      DBKEY = '       1'
     C                   EVAL      DBPGM = @PGM
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If record not found, first time round so create blank one.
 
     C                   IF        *IN20 = *ON
     C                   CLEAR                   GLIPDFD0
     C                   WRITE     GLIPDFD0
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXRBRCH - Retrieve/Select Branch Code.                       *
      *                                                               *
      * Called by: SrXVDFD1                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrXRBRCH      BEGSR
 
      * Retrieve/Select Branch Code. If the Branch Code field
      * contains a ? then a selection list is displayed.
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WKBRCH        WKBRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF' AND
     C                             @RTCD <> '*NOSEL'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = SCBRCH
     C                   EVAL      DBPGM = @PGM
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      SCBRCH = WKBRCH
     C                   ENDIF
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXCPMSQ - Clear Program Message Queue.                       *
      *                                                               *
      * Called by: SrPDFD1                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrXCPMSQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      @PGM          P@PMSQ
     C                   PARM      '*SAME'       P@PMSL
 
     C                   MOVEA     '00000000'    *IN(61)
     C                   MOVEA     '00000'       *IN(69)
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrXSPMSQ - Send Messages to Program Message Queue.            *
      *                                                               *
      * Called by: SrXVDFD1                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrXSPMSQ      BEGSR
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      @PGM          P@PMSQ
     C                   PARM      '*SAME'       P@PMSL
     C                   PARM                    P@MSGI
     C                   PARM      'GLUSRMSG'    P@MSGF
     C                   PARM                    P@MDTA
     C                   PARM      '*INFO'       P@MTYP
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      * Define Variables.
 
     C     *LIKE         DEFINE    @OPTN         WKOPTN
     C     *LIKE         DEFINE    SCBRCH        WKBRCH
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C                   MOVEL     'GL009000'    @PGM
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
     C                   MOVEL     @PGM          DBPGM
     C                   OUT       LDA
 
      * Retrieve Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBPGM = @PGM
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      BJMRDT        SCDAT#
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      * Initialise parameters, work fields, etc.
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN80 = *ON
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
     d/COPY ZSRSRC,ZALIGNZ2LE
