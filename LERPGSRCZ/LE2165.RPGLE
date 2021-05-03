     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Interest Rate Fixing I/C Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2165 - Rollover Interest Rate Fixing I/C Update            *
      *                                                               *
      *  Function:  This module updates, under commitment control,    *
      *  (I/C)      the rollover fixed rate, fixed rate indicator,    *
      *             and advice indicator on the Customer Loans master *
      *             file. If an update fails, it returns an error     *
      *             code with the message description.                *
      *                                                               *
      *             It is only available if switchable feature CLE011 *
      *             is on.                                            *
      *                                                               *
      *  Component of: LE2160 - Rollover Interest Rate Fixing Prompt  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CAS009             Date 16May05               *
      *                 CAP074             Date 08Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011  *CREATE    Date 07Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2- Specific Base Rate *
      *           (Recompile)                                         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    60         General file-, program-, module-access error    *
      *               indicator                                       *
      *    61         General file-, program-, module-access error    *
      *               indicator                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvMsg - Retrieves message text from message file          *
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

     FCLOAN     UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Loan master file DS of the current loan
     D WLoanCLDS     E DS                  EXTNAME(CLOANCL)

      ** Loan master file DS parameter of LE2165
     D PLoanCLDS     E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(PL)

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

      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Externally described DS for Switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D                                     PREFIX(SR)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CLE011          S              1
     D WRUN            S              1
     D PMode           S              1
     D PZRtnCde001     S              1
     D PZField016      S             16
     D PZDecimal       S              1P 0
     D PZDigit         S              2P 0
     D PZMsgID         S              7
     D PZMsgF          S             10
     D PZMsgDta        S            132
     D PZMsgTxt        S            132

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      *
      ** Set up Outgoing fields from the Incoming fields
      *
     C                   EVAL      POMsgTyp = PIMsgTyp
     C                   EVAL      POTrnUsr = PITrnUsr
     C                   EVAL      POTrnWrkStn = PITrnWrkStn
     C                   EVAL      POTrnRef = PITrnRef
     C                   EVAL      POTrnSeqNum = PITrnSeqNum
     C                   EVAL      POTrnAct = PITrnAct
     C                   EVAL      POTrnDateStmp = PITrnDateStmp
     C                   EVAL      POTrnTimeStmp = PITrnTimeStmp
     C                   EVAL      PONumRec = PINumRec
     C                   EVAL      POFiller = PIFiller
     C                   EVAL      POMsgSev = *BLANKS
     C                   EVAL      POMsgID  = *BLANKS
     C                   EVAL      POMsgTxt = *BLANKS
     C                   EVAL      POLoanRef = PILoanRef
      *
      ** Remove editing of Fixed Interest Rate
      *
     C                   EVAL      PZField016 = PIFixIntRate
     C                   EVAL      PZDecimal  = 7
     C                   EVAL      PZDigit    = 15 - PZDecimal
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZRtnCde001
     C                   PARM                    PZField016
     C                   PARM                    PZDecimal
     C                   PARM                    PZDigit
     C                   IF        PZRtnCde001 <> 'Y'
     C                   EVAL      PZMsgID   = 'LER0400'
     C                   EVAL      PZMsgDta  = *BLANKS
     C                   EXSR      SRRtvMsg
     C                   EVAL      POMsgSev = 'E'
     C                   EVAL      POMsgID  = PZMsgID
     C                   EVAL      POMsgTxt = PZMsgTxt
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   MOVE      PZField016    WRFRT
     C                   ENDIF
      *
     C                   EVAL      KLNRF = PILoanRef
     C                   EVAL      KRCDT = 'A'
     C     KLoan2k       CHAIN     CLOAN                              6061
     C                   SELECT
     C                   WHEN      *IN60 = *ON
     C                   EVAL      PZMsgID   = 'LER0401'
     C                   MOVEL     PILoanRef     PZMsgDta
     C                   EXSR      SRRtvMsg
     C                   EVAL      POMsgSev = 'E'
     C                   EVAL      POMsgID  = PZMsgID
     C                   EVAL      POMsgTxt = PZMsgTxt
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   WHEN      *IN61 = *ON
     C                   EVAL      PZMsgID   = 'LER0402'
     C                   MOVEL     PILoanRef     PZMsgDta
     C                   EXSR      SRRtvMsg
     C                   EVAL      POMsgSev = 'E'
     C                   EVAL      POMsgID  = PZMsgID
     C                   EVAL      POMsgTxt = PZMsgTxt
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSL
      *
      ** Check if record has already been updated by another workstation
      *
     C                   IF        (PMode <> 'B')
     C                             AND (PLoanCLDS <> WLoanCLDS)
     C                   EVAL      PZMsgID   = 'LER0413'
     C                   EXSR      SRRtvMsg
     C                   EVAL      POMsgSev = 'E'
     C                   EVAL      POMsgID  = PZMsgID
     C                   EVAL      POMsgTxt = PZMsgTxt
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Set up fields for update
      *
     C                   EVAL      RFRT = WRFRT
     C                   EVAL      RFRI = PIFixRateInd
      *
     C                   IF        PMode <> 'B'
     C                   EVAL      RFAR = 'Y'
     C                   ENDIF
      *
      ** Update file
      *
     C                   UPDATE    CLOANCLF                             60
     C                   IF        *IN60 = *ON
     C                   EVAL      PZMsgID   = 'LER0402'
     C                   EVAL      PZMsgDta  = *BLANKS
     C                   EXSR      SRRtvMsg
     C                   EVAL      POMsgSev = 'E'
     C                   EVAL      POMsgID  = PZMsgID
     C                   EVAL      POMsgTxt = PZMsgTxt
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Commit changes made to the file
      *
     C                   IF        PMode <> 'B'
     C                   COMMIT
     C                   ENDIF
      *
      ** Terminate module
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvMsg - Retrieves the message text from a message file    *
      *             using message ID, message file, and message data  *
      *             as the input.                                     *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     Y2RVMGC, *PSSR                                    *
      *                                                               *
      *****************************************************************
     C     SRRtvMsg      BEGSR
      *
      ** Default of message file
      *
     C                   IF        PZMsgF = *BLANKS
     C                   EVAL      PZMsgF = 'LERMSGF'
     C                   ENDIF
      *
      ** Retrieve message text
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgF
     C                   PARM                    PZMsgDta
     C                   PARM      *BLANKS       PZMsgTxt
      *
     C                   IF        (PRtnCde <> *BLANKS)
     C                   EXSR      *PSSR
     C                   ENDIF
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
      *  Calls:     AOSARDR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Definition of entry parameters
      *
     C     *ENTRY        PLIST
      ** Input parameters
     C                   PARM                    PMode
     C                   PARM                    PLoanCLDS
     C                   PARM                    PIncomingDS
      ** Input parameter
     C                   PARM                    POutgoingDS
      *
      ** Key list for LF/CLOAN
      *
     C     KLoan2k       KLIST
     C                   KFLD                    KLNRF
     C                   KFLD                    KRCDT
      *
      ** Definition of data areas, fields
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LIKE         DEFINE    LNRF          KLNRF
     C     *LIKE         DEFINE    RCDT          KRCDT
     C     *LIKE         DEFINE    RFRT          WRFRT
      *
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
      *
      ** Rollover Interest Rate Fixing Days feature
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCde           7
     C                   PARM      '*VERIFY'     POption           7
     C                   PARM      'CLE011'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
     C                   IF        (PRtnCde <> *BLANKS)
     C                             AND (PRtnCde <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CLE011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Exit module if CLE011 is Off
      *
     C                   IF        PRtnCde = *BLANKS
     C                   EVAL      CLE011 = 'Y'
     C                   ELSE
     C                   EVAL      CLE011 = 'N'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
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
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      POMsgSev = 'E'
      *
     C                   DUMP
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
