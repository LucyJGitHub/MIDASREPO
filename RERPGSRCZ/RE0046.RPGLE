     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Account Transfer Extract')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0046 - Midas RE Account Transfer Extract                   *
      *                                                               *
      *  Function:  This new program will extract the values from the *
      *             Account Transfer Manual Input file and calculate  *
      *             what should be reported by the Retail Advice      *
      *             function.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1075388          Date 21Nov13               *
      *                 AR845655           Date 06Oct11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27563           Date 27Apr10               *
      *                 CAP204A            Date 15Mar10               *
      *                 BUG27369           Date 07Apr10               *
      *                 CAP204  *CREATE    Date 19Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  AR845655 - Update datatype of Paying Bank to Alphanumeric    *
      *             (Recompile)                                       *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG27563 - GLHATMPD should be access via transaction         *
      *             reference and execution date.  Created and used   *
      *             GLHATML2 instead of GLHATML1.  Also, remove       *
      *             locking of LDA to properly reflect DB error       *
      *             details.                                          *
      *  CAP204A - Retail Account Transfer                            *
      *            CCR027 - Cheque account are no longer required     *
      *  BUG27369 - The fee amount is not mentioned in the generated  *
      *             retail advice                                     *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F***GLHATML1  IF   E           K DISK                                                  BUG27563
     FGLHATML2  IF   E           K DISK                                                     BUG27563
      ** Midas GL Account Transfer Manual Input file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZSRSRC,ZPOWERZ1IL
 
     D*GLHATM***     E DS                  EXTNAME(GLHATML1)                                BUG27563
     D GLHATM        E DS                  EXTNAME(GLHATMPD)                                BUG27563
      ** Definition: Historic Account Details
     D**DBACCT**              27     50                                                     BUG27369
     D**CRACCT**             114    137                                                     BUG27369
     D**CHACCT**             225    248                                                      CAP204A
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Objects - long data structure )
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     D DSACCOUNT       DS
     D  DSBRCA                        3A
     D  DSCUST                        6A
     D  DSCCY                         3A
     D  DSACCT                       10S 0
     D  DSACSQ                        2S 0
 
     D DBACCT          DS                                                                   BUG27369
     D  DBBRCA                        3A                                                    BUG27369
     D  DBCUST                        6A                                                    BUG27369
     D  DBCCY                         3A                                                    BUG27369
     D  DBACNT                       10S 0                                                  BUG27369
     D  DBACSQ                        2S 0                                                  BUG27369
                                                                                            BUG27369
     D CRACCT          DS                                                                   BUG27369
     D  CRBRCA                        3A                                                    BUG27369
     D  CRCUST                        6A                                                    BUG27369
     D  CRCCY                         3A                                                    BUG27369
     D  CRACNT                       10S 0                                                  BUG27369
     D  CRACSQ                        2S 0                                                  BUG27369
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PSDS           SDS
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
 
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCUST           S              6A
     D PCCY            S              3A
     D PACOD           S             10A
     D PACSQ           S              2A
     D PBRCA           S              3A
     D PREF            S             15A
     D PPAMT           S             13A
     D PFAMT           S             13A
     D PAMTAF          S             13A
     D PCCCY           S              3A
     D PCAMT           S             13A
     D PEXRT           S             13A
     D PEXDT           S              5P 0                                                  BUG27563
     D WFAMT           S             13P 0
     D WPAMT           S             13P 0
     D WAMTAF          S             13P 0
     D WEXRT           S             13P 8
     D WFRCCY          S              3A
     D WTOCCY          S              3A
     D WCCY            S              3A
     D WFRSPRT         S             13P 8
     D WTOSPRT         S             13P 8
     D WFRMDIN         S              1A
     D WTOMDIN         S              1A
     D WTOCAMT         S             13P 0
     D WFRDEC          S              1P 0
     D WTODEC          S              1P 0
     D WEXRT2          S             13P 8
     D WAMT            S             15P 0
     D WAMTT           S             15P 0
     D WMDIN           S              1A
     D WCAMT           S             13P 0
     D WTOAMT          S             13P 0
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRMAIN
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SRMAIN - Subroutine to check if Transaction reference exists  *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
     C*****KLIST1        CHAIN     GLHATML1                                                 BUG27563
     C     KLIST1        CHAIN     GLHATML2                                                 BUG27563
 
     C**********         IF        NOT %FOUND(GLHATML1)                                     BUG27563
     C                   IF        NOT %FOUND(GLHATML2)                                     BUG27563
     C                   EVAL      PRTCD = '*NRF'
     C                   EVAL      DBFILE = 'GLHATMPD'
     C                   EVAL      DBKEY = PREF
     C                   EVAL      DBPGM = 'RE0046'
     C                   EVAL      DBASE = 001
     C**********         OUT       LDA                                                      BUG27563
     C                   EXSR      *PSSR
 
     C                   ELSE
      ** Calculate Fee Amount
     C                   EXSR      SRFAMT
      ** Calculate Posting amount after fee
     C                   EXSR      SRAMTAF
      ** Calculate Contra amount and Exchange Rate
     C                   EXSR      SRCAMT
      ** Move work fields values to parameter fields
     C                   EXSR      SRMOVVAL
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRFAMT - Calculate fee amount                                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRFAMT        BEGSR
 
     C                   EVAL      WFAMT = 0
     C                   EVAL      DSBRCA = PBRCA
     C                   EVAL      DSCUST = PCUST
     C                   EVAL      DSCCY  = PCCY
     C                   MOVE      PACOD         DSACCT
     C                   MOVE      PACSQ         DSACSQ
 
     C                   EVAL      DBBRCA = R1DBBR                                          BUG27369
     C                   EVAL      DBCUST = R1DBCU                                          BUG27369
     C                   EVAL      DBCCY  = R1DBCY                                          BUG27369
     C                   MOVE      R1DBAC        DBACNT                                     BUG27369
     C                   MOVE      R1DBSQ        DBACSQ                                     BUG27369
                                                                                            BUG27369
     C                   EVAL      CRBRCA = R1CRBR                                          BUG27369
     C                   EVAL      CRCUST = R1CRCU                                          BUG27369
     C                   EVAL      CRCCY  = R1CRCY                                          BUG27369
     C                   MOVE      R1CRAC        CRACNT                                     BUG27369
     C                   MOVE      R1CRSQ        CRACSQ                                     BUG27369
                                                                                            BUG27369
     C                   SELECT
      *
      ** Check if DEBIT account
      *
     C                   WHEN      DSACCOUNT = DBACCT
      *
     C                   IF        R1FPAY = 'D'
     C**********         EVAL      WFAMT = R1F1AM + R1F2AM + R1F3AM                         BUG27369
     C**********                        + R1F4AM + R1F5AM + R1F6AM                          BUG27369
     C                   EVAL      WFAMT = R1F1CE + R1F2CE + R1F3CE                         BUG27369
     C                                  + R1F4CE + R1F5CE + R1F6CE                          BUG27369
     C                   ENDIF
      *
      ** Check if CREDIT
      *
     C                   WHEN      DSACCOUNT = CRACCT
      *
     C                   IF        R1FPAY = 'C'
     C**********         EVAL      WFAMT = R1F1AM + R1F2AM + R1F3AM                         BUG27369
     C**********                        + R1F4AM + R1F5AM + R1F6AM                          BUG27369
     C                   EVAL      WFAMT = R1F1CE + R1F2CE + R1F3CE                         BUG27369
     C                                  + R1F4CE + R1F5CE + R1F6CE                          BUG27369
     C                   ENDIF
      *****************************************************************                      CAP204A
      ***Check*if*CHEQUE***********************************************                      CAP204A
      *****************************************************************                      CAP204A
     C**********         WHEN      DSACCOUNT = CHACCT                                        CAP204A
      *****************************************************************                      CAP204A
     C**********         IF        R1FPAY = 'D'                                              CAP204A
     C**********         EVAL      WFAMT = R1F1AM + R1F2AM + R1F3AM                          CAP204A
     C**********                        + R1F4AM + R1F5AM + R1F6AM                           CAP204A
     C**********         ENDIF                                                               CAP204A
      *****************************************************************                      CAP204A
     C**********         IF        R1DBCY <> R1CHCY                                          CAP204A
     C**********         EVAL      WAMT = WFAMT                                              CAP204A
     C**********         EVAL      WFRCCY = R1DBCY                                           CAP204A
     C**********         EVAL      WTOCCY = R1CHCY                                           CAP204A
     C**********         EXSR      SRCCYCVT                                                  CAP204A
     C**********         EVAL      WFAMT = WAMTT                                             CAP204A
     C**********         ENDIF                                                               CAP204A
      *
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAMTAF - Calculate posting amount after fee is included      *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAMTAF       BEGSR
 
     C                   MOVE      PPAMT         WPAMT
     C                   EVAL      WAMTAF = WPAMT
      *
     C                   IF        R1FGRS = 'G'
 
     C                   SELECT
      *
      ** Check if DEBIT account
      *
     C                   WHEN      DSACCOUNT = DBACCT
      *
     C                   IF        R1FPAY = 'D'
     C                   EVAL      WAMTAF = WPAMT + WFAMT
     C                   ENDIF
      *
      ** Check if CREDIT
      *
     C                   WHEN      DSACCOUNT = CRACCT
      *
     C                   IF        R1FPAY = 'C'
     C                   EVAL      WAMTAF = WPAMT - WFAMT
     C                   ENDIF
      *****************************************************************                      CAP204A
      ***Check*if*CHEQUE***********************************************                      CAP204A
      *****************************************************************                      CAP204A
     C**********         WHEN      DSACCOUNT = CHACCT                                        CAP204A
      *****************************************************************                      CAP204A
     C**********         IF        R1FPAY = 'D'                                              CAP204A
     C**********         EVAL      WAMTAF = WPAMT + WFAMT                                    CAP204A
     C**********         ENDIF                                                               CAP204A
      *
     C                   ENDSL
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCAMT  - Calculate contra amount and exchange rate           *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCAMT        BEGSR
 
     C                   EVAL      WEXRT = R1EXCH
      *
     C                   IF        DSACCOUNT = CRACCT
     C                   EVAL      WCAMT = R1DAMT
     C                   EVAL      PCCCY = R1DBCY
     C                   ELSE
     C                   EVAL      WCAMT = R1CAMT
     C                   EVAL      PCCCY = R1CRCY
     C                   ENDIF
      *
     C                   IF        R1FGRS = 'N'
 
     C                   SELECT
      *
      ** Check if DEBIT account
      *
     C                   WHEN      DSACCOUNT = DBACCT
      *
     C                   IF        R1FPAY = 'C'
     C                             AND R1DBCY <> R1CRCY
     C                   EVAL      ZMD    = R1MDIN
     C                   EVAL      ZEXCH  = R1EXCH
     C                   EVAL      ZCCYI  = R1DBCY
     C                   EVAL      ZCCYO  = R1CRCY
     C                   EVAL      ZAMTCI = R1DAMT
     C                   EXSR      SRZCONV
     C                   EVAL      WCAMT = ZAMTCO
     C                   ENDIF
      *
      ** Check if CREDIT
      *
     C                   WHEN      DSACCOUNT = CRACCT
      *
     C                   IF        R1FPAY = 'D'
     C                             AND R1DBCY <> R1CRCY
     C                   IF        R1MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   EVAL      ZEXCH  = R1EXCH
     C                   EVAL      ZCCYI  = R1CRCY
     C                   EVAL      ZCCYO  = R1DBCY
     C                   EVAL      ZAMTCI = R1CAMT
     C                   EXSR      SRZCONV
     C                   EVAL      WCAMT = ZAMTCO
     C                   ENDIF
      *****************************************************************                      CAP204A
      ***Check*if*CHEQUE***********************************************                      CAP204A
      *****************************************************************                      CAP204A
     C**********         WHEN      DSACCOUNT = CHACCT                                        CAP204A
      *****************************************************************                      CAP204A
     C**********         IF        R1FPAY = 'C'                                              CAP204A
     C**********         EVAL      WEXRT = 1                                                 CAP204A
     C**********         IF        R1CRCY <> R1CHCY                                          CAP204A
     C**********         EVAL      WAMT = WPAMT                                              CAP204A
     C**********         EVAL      WFRCCY = R1CHCY                                           CAP204A
     C**********         EVAL      WTOCCY = R1CRCY                                           CAP204A
     C**********         EXSR      SRCCYCVT                                                  CAP204A
     C**********         EVAL      WCAMT = WAMTT                                             CAP204A
     C**********         EVAL      WEXRT = WEXRT2                                            CAP204A
     C**********         ENDIF                                                               CAP204A
     C**********         ENDIF                                                               CAP204A
      *
     C                   ENDSL
      *
     C**********         ELSE                                                                CAP204A
      *****************************************************************                      CAP204A
     C**********         IF        DSACCOUNT = CHACCT                                        CAP204A
     C**********         EVAL      WCAMT = WPAMT                                             CAP204A
     C**********         EVAL      WEXRT = 1                                                 CAP204A
     C**********         IF        R1CRCY <> R1CHCY                                          CAP204A
     C**********         EVAL      WAMT = WCAMT                                              CAP204A
     C**********         EVAL      WFRCCY = R1CHCY                                           CAP204A
     C**********         EVAL      WTOCCY = R1CRCY                                           CAP204A
     C**********         EXSR      SRCCYCVT                                                  CAP204A
     C**********         EVAL      WCAMT = WAMTT                                             CAP204A
     C**********         EVAL      WEXRT = WEXRT2                                            CAP204A
     C**********         ENDIF                                                               CAP204A
     C**********         ENDIF                                                               CAP204A
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMOVVAL - Move output values to parameters                   *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRMOVVAL      BEGSR
 
     C                   MOVE      WFAMT         PFAMT
     C                   MOVE      WAMTAF        PAMTAF
     C                   MOVE      WCAMT         PCAMT
     C                   MOVE      WEXRT         PEXRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCCYCVT - Currency Conversion                                *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SRFAMT, SRCAMT                                         *
      *                                                               *
      *****************************************************************
 
     C     SRCCYCVT      BEGSR
      *
      ** FROM currency
      *
     C                   EVAL      WCCY = WFRCCY
     C                   EXSR      SRCURR
     C                   EVAL      WFRDEC = A6NBDP
     C                   EVAL      WFRSPRT = A6SPRT
     C                   EVAL      WFRMDIN = A6MDIN
      *
      ** TO currency
      *
     C                   EVAL      WCCY = WTOCCY
     C                   EXSR      SRCURR
     C                   EVAL      WTODEC = A6NBDP
     C                   EVAL      WTOSPRT = A6SPRT
     C                   EVAL      WTOMDIN = A6MDIN
      *
      ** Convert amount to a different currency
      *
     C                   CALL      'ZCCYCN'
     C                   PARM                    WAMT
     C                   PARM                    WFRCCY
     C                   PARM                    WTOCCY
     C                   PARM                    WFRSPRT
     C                   PARM                    WTOSPRT
     C                   PARM                    WFRMDIN
     C                   PARM                    WTOMDIN
     C                   PARM                    WFRDEC
     C                   PARM                    WTODEC
     C                   PARM                    WAMTT
     C                   PARM                    WEXRT2
     C                   PARM                    WMDIN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZCONV  - Currency Decimal places conversion                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SRCAMT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRZCONV       BEGSR
      *
      ** FROM currency
      *
     C                   EVAL      WCCY = ZCCYI
     C                   EXSR      SRCURR
     C                   EVAL      ZCDPI  = A6NBDP
      *
      ** TO currency
      *
     C                   EVAL      WCCY = ZCCYO
     C                   EXSR      SRCURR
     C                   EVAL      ZCDPO  = A6NBDP
      *
      ** Adjust decimal places for different currency
      *
     C                   EXSR      ZCONV
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCURR   - Check currency                                     *
      *                                                               *
      * Called by: SRZCONV                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database Error
      *
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = WCCY
     C                   EVAL      DBPGM = 'RE0046'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    PRTCD
      ** Customer number
     C                   PARM                    PCUST
      ** Currency
     C                   PARM                    PCCY
      ** Account code
     C                   PARM                    PACOD
      ** Account sequence
     C                   PARM                    PACSQ
      ** Branch
     C                   PARM                    PBRCA
      ** Transaction reference
     C                   PARM                    PREF
      ** Posting amount
     C                   PARM                    PPAMT
      ** Posting Date (Execution Date)                                                      BUG27563
     C                   PARM                    PEXDT                                      BUG27563
      ** Fee amount
     C                   PARM                    PFAMT
      ** Amount after fee
     C                   PARM                    PAMTAF
      ** Contra currency
     C                   PARM                    PCCCY
      ** Contra amount
     C                   PARM                    PCAMT
      ** Exchange rate
     C                   PARM                    PEXRT
 
     C     KLIST1        KLIST
     C**********         KFLD                    PBRCA                                      BUG27563
     C                   KFLD                    PREF
     C                   KFLD                    PEXDT                                      BUG27563
 
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
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
     C                   END
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
     C/COPY ZSRSRC,ZCONVZ1ILE
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
