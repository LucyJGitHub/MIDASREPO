     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE T&N Account Code Check - Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Retail T&N Accounts                                  *
      *                                                               *
      *  RE4037 - Midas RE T&N Account Code Check - Prompt            *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CRE015 *CREATE     Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE015 - Retail T&N Accounts                                 *
      *                                                               *
      *****************************************************************
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
     FRE4037DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(D@WKS)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Definition: Program status.
 
     D PSDS           SDS
     D  @PGM                   1     10
     D  @JOB                 244    253
     D  @USER                254    263
     D  @JOBN                264    269S 0
     D  @TIME                282    287S 0
 
     D D@WKS           DS
      * Definition: Workstation status.
     D  D@0256                 1    256
     D  D@0004               257    260
     D  D@FMTN               261    270
     D  D@0099               271    369
     D  D@CRSR               370    371B 0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Definition: First DS for Access Programs, Short Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Definition: Bank Details Accessed Via Access Program.
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PRSEQ           S              5
     D PRLEV           S              1
     D PRENT           S              3
     D PMODE           S              7
 
     ** Other variables
     D @RUN            S              1
     D WKERR           S              1
 
     ** Message Queues Parameter
     D P@PMSQ          S             10
     D P@PMSL          S              5
     D P@MSGI          S              7
     D P@MSGF          S             10
     D P@MDTA          S            132
     D P@MTYP          S              7
 
     ** Access Object Parameters
     D @RTCD           S              7
     D @OPTN           S              7
 
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
 
      ** Set Defaults
 
     C                   EXSR      SrDEFT
 
      ** Main Processing
 
     C                   EXSR      SrPROC
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrDEFT - Set Defaults                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrDEFT        BEGSR
 
     C                   EVAL      PMODE = '*AUDIT'
     C                   EVAL      WKERR = 'N'
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPROC - Main Processing                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: XCPMSQ, SrVALD                                        *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   DOU       *INKC = *ON OR
     C                             WKERR = 'N'
 
     C                   WRITE     RE4037HH
     C                   WRITE     RE4037FF
     C                   WRITE     #MSGCTL
     C                   EXFMT     RE4037DD
 
     C                   EXSR      XCPMSQ
     C                   EXSR      SRVALD
 
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVALD - Validate Fields                                     *
      *                                                               *
      *  Called By: SrPROC                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrVALD        BEGSR
 
     C                   IF        PMODE <> '*AUDIT' AND
     C                             PMODE <> '*CRTDLT' AND
     C                             PMODE <> '*CREATE' AND
     C                             PMODE <> '*DELETE'
     C                   MOVEL     'RE77113'     P@MSGI
     C                   EXSR      XSPMSQ
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WKERR = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSPMSQ: Send Messages to Program Message Queue               *
      *                                                               *
      *  Called By: SrPROC                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     XSPMSQ        BEGSR
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      @PGM          P@PMSQ
     C                   PARM      '*SAME'       P@PMSL
     C                   PARM                    P@MSGI
     C                   PARM      'REUSRMSG'    P@MSGF
     C                   PARM                    P@MDTA
     C                   PARM      '*INFO'       P@MTYP
 
     C                   ENDSR
      *****************************************************************
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
 
     C                   MOVEA     '000'         *IN(61)
     C                   EVAL      WKERR = 'N'
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRSEQ
     C                   PARM                    PRLEV
     C                   PARM                    PRENT
     C                   PARM                    PMODE
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      * Define Variables.
 
     C     *LIKE         DEFINE    @OPTN         WKOPTN
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C                   MOVEL     'RE4037'      @PGM
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
