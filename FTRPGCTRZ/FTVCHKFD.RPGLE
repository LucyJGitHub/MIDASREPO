     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validation for Sufficient Funds')             *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVCHKFD - Validate for Sufficient Funds                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL014   *CREATE   Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************

     FFT102DL0  IF   E           K DISK    INFSR(*PSSR)

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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)

      ** Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)

      ** Data structure for account details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)

      ** Data structure for switchable features details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SLCD         E                     EXTFLD(LCD)

      ** Data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Data structure for access programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PTR_Amount      S             15  0
     D PTR_Curr        S              3
     D PAC_Branch      S              3
     D PAC_Cust        S              6
     D PAC_Curr        S              3
     D PAC_Code        S             10
     D PAC_Seq         S              2
     D PAC_Retail      S             10  0
     D PRetCode        S              7

     D PRTCD           S              7
     D POPTION         S              7
     D PAcctType       S              7
     D PAcctID         S             35
     D PCurrency       S              3
     D WNumRCVOCG      S             15  0
     D WNumSNDOCG      S             15  0
     D WNumPAYAMT      S             15  0
     D WTotal          S             15  0

     D ZALIGNok        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0

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

      ** Initialization

     C                   EVAL      PRetCode = *BLANKS
     C                   EVAL      WTotal = 0

      ** Set account ID to whatever is specified in this order:
      ** 1. header Ordering Customer
      ** 2. header Ordering Institution
      ** 3. detail Ordering Customer
      ** 4. detail Ordering Institution

     C                   SELECT
     C                   WHEN      HPCUSTTH <> *BLANK
     C                   EVAL      PAcctID = HPTOCUS1
     C                   EXSR      SRAccount
     C                   EXSR      SRHeader

     C                   WHEN      HPORDITP <> *BLANK
     C                   EVAL      PAcctID = HPOINST3
     C                   EXSR      SRAccount
     C                   EXSR      SRHeader

     C                   WHEN      PCUSTTD <> *BLANK
     C                   EVAL      PAcctID = PORDCU1
     C                   EXSR      SRAccount
     C                   EXSR      SRDetail

     C                   WHEN      PORDITP <> *BLANK
     C                   EVAL      PAcctID = PORDI35
     C                   EXSR      SRAccount
     C                   EXSR      SRDetail
     C                   ENDSL

     C                   RETURN

      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRAccount - Access account details                           *
      *                                                               *
      *****************************************************************

     C     SRAccount     BEGSR

     C                   CALLB     'AOACCTV1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANKS       PAcctType
     C                   PARM                    PAcctID
     C     ACCNT         PARM      ACCNT         DSSDY

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Ordering customer/institution is in 'header'      *
      *                                                               *
      *****************************************************************

     C     SRHeader      BEGSR

      ** Validate only if account is retail and is held for collateral

     C                   IF        ATYP = 'R'  AND  COLF = 'Y'

      ** Get numeric format of payment amount

     C                   EVAL      PCurrency = PPAYCCY
     C                   EVAL      ZFIELD = PPAYAMT
     C                   EXSR      SRConvert
     C                   MOVE      ZFIELD        WNumPAYAMT
     C                   EVAL      WTotal = WNumPAYAMT

      ** Access detail transactions and compute total amount

     C     HPCCTID       SETLL     FT102DL0
     C     HPCCTID       READE     FT102DL0

     C                   DOW       NOT %EOF(FT102DL0)

      ** Don't process detail transaction reference presently on screen;
      ** payment amount is already accounted for (above)

     C                   IF        TRNSID <> PTRNSID

     C                   SELECT

      ** Details of charges is 'OUR'

     C                   WHEN      HPCCTCHG = 'OUR'  OR  CCYCHG = 'OUR'
     C                   EVAL      WTotal = WTotal + PAYAMT + SNDOCG + RCVOCG

      ** Details of charges is 'SHA'

     C                   WHEN      HPCCTCHG = 'SHA'  OR  CCYCHG = 'SHA'
     C                   EVAL      WTotal = WTotal + PAYAMT + SNDOCG

      ** Neither 'OUR' nor 'SHA'

     C                   OTHER
     C                   EVAL      WTotal = WTotal + PAYAMT
     C                   ENDSL

     C                   ENDIF

     C     HPCCTID       READE     FT102DL0
     C                   ENDDO

      ** Check for sufficient funds

     C                   EXSR      SRCheck

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail - Ordering customer/institution is in 'detail'      *
      *                                                               *
      *****************************************************************

     C     SRDetail      BEGSR

      ** Validate only if account is retail and is held for collateral

     C                   IF        ATYP = 'R'  AND  COLF = 'Y'

      ** Get numeric format of payment amount

     C                   EVAL      PCurrency = PPAYCCY
     C                   EVAL      ZFIELD = PPAYAMT
     C                   EXSR      SRConvert
     C                   MOVE      ZFIELD        WNumPAYAMT

      ** Compute total amount depending on details of charges

     C                   SELECT

      ** Details of charges is 'OUR'

     C                   WHEN      HPCCTCHG = 'OUR'  OR  PCCYCHG = 'OUR'

      ** Get numeric format of sender's/receiver's charges

     C                   EVAL      ZFIELD = PSNDOCG
     C                   EXSR      SRConvert
     C                   MOVE      ZFIELD        WNumSNDOCG

     C                   EVAL      ZFIELD = PRCVOCG
     C                   EXSR      SRConvert
     C                   MOVE      ZFIELD        WNumRCVOCG

     C                   EVAL      WTotal = WNumPAYAMT + WNumSNDOCG + WNumRCVOCG

      ** Details of charges is 'SHA'

     C                   WHEN      HPCCTCHG = 'SHA'  OR  PCCYCHG = 'SHA'

      ** Get numeric format of sender's charges

     C                   EVAL      ZFIELD = PSNDOCG
     C                   EXSR      SRConvert
     C                   MOVE      ZFIELD        WNumSNDOCG

     C                   EVAL      WTotal = WnumPAYAMT + WNumSNDOCG

      ** Details of charges is not 'OUR' nor 'SHA'

     C                   OTHER
     C                   EVAL      WTotal = WNumPAYAMT
     C                   ENDSL

      ** Check for sufficient funds

     C                   EXSR      SRCheck

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert screen fields of Payment Amount to       *
      *              to numeric format                                *
      *                                                               *
      *****************************************************************

     C     SRConvert     BEGSR

      ** Get currency details

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurrency
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR

     C                   ELSE

     C                   EVAL      ZADIG = 15 - A6NBDP
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheck - Check if pay account has sufficient funds to cover *
      *            blocked amount                                     *
      *                                                               *
      *****************************************************************

     C     SRCheck       BEGSR

     C                   MOVE      CNUM          PAC_Cust
     C                   MOVE      ACOD          PAC_Code
     C                   MOVE      ACSQ          PAC_Seq

      ** Call validation module

     C                   CALLB     'GL006000'
     C                   PARM      WTotal        PTR_Amount
     C                   PARM      CCY           PTR_Curr
     C                   PARM      BRCA          PAC_Branch
     C                   PARM                    PAC_Cust
     C                   PARM      CCY           PAC_Curr
     C                   PARM                    PAC_Code
     C                   PARM                    PAC_Seq
     C                   PARM      ACNO          PAC_Retail
     C                   PARM      *BLANKS       PRetCode

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

     C                   PARM                    PRetCode
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
