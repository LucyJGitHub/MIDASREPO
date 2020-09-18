     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Further Settle Instructions validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZAFSETIVAL - Further Settlement Instructions validation      *
      *                                                               *
      *  Function:  This program validates multiple settlement        *
      *             accounts.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 03Jun14               *
      *                 MD000091           Date 15May13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG4478            Date 05Oct04               *
      *                 CDL018  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 -  Enhanced Receive Settlement Instructions           *
      *             (Recompile)                                       *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG4478- Keep the warnings from previously called            *
      *           modules.                                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D WSRACT          S             21A   DIM(12)
      ** Array for the Receipt Accounts
 
     D WSRALL          S              1A   DIM(12)
      ** Array for the Receipt Allocations
 
     D WSRPCT          S              7A   DIM(12)
      ** Array for the Receipt Percentages
 
     D WVRPCT          S              6A   DIM(12)
      ** Array for the Receipt Valid Percentages
 
     D WSRAMT          S             14A   DIM(12)
      ** Array for the Receipt Amounts
 
     D WVRAMT          S             13A   DIM(12)
      ** Array for the Receipt Valid Amounts
 
     D WSPACT          S             21A   DIM(12)
      ** Array for the Payment Accounts
 
     D WSPALL          S              1A   DIM(12)
      ** Array for the Payment Allocations
 
     D WSPPCT          S              7A   DIM(12)
      ** Array for the Payment Percentages
 
     D WVPPCT          S              6A   DIM(12)
      ** Array for the Payment Valid Percentages
 
     D WSPAMT          S             14A   DIM(12)
      ** Array for the Payment Amounts
 
     D WVPAMT          S             13A   DIM(12)
      ** Array for the Payment Valid Amounts
 
     D CHKACCI         S             21A   DIM(12)
      ** Check Array for Interest Account entered more than once
 
     D CHKACCP         S             21A   DIM(12)
      ** Check Array for Principal Account entered more than once
 
     D CHKACCB         S             21A   DIM(12)
      ** Check Array for Principal + Interest Account entered more than once
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      ** Deal in File Format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for Short Dummy Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External DS for Long Dummy Data Structure
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch details
 
     D ACCT          E DS                  EXTNAME(ACCNTAB)
      ** External DS for Account details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Dealing details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  WLCD         E                     EXTFLD(LCD)
      ** External DS for SAR Details
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen - Receive Instructions
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen - Payment Instructions
 
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)
      ** File - Receive Further Settlement Instructions
 
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)
      ** File - Payment Further Settlement Instructions
 
     D #FRECS        E DS                  EXTNAME(SDFSSRPD)
      ** Screen - Receive Further Settlement Instructions
 
     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)
      ** Screen - Payment Further Settlement Instructions
 
     D #FRECE        E DS                  EXTNAME(SDFSERPD)
      ** Errors - Receive Further Settlement Instructions
 
     D #FPAYE        E DS                  EXTNAME(SDFSEPPD)
      ** Errors - Payment Further Settlement Instructions
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 CSF011A
     D                                     PREFIX(C_)                                        CSF011A
      ** External DS for Customer details                                                    CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for Accounts Date Array
     D Wx              S              2P 0
 
      ** DS for Multibranch indicator using RUNDAT
     D RUNDAT          DS
     D  @MBIN                 13     13
 
      ** OUR ACCOUNT
     D                 DS
     D  A#OURA                 1     18
     D  A#NOST                 1      2
     D  A#CNUM                 1      6
     D  A#RENO                 1     10
     D  A#ACOD                 7     16
     D  A#ACAS                 7     18
     D  A#ACSQ                17     18
     D  A#REST                 3     18
 
      ** Parameters for RE101901
     D PRetCode        S              7
     D PInBranch       S              3
     D*PInCust**       S              6  0                                                    CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3
     D PInACode        S             10  0
     D PInASeqN        S              2  0
     D PDebAmnt        S             15  0
     D POutBranch      S              3
     D*POutCust*       S              6  0                                                    CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3
     D POutACode       S             10  0
     D POutASeqN       S              2  0
     D POutRetNo       S             10  0
 
     D WFldNameArr     S             10    DIM(75)
     D*WkCust***       S              6  0                                                    CSD027
     D WkCust          S              6                                                       CSD027
     D WkCcy           S              3
     D WkACOD          S             10  0
     D WkASEQ          S              2  0
     D WkBRCA          S              3
     D WkCustA         S              6
     D WkACodeA        S             10
     D WkASeqNA        S              2
     D WkRetNoA        S             10
     D WIdx            S              3  0
 
      ** Parameters for call to ZA0840
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
     D @@AMT           S             15  0
     D @CSCN           S             10                                                      CSF011A
     D @KYST           S              7                                                      CSF011A
     D SETTF           S              1    INZ(*BLANKS)                                      CSF011A
     D CusIdxA         S              4S 0                                                   CSF011A
     D CusIdxB         S              4S 0                                                   CSF011A
     D CusIdxC         S              4S 0                                                   CSF011A
     D CusIdxD         S              4S 0                                                   CSF011A
     D CusIdxE         S              4S 0                                                   CSF011A
     D W@Len           S              4S 0                                                   CSF011A
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
      ** Receipt - Further Settlement Instructions
 
     C     DDRMAC        IFEQ      'Y'
     C                   EXSR      RECEIP
     C                   ENDIF
 
      ** Payment - Further Settlement Instructions
 
     C     DDPMAC        IFEQ      'Y'
     C                   EXSR      PAYMNT
     C                   ENDIF
 
      ** Exit program
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * RECEIP - Validate Receipt Further Settlement Instructions     *
      *                                                               *
      *****************************************************************
     C     RECEIP        BEGSR
 
      ** Receipt - Clear output fields
 
     C                   CLEAR                   #FRECF
 
      ** Receipt - Validate Accounts
 
     C                   EXSR      VLRACNT
 
      ** Receipt - Validate Allocation
 
     C                   EXSR      VLRALL
 
      ** Receipt - Validate Percentage
 
     C                   EXSR      VLRPCTG
 
      ** Receipt - Validate Amounts
 
     C                   EXSR      VLRAMNT
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * PAYMNT - Validate Payment Further Settlement Instructions     *
      *                                                               *
      *****************************************************************
     C     PAYMNT        BEGSR
 
      ** Payment - Clear output fields
 
     C                   CLEAR                   #FPAYF
 
      ** Payment - Validate Accounts
 
     C                   EXSR      VLPACNT
 
      ** Payment - Validate Allocation
 
     C                   EXSR      VLPALL
 
 
      ** Payment - Validate Percentage
 
     C                   EXSR      VLPPCTG
 
      ** Payment - Validate Amounts
 
     C                   EXSR      VLPAMNT
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLRACNT - Validate Receipt Accounts                           *
      *                                                               *
      *****************************************************************
     C     VLRACNT       BEGSR
 
      ** Validate Unallocated Account
 
     C                   EVAL      Wx = 0
      *
     C     DRUAC         IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1002'
      *
     C                   ELSE
      *
     C                   MOVEL     DRUAC         WWRONS           21
     C                   EXSR      VLROBR
     C                   EXSR      VLRONS
     C                   ENDIF
 
      ** Validate all other Accounts entered
 
     C                   MOVE      *BLANKS       CHKACCI
     C                   MOVE      *BLANKS       CHKACCP
     C                   MOVE      *BLANKS       CHKACCB
     C                   EVAL      Wx = 1
     C                   EVAL      SETTF = 'R'                                               CSF011A
     C                   EXSR      SRSETCNI                                                  CSF011A
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSRACT(Wx) <> *BLANKS
      *
      ** An entry has been made, but the previous field is blank
      *
     C                   IF        Wx > 1
     C                   SUB       1             Wx
     C                   IF        WSRACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1006'
     C                   ENDIF
     C                   ADD       1             Wx
     C                   ENDIF
      *
      ** Account must be valid
      *
     C                   MOVEL     WSRACT(Wx)    WWRONS
     C                   EXSR      VLROBR
     C                   EXSR      VLRONS
      *
      ** If an Account has been entered, then Allocation must be entered
      *
     C                   IF        WSRALL(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1017'
     C                   ENDIF
      *
      ** If an Account has been entered, then either the Percentage
      ** or Amount must be entered.
      *
     C                   IF        WSRPCT(Wx) = *BLANKS AND
     C                             WSRAMT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1007'
     C                   ENDIF
      *
      ** Only the Percentage or the Amount field can be entered.
      ** A combiantion of percentages and amounts is not allowed.
      *
     C                   IF        WSRPCT(Wx) <> *BLANKS AND
     C                             WSRAMT(Wx) <> *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1005'
     C                   ENDIF
      *
      ** Account must be entered if either the Percentage or Amount entered
      *
     C                   IF        WSRACT(Wx) = *BLANKS AND
     C                             WSRPCT(Wx) <> *BLANKS OR
     C                             WSRACT(Wx) = *BLANKS AND
     C                             WSRAMT(Wx) <> *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1008'
     C                   ENDIF
      *
      ** Account can not be entered more than once for Interest
      *
     C                   IF        WSRALL(Wx) = 'I'
     C     WSRACT(Wx)    LOOKUP    CHKACCI                                89
     C                   IF        *IN89 = *ON
     C                   ADD       1             IDx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1013'
     C                   ENDIF
     C                   MOVE      WSRACT(Wx)    CHKACCI(Wx)
     C                   ENDIF
      *
      ** Account can not be entered more than once for Principal
      *
     C                   IF        WSRALL(Wx) = 'P'
     C     WSRACT(Wx)    LOOKUP    CHKACCP                                89
     C                   IF        *IN89 = *ON
     C                   ADD       1             IDx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1013'
     C                   ENDIF
     C                   MOVE      WSRACT(Wx)    CHKACCP(Wx)
     C                   ENDIF
      *
      ** Account can not be entered more than once for Principal + Interest
      *
     C                   IF        WSRALL(Wx) = 'B'
     C     WSRACT(Wx)    LOOKUP    CHKACCB                                89
     C                   IF        *IN89 = *ON
     C                   ADD       1             IDx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1013'
     C                   ENDIF
     C                   MOVE      WSRACT(Wx)    CHKACCB(Wx)
     C                   ENDIF
      *
      ** Do an Overdraft Limit check
     C                   IF        CRE008 = 'Y'
     C                   EXSR      SROvrChk
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   EXSR      SRCNTCNI                                                  CSF011A
     C                   ADD       1             Wx
     C                   ENDDO
     C                   EVAL      SETTF = *BLANKS                                           CSF011A
 
      ** If all the Accounts are valid set up file fields
 
     C                   IF        RUACOK  <> 'N' AND  RAC02OK <> 'N' AND
     C                             RAC03OK <> 'N' AND  RAC04OK <> 'N' AND
     C                             RAC05OK <> 'N' AND  RAC06OK <> 'N' AND
     C                             RAC07OK <> 'N' AND  RAC08OK <> 'N' AND
     C                             RAC09OK <> 'N' AND  RAC10OK <> 'N' AND
     C                             RAC11OK <> 'N' AND  RAC12OK <> 'N'
      *
     C                   MOVE      DRUAC         FRUAC
     C                   MOVE      DRAC01        FRAC01
     C                   MOVE      DRAC02        FRAC02
     C                   MOVE      DRAC03        FRAC03
     C                   MOVE      DRAC04        FRAC04
     C                   MOVE      DRAC05        FRAC05
     C                   MOVE      DRAC06        FRAC06
     C                   MOVE      DRAC07        FRAC07
     C                   MOVE      DRAC08        FRAC08
     C                   MOVE      DRAC09        FRAC09
     C                   MOVE      DRAC10        FRAC10
     C                   MOVE      DRAC11        FRAC11
     C                   MOVE      DRAC12        FRAC12
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLRALL - Validate Receipt Allocation                          *
      *                                                               *
      *****************************************************************
     C     VLRALL        BEGSR
 
      ** Validate Allocation
 
     C                   MOVE      'N'           CHKIP             1
     C                   MOVE      'N'           CHKB              1
     C                   EVAL      Wx = 1
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSRALL(Wx) <> *BLANKS
      *
      ** An Allocation may only be entered if an Account has been entered
      *
     C                   IF        WSRACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1015'
     C                   ENDIF
      *
      ** Allocation must be valid
      *
     C                   IF        WSRALL(Wx) <> 'I' AND
     C                             WSRALL(Wx) <> 'P' AND
     C                             WSRALL(Wx) <> 'B'
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1016'
     C                   ENDIF
      *
      ** If 'Interest Paid Seperately' is set to 'Y' only Principal is allowed
      *
     C                   IF        IKIPDS = 'Y' AND
     C                             WSRALL(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1021'
     C                   ENDIF
      *
      ** If 'Front up Interest' is set to 'Y' only Principal is allowed
      *
     C                   IF        IKFUID = 'Y' AND
     C                             WSRALL(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1022'
     C                   ENDIF
      *
      ** If Deposit Deal, only Principal is allowed on Receipt side
      *
     C                   IF        DLTYPE = 'IT' AND
     C                             WSRALL(Wx) <> 'P' OR
     C                             DLTYPE = 'TD' AND
     C                             WSRALL(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1023'
     C                   ENDIF
      *
      ** Allocations can not be a combination of all I, P and B
      *
     C                   IF        WSRALL(Wx) = 'I' OR
     C                             WSRALL(Wx) = 'P'
     C                   MOVE      'Y'           CHKIP
     C                   ENDIF
      *
     C                   IF        WSRALL(Wx) = 'B'
     C                   MOVE      'Y'           CHKB
     C                   ENDIF
 
     C                   IF        WSRALL(Wx) = 'B' AND
     C                             CHKIP = 'Y' OR
     C                             WSRALL(Wx) = 'I' AND
     C                             CHKB = 'Y' OR
     C                             WSRALL(Wx) = 'P' AND
     C                             CHKB = 'Y'
     C                   ADD       1             IDx
     C                   EXSR      RcvAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1018'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
 
      ** If all the Allocations are valid set up file fields
 
     C                   IF        RAL01OK <> 'N' AND  RAL02OK <> 'N' AND
     C                             RAL03OK <> 'N' AND  RAL04OK <> 'N' AND
     C                             RAL05OK <> 'N' AND  RAL06OK <> 'N' AND
     C                             RAL07OK <> 'N' AND  RAL08OK <> 'N' AND
     C                             RAL09OK <> 'N' AND  RAL10OK <> 'N' AND
     C                             RAL11OK <> 'N' AND  RAL12OK <> 'N'
      *
     C                   MOVE      DRAL01        FRAL01
     C                   MOVE      DRAL02        FRAL02
     C                   MOVE      DRAL03        FRAL03
     C                   MOVE      DRAL04        FRAL04
     C                   MOVE      DRAL05        FRAL05
     C                   MOVE      DRAL06        FRAL06
     C                   MOVE      DRAL07        FRAL07
     C                   MOVE      DRAL08        FRAL08
     C                   MOVE      DRAL09        FRAL09
     C                   MOVE      DRAL10        FRAL10
     C                   MOVE      DRAL11        FRAL11
     C                   MOVE      DRAL12        FRAL12
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLRPCTG - Validate Receipt Percentage                         *
      *                                                               *
      *****************************************************************
     C     VLRPCTG       BEGSR
 
      ** Validate Percentage
 
     C                   MOVE      'N'           ErrPerc           1
     C                   MOVE      'N'           PercEnt           1
     C                   Z-ADD     0             PercTotI          6 0
     C                   Z-ADD     0             PercTotP          6 0
     C                   Z-ADD     0             PercTotB          6 0
     C                   EVAL      Wx = 1
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSRPCT(Wx) <> *BLANKS
      *
      ** A Percentage may only be entered if an Account has been entered
      *
     C                   IF        WSRACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1009'
     C                   ENDIF
      *
      ** Percentage must be valid
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVEL     WSRPCT(Wx)    @@ALPH
     C                   Z-ADD     *ZEROS        @@AMT
     C                   Z-ADD     3             @@IDP
     C                   Z-ADD     3             @@IINT
     C                   MOVE      'Y'           @@MTID
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      ** Percentage must be a numeric field
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrPerc
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1003'
      *
     C                   ELSE
      *
      ** Percentage  must be between '0'and '100'
     C     @@AMT         DIV       1000          WPERC             6 3
      *
     C     WPERC         IFLT      0
     C     WPERC         ORGT      100
     C                   MOVE      'Y'           ErrPerc
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1004'
     C                   ENDIF
     C                   ENDIF
      *
     C     ErrPerc       IFEQ      'N'
     C                   MOVE      @@ALPH        WSRPCT(Wx)
     C                   MOVE      @@AMT         WVRPCT(Wx)
      *
     C                   IF        WSRALL(Wx) = 'I'
     C                   ADD       @@AMT         PercTotI
     C                   ENDIF
      *
     C                   IF        WSRALL(Wx) = 'P'
     C                   ADD       @@AMT         PercTotP
     C                   ENDIF
      *
     C                   IF        WSRALL(Wx) = 'B'
     C                   ADD       @@AMT         PercTotB
     C                   ENDIF
      *
     C                   MOVE      'Y'           PercEnt
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
 
      ** All Percentages entered must add up to 100
 
     C     WSRPCT(1)     IFNE      *BLANKS
     C     PercTotI      IFNE      0
     C     PercTotI      ANDNE     100000
     C     PercTotP      ORNE      0
     C     PercTotP      ANDNE     100000
     C     PercTotB      ORNE      0
     C     PercTotB      ANDNE     100000
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1011'
     C                   ENDIF
     C                   ENDIF
 
      ** Dispay formatted percentage field
 
     C                   MOVE      WSRPCT(1)     DRPC01
     C                   MOVE      WSRPCT(2)     DRPC02
     C                   MOVE      WSRPCT(3)     DRPC03
     C                   MOVE      WSRPCT(4)     DRPC04
     C                   MOVE      WSRPCT(5)     DRPC05
     C                   MOVE      WSRPCT(6)     DRPC06
     C                   MOVE      WSRPCT(7)     DRPC07
     C                   MOVE      WSRPCT(8)     DRPC08
     C                   MOVE      WSRPCT(9)     DRPC09
     C                   MOVE      WSRPCT(10)    DRPC10
     C                   MOVE      WSRPCT(11)    DRPC11
     C                   MOVE      WSRPCT(12)    DRPC12
 
      ** If all the Percentage fields are valid set up file fields
 
     C                   IF        RPC01OK <> 'N' AND  RPC02OK <> 'N' AND
     C                             RPC03OK <> 'N' AND  RPC04OK <> 'N' AND
     C                             RPC05OK <> 'N' AND  RPC06OK <> 'N' AND
     C                             RPC07OK <> 'N' AND  RPC08OK <> 'N' AND
     C                             RPC09OK <> 'N' AND  RPC10OK <> 'N' AND
     C                             RPC11OK <> 'N' AND  RPC12OK <> 'N'
      *
     C                   MOVE      WVRPCT(1)     FRPC01
     C                   MOVE      WVRPCT(2)     FRPC02
     C                   MOVE      WVRPCT(3)     FRPC03
     C                   MOVE      WVRPCT(4)     FRPC04
     C                   MOVE      WVRPCT(5)     FRPC05
     C                   MOVE      WVRPCT(6)     FRPC06
     C                   MOVE      WVRPCT(7)     FRPC07
     C                   MOVE      WVRPCT(8)     FRPC08
     C                   MOVE      WVRPCT(9)     FRPC09
     C                   MOVE      WVRPCT(10)    FRPC10
     C                   MOVE      WVRPCT(11)    FRPC11
     C                   MOVE      WVRPCT(12)    FRPC12
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLRAMNT - Validate Receipt Amounts                            *
      *                                                               *
      *****************************************************************
     C     VLRAMNT       BEGSR
 
      ** Validate Amounts
 
     C                   MOVE      'N'           ErrAmt            1
     C                   MOVE      'N'           AmntEnt           1
     C                   Z-ADD     0             AmntTotI         15 0
     C                   Z-ADD     0             AmntTotP         15 0
     C                   Z-ADD     0             AmntTotB         15 0
     C                   EVAL      Wx = 1
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSRAMT(Wx) <> *BLANKS
      *
      ** An Amount may only be entered if an Account has been entered
      *
     C                   IF        WSRACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1010'
     C                   ENDIF
      *
      ** Amount must be valid
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVEL     WSRAMT(Wx)    @@ALPH
     C                   Z-ADD     *ZEROS        @@AMT
     C                   Z-ADD     RNBDP         @@IDP
     C     12            SUB       RNBDP         @@IINT
     C                   MOVE      'Y'           @@MTID
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      ** Amount must be a numeric field
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrAmt
     C                   ADD       1             IDx
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'MMM0144'
      *
     C                   ELSE
      *
      ** The amount must not be zero
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'Y'           ErrAmt
     C                   ADD       1             IDx
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'MMM0143'
     C                   ENDIF
     C                   ENDIF
      *
      ** If the amount is valid, set up the numeric amount for output
     C     ErrAmt        IFEQ      'N'
     C                   MOVE      @@ALPH        WSRAMT(Wx)
     C                   MOVE      @@AMT         WVRAMT(Wx)
      *
     C                   IF        WSRALL(Wx) = 'I'
     C                   ADD       @@AMT         AmntTotI
     C                   ENDIF
      *
     C                   IF        WSRALL(Wx) = 'P'
     C                   ADD       @@AMT         AmntTotP
     C                   ENDIF
      *
     C                   IF        WSRALL(Wx) = 'B'
     C                   ADD       @@AMT         AmntTotB
     C                   ENDIF
      *
     C                   MOVE      'Y'           AmntEnt
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
      *
      ** Only the Percentage or the Amount field can be entered for a Deal.
      ** A combiantion of percentages and amounts is not allowed.
      *
     C                   IF        PercEnt = 'Y' AND
     C                             AmntEnt = 'Y'
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      RcvPctERR
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1014'
     C                   ENDIF
 
      ** For Allocation 'B' all Amounts must not exceed the Principal + Interest
 
     C     WSRAMT(1)     IFNE      *BLANKS
     C     AmntTotB      IFNE      0
     C     AmntTotB      ANDGT     TotAmIn
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1012'
     C                   ENDIF
     C                   ENDIF
 
      ** For Allocation 'I' all Amounts must not exceed the Interest
 
     C     WSRAMT(1)     IFNE      *BLANKS
     C     AmntTotI      IFNE      0
     C     AmntTotI      ANDGT     UMTTI
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1019'
     C                   ENDIF
     C                   ENDIF
 
      ** For Allocation 'P' all Amounts must not exceed the Principal
 
     C     WSRAMT(1)     IFNE      *BLANKS
     C     AmntTotP      IFNE      0
     C     AmntTotP      ANDGT     UAMNP
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      RcvAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1020'
     C                   ENDIF
     C                   ENDIF
 
      ** Display formatted Amount field
 
     C                   MOVE      WSRAMT(1)     DRAM01
     C                   MOVE      WSRAMT(2)     DRAM02
     C                   MOVE      WSRAMT(3)     DRAM03
     C                   MOVE      WSRAMT(4)     DRAM04
     C                   MOVE      WSRAMT(5)     DRAM05
     C                   MOVE      WSRAMT(6)     DRAM06
     C                   MOVE      WSRAMT(7)     DRAM07
     C                   MOVE      WSRAMT(8)     DRAM08
     C                   MOVE      WSRAMT(9)     DRAM09
     C                   MOVE      WSRAMT(10)    DRAM10
     C                   MOVE      WSRAMT(11)    DRAM11
     C                   MOVE      WSRAMT(12)    DRAM12
 
      ** If all the Amount fields are valid set up file fields
 
     C                   IF        RAM01OK <> 'N' AND  RAM02OK <> 'N' AND
     C                             RAM03OK <> 'N' AND  RAM04OK <> 'N' AND
     C                             RAM05OK <> 'N' AND  RAM06OK <> 'N' AND
     C                             RAM07OK <> 'N' AND  RAM08OK <> 'N' AND
     C                             RAM09OK <> 'N' AND  RAM10OK <> 'N' AND
     C                             RAM11OK <> 'N' AND  RAM12OK <> 'N'
      *
     C                   MOVE      WVRAMT(1)     FRAM01
     C                   MOVE      WVRAMT(2)     FRAM02
     C                   MOVE      WVRAMT(3)     FRAM03
     C                   MOVE      WVRAMT(4)     FRAM04
     C                   MOVE      WVRAMT(5)     FRAM05
     C                   MOVE      WVRAMT(6)     FRAM06
     C                   MOVE      WVRAMT(7)     FRAM07
     C                   MOVE      WVRAMT(8)     FRAM08
     C                   MOVE      WVRAMT(9)     FRAM09
     C                   MOVE      WVRAMT(10)    FRAM10
     C                   MOVE      WVRAMT(11)    FRAM11
     C                   MOVE      WVRAMT(12)    FRAM11
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLPACNT - Validate Payment Accounts                           *
      *                                                               *
      *****************************************************************
     C     VLPACNT       BEGSR
 
      ** Validate Unallocated Account
 
     C                   EVAL      Wx = 0
      *
     C     DPUAC         IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1002'
      *
     C                   ELSE
     C                   MOVEL     DPUAC         WWPONS           21
     C                   EXSR      VLPOBR
     C                   EXSR      VLPONS
     C                   ENDIF
 
      ** Validate all other Accounts entered
 
     C                   MOVE      *BLANKS       CHKACCI
     C                   MOVE      *BLANKS       CHKACCP
     C                   MOVE      *BLANKS       CHKACCB
     C                   EVAL      Wx = 1
     C                   EVAL      SETTF = 'P'                                               CSF011A
     C                   EXSR      SRSETCNI                                                  CSF011A
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSPACT(Wx) <> *BLANKS
      *
      ** An entry has been made, but the previous field is blank
      *
     C                   IF        Wx > 1
     C                   SUB       1             Wx
     C                   IF        WSPACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1006'
     C                   ENDIF
     C                   ADD       1             Wx
     C                   ENDIF
      *
      ** Account must be valid
      *
     C                   MOVEL     WSPACT(Wx)    WWPONS
     C                   EXSR      VLPOBR
     C                   EXSR      VLPONS
      *
      ** If an Account has been entered, then Allocation must be entered
      *
     C                   IF        WSPALL(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1017'
     C                   ENDIF
      *
      ** If an Account has been entered, then either the Percentage
      ** or Amount must be entered.
      *
     C                   IF        WSPPCT(Wx) = *BLANKS AND
     C                             WSPAMT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1007'
     C                   ENDIF
      *
      ** Only the Percentage or the Amount field can be entered.
      ** A combiantion of percentages and amounts is not allowed.
      *
     C                   IF        WSPPCT(Wx) <> *BLANKS AND
     C                             WSPAMT(Wx) <> *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1005'
     C                   ENDIF
      *
      ** Account must be entered if either the Percentage or Amount entered
      *
     C                   IF        WSPACT(Wx) = *BLANKS AND
     C                             WSPPCT(Wx) <> *BLANKS OR
     C                             WSPACT(Wx) = *BLANKS AND
     C                             WSPAMT(Wx) <> *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1008'
     C                   ENDIF
      *
      ** Account can not be entered more than once for Interest
      *
     C                   IF        WSPALL(Wx) = 'I'
     C     WSPACT(Wx)    LOOKUP    CHKACCI                                89
     C                   IF        *IN89 = *ON
     C                   ADD       1             IDx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1013'
     C                   ENDIF
     C                   MOVE      WSPACT(Wx)    CHKACCI(Wx)
     C                   ENDIF
      *
      ** Account can not be entered more than once for Principal
      *
     C                   IF        WSPALL(Wx) = 'P'
     C     WSPACT(Wx)    LOOKUP    CHKACCP                                89
     C                   IF        *IN89 = *ON
     C                   ADD       1             IDx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1013'
     C                   ENDIF
     C                   MOVE      WSPACT(Wx)    CHKACCP(Wx)
     C                   ENDIF
      *
      ** Account can not be entered more than once for Principal + Interest
      *
     C                   IF        WSPALL(Wx) = 'B'
     C     WSPACT(Wx)    LOOKUP    CHKACCB                                89
     C                   IF        *IN89 = *ON
     C                   ADD       1             IDx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1013'
     C                   ENDIF
     C                   MOVE      WSPACT(Wx)    CHKACCB(Wx)
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   EXSR      SRCNTCNI                                                  CSF011A
     C                   ADD       1             Wx
     C                   ENDDO
     C                   EVAL      SETTF = *BLANKS                                           CSF011A
 
      ** If all the Accounts are valid set up file fields
 
     C                   IF        PUACOK  <> 'N' AND  PAC02OK <> 'N' AND
     C                             PAC03OK <> 'N' AND  PAC04OK <> 'N' AND
     C                             PAC05OK <> 'N' AND  PAC06OK <> 'N' AND
     C                             PAC07OK <> 'N' AND  PAC08OK <> 'N' AND
     C                             PAC09OK <> 'N' AND  PAC10OK <> 'N' AND
     C                             PAC11OK <> 'N' AND  PAC12OK <> 'N'
      *
     C                   MOVE      DPUAC         FPUAC
     C                   MOVE      DPAC01        FPAC01
     C                   MOVE      DPAC02        FPAC02
     C                   MOVE      DPAC03        FPAC03
     C                   MOVE      DPAC04        FPAC04
     C                   MOVE      DPAC05        FPAC05
     C                   MOVE      DPAC06        FPAC06
     C                   MOVE      DPAC07        FPAC07
     C                   MOVE      DPAC08        FPAC08
     C                   MOVE      DPAC09        FPAC09
     C                   MOVE      DPAC10        FPAC10
     C                   MOVE      DPAC11        FPAC11
     C                   MOVE      DPAC12        FPAC12
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLPALL - Validate Payment Allocation                          *
      *                                                               *
      *****************************************************************
     C     VLPALL        BEGSR
 
      ** Validate Allocation
 
     C                   MOVE      'N'           CHKIP
     C                   MOVE      'N'           CHKB
     C                   EVAL      Wx = 1
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSPALL(Wx) <> *BLANKS
      *
      ** An Allocation may only be entered if an Account has been entered
      *
     C                   IF        WSPACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1015'
     C                   ENDIF
      *
      ** Allocation must be valid
      *
     C                   IF        WSPALL(Wx) <> 'I' AND
     C                             WSPALL(Wx) <> 'P' AND
     C                             WSPALL(Wx) <> 'B'
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1016'
     C                   ENDIF
      *
      ** If 'Interest Paid Seperately' is set to 'Y' only Principal is allowed
      *
     C                   IF        IKIPDS = 'Y' AND
     C                             WSPALL(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1021'
     C                   ENDIF
      *
      ** If 'Front up Interest' is set to 'Y' only Principal is allowed
      *
     C                   IF        IKFUID = 'Y' AND
     C                             WSPALL(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1022'
     C                   ENDIF
      *
      ** If Loan Deal, only Principal is allowed on Payment side
      *
     C                   IF        DLTYPE = 'IP' AND
     C                             WSPALL(Wx) <> 'P' OR
     C                             DLTYPE = 'TI' AND
     C                             WSPALL(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1024'
     C                   ENDIF
      *
      ** Allocations can not be a combination of all I, P and B
      *
     C                   IF        WSPALL(Wx) = 'I' OR
     C                             WSPALL(Wx) = 'P'
     C                   MOVE      'Y'           CHKIP
     C                   ENDIF
      *
     C                   IF        WSPALL(Wx) = 'B'
     C                   MOVE      'Y'           CHKB
     C                   ENDIF
 
     C                   IF        WSPALL(Wx) = 'B' AND
     C                             CHKIP = 'Y' OR
     C                             WSPALL(Wx) = 'I' AND
     C                             CHKB = 'Y' OR
     C                             WSPALL(Wx) = 'P' AND
     C                             CHKB = 'Y'
     C                   ADD       1             IDx
     C                   EXSR      PayAllERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1018'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
 
      ** If all the Allocations are valid set up file fields
 
     C                   IF        PAL01OK <> 'N' AND  PAL02OK <> 'N' AND
     C                             PAL03OK <> 'N' AND  PAL04OK <> 'N' AND
     C                             PAL05OK <> 'N' AND  PAL06OK <> 'N' AND
     C                             PAL07OK <> 'N' AND  PAL08OK <> 'N' AND
     C                             PAL09OK <> 'N' AND  PAL10OK <> 'N' AND
     C                             PAL11OK <> 'N' AND  PAL12OK <> 'N'
      *
     C                   MOVE      DPAL01        FPAL01
     C                   MOVE      DPAL02        FPAL02
     C                   MOVE      DPAL03        FPAL03
     C                   MOVE      DPAL04        FPAL04
     C                   MOVE      DPAL05        FPAL05
     C                   MOVE      DPAL06        FPAL06
     C                   MOVE      DPAL07        FPAL07
     C                   MOVE      DPAL08        FPAL08
     C                   MOVE      DPAL09        FPAL09
     C                   MOVE      DPAL10        FPAL10
     C                   MOVE      DPAL11        FPAL11
     C                   MOVE      DPAL12        FPAL12
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLPPCTG - Validate Payment Percentage                         *
      *                                                               *
      *****************************************************************
     C     VLPPCTG       BEGSR
 
      ** Validate Percentage
 
     C                   MOVE      'N'           ErrPerc
     C                   MOVE      'N'           PercEnt
     C                   Z-ADD     0             PercTotI          6 0
     C                   Z-ADD     0             PercTotP          6 0
     C                   Z-ADD     0             PercTotB          6 0
     C                   EVAL      Wx = 1
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSPPCT(Wx) <> *BLANKS
      *
      ** A Percentage may only be entered if an Account has been entered
      *
     C                   IF        WSPACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1009'
     C                   ENDIF
      *
      ** Percentage must be valid
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVEL     WSPPCT(Wx)    @@ALPH
     C                   Z-ADD     *ZEROS        @@AMT
     C                   Z-ADD     3             @@IDP
     C                   Z-ADD     3             @@IINT
     C                   MOVE      'Y'           @@MTID
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      ** Percentage must be a numeric field
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrPerc
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1003'
      *
     C                   ELSE
      *
      ** Percentage  must be between '0'and '100'
     C     @@AMT         DIV       1000          WPERC             6 3
      *
     C     WPERC         IFLT      0
     C     WPERC         ORGT      100
     C                   MOVE      'Y'           ErrPerc
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1004'
     C                   ENDIF
     C                   ENDIF
      *
     C     ErrPerc       IFEQ      'N'
     C                   MOVE      @@ALPH        WSPPCT(Wx)
     C                   MOVE      @@AMT         WVPPCT(Wx)
      *
     C                   IF        WSPALL(Wx) = 'I'
     C                   ADD       @@AMT         PercTotI
     C                   ENDIF
      *
     C                   IF        WSPALL(Wx) = 'P'
     C                   ADD       @@AMT         PercTotP
     C                   ENDIF
      *
     C                   IF        WSPALL(Wx) = 'B'
     C                   ADD       @@AMT         PercTotB
     C                   ENDIF
      *
     C                   MOVE      'Y'           PercEnt
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
 
      ** All Percentages entered must add up to 100
 
     C     WSPPCT(1)     IFNE      *BLANKS
     C     PercTotI      IFNE      0
     C     PercTotI      ANDNE     100000
     C     PercTotP      ORNE      0
     C     PercTotP      ANDNE     100000
     C     PercTotB      ORNE      0
     C     PercTotB      ANDNE     100000
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1011'
     C                   ENDIF
     C                   ENDIF
 
      ** Dispay formatted percentage field
 
     C                   MOVE      WSPPCT(1)     DPPC01
     C                   MOVE      WSPPCT(2)     DPPC02
     C                   MOVE      WSPPCT(3)     DPPC03
     C                   MOVE      WSPPCT(4)     DPPC04
     C                   MOVE      WSPPCT(5)     DPPC05
     C                   MOVE      WSPPCT(6)     DPPC06
     C                   MOVE      WSPPCT(7)     DPPC07
     C                   MOVE      WSPPCT(8)     DPPC08
     C                   MOVE      WSPPCT(9)     DPPC09
     C                   MOVE      WSPPCT(10)    DPPC10
     C                   MOVE      WSPPCT(11)    DPPC11
     C                   MOVE      WSPPCT(12)    DPPC12
 
      ** If all the Percentage fields are valid set up file fields
 
     C                   IF        PPC01OK <> 'N' AND  PPC02OK <> 'N' AND
     C                             PPC03OK <> 'N' AND  PPC04OK <> 'N' AND
     C                             PPC05OK <> 'N' AND  PPC06OK <> 'N' AND
     C                             PPC07OK <> 'N' AND  PPC08OK <> 'N' AND
     C                             PPC09OK <> 'N' AND  PPC10OK <> 'N' AND
     C                             PPC11OK <> 'N' AND  PPC12OK <> 'N'
      *
     C                   MOVE      WVPPCT(1)     FPPC01
     C                   MOVE      WVPPCT(2)     FPPC02
     C                   MOVE      WVPPCT(3)     FPPC03
     C                   MOVE      WVPPCT(4)     FPPC04
     C                   MOVE      WVPPCT(5)     FPPC05
     C                   MOVE      WVPPCT(6)     FPPC06
     C                   MOVE      WVPPCT(7)     FPPC07
     C                   MOVE      WVPPCT(8)     FPPC08
     C                   MOVE      WVPPCT(9)     FPPC09
     C                   MOVE      WVPPCT(10)    FPPC10
     C                   MOVE      WVPPCT(11)    FPPC11
     C                   MOVE      WVPPCT(12)    FPPC12
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLPAMNT - Validate Payment Amounts                            *
      *                                                               *
      *****************************************************************
     C     VLPAMNT       BEGSR
 
      ** Validate Amounts
 
     C                   MOVE      'N'           ErrAmt
     C                   MOVE      'N'           AmntEnt
     C                   Z-ADD     0             AmntTotI         15 0
     C                   Z-ADD     0             AmntTotP         15 0
     C                   Z-ADD     0             AmntTotB         15 0
     C                   EVAL      Wx = 1
      *
     C                   DOW       Wx <= 12
 
     C                   IF        WSPAMT(Wx) <> *BLANKS
      *
      ** An Amount may only be entered if an Account has been entered
      *
     C                   IF        WSPACT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1010'
     C                   ENDIF
      *
      ** Amount must be valid
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVEL     WSPAMT(Wx)    @@ALPH
     C                   Z-ADD     *ZEROS        @@AMT
     C                   Z-ADD     PNBDP         @@IDP
     C     12            SUB       PNBDP         @@IINT
     C                   MOVE      'Y'           @@MTID
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      ** Amount must be a numeric field
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrAmt
     C                   ADD       1             IDx
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'MMM0144'
      *
     C                   ELSE
      *
      ** The amount must not be zero
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'Y'           ErrAmt
     C                   ADD       1             IDx
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'MMM0143'
     C                   ENDIF
     C                   ENDIF
      *
      ** If the amount is valid, set up the numeric amount for output
     C     ErrAmt        IFEQ      'N'
     C                   MOVE      @@ALPH        WSPAMT(Wx)
     C                   MOVE      @@AMT         WVPAMT(Wx)
      *
     C                   IF        WSPALL(Wx) = 'I'
     C                   ADD       @@AMT         AmntTotI
     C                   ENDIF
      *
     C                   IF        WSPALL(Wx) = 'P'
     C                   ADD       @@AMT         AmntTotP
     C                   ENDIF
      *
     C                   IF        WSPALL(Wx) = 'B'
     C                   ADD       @@AMT         AmntTotB
     C                   ENDIF
      *
     C                   MOVE      'Y'           AmntEnt
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
 
      ** Only the Percentage or the Amount field can be entered for a Deal.
      ** A combiantion of percentages and amounts is not allowed.
 
     C                   IF        PercEnt = 'Y' AND
     C                             AmntEnt = 'Y'
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      PayPctERR
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1014'
     C                   ENDIF
 
      ** For Allocation 'B' all Amounts must not exceed the Principal + Interest
 
     C     WSPAMT(1)     IFNE      *BLANKS
     C     AmntTotB      IFNE      0
     C     AmntTotB      ANDGT     TotAmIn
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1012'
     C                   ENDIF
     C                   ENDIF
 
      ** For Allocation 'I' all Amounts must not exceed the Interest
 
     C     WSPAMT(1)     IFNE      *BLANKS
     C     AmntTotI      IFNE      0
     C     AmntTotI      ANDGT     UMTTI
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1019'
     C                   ENDIF
     C                   ENDIF
 
      ** For Allocation 'P' all Amounts must not exceed the Principal
 
     C     WSPAMT(1)     IFNE      *BLANKS
     C     AmntTotP      IFNE      0
     C     AmntTotP      ANDGT     UAMNP
     C                   EVAL      Wx = 1
     C                   ADD       1             IDx
     C                   EXSR      PayAmtERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM1020'
     C                   ENDIF
     C                   ENDIF
 
      ** Display formatted Amount field
 
     C                   MOVE      WSPAMT(1)     DPAM01
     C                   MOVE      WSPAMT(2)     DPAM02
     C                   MOVE      WSPAMT(3)     DPAM03
     C                   MOVE      WSPAMT(4)     DPAM04
     C                   MOVE      WSPAMT(5)     DPAM05
     C                   MOVE      WSPAMT(6)     DPAM06
     C                   MOVE      WSPAMT(7)     DPAM07
     C                   MOVE      WSPAMT(8)     DPAM08
     C                   MOVE      WSPAMT(9)     DPAM09
     C                   MOVE      WSPAMT(10)    DPAM10
     C                   MOVE      WSPAMT(11)    DPAM11
     C                   MOVE      WSPAMT(12)    DPAM12
 
      ** If all the Amount fields are valid set up file fields
 
     C                   IF        PAM01OK <> 'N' AND  PAM02OK <> 'N' AND
     C                             PAM03OK <> 'N' AND  PAM04OK <> 'N' AND
     C                             PAM05OK <> 'N' AND  PAM06OK <> 'N' AND
     C                             PAM07OK <> 'N' AND  PAM08OK <> 'N' AND
     C                             PAM09OK <> 'N' AND  PAM10OK <> 'N' AND
     C                             PAM11OK <> 'N' AND  PAM12OK <> 'N'
      *
     C                   MOVE      WVPAMT(1)     FPAM01
     C                   MOVE      WVPAMT(2)     FPAM02
     C                   MOVE      WVPAMT(3)     FPAM03
     C                   MOVE      WVPAMT(4)     FPAM04
     C                   MOVE      WVPAMT(5)     FPAM05
     C                   MOVE      WVPAMT(6)     FPAM06
     C                   MOVE      WVPAMT(7)     FPAM07
     C                   MOVE      WVPAMT(8)     FPAM08
     C                   MOVE      WVPAMT(9)     FPAM09
     C                   MOVE      WVPAMT(10)    FPAM10
     C                   MOVE      WVPAMT(11)    FPAM11
     C                   MOVE      WVPAMT(12)    FPAM11
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLROBR - Validate Receipt Settlement Branch                   *
      *                                                               *
      *****************************************************************
     C     VLROBR        BEGSR
 
      ** Receipt Accounts and Settlement Branches if not Multi-Branching
 
     C     @MBIN         IFNE      'Y'
     C                   MOVEL     WWRONS        DDRONS           18
     C                   MOVEL     *BLANKS       DDROBR            3
     C                   ENDIF
 
      ** Receipt Accounts and Settlement Branches if Multi-Branching
 
     C     @MBIN         IFEQ      'Y'
     C     DDRSTM        IFEQ      '05'
     C                   MOVE      WWRONS        DDRONS
     C                   MOVEL     WWRONS        DDROBR
     C                   ELSE
     C                   MOVEL     WWRONS        DDRONS
     C                   MOVEL     *BLANKS       DDROBR
     C                   ENDIF
     C                   ENDIF
 
      ** If Settlement Method is 05 and Multi-Branching
 
     C     @MBIN         IFEQ      'Y'
     C     DDRSTM        ANDEQ     '05'
      *
      ** Settlement Branch is Mandatory
      *
     C     DDROBR        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0885'
     C                   ELSE
      *
      ** Validate Settlement Branch
      *
     C                   MOVE      DDROBR        @BRCA             3
     C                   EXSR      ACBRCH
      *
      ** No Selection
      *
     C     PRTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0863'
     C                   ENDIF
      *
      ** Error in Settlement Branch
      *
     C     PRTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0884'
     C                   ELSE
     C                   MOVE      @DSNB         DDROBR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLRONS - VALIDATE OUR RECEIVE NOSTRO                          *
      *                                                               *
      *****************************************************************
     C     VLRONS        BEGSR
      *
      ** Reset A/C closed indicator
      *
     C                   MOVE      *BLANKS       W#ACOPEN          1
      *
      ** Move Our Nostro into Our Account Data Structure
      *
     C                   MOVE      DDRONS        A#OURA
      *
      ** IF SETLEMENT TYPE IS 05 MUST IDENTIFY A LIVE RECORD ON ACCNTAB
      ** (IN COMBINATION WITH RECEIPT CURRENCY)
      *
     C     DDRSTM        IFEQ      '05'
      *
     C     A#ACSQ        IFEQ      *BLANKS
     C     A#ACSQ        OREQ      '00'
     C                   MOVE      '01'          A#ACSQ
     C                   ENDIF
      *
     C**********         TESTN                   A#CNUM               99                     CSF011A
     C***99*****         TESTN                   A#ACOD               99                     CSF011A
     C                   TESTN                   A#ACOD               99                     CSF011A
     C   99              TESTN                   A#ACSQ               99
      *
      ** INVALID CUSTOMER, A/C CODE & A/C SEQUENCE
      *
     C     *IN99         IFNE      '1'
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0910'
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       PACID
     C                   MOVEL     A#CNUM        PACID
     C                   MOVE      E#RCCY        PCYCD
     C                   MOVE      A#ACSQ        PACSN
     C                   MOVE      A#ACOD        PACCD
      *
      * Default branch
      *
     C     @MBIN         IFEQ      'N'
     C                   MOVE      BJSBRC        DDROBR
     C                   ENDIF
      *
     C                   MOVE      DDROBR        PBRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                             AND SETTF = 'R'                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     PRTCD         IFNE      *BLANKS
     C     ##PREC        ANDNE     'Y'
     C     RECI          ORNE      'D'
     C     ##PREC        ANDNE     'Y'
     C     ACST          OREQ      'C'
     C     ##PREC        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0910'
     C                   ELSE
     C                   MOVE      'Y'           W#ACOPEN
      *
      ** Ensure account is not blocked for Debit/Credit
      *
     C                   TESTB     '2'           RETB                     91    DEBIT
      *
      ** A/C IS BLOCKED
      *
     C     *IN91         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'
     C                   ENDIF
     C                   ENDIF
 
      ** Set up Account ID for Overdraft Limit Check
 
     C                   IF        CDL008 = 'Y'
     C                   EVAL      WkCust = CNUM
     C                   EVAL      WkCcy  = CCY
     C                   EVAL      WkACOD = ACOD
     C                   EVAL      WkASeq = ACSQ
     C                   EVAL      WkBRCA = BRCA
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** IF SETL TYPE IS 14, NOSTRO MUST CONTAIN A 10 DIGIT NUMBER
      ** WHICH IDENTIFIES A LIVE RECORD ON FILE ACCNTAB
      *
     C     DDRSTM        IFEQ      '14'
     C                   TESTN                   A#RENO               99
      *
      ** INVALID RETAIL A/C NUMBER
      *
     C     *IN99         IFNE      '1'
     C     A#ACSQ        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0911'
     C                   ELSE
      *
     C                   MOVEL     A#RENO        PACID
     C                   MOVE      *BLANKS       PCYCD
     C                   MOVE      *BLANKS       PACSN
     C                   MOVE      *BLANKS       PACCD
     C                   MOVE      *BLANKS       PBRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                             AND SETTF = 'R'                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     PRTCD         IFNE      *BLANKS
     C     ##PREC        ANDNE     'Y'
     C     RECI          ORNE      'D'
     C     ##PREC        ANDNE     'Y'
     C     ACST          OREQ      'C'
     C     ##PREC        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0911'
     C                   ELSE
      *
     C                   MOVE      'Y'           W#ACOPEN
      *
      ** Ensure account is not blocked for Debit/Credit
      *
     C                   TESTB     '2'           RETB                     91    DEBIT
      *
      ** A/C IS BLOCKED
      *
     C     *IN91         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'
     C                   ENDIF
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      BRCA          DDROBR
      *
      ** IF SETL IS 14 AND NOSTRO IDENTIFIES A LIVE RECORD ON ACCNTAB
      ** RECEIPT CURRENCY MUST BE SAME AS CURRENCY OF ACCOUNT
      *
     C     E#RCCY        IFNE      CCY
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0914'
      *
     C                   ELSE
      *
      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
      *
     C     @MBIN         IFEQ      'N'
     C     BRCA          ANDNE     BJSBRC
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0888'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
 
      ** Set up Account ID for Overdraft Limit Check
 
     C                   IF        CDL008 = 'Y'
     C                   EVAL      WkCust = CNUM
     C                   EVAL      WkCcy  = CCY
     C                   EVAL      WkACOD = ACOD
     C                   EVAL      WkASeq = ACSQ
     C                   EVAL      WkBRCA = BRCA
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** IF SETL TYPE IS 05 OR 14 AND A/C IS NOT CLOSED
      ** THE DATE OF RECEIPT MUST NOT BE BEFORE THE DATE A/C OPENED
      *
     C     DDRSTM        IFEQ      '05'
     C     DDRSTM        OREQ      '14'
      *
     C     W#ACOPEN      IFEQ      'Y'
     C     ##ACTN        ANDEQ     'I'
     C     ##DATR        ANDLT     DACO
     C                   ADD       1             Idx
     C                   EXSR      RcvAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0912'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLPOBR - Validate Payment Settlement Branch                   *
      *                                                               *
      *****************************************************************
     C     VLPOBR        BEGSR
 
      ** Payment Accounts and Settlement Branches if not Multi-Branching
 
     C     @MBIN         IFNE      'Y'
     C                   MOVEL     WWPONS        DDPONS           18
     C                   MOVEL     *BLANKS       DDPOBR            3
     C                   ENDIF
 
      ** Payment Accounts and Settlement Branches if Multi-Branching
 
     C     @MBIN         IFEQ      'Y'
     C     DDPSTM        IFEQ      '05'
     C                   MOVE      WWPONS        DDPONS
     C                   MOVEL     WWPONS        DDPOBR
     C                   ELSE
     C                   MOVEL     WWPONS        DDPONS
     C                   MOVEL     *BLANKS       DDPOBR
     C                   ENDIF
     C                   ENDIF
 
      ** If Settlement Method is 05 and Multi-Branching
 
     C     @MBIN         IFEQ      'Y'
     C     DDPSTM        ANDEQ     '05'
      *
      ** Settlement Branch is Mandatory
      *
     C     DDPOBR        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0882'
     C                   ELSE
      *
      ** Validate Settlement Branch
      *
     C                   MOVE      DDPOBR        @BRCA
     C                   EXSR      ACBRCH
      *
      ** No Selection
      *
     C     PRTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0864'
     C                   ENDIF
      *
      ** Error in Settlement Branch
      *
     C     PRTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0881'
     C                   ELSE
     C                   MOVE      @DSNB         DDPOBR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * VLPONS - VALIDATE OUR PAYMENT NOSTRO                          *
      *                                                               *
      *****************************************************************
     C     VLPONS        BEGSR
      *
      ** Reset A/C closed indicator
      *
     C                   MOVE      *BLANKS       W#ACOPEN
      *
      ** Move Our Nostro into Our Account Data Structure
      *
     C                   MOVE      DDPONS        A#OURA
      *
      ** IF SETLEMENT TYPE IS 05 MUST IDENTIFY A LIVE RECORD ON ACCNTAB
      ** (IN COMBINATION WITH PAYMENT CURRENCY)
      *
     C     DDPSTM        IFEQ      '05'
      *
     C     A#ACSQ        IFEQ      *BLANKS
     C     A#ACSQ        OREQ      '00'
     C                   MOVE      '01'          A#ACSQ
     C                   ENDIF
      *
     C**********         TESTN                   A#CNUM               99                     CSF011A
     C***99*****         TESTN                   A#ACOD               99                     CSF011A
     C                   TESTN                   A#ACOD               99                     CSF011A
     C   99              TESTN                   A#ACSQ               99
      *
      ** INVALID CUSTOMER, A/C CODE & A/C SEQUENCE
      *
     C     *IN99         IFNE      '1'
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0940'
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       PACID
     C                   MOVEL     A#CNUM        PACID
     C                   MOVE      E#PCCY        PCYCD
     C                   MOVE      A#ACSQ        PACSN
     C                   MOVE      A#ACOD        PACCD
      *
      * Default branch
      *
     C     @MBIN         IFEQ      'N'
     C                   MOVE      BJSBRC        DDPOBR
     C                   ENDIF
      *
     C                   MOVE      DDPOBR        PBRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                             AND SETTF = 'P'                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     PRTCD         IFNE      *BLANKS
     C     ##PPAY        ANDNE     'Y'
     C     RECI          ORNE      'D'
     C     ##PPAY        ANDNE     'Y'
     C     ACST          OREQ      'C'
     C     ##PPAY        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0940'
     C                   ELSE
     C                   MOVE      'Y'           W#ACOPEN
      *
      ** Ensure account is not blocked for Debit/Credit
      *
     C                   TESTB     '3'           RETB                     92    CREDIT
      *
      ** A/C IS BLOCKED
      *
     C     *IN92         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0992'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** IF SETL TYPE IS 14, NOSTRO MUST CONTAIN A 10 DIGIT NUMBER
      ** WHICH IDENTIFIES A LIVE RECORD ON FILE ACCNTAB
      *
     C     DDPSTM        IFEQ      '14'
     C                   TESTN                   A#RENO               99
      *
      ** INVALID RETAIL A/C NUMBER
      *
     C     *IN99         IFNE      '1'
     C     A#ACSQ        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0941'
     C                   ELSE
      *
     C                   MOVEL     A#RENO        PACID
     C                   MOVE      *BLANKS       PCYCD
     C                   MOVE      *BLANKS       PACSN
     C                   MOVE      *BLANKS       PACCD
     C                   MOVE      *BLANKS       PBRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                             AND SETTF = 'P'                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     PRTCD         IFNE      *BLANKS
     C     ##PPAY        ANDNE     'Y'
     C     RECI          ORNE      'D'
     C     ##PPAY        ANDNE     'Y'
     C     ACST          OREQ      'C'
     C     ##PPAY        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0941'
     C                   ELSE
      *
     C                   MOVE      'Y'           W#ACOPEN
      *
      ** Ensure account is not blocked for Debit/Credit
      *
     C                   TESTB     '3'           RETB                     92    CREDIT
      *
      ** A/C IS BLOCKED
      *
     C     *IN92         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0992'
     C                   ENDIF
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      BRCA          DDPOBR
      *
      ** IF SETL IS 14 AND NOSTRO IDENTIFIES A LIVE RECORD ON ACCNTAB
      ** RECEIPT CURRENCY MUST BE SAME AS CURRENCY OF ACCOUNT
      *
     C     E#PCCY        IFNE      CCY
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0944'
      *
     C                   ELSE
      *
      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
      *
     C     @MBIN         IFEQ      'N'
     C     BRCA          ANDNE     BJSBRC
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0887'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** IF SETL TYPE IS 05 OR 14 AND A/C IS NOT CLOSED
      ** THE DATE OF PAYMENT MUST NOT BE BEFORE THE DATE A/C OPENED
      *
     C     DDPSTM        IFEQ      '05'
     C     DDPSTM        OREQ      '14'
      *
     C     W#ACOPEN      IFEQ      'Y'
     C     ##ACTN        ANDEQ     'I'
     C     ##DATP        ANDLT     DACO
     C                   ADD       1             Idx
     C                   EXSR      PayAcntERR
     C                   EVAL      MsgIDArr(Idx) = 'ESM0942'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      * ACBRCH - ACCESS BRANCH DETAILS
      *
      *****************************************************************
     C     ACBRCH        BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @BRCA         @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      * ACACCT - ACCESS ACCOUNT DETAILS
      *
      *****************************************************************
     C     ACACCT        BEGSR
 
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PACID            10
     C                   PARM                    PCYCD             3
     C                   PARM                    PACCD            10
     C                   PARM                    PACSN             2
     C                   PARM                    PBRCA             3
     C                   PARM                    PTYPE             7
     C                   PARM                    PNOSN             2
     C     ACCT          PARM      ACCT          DSSDY
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * GETCCYDET - Get currency details                              *
      *****************************************************************
     C     GETCCYDET     BEGSR
 
      **  Access Currency Details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SROvrChk - Overdraft Limit Check for the receive settlement   *
      *            Account                                            *
      *                                                               *
      *****************************************************************
     C     SROvrChk      BEGSR
 
     C                   EVAL      PInBranch = WkBRCA
     C                   EVAL      PInCust = WkCust
     C                   EVAL      PInCurr = WkCcy
     C                   EVAL      PInACode = WkACOD
     C                   EVAL      PInASeqN = WkASEQ
 
     C                   CALL      'RE101901'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PInBranch
     C                   PARM                    PInCust
     C                   PARM                    PInCurr
     C                   PARM                    PInACode
     C                   PARM                    PInASeqN
     C                   PARM                    PDebAmnt
     C                   PARM                    POutBranch
     C                   PARM                    POutCust
     C                   PARM                    POutCurr
     C                   PARM                    POutACode
     C                   PARM                    POutASeqN
     C                   PARM                    POutRetNo
 
     C                   IF        PRetCode = '*ODLMTX'
     C                   MOVE      POutCust      WkCustA
     C                   MOVE      POutACode     WkACodeA
     C                   MOVE      POutASeqN     WkASeqNA
     C                   MOVE      POutRetNo     WkRetNoA
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      RcvAcntWRN
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1949'
     C                   IF        POutRetNo = *Zeros
     C**********         EVAL      WMsgDtaArr(WIdx) = POutBranch + '-' +                    MD000091
     C**********                   WkCustA + '-' + POutCurr + '-' +                         MD000091
     C**********                   WkACodeA + '-' + WkASeqNA                                MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +                           MD000091
     C                             WkCustA + '-' + POutCurr + '-' +                         MD000091
     C                             WkACodeA + '-' + WkASeqNA                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
     C                   ELSE
     C**********         EVAL      WMsgDtaArr(WIdx) = POutBranch + '-' +                    MD000091
     C**********                   WkCustA + '-' + POutCurr + '-' +                         MD000091
     C**********                   WkACodeA + '-' + WkASeqNA + '/' +                        MD000091
     C**********                   WkRetNoA                                                 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +                           MD000091
     C                             WkCustA + '-' + POutCurr + '-' +                         MD000091
     C                             WkACodeA + '-' + WkASeqNA + '/' +                        MD000091
     C                             WkRetNoA                                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcvAcntERR - Receipt Account Field in Error                  *
      *                                                               *
      *****************************************************************
     C     RcvAcntERR    BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 0
     C                   EVAL      RUACOK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRUAC'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      RAC02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      RAC03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      RAC04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      RAC05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      RAC06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      RAC07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      RAC08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      RAC09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      RAC10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      RAC11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      RAC12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAC12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcvAllERR  - Payment Allocation Field in Error               *
      *                                                               *
      *****************************************************************
     C     RcvAllERR     BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   EVAL      RAL01OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL01'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      RAL02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      RAL03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      RAL04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      RAL05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      RAL06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      RAL07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      RAL08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      RAL09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      RAL10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      RAL11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      RAL12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAL12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcvAcntWRN - Receipt Account Field Warning                   *
      *                                                               *
      *****************************************************************
     C     RcvAcntWRN    BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 0
     C                   EVAL      WFldNameArr(Idx) = 'DRUAC'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      WFldNameArr(Idx) = 'DRAC02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      WFldNameArr(Idx) = 'DRAC03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      WFldNameArr(Idx) = 'DRAC04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      WFldNameArr(Idx) = 'DRAC05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      WFldNameArr(Idx) = 'DRAC06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      WFldNameArr(Idx) = 'DRAC07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      WFldNameArr(Idx) = 'DRAC08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      WFldNameArr(Idx) = 'DRAC09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      WFldNameArr(Idx) = 'DRAC10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      WFldNameArr(Idx) = 'DRAC11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      WFldNameArr(Idx) = 'DRAC12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcvPctERR - Receipt Percentage Field in Error                *
      *                                                               *
      *****************************************************************
     C     RcvPctERR     BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   EVAL      RPC01OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC01'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      RPC02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      RPC03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      RPC04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      RPC05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      RPC06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      RPC07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      RPC08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      RPC09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      RPC10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      RPC11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      RPC12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRPC12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcvAmtERR - Receipt Amount Field in Error                    *
      *                                                               *
      *****************************************************************
     C     RcvAmtERR     BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   EVAL      RAM01OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM01'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      RAM02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      RAM03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      RAM04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      RAM05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      RAM06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      RAM07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      RAM08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      RAM09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      RAM10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      RAM11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      RAM12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DRAM12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PayAcntERR - Payment Account Field in Error                  *
      *                                                               *
      *****************************************************************
     C     PayAcntERR    BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 0
     C                   EVAL      PUACOK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPUAC'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      PAC02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      PAC03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      PAC04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      PAC05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      PAC06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      PAC07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      PAC08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      PAC09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      PAC10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      PAC11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      PAC12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAC12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PayAllERR  - Payment Allocation Field in Error               *
      *                                                               *
      *****************************************************************
     C     PayAllERR     BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   EVAL      PAL01OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL01'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      PAL02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      PAL03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      PAL04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      PAL05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      PAL06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      PAL07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      PAL08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      PAL09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      PAL10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      PAL11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      PAL12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAL12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PayPctERR - Payment Percentage Field in Error                *
      *                                                               *
      *****************************************************************
     C     PayPctERR     BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   EVAL      PPC01OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC01'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      PPC02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      PPC03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      PPC04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      PPC05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      PPC06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      PPC07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      PPC08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      PPC09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      PPC10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      PPC11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      PPC12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPPC12'
      *
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PayAmtERR - Payment Amount Field in Error                    *
      *                                                               *
      *****************************************************************
     C     PayAmtERR     BEGSR
 
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   EVAL      PAM01OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM01'
      *
     C                   WHEN      Wx = 2
     C                   EVAL      PAM02OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM02'
      *
     C                   WHEN      Wx = 3
     C                   EVAL      PAM03OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM03'
      *
     C                   WHEN      Wx = 4
     C                   EVAL      PAM04OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM04'
      *
     C                   WHEN      Wx = 5
     C                   EVAL      PAM05OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM05'
      *
     C                   WHEN      Wx = 6
     C                   EVAL      PAM06OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM06'
      *
     C                   WHEN      Wx = 7
     C                   EVAL      PAM07OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM07'
      *
     C                   WHEN      Wx = 8
     C                   EVAL      PAM08OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM08'
      *
     C                   WHEN      Wx = 9
     C                   EVAL      PAM09OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM09'
      *
     C                   WHEN      Wx = 10
     C                   EVAL      PAM10OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM10'
      *
     C                   WHEN      Wx = 11
     C                   EVAL      PAM11OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM11'
      *
     C                   WHEN      Wx = 12
     C                   EVAL      PAM12OK = 'N'
     C                   EVAL      FldNameArr(Idx) = 'DPAM12'
      *
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SRSETCNI - Reset Customer Details Counter                     *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SRSETCNI      BEGSR                                                               CSF011A
     C                   EVAL      CusIdxA = 57                                              CSF011A
     C                   EVAL      CusIdxB = 67                                              CSF011A
     C                   EVAL      CusIdxC = 87                                              CSF011A
     C                   EVAL      CusIdxD = 97                                              CSF011A
     C                   EVAL      CusIdxE = 117                                             CSF011A
     C                   EVAL      W@Len = 115                                               CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * CSFACT - Populate Customer Name Input details                 *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     CSFACT        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
                                                                                             CSF011A
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                   IF        SETTF = 'P'                                               CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxA:10) = C_BBCSSN                      CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxB:20) = C_BBCRNM                      CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxC:10) = C_BBCRTN                      CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxD:20) = ANAM                          CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxE:12) = C_BBCSID                      CSF011A
     C                   ELSEIF    SETTF = 'R'                                               CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxA:10) = C_BBCSSN                      CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxB:20) = C_BBCRNM                      CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxC:10) = C_BBCRTN                      CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxD:20) = ANAM                          CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxE:12) = C_BBCSID                      CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SRCNTCNI -  Customer Details File Position Counter            *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SRCNTCNI      BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   EVAL      CusIdxA = CusidxA + W@Len                                 CSF011A
     C                   EVAL      CusIdxB = CusidxB + W@Len                                 CSF011A
     C                   EVAL      CusIdxC = CusidxC + W@Len                                 CSF011A
     C                   EVAL      CusIdxD = CusidxD + W@Len                                 CSF011A
     C                   EVAL      CusIdxE = CusidxE + W@Len                                 CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST  - Access Customer details                             *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       PRTCD                                       CSF011A
     C                   PARM      '*KEY   '     POPTN                                       CSF011A
     C                   PARM      CNUM          @CSCN                                       CSF011A
     C                   PARM      *BLANKS       @KYST                                       CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Determine Deal Type
 
     C     ##ACTN        IFEQ      'I'
     C                   MOVE      IKTYPE        DLTYPE            2
     C                   ELSE
     C                   MOVE      IKMTYP        DLTYPE
     C                   ENDIF
 
      ** Calculate Total of Principal + Interest of Deal
 
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        UAMNP            15 0
     C                   ELSE
     C                   Z-ADD     IKAMNP        UAMNP
     C                   ENDIF
      *
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        UMTTI            15 0
     C                   ELSE
     C                   Z-ADD     IKMTTI        UMTTI
     C                   ENDIF
      *
     C     UAMNP         ADD       UMTTI         TotAmIn          15 0
     C                   MOVE      TotAmIn       PAmtInRec
     C                   MOVE      TotAmIn       PAmtInPay
 
      ** Default Receipt Unallocated Account and Account 1
 
     C     DDRMAC        IFEQ      'Y'
     C     DRUAC         IFEQ      *BLANKS
     C                   MOVEL     DDRONX        DRUAC
     C                   ENDIF
     C                   MOVEL     DDRONX        DRAC01
     C                   ENDIF
 
      ** Default Payment Unallocated Account and Account 1
 
     C     DDPMAC        IFEQ      'Y'
     C     DPUAC         IFEQ      *BLANKS
     C                   MOVEL     DDPONX        DPUAC
     C                   ENDIF
     C                   MOVEL     DDPONX        DPAC01
     C                   ENDIF
 
      ** Set RECEIPT details
 
     C     DDRMAC        IFEQ      'Y'
      *
      ** Get Receipt currency details
      *
     C                   MOVEL     ##RCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   Z-ADD     A6NBDP        RNBDP             1 0
      *
      ** If Deposit Deal, only Principal is allowed on Receipt side
     C                   IF        DLTYPE = 'IT' OR DLTYPE = 'TD'
     C                   MOVE      UAMNP         PAmtInRec
     C                   ENDIF
      *
      ** Output Total Amount
      *
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    PAmtInRec        15 0
     C                   PARM                    RNBDP
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        PAmtOutS         16
     C                   PARM      *BLANK        PAmtOutU         17
      *
     C                   MOVE      PAmtOutS      DRTAMT
      *
      ** Load Accounts array
      *
     C                   MOVE      DRAC01        WSRACT(1)
     C                   MOVE      DRAC02        WSRACT(2)
     C                   MOVE      DRAC03        WSRACT(3)
     C                   MOVE      DRAC04        WSRACT(4)
     C                   MOVE      DRAC05        WSRACT(5)
     C                   MOVE      DRAC06        WSRACT(6)
     C                   MOVE      DRAC07        WSRACT(7)
     C                   MOVE      DRAC08        WSRACT(8)
     C                   MOVE      DRAC09        WSRACT(9)
     C                   MOVE      DRAC10        WSRACT(10)
     C                   MOVE      DRAC11        WSRACT(11)
     C                   MOVE      DRAC12        WSRACT(12)
      *
      ** Load Allocations array
      *
     C                   MOVE      DRAL01        WSRALL(1)
     C                   MOVE      DRAL02        WSRALL(2)
     C                   MOVE      DRAL03        WSRALL(3)
     C                   MOVE      DRAL04        WSRALL(4)
     C                   MOVE      DRAL05        WSRALL(5)
     C                   MOVE      DRAL06        WSRALL(6)
     C                   MOVE      DRAL07        WSRALL(7)
     C                   MOVE      DRAL08        WSRALL(8)
     C                   MOVE      DRAL09        WSRALL(9)
     C                   MOVE      DRAL10        WSRALL(10)
     C                   MOVE      DRAL11        WSRALL(11)
     C                   MOVE      DRAL12        WSRALL(12)
      *
      ** Load Percentage array
      *
     C                   MOVE      *BLANKS       WVRPCT
      *
     C                   MOVE      DRPC01        WSRPCT(1)
     C                   MOVE      DRPC02        WSRPCT(2)
     C                   MOVE      DRPC03        WSRPCT(3)
     C                   MOVE      DRPC04        WSRPCT(4)
     C                   MOVE      DRPC05        WSRPCT(5)
     C                   MOVE      DRPC06        WSRPCT(6)
     C                   MOVE      DRPC07        WSRPCT(7)
     C                   MOVE      DRPC08        WSRPCT(8)
     C                   MOVE      DRPC09        WSRPCT(9)
     C                   MOVE      DRPC10        WSRPCT(10)
     C                   MOVE      DRPC11        WSRPCT(11)
     C                   MOVE      DRPC12        WSRPCT(12)
      *
      ** Load Amounts array
      *
     C                   MOVE      *BLANKS       WVRAMT
      *
     C                   MOVE      DRAM01        WSRAMT(1)
     C                   MOVE      DRAM02        WSRAMT(2)
     C                   MOVE      DRAM03        WSRAMT(3)
     C                   MOVE      DRAM04        WSRAMT(4)
     C                   MOVE      DRAM05        WSRAMT(5)
     C                   MOVE      DRAM06        WSRAMT(6)
     C                   MOVE      DRAM07        WSRAMT(7)
     C                   MOVE      DRAM08        WSRAMT(8)
     C                   MOVE      DRAM09        WSRAMT(9)
     C                   MOVE      DRAM10        WSRAMT(10)
     C                   MOVE      DRAM11        WSRAMT(11)
     C                   MOVE      DRAM12        WSRAMT(12)
      *
     C                   ENDIF
 
      ** Set PAYMENT details
 
     C     DDPMAC        IFEQ      'Y'
      *
      ** Get Payment currency details
      *
     C                   MOVEL     ##PCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   Z-ADD     A6NBDP        PNBDP             1 0
      *
      ** If Loan Deal, only Principal is allowed on Payment side
     C                   IF        DLTYPE = 'IP' OR DLTYPE = 'TI'
     C                   MOVE      UAMNP         PAmtInPay
     C                   ENDIF
      *
      ** Output Total Amount
      *
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    PAmtInPay        15 0
     C                   PARM                    PNBDP
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        PAmtOutS
     C                   PARM      *BLANK        PAmtOutU
      *
     C                   MOVE      PAmtOutS      DPTAMT
      *
      ** Load Accounts array
      *
     C                   MOVE      DPAC01        WSPACT(1)
     C                   MOVE      DPAC02        WSPACT(2)
     C                   MOVE      DPAC03        WSPACT(3)
     C                   MOVE      DPAC04        WSPACT(4)
     C                   MOVE      DPAC05        WSPACT(5)
     C                   MOVE      DPAC06        WSPACT(6)
     C                   MOVE      DPAC07        WSPACT(7)
     C                   MOVE      DPAC08        WSPACT(8)
     C                   MOVE      DPAC09        WSPACT(9)
     C                   MOVE      DPAC10        WSPACT(10)
     C                   MOVE      DPAC11        WSPACT(11)
     C                   MOVE      DPAC12        WSPACT(12)
      *
      ** Load Allocations array
      *
     C                   MOVE      DPAL01        WSPALL(1)
     C                   MOVE      DPAL02        WSPALL(2)
     C                   MOVE      DPAL03        WSPALL(3)
     C                   MOVE      DPAL04        WSPALL(4)
     C                   MOVE      DPAL05        WSPALL(5)
     C                   MOVE      DPAL06        WSPALL(6)
     C                   MOVE      DPAL07        WSPALL(7)
     C                   MOVE      DPAL08        WSPALL(8)
     C                   MOVE      DPAL09        WSPALL(9)
     C                   MOVE      DPAL10        WSPALL(10)
     C                   MOVE      DPAL11        WSPALL(11)
     C                   MOVE      DPAL12        WSPALL(12)
      *
      ** Load Percentage array
      *
     C                   MOVE      *BLANKS       WVPPCT
      *
     C                   MOVE      DPPC01        WSPPCT(1)
     C                   MOVE      DPPC02        WSPPCT(2)
     C                   MOVE      DPPC03        WSPPCT(3)
     C                   MOVE      DPPC04        WSPPCT(4)
     C                   MOVE      DPPC05        WSPPCT(5)
     C                   MOVE      DPPC06        WSPPCT(6)
     C                   MOVE      DPPC07        WSPPCT(7)
     C                   MOVE      DPPC08        WSPPCT(8)
     C                   MOVE      DPPC09        WSPPCT(9)
     C                   MOVE      DPPC10        WSPPCT(10)
     C                   MOVE      DPPC11        WSPPCT(11)
     C                   MOVE      DPPC12        WSPPCT(12)
      *
      ** Load Amounts array
      *
     C                   MOVE      *BLANKS       WVPAMT
      *
     C                   MOVE      DPAM01        WSPAMT(1)
     C                   MOVE      DPAM02        WSPAMT(2)
     C                   MOVE      DPAM03        WSPAMT(3)
     C                   MOVE      DPAM04        WSPAMT(4)
     C                   MOVE      DPAM05        WSPAMT(5)
     C                   MOVE      DPAM06        WSPAMT(6)
     C                   MOVE      DPAM07        WSPAMT(7)
     C                   MOVE      DPAM08        WSPAMT(8)
     C                   MOVE      DPAM09        WSPAMT(9)
     C                   MOVE      DPAM10        WSPAMT(10)
     C                   MOVE      DPAM11        WSPAMT(11)
     C                   MOVE      DPAM12        WSPAMT(12)
      *
     C                   ENDIF
 
      ** Initialize Effective Receive and Payment Currencies
 
     C                   MOVEL     ##RCCY        E#RCCY            3
     C                   MOVEL     ##PCCY        E#PCCY            3
 
     C**********         EVAL      WIdx = *ZEROS                                             BUG4478
 
      ** Initialise customer name on input fields                                            CSF011A
                                                                                             CSF011A
     C                   EVAL      Wx = 1                                                    CSF011A
     C                   EXSR      SRSETCNI                                                  CSF011A
     C                   DOW       Wx <= 12                                                  CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxA:10) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxB:20) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxC:10) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxD:20) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxE:12) = *BLANKS                       CSF011A
     C                   EXSR      SRCNTCNI                                                  CSF011A
     C                   ADD       1             Wx                                          CSF011A
     C                   ENDDO                                                               CSF011A
                                                                                             CSF011A
     C                   EVAL      Wx = 1                                                    CSF011A
     C                   EXSR      SRSETCNI                                                  CSF011A
     C                   DOW       Wx <= 12                                                  CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxA:10) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxB:20) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxC:10) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxD:20) = *BLANKS                       CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxE:12) = *BLANKS                       CSF011A
     C                   EXSR      SRCNTCNI                                                  CSF011A
     C                   ADD       1             Wx                                          CSF011A
     C                   ENDDO                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Calling program
     C                   PARM                    ##CALP            4
 
      ** Payment currency
     C                   PARM                    ##PCCY            3
 
      ** Receive currency
     C                   PARM                    ##RCCY            3
 
      ** Transaction Type
     C                   PARM                    ##TTYP            2
 
      ** Booking branch
     C                   PARM                    ##BRCA            3
 
      ** Receipt Date
      ** (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATR            5 0
 
      ** Payment Date
      ** (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATP            5 0
 
      ** Payment - Settle instructions - Screen format
     C                   PARM                    ##PAYS
 
      ** Receive - Settle instructions - Screen format
     C                   PARM                    ##RECS
 
      ** Payment - Further Settle instructions - Screen format
     C                   PARM                    #FPAYS
 
      ** Receive - Further Settle instructions - Screen format
     C                   PARM                    #FRECS
 
      ** Action Code
     C                   PARM                    ##ACTN            1
 
      ** Protect Payment Field
     C                   PARM                    ##PPAY            1
 
      ** Protect Receipt Field
     C                   PARM                    ##PREC            1
 
      ** LDNI Deal details
     C                   PARM                    NwDlFilFmt
 
      ** OUTPUTS
      ** Payment - Further Settle instructions OK
     C                   PARM                    #FPAYE
 
      ** Receive - Further Settle instructions OK
     C                   PARM                    #FRECE
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning Messages
     C                   PARM                    WFldNameArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** Payment - Further Settle instructions - File format
     C                   PARM                    #FPAYF
 
      ** Receive - Further Settle instructions - File format
     C                   PARM                    #FRECF
 
 
      ** Read Data Area - RUNDAT
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Access Bank Details via access program
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Access Dealing details via access program
 
     C                   CALLB     'AODEALR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDDEAL        PARM      SDDEAL        DSFDY
 
      ** Check if switchable feature CDL008 is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CDL008'      PSARD             1
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL008            1
     C                   ELSE
     C                   MOVE      'N'           CDL008
     C                   ENDIF
 
      ** Check if Cash Management is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CRE008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
     C                   MOVE      'Y'           CRE008            1
     C                   ELSE
     C                   MOVE      'N'           CRE008
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
