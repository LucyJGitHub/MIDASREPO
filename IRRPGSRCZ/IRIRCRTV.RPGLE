     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single CCY Retrieve IRC Details Module')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRIRCRTV - Retrieve IRC Details Module                       *
      *                                                               *
      *  Function:  This module will format the IRC details:          *
      *             our/their rate change dates and our/their         *
      *             interest payment dates.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11456           Date 11May06               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11456-Screen-definition file should be alpha              *
      *           (Recompile)                                         *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  30 - Chain Indicator                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      * SRORCD - Set Our Rate Change Dates                            *
      * SROPYD - Set Our Interest Payment Dates                       *
      * SRTRCD - Set Their Rate Change Dates                          *
      * SRTPYD - Set Their Interest Payment Dates                     *
      * SRFRMT - Format Dates                                         *
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
 
     FDLDTSCL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ArraySize       C                   CONST(82)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure used by Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data Structure (long) used by Access Programs
 
     D ORCDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(OR)
 
     D OIPDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(OI)
 
     D TRCDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(TR)
 
     D TIPDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(TI)
 
     D                 DS
     D DtArray                 1    492S 0 DIM(ArraySize)
     D DtArrayA                1    492A
 
      ** Last processing date (82nd PRDT) UR/UP/TR/TP
     D PLastPRDT       DS
     D WLastPRDT               1     12P 0 DIM(4)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PDeal           S              6A
     D PRtCd           S              7A
     D POption         S              7A
     D PADate          S              7A
     D PDate           S              6  0
     D X               S              2  0
     D KDeal           S              6  0
     D KOurThrIn       S              1A
     D KRChInPay       S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
                                                                                              CAP043
      ** Initialise last PRDT work fields                                                     CAP043
                                                                                              CAP043
     C                   EVAL      WLastPRDT(1) = *ZERO                                       CAP043
     C                   EVAL      WLastPRDT(2) = *ZERO                                       CAP043
     C                   EVAL      WLastPRDT(3) = *ZERO                                       CAP043
     C                   EVAL      WLastPRDT(4) = *ZERO                                       CAP043
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SR/SRORCD - Set Our Rate Change Date                   *
      *        SR/SROPYD - Set Our Interest Payment Dates             *
      *        SR/SRTRCD - Set Their Rate Change Date                 *
      *        SR/SRTPYD - Set Their Interest Payment Dates           *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      ORCDScnFmt = *Blanks
     C                   EVAL      OIPDScnFmt = *Blanks
     C                   EVAL      TRCDScnFmt = *Blanks
     C                   EVAL      TIPDScnFmt = *Blanks
 
     C                   EXSR      SRORCD
     C                   EXSR      SROPYD
     C                   EXSR      SRTRCD
     C                   EXSR      SRTPYD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRORCD - Set Our Rate Change Dates                         *
      *                                                               *
      * Called by: SR/SRPROC                                          *
      *                                                               *
      * Calls: SR/SRFRMT - Format Dates                               *
      *                                                               *
      *****************************************************************
 
     C     SRORCD        BEGSR
 
     C                   EVAL      KOurThrIn = 'U'
     C                   EVAL      KRChInPay = 'R'
 
     C                   EXSR      SRFRMT
     C                   MOVEL     DtArrayA      ORCDScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SROPYD - Set Our Interest Payment Dates                    *
      *                                                               *
      * Called by: SR/SRPROC                                          *
      *                                                               *
      * Calls: SR/SRFRMT - Format Dates                               *
      *                                                               *
      *****************************************************************
 
     C     SROPYD        BEGSR
 
     C                   EVAL      KOurThrIn = 'U'
     C                   EVAL      KRChInPay = 'P'
 
     C                   EXSR      SRFRMT
     C                   MOVEL     DtArrayA      OIPDScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRTRCD - Set Their Rate Change Dates                       *
      *                                                               *
      * Called by: SR/SRPROC                                          *
      *                                                               *
      * Calls: SR/SRFRMT - Format Dates                               *
      *                                                               *
      *****************************************************************
 
     C     SRTRCD        BEGSR
 
     C                   EVAL      KOurThrIn = 'T'
     C                   EVAL      KRChInPay = 'R'
 
     C                   EXSR      SRFRMT
     C                   MOVEL     DtArrayA      TRCDScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRTPYD - Set Their Interest Payment Dates                  *
      *                                                               *
      * Called by: SR/SRPROC                                          *
      *                                                               *
      * Calls: SR/SRFRMT - Format Dates                               *
      *                                                               *
      *****************************************************************
 
     C     SRTPYD        BEGSR
 
     C                   EVAL      KOurThrIn = 'T'
     C                   EVAL      KRChInPay = 'P'
 
     C                   EXSR      SRFRMT
     C                   MOVEL     DtArrayA      TIPDScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRFRMT - Format Dates                                      *
      *                                                               *
      * Called by: SR/SRORCD, SR/SROPYD, SR/SRTRCD, SR/SRTPYD         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRFRMT        BEGSR
 
     C                   EVAL      DtArray = *Zeros
     C                   EVAL      X = 1
 
     C                   MOVEL     PDeal         KDeal
 
     C     KDLDTSCL0     SETLL     DLDTSCL0
     C     KDLDTSCL0     READE     DLDTSCL0                               30
 
     C**********         DOW       *IN30 = *OFF                                               CAP043
     C                   DOW       (*IN30 = *OFF) AND (X<83)                                  CAP043
     C                   CALL      'ZDATE2'
     C                   PARM                    PRDT
     C                   PARM                    BJDFIN
     C                   PARM                    PDate
     C                   PARM                    PADate
 
     C                   EVAL      DtArray(X) = PDate
     C                   EVAL      X = X + 1
     C     KDLDTSCL0     READE     DLDTSCL0                               30
                                                                                              CAP043
     C                   IF        (*IN30 = *OFF) AND (X = 82)                                CAP043
     C                   SELECT                                                               CAP043
     C                   WHEN      (KOurThrIn = 'U') AND (KRChInPay = 'R')                    CAP043
     C                   Z-ADD     PRDT          WLastPRDT(1)                                 CAP043
     C                   WHEN      (KOurThrIn = 'U') AND (KRChInPay = 'P')                    CAP043
     C                   Z-ADD     PRDT          WLastPRDT(2)                                 CAP043
     C                   WHEN      (KOurThrIn = 'T') AND (KRChInPay = 'R')                    CAP043
     C                   Z-ADD     PRDT          WLastPRDT(3)                                 CAP043
     C                   WHEN      (KOurThrIn = 'T') AND (KRChInPay = 'P')                    CAP043
     C                   Z-ADD     PRDT          WLastPRDT(4)                                 CAP043
     C                   ENDSL                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
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
 
     C     *Entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PDeal
     C                   PARM                    PLastPRDT                                    CAP043
     C                   PARM                    ORCDScnFmt
     C                   PARM                    OIPDScnFmt
     C                   PARM                    TRCDScnFmt
     C                   PARM                    TIPDScnFmt
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd  <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KDLDTSCL0     KLIST
     C                   KFLD                    KDeal
     C                   KFLD                    KOurThrIn
     C                   KFLD                    KRChInPay
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
