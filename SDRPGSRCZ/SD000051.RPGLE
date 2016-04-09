     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Log Message for Compliance Watch')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000051 - Sending message to Compliance Watch               *
      *                                                               *
      *  Function:  This module will log file an 'insert' or 'amend'  *
      *             message for Compliance Watch each time an insert  *
      *             or amend was done on the maintenance.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529           Date 09Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRWrite  -  Subroutine to insert record to compliance        *
      *              watch file.                                      *
      *  SRSend   -  Subroutine to invoke the sending of message.     *
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
 
     FSDCDSHL0  IF A E           K DISK
      ** Customer Details Shadow file
 
     FSDACUSL0  IF A E           K DISK
      ** SD Additional Customer Details
 
     FSDCWMGPD  UF A E           K DISK
      ** SD Message to Compliance Watch
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Midas SD Bank details ICD files
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas SD Watch List Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
     D  WIND15               286    300
 
      ** Midas SC Switchable features description File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** SD data area
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PAction         S              1
     D PCustNumber     S              6
      ** Entry Parameters
 
     D TimeStamp       S               Z
      ** Timestamp for the transaction
 
     D PCustNumber10   S             10
     D PRetCode        S              7A
     D POption         S              7A
     D PSard           S              6A
     D PICCOB          S              1
     D WUpdSts         S              1A   INZ('N')
     D WSysPrefix      S              2
     D CSD017          S              1A
     D CCF001          S              1A
 
      ** Formatted date field for use in the parameter list
     D Dayin           S              5P 0
     D Dayout          S              8S 0
     D RetCode         S              1A
 
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
 
     C                   IF        (PAction = 'I' OR PAction = 'A')
     C                             AND PCustNumber <> *BLANK
 
     C                   EXSR      SRWrite
 
     C                   ENDIF
 
     C                   EXSR      SRSEND
 
      ** End of program
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite  - Subroutine to insert record in compliance          *
      *            watch file.                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRMove                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EXSR      SRMove
     C                   Write     SDCWMGD0
     C                   EVAL      WUpdSts  = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove   - Subroutine move the values to compliance           *
      *            watch fields before for amend or insert record.    *
      *                                                               *
      * Called by: SRInsert, SRAmend                                  *
      *                                                               *
      * Calls: ZDATE9                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRMove        BEGSR
 
     C     PCustNumber   CHAIN     SDCDSHL0
     C                   IF        %FOUND(SDCDSHL0)
      ** Address1
     C                   EVAL      CWCNA1 = BBCNA1
 
      ** Address2
     C                   EVAL      CWCNA2 = BBCNA2
 
      ** Address3
     C                   EVAL      CWCNA3 = BBCNA3
 
      ** Address4
     C                   EVAL      CWCNA4 = BBCNA4
 
      ** Report Name
     C                   EVAL      CWCRNM = BBCRNM
 
      ** Parent Indicator
     C                   EVAL      CWPAIN = BBPAIN
 
      ** Country Citizenship
     C                   EVAL      CWCNCZ = BBCNCZ
 
      ** Branch Code
     C                   EVAL      CWBRCD = BBBRCD
 
      ** Country of Domicile
     C                   EVAL      CWCOLC = BBCOLC
 
      ** Branch Indicator
     C                   EVAL      CWBSIN = BBBSIN
 
      ** Bank Indicator
     C                   EVAL      CWBNBI = BBBNBI
 
      ** Date of first contact
      ** Convert day number to YYYYMMDD format
 
     C                   EVAL      DayIn  = BBDOIC
     C                   CALLB     'ZDATE9'
     C                   Parm                    DayIn
     C                   Parm      *ZEROS        DayOut
     C                   Parm      *ZEROS        RetCode
     C                   EVAL      CWDOIC = %CHAR(DayOut)
 
      ** Institution Code
     C                   EVAL      CWLINC = BBLINC
 
      ** Telephone
     C                   EVAL      CWCTNB = BBCTNB
 
      ** Industry
     C                   EVAL      CWLICD = BBLICD
 
      ** Account Holder Type
     C                   EVAL      CWTAIN = BBTAIN
 
      ** Customer Type
     C                   EVAL      CWCSTY = BBCSTY
 
      ** Retail Customer Group
     C                   EVAL      CWCGRP = BBCGRP
 
      ** Telex Address
     C                   EVAL      CWTXA1 = BBTXA1
 
      ** Corporate Customer
 
     C                   EVAL      CWCRPC = 'N'
 
      ** If CCF001 is installed and either the Corporate Customer flag or
      **   Bank Indicator is 'Y'
 
     C                   IF        CCF001 = 'Y' AND BBBNBI = 'Y'
     C                             OR CCF001 = 'Y' AND BBCRPC = 'Y'
     C                   EVAL      CWCRPC = 'Y'
     C                   ENDIF
 
      ** IF CCF001 is not active and CSD017 is active and no private customer
      **   industry code have been defined on the AML configuration data, set
      **   Corporate Customer equla to 'Y' for all Midas Customer with
      **   non blank industry code
 
     C                   IF        CCF001 = 'N' AND CSD017 = 'Y'
     C                             AND WIND15 = *BLANKS
     C                             AND BBLICD <> *BLANKS
     C                   EVAL      CWCRPC = 'Y'
     C                   ENDIF
 
      ** If CCF001 is not active and CSD017 is active and at least one
      **   private customer industry code has been defined in the AML
      **   configuration data, then set the corporate customer equal to
      **   'Y' for customers with an industry code not in the list of
      **   private customer industry code.
 
     C                   IF        CCF001 = 'N' AND CSD017 = 'Y'
     C                             AND WIND15 <> *BLANKS
     C                   IF        W1IND1 <> BBLICD OR
     C                             W1IND2 <> BBLICD OR
     C                             W1IND3 <> BBLICD OR
     C                             W1IND4 <> BBLICD OR
     C                             W1IND5 <> BBLICD
     C                   EVAL      CWCRPC = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** If CCF001 and CSD017 are not active, set the corporate customer
      **   equal to 'Y' for all Midas customers with a non-blank industry
      **   code
 
     C                   IF        CCF001 = 'N' AND CSD017 = 'N'
     C                             AND BBLICD <> *BLANKS
     C                   EVAL      CWCRPC = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C     PCustNumber   CHAIN     SDACUSL0
     C                   IF        %FOUND(SDACUSL0)
      ** Customer Fax Number
     C                   EVAL      CWFXNB = E5FXNB
 
      ** Customer Identity Number
     C                   EVAL      CWIDNO = E5IDNO
 
      ** Customer Telex Number
     C                   EVAL      CWTXNB = E5TXNB
 
      ** Date of Birth
     C                   EVAL      CWDOBH = E5BRT2 + %SUBST(E5BRT1:5:2) +
     C                                      %SUBST(E5BRT1:3:2) +
     C                                      %SUBST(E5BRT1:1:2)
 
      ** Date of Last Visit
      ** Convert day number to YYYYMMDD format
 
     C                   EVAL      DayIn  = E5DOLV
     C                   CALLB     'ZDATE9'
     C                   Parm                    DayIn
     C                   Parm      *ZEROS        DayOut
     C                   Parm      *ZEROS        RetCode
     C                   EVAL      CWDOLV = %CHAR(DayOut)
 
      ** Customer Mail Details
     C                   EVAL      CWMDTL = E5MDTL
 
      ** Account Owner Address line 1
     C                   EVAL      CWAOA1 = E5CNA1
 
      ** Account Owner Address line 2
     C                   EVAL      CWAOA2 = E5CNA2
 
      ** Account Owner Address line 3
     C                   EVAL      CWAOA3 = E5CNA3
 
      ** Account Owner Address line 4
     C                   EVAL      CWAOA4 = E5CNA4
 
      ** Additional Customer fields
     C                   EVAL      CWFL01 = E5FL01
     C                   EVAL      CWFL02 = E5FL02
     C                   EVAL      CWFL03 = E5FL03
     C                   EVAL      CWFL04 = E5FL04
     C                   EVAL      CWFL05 = E5FL05
     C                   EVAL      CWFL06 = E5FL06
     C                   EVAL      CWFL07 = E5FL07
     C                   EVAL      CWFL08 = E5FL08
     C                   EVAL      CWFL09 = E5FL09
     C                   EVAL      CWFL10 = E5FL10
     C                   ENDIF
 
      ** System prefix
     C                   EVAL      CWSYPX = WSysPrefix
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      CWTMST = %char(Timestamp)
 
     C                   EVAL      CWCNUM = BBBRCD + PCustNumber
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSEND - Sending Message routine                              *
      *                                                               *
      * Called by: SRAmend, SRInsert                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSEND        BEGSR
 
     C                   IF        WUpdSts  = 'Y'
     C                   CALL      'SDC000052'
     C                   PARM      'I'           PICCOB
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
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
 
     C     *entry        PLIST
     C                   PARM                    PAction
     C                   PARM                    PCustNumber
 
     C                   EVAL      PCustNumber10 = PcustNumber
     C                   EVAL      WUpdSts       = 'N'
 
      ** Check if CCF001 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
 
      ** Check if CSD017 (AML Interface) is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
 
      ** Check if CSD017 (AML Interface) is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSD017'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSD017 = 'Y'
     C                   ELSE
     C                   EVAL      CSD017 = 'N'
     C                   ENDIF
 
     C                   IF        CSD017 = 'Y'
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST  '    POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBKEY = '*FIRST  '
     C                   EVAL      DBPGM = 'SD000051'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C     *LOCK         IN        SDSTAT
     C                   EVAL      WSysPrefix  = LIBR
     C                   OUT       SDSTAT
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      PRetCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
