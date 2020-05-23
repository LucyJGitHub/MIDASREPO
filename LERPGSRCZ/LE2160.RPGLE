     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover interest rate fixing prompt')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2160 - Rollover Interest Rate Fixing Prompt                *
      *                                                               *
      *  Function: This module is called from the Transactions Input  *
      *            menu. It validates the prompt fields entered by    *
      *            the user and for each loan fulfilling the selection*
      *            criteria, it determines the effective interest     *
      *            rate to be fixed on the loan and calls LE2165 for  *
      *            update.                                            *
      *                                                               *
      *  Component of: LEC2160 - Rollover Int. Rate Fixing Input Ctl  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. FCM101E            Date 25Apr19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 260183             Date 29Oct15               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238541             Date 21Jul06               *
      *                 235907             Date 21Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 223823             Date 16Dec03               *
      *                 BUG6924            Date 04May05               *
      *                 CAP074             Date 08Aug02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CLE011  *CREATE    Date 07Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FCM101E - Add Floor Rates checking on rate fixing            *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  260183 - LEC2460 failed because LF/LELOANL2 can't find       *
      *           matured loans that has RATF='Y'. Amend sources such *
      *           that these loans are also retrieved using a new LF. *
      *           (Applied for MD-36224).                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  238541 - Applied fix 235907.                                 *
      *  235907 - Incorrect processing for loans with rate fixing days*
      *           equal to 00. Applied additional fix existing on     *
      *           LE2160 by fix 228121.                               *
      *         - If rate to be used is today's rate, obtain it from  *
      *           live base rates file, not from history file.        *
      *         - When called with *ALL option, process also loans    *
      *           with rollover date after today.                     *
      *         - Wrong date selection for loans with zero fix days.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  223823 - Rate was not fixed if Loan had not previously been  *
      *           attached to a Base rate so CHIN <> 'R'. Check new   *
      *           change indicator on rollover details too.           *
      *  BUG6924- Recompile over changes in display file.             *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CSD006 - Use correct parameters for Access Objects           *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10        End-of-file indicator for LELOANL0               *
      *    12        File access indicator for LELOANL2               *
      *    21        Screen field error, 'From Loan Reference'        *
      *    22        Screen field error, 'To Loan Reference'          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRValidLoan - Validation of input fields.                    *
      *  SRDefault - Performs defaulting prior to main processing.    *
      *  SRProcess - Performs detail processing of fields.            *
      *  SRFixRate - Calculates rates.                                *
      *  SRSndMsg - Sends message to program queue.                   *
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
 
      ** Rollover Interest Rate Fixing Prompt screen
     FLE2160DF  CF   E             WORKSTN INFDS(ScrInfo)
      *
      ** Live Loan details
     FLELOANL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
      *
      ** Live Rollover details
     FLELOANL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L2)
      *                                                                                       260183
     FLELOANLH  IF   E           K DISK    INFSR(*PSSR) PREFIX(L2)                            260183
     F                                     RENAME(CLOANCKF: LELOANF)                          260183
      ** Loans to be reactivated Rollover details                                             260183
      *                                                                                       260183
     FXXCLOQY0  IF   E           K DISK    INFSR(*PSSR)                                      FCM101E
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
                                                                                             FCM101E
      ** Externally described DS for Switchable Feature Details                              FCM101E
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 FCM101E
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *                                                                                       CLE148
      ** Parameters for calling AOSVALR0 (System Value Access Object)                         CLE148
      *                                                                                       CLE148
     D PRetCode        S              7A                                                      CLE148
     D PSysValK1       S             20A                                                      CLE148
     D PSysVal1        S            200A                                                      CLE148
     D PSysValK2       S             20A                                                      CLE148
     D PSysVal2        S            200A                                                      CLE148
     D PSysValK3       S             20A                                                      CLE148
     D PSysVal3        S            200A                                                      CLE148
     D PSysValK4       S             20A                                                      CLE148
     D PSysVal4        S            200A                                                      CLE148
     D PSysValK5       S             20A                                                      CLE148
     D PSysVal5        S            200A                                                      CLE148
     D PSysValK6       S             20A                                                      CLE148
     D PSysVal6        S            200A                                                      CLE148
     D PSysValK7       S             20A                                                      CLE148
     D PSysVal7        S            200A                                                      CLE148
     D PSysValK8       S             20A                                                      CLE148
     D PSysVal8        S            200A                                                      CLE148
     D PSysValK9       S             20A                                                      CLE148
     D PSysVal9        S            200A                                                      CLE148
     D PSysValK10      S             20A                                                      CLE148
     D PSysVal10       S            200A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ALAR            S              1    DIM (6)                                            CLE148
      ** Loan master file DS parameter of LE2165
     D PLoanCLDS     E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(L0)
 
      ** Incoming Message parameter of LE2165
     D PIncomingDS     DS            99
     D  PIMsgTyp               1      4
     D  PITrnUsr               5     20
     D  PITrnWrkStn           21     36
     D  PITrnRef              37     51
     D  PITrnSeqNum           52     55S 0
     D  PITrnAct              56     56
     D  PITrnDateStmp         57     64S 0
     D  PITrnTimeStmp         65     72S 0
     D  PINumRec              73     76S 0
     D  PIFiller              77     80
     D**PILoanRef             81     86S 0                                                    CLE148
     D  PILoanRef             81     86A                                                      CLE148
     D  PIFixIntRate          87     98
     D  PIFixRateInd          99     99
      *
      ** Outgoing Message parameter of LE2165
     D POutgoingDS     DS           172
     D  POMsgTyp               1      4
     D  POTrnUsr               5     20
     D  POTrnWrkStn           21     36
     D  POTrnRef              37     51
     D  POTrnSeqNum           52     55S 0
     D  POTrnAct              56     56
     D  POTrnDateStmp         57     64S 0
     D  POTrnTimeStmp         65     72S 0
     D  PONumRec              73     76S 0
     D  POFiller              77     80
     D  POMsgSev              81     81
     D  POMsgID               82     88
     D  POMsgTxt              89    166
     D**POLoanRef            167    172S 0                                                    CLE148
     D  POLoanRef            167    172A                                                      CLE148
      *
     D LEALLO        E DS                  EXTNAME(LEALLO)
      *
     D                 DS
     D SFRLN                   1      6
     D*WFRLN****               1      6S 0                                                    CLE148
     D STOLN                   7     12
     D*WTOLN****               7     12S 0                                                    CLE148
      *
      ** Display file information data structure
     D ScrInfo       E DS                  EXTNAME(Y2I#DSP)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Base rate codes
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** Externally described DS for Historic Base rate
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D WError          S              1A
     D WWorkAll        S              1A
     D WWorkBase       S              2S 0
     D WWorkCcy        S              3A
     D WBaseRate       S             11P 7
     D WFixedRate      S             11P 7
     D WRateFixedInd   S              1A
     D WSpreadInd      S              1A
     D WSpread         S             11P 7
     D POYYYYMMDD      S              8S 0
     D PRtnCde         S              7A
     D POption         S              7A
     D PRTCD           S              7A                                                      CLE148
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
     D WChr011         S             11A                                                      CLE148
     D WType           S              1A                                                      CLE148
     D WArrIdx         S              1  0                                                    CLE148
     D WLoanStr        S              6                                                       CLE148
     D WValInp         C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567-               CLE148
     D                                     89'                                                CLE148
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   DOW       *INKC = *OFF
      *
      *************************
      ** Screen input/output **
      *************************
      *
     C                   WRITE     LE2160F0
     C                   WRITE     LE2160F2
      *
      ** Inform user of the range of loans the were finished processing
     C                   IF        (SFRLN <> *BLANKS)
     C                             AND (WError <> 'Y')
     C                   EVAL      WZMsgData = SFRLN
     C                   CAT       STOLN:0       WZMsgData
     C                   EVAL      WZMsgID = 'LER0412'
     C                   EXSR      SRSndMsg
     C                   EVAL      SFRLN = *BLANKS
     C                   EVAL      STOLN = *BLANKS
     C                   ENDIF
     C                   WRITE     LE2160C0
     C                   EXFMT     LE2160F1
      *
     C                   SELECT
      *
      ***************
      ** F3 - Exit **
      ***************
      *
     C                   WHEN      *INKC = *ON
      *
      ******************
      ** F5 - Refresh **
      ******************
      *
     C                   WHEN      *INKE = *ON
      *
     C                   EVAL      SFRLN = *BLANKS
     C                   EVAL      STOLN = *BLANKS
     C                   MOVEA     '00'          *IN(21)
      ** Clear program queue
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    WZMsgPgm
     C                   PARM                    WZMsgMod
     C                   PARM                    WZMsgProc
      *
      *************
      ** <Enter> **
      *************
      *
     C                   OTHER
      *
      ** Validate user input of the 'From' and 'To' loan references.
      *
     C                   EXSR      SRValidLoan
      *
      ** Continue processing if all inputs are OK
      *
     C                   IF        WError = 'N'
      *
     C                   MOVE      SFRLN         KLNRF
     C     KLoan         SETLL     LELOANL0
     C                   READ      LELOANL0                               10
      *
      ** Process all Rollover loans from LELOANL0 starting
      ** from the 'From Loan' until the end of file or an error is detected.
     C                   DOW       (*IN10 = *OFF)
     C                             AND (WError = 'N')
     C**********                   AND (L0LNRF <= WTOLN)                                      CLE148
     C                             AND (L0LNRF <= STOLN)                                      CLE148
      *
     C     L0LNRF        CHAIN     LELOANL2                           12
      *                                                                                       260183
      ** If loan details cannot be found in live loans                                        260183
      ** try looking at loans that are matured but will                                       260183
      ** be reactivated                                                                       260183
      *                                                                                       260183
     C                   IF        *IN12 = *ON                                                260183
     C                             AND (L0RATF = 'Y')                                         260183
     C     L0LNRF        CHAIN     LELOANLH                           12                      260183
     C                   ENDIF                                                                260183
      *                                                                                       260183
     C                   IF        *IN12 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBase
     C                   MOVEL     'LELOANL2'    DBFile
     C                   MOVEL     KLNRF         DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         IF        L0CHIN = 'R'                                               223823
      * Process loan if New Change Indicator = 'R' (change at Rollover)                       223823
      * or New Change Indicator is blank & previous value was 'R'.                            223823
     C                   IF        L0NCHI = 'R'                                               223823
     C                             OR (L0CHIN = 'R')                                          223823
     C                             AND (L0NCHI = ' ')                                         223823
     C                   EXSR      SRProcess
     C                   IF        POMsgSev = 'E'
     C                   IF        (POMsgID = 'LER0401')
     C                             OR (POMsgID = 'LER0402')
     C                   MOVEL     POLoanRef     WZMsgData
     C                   ENDIF
     C                   EVAL      WZMsgID = POMsgID
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndMsg
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      LELOANL0                               10
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidLoan - Performs detail validation of the input-capable*
      *                fields.                                        *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     ZAMSGCLRPG, SRSndMsg, ZALIGN, SRDefault           *
      *                                                               *
      *****************************************************************
     C     SRValidLoan   BEGSR
      *
      *******************************
      ** Validation Initialization **
      *******************************
      *
     C                   EVAL      WError = 'N'
     C                   MOVEA     '00'          *IN(21)
      ** Clear program queue
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    WZMsgPgm
     C                   PARM                    WZMsgMod
     C                   PARM                    WZMsgProc
      *
      *****************
      ** 'From' Loan **
      *****************
      *
      ** Mandatory. Must be either numeric or '*ALL'.
      *
     C                   SELECT
      *
     C                   WHEN      SFRLN = *BLANKS
     C                   EVAL      WZMsgID = 'LER0406'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN21 = *ON
      *
     C                   WHEN      %TRIM(SFRLN) = '*ALL'
     C                   IF        (STOLN <> *BLANKS)
     C                   EVAL      WZMsgID = 'LER0411'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *ON
     C                   GOTO      EXValidLoan
     C                   ENDIF
      *
     C                   OTHER
     C                   IF        ( wLoanAlpha = 'Y' )                                       CLE148
     C                   MOVE      *BLANKS       WLoanStr                                     CLE148
     C                   EVAL      WLoanStr = SFRLN                                           CLE148
     C                   EVAL      WType = 'F'                                                CLE148
     C                   EXSR      LoanSR                                                     CLE148
     C                   EVAL      SFRLN = WLoanStr                                           CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVE      *BLANKS       PIChr016
     C                   MOVE      SFRLN         PIChr016
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM                    PIChr016         16
     C                   PARM      *ZERO         PIDec010          1 0
     C                   PARM      6             PIDig020          2 0
     C                   PARM      *BLANKS       POChr016         16
     C                   IF        PRtnCde <> *BLANKS
     C                   EVAL      WZMsgID = 'LER0407'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   MOVE      POChr016      SFRLN
     C                   ENDIF
     C                   ENDIF                                                                CLE148
 
     C                   ENDSL
      *
      ***************
      ** 'To' Loan **
      ***************
      *
      ** Optional. If entered must be numeric.
      *
     C                   IF        STOLN <> *BLANKS
      *
     C                   IF        ( wLoanAlpha = 'Y' )                                       CLE148
     C                   MOVE      *BLANKS       WLoanStr                                     CLE148
     C                   EVAL      WLoanStr = STOLN                                           CLE148
     C                   EVAL      WType = 'T'                                                CLE148
     C                   EXSR      LoanSR                                                     CLE148
     C                   EVAL      STOLN = WLoanStr                                           CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVE      *BLANKS       PIChr016
     C                   MOVE      STOLN         PIChr016
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM                    PIChr016
     C                   PARM      *ZERO         PIDec010
     C                   PARM      6             PIDig020
     C                   PARM      *BLANKS       POChr016
     C                   IF        PRtnCde <> *BLANKS
     C                   EVAL      WZMsgID = 'LER0409'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WError = 'Y'
     C                   GOTO      EXValidLoan
     C                   ELSE
     C                   MOVE      POChr016      STOLN
     C                   ENDIF                                                                CLE148
     C                   ENDIF
      *
     C                   ENDIF
      *
      ****************
      ** Defaulting **
      ****************
      *
     C                   EXSR      SRDefault
      *
      **********************
      ** Cross Validation **
      **********************
      *
      ** Do cross validation if both input fields are valid
      *
     C                   IF        WError <> 'Y'
      *
     C                   IF        STOLN <> *BLANKS
      *
      ** 'To' loan should NOT be less than the 'From' loan
     C**********         IF        WTOLN < WFRLN                                              CLE148
     C                   IF        STOLN < SFRLN                                              CLE148
     C                   EVAL      WZMsgID = 'LER0410'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WError = 'Y'
     C                   GOTO      EXValidLoan
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If 'To' loan is blank, 'From' loan should be a valid loan with
      ** Rate Change indicator = 'R' and either Next Base Rate Type <> 0
      ** or Base Rate Code <> 0.
     C                   IF        (STOLN = *BLANKS)
     C                             OR (STOLN = SFRLN)
      *
     C                   MOVE      SFRLN         KLNRF
     C     KLoan         CHAIN     LELOANL0                           10
      *
     C                   IF        (*IN10 = *ON)
     C                   EVAL      WZMsgID = 'LER0401'
     C                   EVAL      WZMsgData = SFRLN
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WError = 'Y'
     C                   GOTO      EXValidLoan
     C                   ENDIF
      *
     C                   IF        (*IN10 = *OFF)
     C**********         IF        (L0CHIN <> 'R')                                            235907
     C**********                   OR (L0NBRA = 0 AND L0BRTT = 0)                             235907
     C                   IF        (L0NBRA = 0 AND L0BRTT = 0)                                235907
     C                   EVAL      WZMsgID = 'LER0408'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WError = 'Y'
     C                   GOTO      EXValidLoan
     C                   ENDIF
      *                                                                                       235907
     C                   IF        (L0CHIN = 'R' AND L0NCHI = ' ')                            235907
     C                             OR (L0NCHI = 'R')                                          235907
     C                   ELSE                                                                 235907
     C                   EVAL      WZMsgID = 'LER0408'                                        235907
     C                   EXSR      SRSndMsg                                                   235907
     C                   EVAL      *IN21 = *ON                                                235907
     C                   EVAL      *IN22 = *ON                                                235907
     C                   EVAL      WError = 'Y'                                               235907
     C                   GOTO      EXValidLoan                                                235907
     C                   ENDIF                                                                235907
     C                   ENDIF
      *
      ** If 'From loan' is valid
     C                   IF        (*IN21 = *OFF)
     C                   EVAL      STOLN = SFRLN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXValidLoan   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Performs defaulting prior to main processing.    *
      *                                                               *
      *  Called by: SRValidLoan                                       *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRDefault     BEGSR
      *
     C                   EVAL      WWorkAll = *BLANK
      *
     C                   IF        %TRIM(SFRLN) = '*ALL'
     C                   IF        ( WLoanAlpha = 'Y' )                                       CLE148
     C                   EVAL      SFRLN = 'AAAAAA'                                           CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      SFRLN = '000001'
     C                   ENDIF                                                                CLE148
     C                   EVAL      STOLN = '999998'
     C                   EVAL      WWorkAll = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Performs detail processing of fields.            *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     AOBSRTR0, ZFWDT, SRFixRate, ZDATE9, *PSSR, ZEDIT, *
      *             LE2165                                            *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      ********************
      ** Base Rate Code **
      ********************
      *
     C                   EVAL      WWorkBase = 0
      ** If Next Base Rate Type is present
     C                   IF        L0NBRA <> 0
     C                   EVAL      WWorkBase = L0NBRA
      ** If Next Base Rate Type is NOT present, check Next Rate/Spread
     C                   ELSE
      ** If Next Rate/Spread is also zero, use old base rate
     C                   IF        L0NRTS = 0
     C                   EVAL      WWorkBase = L0BRTT
     C                   ENDIF
     C                   ENDIF
      *
      *******************
      ** Currency Code **
      *******************
      *
      ** If New Currency is present, use New Currency else use Loan
      ** Currency
     C                   IF        L2NCCY <> *BLANKS
     C                   EVAL      WWorkCcy = L2NCCY
     C                   ELSE
     C                   EVAL      WWorkCcy = L0CCY
     C                   ENDIF
      *
      ******************************************
      ** Fixed Rate and Rate Fixing Indicator **
      ******************************************
      *
     C                   EVAL      WFixedRate = 0
     C                   EVAL      WRateFixedInd = *BLANK
      *
      ** If Next Base Rate Type OR Base Rate Code is used
     C                   IF        WWorkBase <> 0
      *
     C                   MOVE      WWorkBase     PBASE
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      WWorkCcy      PCYCD             3
     C                   PARM                    PBASE             2
     C*****SDBSRT********PARM      *BLANKS       SDBSRT                                       CSD006
     C     SDBSRT        PARM      *BLANKS       DSFDY                                        CSD006
      *
     C                   IF        PRtnCde = *BLANKS
      *
      ** Working day which is the loan rollover rate fixing days
      ** forward from the run date. If rollover fix days is zero, set
      ** working day to 1 to have 1 day forward from the rundate.
     C                   MOVE      L0RFDY        PDaysFwd
     C**********         IF        PDaysFwd = 0                                               235907
     C**********         Z-ADD     1             PDaysFwd                                     235907
     C**********         ENDIF                                                                235907
      *
     C                   CALL      'ZFWDT'
     C                   PARM      BJRDNB        PInpDay           5 0
     C                   PARM                    PDaysFwd          2 0
     C                   PARM      *ZERO         POutDay           5 0
     C                   PARM      WWorkCcy      PCYCD             3
     C                   PARM      *BLANKS       PLocation         3
      *
     C                   IF        (L0RLDT <> 0)
     C**********                   AND (L0RLDT < POutDay)                                     235907
     C                             AND (L0RLDT <= POutDay)                                    235907
     C**********         IF        (WWorkAll = 'Y' AND L0RFDY = '00')                         235907
     C**********                   OR (WWorkAll <> 'Y')                                       235907
     C                   EXSR      SRFixRate
     C**********         ENDIF                                                                235907
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ******************************************
      ** Rollover Interest Rate Fixing Update **
      ******************************************
      *
     C**********         IF        (WWorkAll = 'Y' AND L0RFDY = '00')                         235907
     C**********                   OR (WWorkAll <> 'Y')                                       235907
     C                   IF        WRateFixedInd = 'Y'                                        235907
      *
     C                   EVAL      PIMsgTyp = 'RTFX'
     C                   EVAL      PITrnUsr = PSUser
     C                   EVAL      PITrnWrkStn = PSJobName
     C                   EVAL      PITrnSeqNum = 1
     C                   EVAL      PITrnAct = 'A'
     C                   EVAL      PITrnTimeStmp = PSRunTime
     C                   EVAL      PINumRec = 1
     C                   EVAL      PIFiller = *BLANKS
     C                   EVAL      PILoanRef = L0LNRF
     C                   EVAL      PIFixRateInd = WRateFixedInd
      *
      ** Loan's branch code + Next available ref. from LEALLO + '0001'
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         ADD       1             PCLast                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         MOVE      PCLast        WChr011          11                          CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVE      PCNEXT        WChr011                                      CLE148
     C                   MOVEL     WChr011       PITrnRef
     C                   MOVEL     L0BRCA        PITrnRef
     C                   MOVE      '0001'        PITrnRef
      *
      ** Transaction DateStamp:
      ** MIDAS run date 'DDMMYYYY' or 'MMDDYYYY' depending on the date fmt
     C                   EVAL      PIDay050 = BJRDNB
     C                   CALLB     'ZDATE9'
     C                   PARM                    PIDay050          5 0
     C                   PARM      *ZERO         POYYYYMMDD
     C                   PARM      *BLANKS       PORtn             1
      *
     C                   IF        PORtn = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     POYYYYMMDD    WYYYY             4
     C                   MOVE      POYYYYMMDD    WChr004           4
     C                   MOVEL     WChr004       WMM               2
     C                   MOVE      WChr004       WDD               2
      *
     C                   IF        BJDFIN = 'D'
     C                   MOVEL     WDD           WChr004
     C                   MOVE      WMM           WChr004
     C                   ELSE
     C                   MOVEL     WMM           WChr004
     C                   MOVE      WDD           WChr004
     C                   ENDIF
     C                   MOVEL     WChr004       PITrnDateStmp
     C                   MOVE      WYYYY         PITrnDateStmp
      *
      ** Suppresed leading zeros with 7 decimal places
     C                   MOVE      *BLANKS       PIFixIntRate
     C                   MOVE      *BLANKS       PIOChr016
     C                   MOVE      WFixedRate    PIOChr016
     C                   CALL      'ZEDIT'
     C                   PARM                    PIOChr016        16
     C                   PARM      7             PIDec010
     C                   MOVE      PIOChr016     PIFixIntRate
      *
     C                   CALL      'LE2165'
     C                   PARM      'I'           PMode             1
     C                   PARM                    PLoanCLDS
     C                   PARM                    PIncomingDS
     C                   PARM      *BLANKS       POutgoingDS
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFixRate - Performs calculation of rates.                   *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls:     ZBKDT, AOBSRTR0                                   *
      *                                                               *
      *****************************************************************
     C     SRFixRate     BEGSR
      *
     C                   EVAL      WRateFixedInd = 'Y'
     C                   EVAL      WBaseRate = 0
     C                   EVAL      WFixedRate = 0
      *
      ***************
      ** Base Rate **
      ***************
      *
     C**********         IF        L0RFDY = '00'                                              235907
     C**********                                                                              235907
     C**********         EVAL      WBaseRate = BANBRT                                         235907
     C**********                                                                              235907
     C**********         ELSE                                                                 235907
      *
      ** Working day which is the loan rollover rate fixing days
      ** back from the rollover date
     C                   MOVE      L0RFDY        PDaysBck
     C                   CALLB     'ZBKDT'
     C                   PARM      L0RLDT        PInpOutDay        5 0
     C                   PARM      WWorkCcy      PCYCD
     C                   PARM      *BLANKS       PLocation
     C                   PARM                    PDaysBck          2 0
     C                   PARM                    PDayNbr           5 0
      *                                                                                       235907
      ** Use the new base rate if the value date of the new rate is                           235907
      ** before the fixing date                                                               235907
      *                                                                                       235907
     C                   IF        BAVDNR <= PDayNbr                                          235907
     C                   EVAL      WBaseRate = BANBRT                                         235907
     C                   ELSE                                                                 235907
      *
      ** Determine the historic base rate applicable
     C                   MOVE      WWorkBase     PBaseP
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      WWorkCcy      PCYCD
     C                   PARM                    PBaseP            2 0
     C                   PARM      PDayNbr       PDayNo            5 0
     C     SDBSHS        PARM                    SDBSHS
      *
     C                   IF        PRtnCde = *BLANKS
     C                   EVAL      WBaseRate = G0CBSR
     C                   ELSE
     C                   EVAL      WBaseRate = BANBRT
     C                   ENDIF
     C                   ENDIF                                                                235907
     C**********                                                                              235907
     C**********         ENDIF                                                                235907
      *
      ***********************************
      ** Rate/Spread, Spread Indicator **
      ***********************************
      *
     C                   IF        L0NSIN <> *BLANK
     C                   EVAL      WSpreadInd = L0NSIN
     C                   EVAL      WSpread = L0NRTS
     C                   ELSE
     C                   EVAL      WSpreadInd = L0SPIN
     C                   EVAL      WSpread = L0RTSP
     C                   ENDIF
      *                                                                                      FCM101E
      ** Check Base Rate vs Floor Rates and recalculate Spread                               FCM101E
      *                                                                                      FCM101E
     C                   If        FCM101 = 'Y'                                              FCM101E
      *                                                                                      FCM101E
     C                   IF        L0PTYP = 61 or L0PTYP = 62                                FCM101E
     C                             or L0PTYP = 64 or L0PTYP = 66                             FCM101E
     C                             or L0PTYP = 64 or L0PTYP = 66                             FCM101E
     C                             or L0PTYP = 68 or L0PTYP = 69                             FCM101E
     C                             or L0PTYP = 70 or L0PTYP = 71                             FCM101E
     C                             or L0PTYP = 72                                            FCM101E
      *                                                                                      FCM101E
     C     L0NNSG        Ifne      *Blank                                                    FCM101E
     C                   Z-add     L0NNSP        WCNSP                                       FCM101E
     C                   Move      L0NNSG        WCNSG                                       FCM101E
     C                   Else                                                                FCM101E
     C                   Z-add     L0CNSP        WCNSP                                       FCM101E
     C                   Move      L0CNSG        WCNSG                                       FCM101E
     C                   Endif                                                               FCM101E
      *                                                                                      FCM101E
     C     L0LNRF        CHAIN     XXCLOQY0                                                  FCM101E
      *                                                                                      FCM101E
     C                   If        %found                                                    FCM101E
     C                   Move      XQBRSG        BASFSG                                      FCM101E
     C                   Z-add     XQBRTF        BASFLR                                      FCM101E
     C     XQBRSG        Ifeq      '-'                                                       FCM101E
     C     XQBRTF        MULT      -1            BASFLR                                      FCM101E
     C                   Endif                                                               FCM101E
                                                                                             FCM101E
     C                   Move      XQAISG        AIRFSG                                      FCM101E
     C                   Z-add     XQAIRF        AIRFLR                                      FCM101E
     C     XQAISG        Ifeq      '-'                                                       FCM101E
     C     XQAIRF        MULT      -1            AIRFLR                                      FCM101E
     C                   Endif                                                               FCM101E
                                                                                             FCM101E
     C                   Else                                                                FCM101E
     C                   Z-Add     *zero         BASFLR                                      FCM101E
     C                   Move      *blank        BASFSG                                      FCM101E
     C                   Z-Add     *zero         AIRFLR                                      FCM101E
     C                   Move      *blank        AIRFSG                                      FCM101E
     C                   Endif                                                               FCM101E
      *                                                                                      FCM101E
     C                   Call      'XXCALCSPRT'                                              FCM101E
     C                   Parm      *BLANKS       PRTCD             7                         FCM101E
     C                   Parm                    WBaseRate                                   FCM101E
     C                   Parm                    BASFLR           11 7                       FCM101E
     C                   Parm                    BASFSG            1                         FCM101E
     C                   Parm                    AIRFLR           11 7                       FCM101E
     C                   Parm                    AIRFSG            1                         FCM101E
     C                   Parm                    WCNSP            11 7                       FCM101E
     C                   Parm                    WCNSG             1                         FCM101E
     C                   Parm      *ZERO         PNewSpread       11 7                       FCM101E
     C                   Parm      *ZERO         PFinalRate       11 7                       FCM101E
     C                   Parm      *Blank        PNewSpreadSign    1                         FCM101E
      *                                                                                      FCM101E
     C                   Z-add     PNewSpread    WSpread                                     FCM101E
     C                   Move      WCNSG         WSpreadInd                                  FCM101E
      *                                                                                      FCM101E
     C     PNewSpreadSignIfne      ' '                                                       FCM101E
     C                   Move      PNewSpreadSignWSpreadInd                                  FCM101E
     C                   Endif                                                               FCM101E
      *                                                                                      FCM101E
     C                   Endif                                                               FCM101E
     C                   Endif                                                               FCM101E
      *
      ****************
      ** Fixed Rate **
      ****************
      *
     C                   SELECT
     C                   WHEN      WSpreadInd = 'A'
     C                   EVAL      WFixedRate = WBaseRate + WSpread
     C                   WHEN      WSpreadInd = 'S'
     C                   EVAL      WFixedRate = WBaseRate - WSpread
     C                   WHEN      WSpreadInd = 'P'
     C                   EVAL      WFixedRate = WBaseRate * (WSpread/100)
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Sends message to program queue.                   *
      *                                                               *
      *  Called by: Main processing, SRValidLoan                      *
      *                                                               *
      *  Calls:     ZAMSGTOSCN                                        *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
      *
      ** Defaulting
      *
     C                   IF        WZMsgFile = *BLANKS
     C                   EVAL      WZMsgFile = 'LERMSGF'
     C                   ENDIF
      *
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    WZMsgFile        10
     C                   PARM                    WZMsgID           7
     C                   PARM                    WZMsgData        45
     C                   PARM                    WZMsgPgm         10
     C                   PARM                    WZMsgMod         10
     C                   PARM                    WZMsgProc        10
      *
     C                   EVAL      WZMsgID = *BLANKS
     C                   EVAL      WZMsgData = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Define key list of LELOANL0 and LELOANL2
      *
     C     KLoan         KLIST
     C                   KFLD                    KLNRF
      *
     C     *DTAARA       DEFINE                  LDA
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C     *LIKE         DEFINE    L0LNRF        KLNRF
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde           7
     C                   PARM      '*FIRST '     POption           7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     POption       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Program, module and procedure names for database error proc'g
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Set up constant screen fields
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SRUNA = BJMRDT
     C                   EVAL      SWSID = PSJobName
     C                   EVAL      SPGM  = PSProcPgm
      *
      ** Set up constant parameters for sending/clearing messages
      *
     C                   EVAL      WZMsgPgm = PSProcPgm
     C                   EVAL      WZMsgMod = PSProcMod
     C                   EVAL      WZMsgProc = PSProcName
      *
      ** Determine if FCM101 is installed                                                    FCM101E
      *                                                                                      FCM101E
     C                   MOVE      'N'           FCM101            1                         FCM101E
     C                   CALL      'AOSARDR0'                                                FCM101E
     C                   PARM      *BLANK        PRtnCde                                     FCM101E
     C                   PARM      '*VERIFY'     POption                                     FCM101E
     C                   PARM      'FCM101'      PSard             6                         FCM101E
     C     SCSARD        PARM      SCSARD        DSFDY                                       FCM101E
                                                                                             FCM101E
     C     PRtnCde       IFEQ      *BLANK                                                    FCM101E
     C                   MOVE      'Y'           FCM101                                      FCM101E
     C                   ENDIF                                                               FCM101E
      *                                                                                       CER001
      ** Parameter list for calling AOSVALR0                                                  CLE148
      *                                                                                       CLE148
     C     P_AOSVALR0    PList                                                                CLE148
      *                                                                                       CLE148
      ** Return Code (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PRetCode                                     CLE148
      *                                                                                       CLE148
      ** System Value to be retrieved (Input)                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysValK1                                    CLE148
      *                                                                                       CLE148
      ** Value returned (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysVal1                                     CLE148
     C                   PARM                    PSysValK2                                    CLE148
     C                   PARM                    PSysVal2                                     CLE148
     C                   PARM                    PSysValK3                                    CLE148
     C                   PARM                    PSysVal3                                     CLE148
     C                   PARM                    PSysValK4                                    CLE148
     C                   PARM                    PSysVal4                                     CLE148
     C                   PARM                    PSysValK5                                    CLE148
     C                   PARM                    PSysVal5                                     CLE148
     C                   PARM                    PSysValK6                                    CLE148
     C                   PARM                    PSysVal6                                     CLE148
     C                   PARM                    PSysValK7                                    CLE148
     C                   PARM                    PSysVal7                                     CLE148
     C                   PARM                    PSysValK8                                    CLE148
     C                   PARM                    PSysVal8                                     CLE148
     C                   PARM                    PSysValK9                                    CLE148
     C                   PARM                    PSysVal9                                     CLE148
     C                   PARM                    PSysValK10                                   CLE148
     C                   PARM                    PSysVal10                                    CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   EVAL      PRetCode = *BLANKS                                         CLE148
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   EVAL      PSysVal1 = *BLANKS                                         CLE148
      *                                                                                       CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
      *                                                                                       CLE148
      ** If Error retrieving the System values                                                CLE148
      *                                                                                       CLE148
     C                   IF        %ERROR OR PRetCode <> *BLANKS                              CLE148
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'AOSVALR0'                                        CLE148
     C                   EVAL      DBASE = 2                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = 'LE2160'                                           CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
      *
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
      *  Called by: Error trapping routine                            *
      *                                                               *
      *  Calls:     DBERRCTL                                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CLE148
      /EJECT                                                                                  CLE148
      *****************************************************************                       CLE148
      *                                                               *                       CLE148
      * LoanSR - Alpha Loan mode.                                     *                       CLE148
      *        - This subroutine will right align alphanumeric        *                       CLE148
      *          inputs and perform necessary validation.             *                       CLE148
      *        - Will include leading zeros after right aligning.     *                       CLE148
      *                                                               *                       CLE148
      * Called by: SRValidLoan                                        *                       CLE148
      *                                                               *                       CLE148
      *****************************************************************                       CLE148
      *                                                                                       CLE148
     C     LoanSR        BEGSR                                                                CLE148
     C                   EVALR     WLoanStr=%TRIMR(WLoanStr)                                  CLE148
      *                                                                                       CLE148
      ** Clear ALAR then add leading zeros in LOANSTR                                         CLE148
      *                                                                                       CLE148
     C                   MOVEA     *BLANKS       ALAR                                         CLE148
     C                   MOVEA     WLoanStr      ALAR                                         CLE148
     C                   Z-ADD     1             WArrIdx                                      CLE148
     C     ALAR(WArrIdx) DOWEQ     ' '                                                        CLE148
     C                   MOVE      '0'           ALAR(WArrIdx)                                CLE148
     C                   ADD       1             WArrIdx                                      CLE148
     C                   ENDDO                                                                CLE148
     C                   MOVEA     ALAR          WLoanStr                                     CLE148
      *                                                                                       CLE148
      ** Perform checking of there are invalid characters.                                    CLE148
      *                                                                                       CLE148
     C                   IF        ( %CHECK (WvalInp : WLoanStr) > 0 )                        CLE148
     C                   EVAL      WZMsgID = 'LER0416'                                        CLE148
     C                   EVAL      WError = 'Y'                                               CLE148
     C                   EXSR      SRSndMsg                                                   CLE148
     C                   IF        ( WType = 'F')                                             CLE148
     C                   EVAL      *IN21 = *ON                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      *IN22 = *ON                                                CLE148
     C                   ENDIF                                                                CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   ENDSR                                                                CLE148
      *****************************************************************                       CLE148