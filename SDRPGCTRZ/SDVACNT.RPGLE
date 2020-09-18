     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes - Account Number Validation Module')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Nostro Code Details Validation*
      *                                                               *
      *  SDVACNT  - Validate the Account Number                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Nostro Code amendments must not be                  *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE095             Date 25Apr14               *
      *                 AR1095876          Date 30Sep13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *
      *
     FGLACNTL3  IF   E           K DISK
      * RTV : Account Extension file
      *
 
 
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
 
      *  Multi Branching Data Area
     D RUNDAT          DS
     D  MBIN                  13     13                                         *Multi-Branch
      *  800 byte DS for incoming data from Access Program
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *  200 byte DS for incoming data from Access Program
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *  Bank Detail DS for incoming data from Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *  ACCNTAB Detail DS for incoming data from Access Program
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *  Define work field Access Pgm Return Code
     D WUAPRC          S              7A
      *  Define work field Account type
     D WUACTY          S              1A
      *  Define work field Nostro Shortname
     D WUNOSN          S             10A
      *  Define work field Account Status
     D WUASTT          S              1A
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      *  Get Multi Branched Value from RUNDAT DTAARA     *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MBIN          WUMBIN            1
      *
      ** VALIDATION
 
      *
      ** Validate Customer Number
     C     DDCUST        IFEQ      *BLANK
      *  Send message '*Value required'
     C                   EVAL      DDCUSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCUST    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0001'
     C                   GOTO      EMAIN
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      DDCUST        @CUST            10
     C                   PARM      *BLANKS       @KYST             7
     C                   PARM                    DSSDY
      *
      **  If not found, Send message 'Customer Code Not Found'.
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DDCUSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCUST    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0081'
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate Currency Code
      *
     C     DDCYCD        IFEQ      *BLANK
      *  Send message '*Value required'
     C                   EVAL      DDCYCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCYCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0001'
      *
     C                   ELSE
      ** Get currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      DDCYCD        @CYCD             3
     C                   PARM                    DSSDY
     **  If not found, Send message 'Currency Code Not Found'.
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DDCYCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCYCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0071'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Account Code
      *
     C     DDACCD        IFEQ      *BLANK
      * Send message '*Value required'
     C                   EVAL      DDACCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0001'
     C                   ELSE
      * Check Account Code is numeric
     C                   TESTN                   DDACCD               90  90
     C   90              MOVE      DDACCD        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90
      * All blank is OK
     C  N90DDACCD        COMP      *BLANKS                                90
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   EVAL      DDACCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0010'
      *
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      DDACCD        @IACOD           10
     C                   PARM                    DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
      * Send message 'Account Code Not Found'
     C                   EVAL      DDACCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0069'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Account Sequence Number
      *
     C     DDACSN        IFEQ      *BLANK
      * Send message '*Value required'
     C                   EVAL      DDACSNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACSN    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0001'
     C                   ELSE
      * Check Account Sequence No.  WRK is numeric
     C                   TESTN                   DDACSN               90  90
     C   90              MOVE      DDACSN        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90
      * All blank is OK
     C  N90DDACSN        COMP      *BLANKS                                90
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   EVAL      DDACSNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACSN    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0010'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Branch Code
      * WRK.Multi-branching Indicator is Multi-branched
     C     WUMBIN        IFEQ      'Y'
      * DTL.Branch code is blank
     C     DDBRCD        IFEQ      *BLANK
      * Send message 'Branch Code Required'
     C                   EVAL      DDBRCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0909'
     C                   ELSE
      * DTL.Branch Code is Not Blank
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      DDBRCD        @BRCD             3
     C                   PARM                    DSSDY
     C     @RTCD         IFNE      *BLANKS
      * Send message 'Branch Code Not Found'
     C                   EVAL      DDBRCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0075'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      * get default branch - Bank Details
      ** Retrieve Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
      * Send message 'Branch Code Not Found'
     C                   EVAL      DDBRCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0852'
     C                   ELSE
     C                   EVAL      DDBRCD = BJSBRC
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check Exist of Branch Code
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      DDBRCD        @BRCD             3
     C                   PARM                    DSSDY
     C     @RTCD         IFNE      *BLANKS
      * Send message 'Branch Code Not Found'
     C                   EVAL      DDBRCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0075'
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Account I.D. - Nostro Details  *
      *
      *    Access ACCNTAB to verify account details
     C*
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANK        WUAPRC            7            B:Return Cde
     C                   PARM      DDCUST        UU01             10            I:A/c Id
     C                   PARM      DDCYCD        UU02              3            I:Currency
     C                   PARM      DDACCD        UU03             10            I:A/c Code
     C                   PARM      DDACSN        UU04              2            I:A/c Seq
     C                   PARM      DDBRCD        UU05              3            I:Branch
     C     WUACTY        PARM                    UU06              7            O:A/c Type
     C     WUNOSN        PARM                    UU07             10            O:Nostro No
     C     SDACCT        PARM      SDACCT        DSSDY                          O:A/c Fmt
      **
      *    Pass back A/c Status
      *
     C                   EVAL      WUASTT = ACST                                O:A/c Status
      * CASE: WRK.Multi-branching Indicator is Multi-branched
     C     WUMBIN        IFEQ      'Y'
      *
      * CASE: WRK.Access Pgm Return Code is AP No Record Found OR
      * CASE: WRK.Account status is Closed
     C                   IF        WUAPRC = '*NRF' OR
     C                             WUASTT = 'C'
      *
      * Setup message data for message 'Account Not Found'
     C                   EVAL      DDCUSTOK = 'N'
      *
     C                   EVAL      DDCYCDOK = 'N'
      *
     C                   EVAL      DDBRCDOK = 'N'
      *
     C                   EVAL      DDACCDOK = 'N'
      *
     C                   EVAL      DDACSNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0860'
      *
     C                   ENDIF
      ** If Retail Account Balance is on, account must not have
      *** its Retail Account Check indicator to 'Y'
     C     CRE010        IFEQ      'Y'
     C                   MOVEL     DDCUST        KCNUM
     C                   MOVEL     DDCYCD        KCCY
     C                   MOVEL     DDBRCD        KBRCA
     C                   MOVEL     DDACCD        KACOD
     C                   MOVEL     DDACSN        KACSQ
      *
     C     KACEXT        CHAIN     GLACNTL3                           01
     C     *IN01         IFEQ      *OFF
     C     F1IABC        ANDEQ     'Y'
      *
     C                   EVAL      DDCUSTOK = 'N'
      *
     C                   EVAL      DDCYCDOK = 'N'
      *
     C                   EVAL      DDBRCDOK = 'N'
      *
     C                   EVAL      DDACCDOK = 'N'
      *
     C                   EVAL      DDACSNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR9990'
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ELSE
      * CASE: *OTHERWISE - Multi-Branch Off
      * CASE: WRK.Access Pgm Return Code is AP No Record Found
      * CASE: WRK.Account status is Closed
     C                   IF        WUAPRC = '*NRF' OR
     C                             WUASTT = 'C'
      * Setup message data for message 'Account Not Found -MB Off'
     C                   EVAL      DDCUSTOK = 'N'
      *
     C                   EVAL      DDCYCDOK = 'N'
      *
     C                   EVAL      DDBRCDOK = 'N'
      *
     C                   EVAL      DDACCDOK = 'N'
      *
     C                   EVAL      DDACSNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACSN    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0916'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
 
 
      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Field(s) requiring validation
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDCUST            6
     C                   PARM                    DDCYCD            3
     C                   PARM                    DDACCD           10
     C                   PARM                    DDACSN            2
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Branch Code             - OK
     C                   PARM                    DDBRCDOK          1
      ** Customer Number         - OK
     C                   PARM                    DDCUSTOK          1
      ** Nostro Currency Code    - OK
     C                   PARM                    DDCYCDOK          1
      ** Account Code            - OK
     C                   PARM                    DDACCDOK          1
      ** Account Sequence Number - OK
     C                   PARM                    DDACSNOK          1
      *
      ** Check if Retail Account Balance Check CRE010 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE010'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE010            1
     C                   ELSE
     C                   MOVE      'N'           CRE010
     C                   ENDIF
      *
      ** Define keylist for GLACNTL3
      *
     C     KACEXT        KLIST
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KBRCA             3
      *
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
(c) Finastra International Limited 2006
