     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement retrieve')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFESTRTV - Fee Settlement Retrieve                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054354           Date 23Oct19               *
      *                 MD026969A          Date 23Oct19               *
      *                 MD026969           Date 23Oct19               *
      *                 CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027384           Date 10Jun14               *
      *                 MD022368           Date 12Aug13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 261128             Date 27Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 258110             Date 22Jan09               *
      *                 CLE073             Date 13May08               *
      *                 262843             Date 20Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244314             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240968             Date 10Jul06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG7528            Date 07Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3760            Date 30Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 223947             Date 19Apr04               *
      *                 BUG1644            Date 05Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 20Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  MD026969A - Further modifications.                           *
      *           - Applied for MD054354                              *
      *  MD026969 - New Processing for Fee Settlement.                *
      *           - Applied for MD054354                              *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD027384 - recompile due to change in SDEXSTPD               *
      *  MD022368 - System accepted a settlement against zero past due*
      *             amount. Prevent input of fee settlement if FEAMTP *
      *             is equal to zero.                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  261128 - Full settlement for loan fee was posted over        *
      *           suspense account. Populate S#CNUM to avoid error on *
      *           ZASETINVAL.                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  258110 - Java returns '000' so loan processing not done.     *
      *  CLE073 - Calculated loan based fees                          *
      *  262843 - Apply CORE fix 258669.                              *
      *  258669 - Default fee events settlement instruction first from*
      *           Fees Master if found, otherwise retrieve from       *
      *           Extended Settlement file.                           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if transaction has status 'R'                  *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  BUG7528- Fee Amount Due / Past Due should be adjusted by the *
      *           amounts of any existing settlements on LEFEEAD.     *
      *           (Taken from M4IXXSRC/LERPGSRC LE2220.)              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3760- Compliance Watch (CSD015) changes missing from the  *
      *           Lending APIs.                                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  223947 - 3rd reopen of Bug678:  Corrections & omissions.     *
      *  BUG1644- Authorising a fee settlement which has been         *
      *           entered against a fee with past due = 0 should      *
      *           give a warning not an error (LEFESTRTV)             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *         - Use 24x7 runday, and user from ZMUSER               *
      *  CLE031 - Lending Enhancements.                               *
      *         - LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FC_)
 
     FLEFEEAL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:LEFEEAD0)
     F                                     PREFIX(FA_)
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FE_)
                                                                                             BUG3760
      ** Compliance Watch Hit List File                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3760
                                                                                              258669
      ** Midas SD Extended Settlement                                                         258669
     FSDEXSTL1  IF   E           K DISK                                                       258669
 
     FCLOAN     IF   E           K DISK    INCLUDE(CLOANCLF)                                  CLE073
     FLEFZASL2  IF   E           K DISK    INFSR(*PSSR)                                     MD026969
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
     D PDFeeSttmt      C                   Const('ZeroPDFeeSettlements')                    MD054354
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Fee Settlement Details in file format
     D LEFEEADFmt    E DS                  EXTNAME(LEFEEAD)
     D                                     PREFIX(FA_)
      * Pay settlement instructions in file format                                            258669
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)                                  258669
                                                                                              258669
      * Receive settlement instructions in file format                                        258669
     D ##RECF        E DS                  EXTNAME(SDESFRPD)                                  258669
                                                                                              258669
      * Pay settlement instructions in screen format                                          258669
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)                                  258669
                                                                                              258669
      * Receive settlement instructions in screen format                                      258669
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)                                  258669
 
      * Fee amounts data structure
     D  @FEAMA         DS
     D  FE_FEAMT1              1     11  0
     D  FE_FEAMT2             12     22  0
     D  FE_FEAMT3             23     33  0
     D  FE_FEAMT4             34     44  0
     D  FE_FEAMT5             45     55  0
     D  FEAM                   1     55  0
     D                                     DIM(5) ASCEND
 
      * Fee rates data structure
     D  @FRTA          DS
     D  FE_FEFRT1              1      7  5
     D  FE_FEFRT2              8     14  5
     D  FE_FEFRT3             15     21  5
     D  FE_FEFRT4             22     28  5
     D  FE_FEFRT5             29     35  5
     D  FRT                    1     35  5
     D                                     DIM(5) ASCEND
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Customer lending Details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  SDBRCHDFAC   E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Fee codes Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** RUNDAT DATA AREA
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** User information                                                                     CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
                                                                                              CAP084
      ** Midas Functions for Watch List Checking Details File                                BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
                                                                                             BUG3760
      ** Watch List Tranaction Details File                                                  BUG3760
     D CWLCDS        E DS                  EXTNAME(SDWLTOPD)                                 BUG3760
                                                                                             BUG3760
      ** External DS for Compliance Watch Configuration Data File                            BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                             BUG3760
      ** 24X7 status dataarea                                                                 CAP084
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CAP084
                                                                                              CAP084
      ** SD data area                                                                         CAP084
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CAP084
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CAP084
     D CSC011          S              1A   INZ('N')                                           CAP084
     D WProcDate       S                   LIKE(BJRDNB)                                       CAP084
     D PRTCD           S              7A                                                      CAP084
     D POPTN           S              7A                                                      CAP084
     D PSARD           S              6A                                                      CAP084
 
      ** Switchable features - Watch List Checking                                           BUG3760
     D CSD015          S              1A                                                     BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D W2LOAN          S              6                                                      BUG3760
     D W2CNUM          S              6                                                      BUG3760
     D W2FACL          S              5                                                      BUG3760
     D W2FSEQ          S              2                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
                                                                                             BUG3760
     D CAP086          S              1A                                                      CAP086
                                                                                              CAP086
     D PSysVal01       S             20A                                                      240968
     D PCurSet01       S            200A                                                      240968
     D PSysVal02       S             20A                                                      240968
     D PCurSet02       S            200A                                                      240968
     D PSysVal03       S             20A                                                      240968
     D PCurSet03       S            200A                                                      240968
     D PSysVal04       S             20A                                                      240968
     D PCurSet04       S            200A                                                      240968
     D PSysVal05       S             20A                                                      240968
     D PCurSet05       S            200A                                                      240968
     D PSysVal06       S             20A                                                      240968
     D PCurSet06       S            200A                                                      240968
     D PSysVal07       S             20A                                                      240968
     D PCurSet07       S            200A                                                      240968
     D PSysVal08       S             20A                                                      240968
     D PCurSet08       S            200A                                                      240968
     D PSysVal09       S             20A                                                      240968
     D PCurSet09       S            200A                                                      240968
     D PSysVal10       S             20A                                                      240968
     D PCurSet10       S            200A                                                      240968
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * If the user is connected via a browser, the job user name is QUSER -                 BUG7029
      * the actual user name is stored in ZMUSER                                             BUG7029
     C                   IN        ZMUSER                                                    BUG7029
                                                                                             BUG7029
      * CLEAR OUTPUTS
 
     C                   CLEAR                   LEFEEADFmt
     C                   MOVE      'Y'           S#ACTNok
     C                   MOVE      'Y'           S#CSSNok
     C                   MOVE      'Y'           S#FACTok
     C                   MOVE      'Y'           S#FCNOok
     C                   MOVE      'Y'           S#FSEQok
     C                   MOVE      'Y'           S#VDATok
     C                   MOVE      'Y'           S#LOANok                                     CLE073
     C                   MOVE      *BLANK        S#CNUM
     C***********        MOVE      *BLANK        S#FCCY                                       223947
     C                   Z-ADD     *ZERO         FecyNBDP
     C                   MOVE      *BLANK        S#FTYP
     C                   MOVE      *BLANK        S#FCOD
     C                   MOVE      *BLANK        S#FENV
     C                   MOVE      *BLANK        S#DUPD
     C                   Z-ADD     *ZERO         W#VDAT
     C                   Z-ADD     *ZERO         W#SADD
     C                   MOVE      *BLANK        W#PTFI
     C                   Z-ADD     *ZERO         W#CPAM
 
     C                   Z-ADD     *ZERO         W#FAMT
     C                   MOVEL     *BLANK        FcbrORBR          3                          CLE073
     C                   MOVEL     *BLANK        FcbrBranch
     C                   MOVEL     *BLANK        FcbrBICN
     C                   MOVEL     *BLANK        FcbrMQSM
     C**********         Z-ADD     *ZERO         FcbrSYCU                                     CSD027
     C                   EVAL      FcbrSYCU = *BLANKS                                         CSD027
     C                   MOVEL     *BLANK        FccyFCCY
     C                   Z-ADD     *ZERO         FccyNBDP
 
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIdArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
                                                                                              CAP086
      ** If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                                  CAP086
      ** Do Authorisation are required                                                        CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             P#MODE = *BLANKS                                           CAP086
     C                   EVAL      FA_AUTH = *BLANKS                                          CAP086
     C                   ENDIF                                                                CAP086
 
      **  Valid action code
 
     C                   EXSR      VALACTN
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      ** Validate customer, facility type and facility number
 
     C                   IF        CLE073 = 'N' Or                                            CLE073
     C                             CLE073 = 'Y' And                                           CLE073
     C                             S#LOAN = *Blanks                                           CLE073
     C                   EXSR      VLCFTFN
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#CSSNok      IFEQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C                   RETURN
     C                   END
 
      ** Check facility exists
 
     C                   EXSR      CHKFCLTY
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#CSSNok      IFEQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C                   RETURN
     C                   END
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
      ** Validate loan of fee                                                                 CLE073
                                                                                              CLE073
     C                   IF        CLE073 = 'Y' AND                                           CLE073
     C                             S#FACT = *BLANKS                                           CLE073
     C                   EXSR      CHKLOAN                                                    CLE073
                                                                                              CLE073
     C     S#LOANok      IFEQ      'N'                                                        CLE073
     C     S#CSSNok      OREQ      'N'                                                        261128
     C                   RETURN                                                               CLE073
     C                   END                                                                  CLE073
                                                                                              CLE073
     C                   EndIf                                                                CLE073
 
      * Validate Fee Sequence Number
 
     C                   EXSR      VLDFSEQ
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#FSEQok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      * Validate value date
 
     C                   EXSR      VLDVDAT
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#VDATok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      ** Check fee details exist
 
     C                   EXSR      CHKFEEDT
 
      ** Check fee settlement
 
     C                   EXSR      CHKFEES
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#CSSNok      IFEQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C     S#FSEQok      OREQ      'N'
     C     S#VDATok      OREQ      'N'
     C     S#LOANok      OREQ      'N'                                                        CLE073
     C                   RETURN
     C                   END
 
      ** If not insert, valididate the action
 
     C     S#ACTN        IFNE      'I'
     C                   EXSR      VLDACT
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C                   RETURN
     C                   END
      *
      **  Validate Authority (if not batch download)
      *
     C     P#MODE        IFNE      'B'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      VLDAUT
     C                   ENDIF
 
     C                   RETURN
 
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Valididate the action code
      ***********************************************************
     C     VALACTN       BEGSR
 
     C     P#MODE        IFEQ      'B'
 
     C     S#ACTN        IFNE      'A'
     C     S#ACTN        ANDNE     'X'
     C     S#ACTN        ANDNE     'D'
     C     S#ACTN        ANDNE     'I'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
     C     S#ACTN        IFNE      'E'
     C     S#ACTN        ANDNE     'A'
     C     S#ACTN        ANDNE     'X'
     C     S#ACTN        ANDNE     'D'
     C     S#ACTN        ANDNE     'I'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Validate customer, facility type and facility number
      ***********************************************************
     C     VLCFTFN       BEGSR
 
      ** Customer number must be defined
 
     C     S#CSSN        IFEQ      *BLANKS
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0214'     MsgIdArr(Ix)
 
     C                   ELSE
 
      ** Customer number must refer to a valid customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      S#CSSN        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0214'     MsgIdArr(Ix)
     C                   ELSE
 
     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   MOVEL     BBCUST        S#CNUM
     C                   ENDIF
 
     C                   ENDIF
 
      ** Facility type and facility number must be defined
 
     C     S#FACT        IFEQ      *BLANKS
     C     S#FCNO        OREQ      *BLANKS
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FACT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0215'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#FACT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           S#FACTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FACT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0004'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        S#FACT
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#FCNO        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FCNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0005'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        S#FCNO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************                             CLE073
      ** Check loan exists                                                                    CLE073
      ***********************************************************                             CLE073
     C     CHKLOAN       BEGSR                                                                CLE073
                                                                                              CLE073
      ** Loan must exist on loans file                                                        CLE073
                                                                                              CLE073
     C                   If        S#LOAN <> *BLANKS                                          CLE073
     C                   MOVEL     S#LOAN        K#LOAN                                       CLE073
     C                   MOVEL     'A'           K#RCDT                                       CLE073
                                                                                              CLE073
     C     LOANKK        CHAIN     CLOAN                              80                      CLE073
      *                                                                                       CLE073
     C     *IN80         IFEQ      *OFF                                                       CLE073
                                                                                              CLE073
     C                   CALL      'AOBRCHR1'                                                 CLE073
     C                   PARM      '       '     @RTCD                                        CLE073
     C                   PARM      '*KEY   '     @OPTN                                        CLE073
     C                   PARM      BRCA          @BRCA             3                          CLE073
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CLE073
      *                                                                                       CLE073
     C     @RTCD         IFNE      *BLANK                                                     CLE073
     C                   MOVEL     'SDBRCHPD'    DBFILE                                       CLE073
     C                   MOVEL     '906'         DBASE                                        CLE073
     C                   MOVEL     BRCA          DBKEY                                        CLE073
     C                   EXSR      *PSSR                                                      CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
     C                   CALL      'AOCURRR0'                                                 CLE073
     C                   PARM      '       '     @RTCD                                        CLE073
     C                   PARM      '*KEY   '     @OPTN                                        CLE073
     C                   PARM      CCY           @CCY              3                          CLE073
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE073
      *                                                                                       CLE073
     C     @RTCD         IFNE      *BLANK                                                     CLE073
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CLE073
     C                   MOVEL     '907'         DBASE                                        CLE073
     C                   MOVEL     CCY           DBKEY                                        CLE073
     C                   EXSR      *PSSR                                                      CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
     C                   MOVEL     ORBR          FcbrOrbr                                     CLE073
     C                   MOVEL     BRCA          FcbrBranch                                   CLE073
     C                   MOVEL     A8BICN        FcbrBICN                                     CLE073
     C                   MOVEL     A8MQSM        FcbrMQSM                                     CLE073
     C                   EVAL      FcbrSYCU = A8SYCU                                          CLE073
     C                   MOVEL     CCY           FccyFCCY                                     CLE073
     C                   MOVEL     A6NBDP        FccyNBDP                                     CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C     *IN80         IFEQ      *ON                                                        CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ADD       1             Ix                                           CLE073
     C                   MOVEL     'S#LOAN    '  FldNameArr(Ix)                               CLE073
     C                   MOVEL     'XLE0001'     MsgIdArr(Ix)                                 CLE073
                                                                                              CLE073
     C                   ELSE                                                                 CLE073
                                                                                              CLE073
     C     S#FACT        IFNE      *BLANKS                                                    CLE073
     C     S#FCNO        ORNE      *BLANKS                                                    CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ADD       1             Ix                                           CLE073
     C                   MOVEL     'S#LOAN    '  FldNameArr(Ix)                               CLE073
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)                                 CLE073
     C                   EndIf                                                                CLE073
     C                   EndIf                                                                CLE073
     C                   EndIf                                                                CLE073
                                                                                              CLE073
     C     S#FACT        IFEQ      *BLANKS                                                    CLE073
     C     S#FCNO        ANDEQ     *BLANKS                                                    CLE073
     C     S#LOAN        ANDEQ     *BLANKS                                                    CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ADD       1             Ix                                           CLE073
     C                   MOVEL     'S#LOAN    '  FldNameArr(Ix)                               CLE073
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)                                 CLE073
     C                   EndIf                                                                CLE073
      *                                                                                       261128
      ** Customer number must refer to a valid customer                                       261128
      *                                                                                       261128
     C                   CALLB     'AOCUSTR0'                                                 261128
     C                   PARM      *BLANKS       @RTCD             7                          261128
     C                   PARM      '*KEY    '    @OPTN             7                          261128
     C                   PARM      S#CSSN        @KEY1            10                          261128
     C                   PARM                    @KYST             7                          261128
     C     SDCUST        PARM      SDCUST        DSSDY                                        261128
      *                                                                                       261128
     C     @RTCD         IFNE      *BLANK                                                     261128
     C                   MOVE      'N'           S#CSSNok                                     261128
     C                   ADD       1             Ix                                           261128
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)                               261128
     C                   MOVEL     'LEF0214'     MsgIdArr(Ix)                                 261128
     C                   ELSE                                                                 261128
      *                                                                                       261128
     C                   MOVEL     *BLANK        S#CSSN                                       261128
     C                   MOVEL     BBCUST        S#CSSN                                       261128
     C                   MOVEL     BBCUST        S#CNUM                                       261128
     C                   ENDIF                                                                261128
      *                                                                                       261128
     C                   ENDSR                                                                CLE073
      ***********************************************************                             CLE073
      /SPACE 5                                                                                CLE073
      ***********************************************************
      **  Check facility exists                                 *
      ***********************************************************
     C     CHKFCLTY      BEGSR
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
     C                   MOVEL     'A'           K#RCDT
 
     C     FCLTYK        CHAIN     FCLTYFMF                           80
      *
     C     *IN80         IFEQ      *OFF
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FC_BRCA       @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     FC_BRCA       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FC_FCCY       @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     FC_FCCY       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     FC_FAMT       W#FAMT
     C                   MOVEL     FC_ORBR       FcbrOrbr                                     CLE073
     C                   MOVEL     FC_BRCA       FcbrBranch
     C                   MOVEL     A8BICN        FcbrBICN
     C                   MOVEL     A8MQSM        FcbrMQSM
     C**********         Z-ADD     A8SYCU        FcbrSYCU                                     CSD027
     C                   EVAL      FcbrSYCU = A8SYCU                                          CSD027
     C                   MOVEL     FC_FCCY       FccyFCCY
     C                   MOVEL     A6NBDP        FccyNBDP
 
     C                   ELSE
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0006'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      *****************************************************************
      * Validate Fee Sequence Number                                  *
      *****************************************************************
     C     VLDFSEQ       BEGSR
 
     C     S#FSEQ        IFEQ      *BLANKS
     C                   MOVE      'N'           S#FSEQok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FSEQ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0014'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#FSEQ        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           S#FSEQok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FSEQ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0014'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        S#FSEQ
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Value Date                                           *
      *****************************************************************
     C     VLDVDAT       BEGSR
 
      ** If the value date is not defined, default it to the run date
     C     S#VDAT        IFEQ      *BLANKS
 
     C*******            MOVE      BJRDNB        ZDAYNO                                       CAP084
     C                   MOVE      WProcDate     ZDAYNO                                       CAP084
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#VDAT
      *
     C                   ENDIF
 
      ** The date must be valid
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#VDAT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
      *
     C                   MOVE      'N'           S#VDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#VDAT      'FldNameArr(Ix)
     C                   MOVEL     'LER0159'     MsgIdArr(Ix)
 
     C                   ELSE
     C                   Z-ADD     ZDAYNO        W#VDAT
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check fee details exist                                       *
      *****************************************************************
     C     CHKFEEDT      BEGSR
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACL
     C                   MOVE      S#FCNO        K#FACL
     C                   IF        CLE073 = 'N' OR                                            CLE073
     C                             CLE073 = 'Y' AND                                           CLE073
     C                             S#LOAN = *BLANKS                                           CLE073
     C**********         Z-ADD     *ZEROS        K#LOAN                                       CLE148
     C                   MOVEL     *BLANKS       K#LOAN                                       CLE148
     C                   ELSE                                                                 CLE073
     C                   MOVEL     S#LOAN        K#LOAN                                       CLE073
     C                   ENDIF                                                                CLE073
     C                   MOVE      S#FSEQ        K#FSEQ
 
     C     FEEAK         CHAIN     LEFEEDL1                           80
 
     C     *IN80         IFEQ      *ON
     C     FE_FERECI     ORNE      'D'
 
     C                   MOVE      'N'           S#FSEQok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FSEQ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0073'     MsgIdArr(Ix)
 
     C                   ELSE
 
      ** If calculated loan fees, and fee for a loan not of reserved fee calc type, error     CLE073
      ** Note that loan fees of reserved fee calc type may be amended or settled even if      CLE073
      ** fee is fixed amount (type 99)                                                        CLE073
                                                                                              CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     *IN80         ANDEQ     '0'                                                        CLE073
     C*****K#LOAN        ANDNE     0                                                   CLE073 CLE148
     C     K#LOAN        ANDNE     *BLANKS                                                    CLE148
     C     FE_FECALT     ANDNE     '97'                                                       CLE073
     C     FE_FECALT     ANDNE     '98'                                                       CLE073
     C     FE_FECALT     ANDNE     '99'                                                       CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ADD       1             Ix                                           CLE073
     C                   MOVEL     'S#LOAN    '  FldNameArr(Ix)                               CLE073
     C                   MOVEL     'XLE0002'     MsgIdArr(Ix)                                 CLE073
     C                   ELSE                                                                 CLE073
      * Settlements cannot be done for fixed fees
      * or for non-calculated types
 
     C     FE_FEFAMT     IFNE      *ZEROS
     C     CLE073        ANDEQ     'N'                                                        CLE073
     C     FE_FEFAMT     ORNE      *ZEROS                                                     CLE073
     C     CLE073        ANDEQ     'Y'                                                        CLE073
     C     FE_FECALT     ANDNE     '97'                                                       CLE073
     C     FE_FECALT     ANDNE     '98'                                                       CLE073
     C     FE_FECALT     ANDNE     '99'                                                       CLE073
     C                   MOVE      'N'           S#FSEQok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FSEQ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0068'     MsgIdArr(Ix)
     C                   ENDIF
     C     FE_FECALT     IFEQ      *BLANKS
     C                   MOVE      'N'           S#FSEQok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FSEQ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0069'     MsgIdArr(Ix)
     C                   ENDIF
 
      * Fee currency
     C                   MOVEL     FE_FEFCCY     S#FCCY
 
      * Fee currency decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FE_FEFCCY     @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     FE_FEFCCY     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        FecyNBDP
 
      * Settlement adjustment due date
 
     C     FE_FEDIND     IFNE      *BLANK
     C                   Z-ADD     FE_FEDDAT     W#SADD
     C                   ELSE
     C                   SELECT
     C     FE_FEPYON     WHENEQ    'E'
     C                   Z-ADD     FE_FEPEND     W#SADD
     C     FE_FEPYON     WHENEQ    'N'
     C                   Z-ADD     FE_FENPYD     W#SADD
     C                   ENDSL
     C                   ENDIF
      *                                                                                     MD026969
     C     FE_FEAMTP     IFEQ      0                                                        MD026969
     C     FE_FELOAN     ANDEQ     *BLANK                                                   MD054354
     C     FE_FEPYON     ANDEQ     'N'                                                      MD026969
     C     PDFeeSet      ANDEQ     'Y'                                                      MD054354
     C                   Z-ADD     FE_FELPDT     W#SADD                                     MD026969
     C                   ENDIF                                                              MD026969
 
      * Participant Fee Indicator and fee type
 
     C                   MOVEL     FE_PTFI       W#PTFI
     C                   SELECT
     C     W#PTFI        WHENEQ    *BLANK
     C                   MOVEL     'LER0205'     ZAMSID
     C     W#PTFI        WHENEQ    'P'
     C     W#PTFI        OREQ      'S'                                                        CLE106
     C     W#PTFI        OREQ      'R'                                                        CLE106
     C                   MOVEL     'LER0206'     ZAMSID
     C     W#PTFI        WHENEQ    'I'
     C                   MOVEL     'LER0207'     ZAMSID
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#FTYP
 
      * Fee narrative
 
     C                   MOVEL     FE_FEFCOD     @FCOD
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @FCOD             2
     C     SDFEE         PARM      SDFEE         DSFDY
     C                   MOVE      AUFECD        S#FCOD
     C                   MOVE      AUFENV        S#FENV
 
      * Value date of fee settlement must be earlier than or equal
      * to rundate and later than fee period start date
 
     C     S#ACTN        IFEQ      'I'
     C*****W#VDAT        IFGT      BJRDNB                                                     CAP084
     C     W#VDAT        IFGT      WProcDate                                                  CAP084
     C     W#VDAT        ORLE      FE_FEPSTD
     C                   MOVE      'N'           S#VDATok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VDAT    '  FldNameArr(Ix)
     C                   MOVEL     'LER0160'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      * Calculate fee amount due/past due
 
     C     S#FSEQok      IFEQ      'Y'
     C*******************Z-ADD     FE_FEAMTP     ZFLD15                                      BUG7528
     C*******************Z-ADD     FecyNBDP      ZDECS                                       BUG7528
     C*******************EXSR      ZSEDIT                                                    BUG7528
     C*******************MOVE      ZOUT21        S#DUPD                                      BUG7528
      *                                                                                      BUG7528
      * Save values of Fee adjustment being actioned.                                        BUG7528
     C                   MOVE      FA_FATYPE     W#TYPE            1                         BUG7528
     C                   Z-ADD     FA_FASADJ     W#FSET           15 0                       BUG7528
      *                                                                                      BUG7528
      *  Check if there is a full settlement against this fee:                               BUG7528
     C                   Z-ADD     0             WFULL             2 0                       BUG7528
     C     WKFEE         SETLL     LEFEEAL2                                                  BUG7528
     C     *IN71         DOUEQ     '1'                                                       BUG7528
     C     WKFEE         READE (N) LEFEEAL2                               71                 BUG7528
      *                                                                                      BUG7528
     C     *IN71         IFEQ      '1'                                                       BUG7528
     C                   ITER                                                                BUG7528
     C                   ENDIF                                                               BUG7528
      *                                                                                      BUG7528
     C     FA_FATYPE     IFEQ      'F'                                                       BUG7528
     C                   ADD       1             WFULL                                       BUG7528
     C                   ENDIF                                                               BUG7528
      *                                                                                      BUG7528
     C                   ENDDO                                                               BUG7528
      *                                                                                      BUG7528
      * If settlements already exist for this fee, the value of FEAMTP                       BUG7528
      * should be adjusted before displaying on the screen.                                  BUG7528
     C                   Z-ADD     FE_FEAMTP     W#FEAM           15 0                       BUG7528
     C     WKFEE         SETLL     LEFEEAL2                                                  BUG7528
     C     *IN71         DOUEQ     '1'                                                       BUG7528
     C     WKFEE         READE (N) LEFEEAL2                               71                 BUG7528
      *                                                                                      BUG7528
     C     *IN71         IFEQ      '1'                                                       BUG7528
     C                   ITER                                                                BUG7528
     C                   ENDIF                                                               BUG7528
      *                                                                                      BUG7528
     C                   SUB       FA_FASADJ     W#FEAM                                      BUG7528
      *                                                                                      BUG7528
      **  Subtract all amounts when action is 'I' for insert, but                            BUG7528
      ** for other actions, add back in the settlement being acioned.                        BUG7528
      *                                                                                      BUG7528
     C     S#ACTN        IFEQ      'E'                                                       BUG7528
     C     S#ACTN        OREQ      'A'                                                       BUG7528
     C     S#ACTN        OREQ      'X'                                                       BUG7528
     C     S#ACTN        OREQ      'D'                                                       BUG7528
     C     W#VDAT        IFEQ      FA_FAVDAT                                                 BUG7528
     C     WFULL         IFEQ      0                                                         BUG7528
      * If a full payment has been made to the fee, this will reduce                         BUG7528
      * the outstanding amount to zero, although previously input                            BUG7528
      * settlements will still be actioned first.                                            BUG7528
     C     WFULL         ORGE      1                                                         BUG7528
     C     FA_FATYPE     ANDEQ     'F'                                                       BUG7528
     C                   ADD       FA_FASADJ     W#FEAM                                      BUG7528
     C                   ELSE                                                                BUG7528
      **  Else, there's a full settlement but it's not being actioned.                       BUG7528
     C                   Z-ADD     FA_FASADJ     W#FEAM                                      BUG7528
     C                   LEAVE                                                               BUG7528
     C                   ENDIF                                                               BUG7528
     C                   ENDIF                                                               BUG7528
     C                   ENDIF                                                               BUG7528
     C                   ENDDO                                                               BUG7528
      **  Restore values of Fee adjustment being actioned.                                   BUG7528
     C                   MOVE      W#TYPE        FA_FATYPE                                   BUG7528
     C                   Z-ADD     W#FSET        FA_FASADJ                                   BUG7528
      *                                                                                      BUG7528
      **  Output Fee Amount Past Due to screen field:                                        BUG7528
     C                   Z-ADD     W#FEAM        ZFLD15                                      BUG7528
     C                   Z-ADD     FecyNBDP      ZDECS                                       BUG7528
     C                   EXSR      ZSEDIT                                                    BUG7528
     C                   MOVE      ZOUT21        S#DUPD                                      BUG7528
      *                                                                                      BUG7528
     C                   ENDIF
 
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
      ** If ANY of the Settlements fields have been entered, bypass                           258669
      ** retrieval from Fees Master.                                                          258669
      *                                                                                       258669
     C                   IF            (InRecSttmt = *blank)                                  258669
     C                             AND (InPaySttmt = *blank)                                  258669
     C                             AND (S#ACTN = 'I')                                         258669
      *                                                                                       258669
      ** Default Receive Instructions.                                                        258669
      *                                                                                       258669
     C                   EXSR      DEFREC                                                     258669
      *                                                                                       258669
      ** Default Payment Instruction.                                                         258669
      *                                                                                       258669
     C                   EXSR      DEFPAY                                                     258669
      *                                                                                       258669
     C                   ENDIF                                                                258669
      *                                                                                       258669
     C                   ENDIF
 
     C                   ENDSR
     C*****************************************************************                       258669
      /EJECT                                                                                  258669
      *****************************************************************                       258669
      *                                                               *                       258669
      * DEFREC - DEFAULT RECEIVE INSTRUCTIONS                         *                       258669
      *                                                               *                       258669
      *****************************************************************                       258669
     C     DEFREC        BEGSR                                                                258669
      *                                                                                       258669
      ** Initialize Payment Instructions.                                                     258669
      *                                                                                       258669
     C                   CLEAR                   ##RECF                                       258669
      *                                                                                       258669
      ** Default Receive Instructions from Fees Master.                                       258669
      *                                                                                       258669
     C                   MOVEL     FE_RSTM       FLRSTM                                       258669
     C                   MOVEL     FE_RONS       FLRONS                                       258669
      *                                                                                       258669
     C                   MOVEL     FE_RIBN       FLRIBN                                       258669
     C                   MOVEL     FE_RIBA       FLRIBA                                       258669
     C                   MOVEL     FE_ROBN       FLROBN                                       258669
     C                   MOVEL     FE_ROCN       FLROCN                                       258669
      *                                                                                       258669
     C                   MOVEL     FE_OSDB       FLROBR                                       258669
      *                                                                                       258669
      ** If the currency of the instruction is not the receive currency                       258669
      ** set the receive settlement currenct to that currency.                                258669
      *                                                                                       258669
     C     FE_FEFCCY     IFNE      S#FCCY                                                     258669
     C     S#FCCY        ANDNE     *BLANK                                                     258669
     C                   MOVEL     FE_FEFCCY     FLRSCY                                       258669
     C                   ELSE                                                                 258669
     C                   MOVEL     *BLANK        FLRSCY                                       258669
     C                   ENDIF                                                                258669
     C                   Z-ADD     *ZEROS        FLREXR                                       258669
     C                   MOVEL     *BLANKS       FLREXI                                       258669
      *                                                                                       258669
     C                   ENDSR                                                                258669
     C*****************************************************************                       258669
      /EJECT                                                                                  258669
      *****************************************************************                       258669
      *                                                               *                       258669
      * DEFPAY - DEFAULT PAYMENT INSTRUCTIONS                         *                       258669
      *                                                               *                       258669
      *****************************************************************                       258669
     C     DEFPAY        BEGSR                                                                258669
      *                                                                                       258669
      ** Initialize Payment Instructions.                                                     258669
      *                                                                                       258669
     C                   CLEAR                   ##PAYF                                       258669
      *                                                                                       258669
      ** Default Payment Instructions from Fees Master.                                       258669
      *                                                                                       258669
     C                   MOVEL     FE_PSTM       FLPSTM                                       258669
     C                   MOVEL     FE_PONS       FLPONS                                       258669
     C                   MOVEL     FE_PIBN       FLPIBN                                       258669
     C                   MOVEL     FE_PIBA       FLPIBA                                       258669
     C                   MOVEL     FE_POBN       FLPOBN                                       258669
     C                   MOVEL     FE_POCN       FLPOCN                                       258669
     C                   MOVEL     FE_RCRN       FLRCRN                                       258669
     C                   MOVEL     FE_RCRA       FLRCRA                                       258669
     C                   MOVEL     FE_RVNO       FLRVNO                                       258669
     C                   MOVEL     FE_AWBN       FLAWBN                                       258669
     C                   MOVEL     FE_AWBA       FLAWBA                                       258669
     C                   MOVEL     FE_BENN       FLBENN                                       258669
     C                   MOVEL     FE_BENA       FLBENA                                       258669
     C                   MOVEL     FE_DTP1       FLDTP1                                       258669
     C                   MOVEL     FE_DTP2       FLDTP2                                       258669
     C                   MOVEL     FE_DTP3       FLDTP3                                       258669
     C                   MOVEL     FE_DTP4       FLDTP4                                       258669
     C                   MOVEL     FE_DCHG       FLDCHG                                       258669
     C                   MOVEL     FE_BTB1       FLBTB1                                       258669
     C                   MOVEL     FE_BTB2       FLBTB2                                       258669
     C                   MOVEL     FE_BTB3       FLBTB3                                       258669
     C                   MOVEL     FE_BTB4       FLBTB4                                       258669
     C                   MOVEL     FE_BTB5       FLBTB5                                       258669
     C                   MOVEL     FE_BTB6       FLBTB6                                       258669
     C                   MOVEL     FE_CVMR       FLCVMR                                       258669
      *                                                                                       258669
     C                   MOVEL     FE_OMDB       FLPOBR                                       258669
      *                                                                                       258669
      ** If the currency of the instructions is not the payment                               258669
      ** currency set the payment settlement currenct to that currency.                       258669
      *                                                                                       258669
     C     FE_FEFCCY     IFNE      S#FCCY                                                     258669
     C                   MOVEL     FE_FEFCCY     FLPSCY                                       258669
      *                                                                                       258669
      ** Check value of BYIERI (Include ERI in field 72) to populate                          258669
      ** FLIC72 field.                                                                        258669
      *                                                                                       258669
     C                   MOVEL     FE_FEFCCY     BYCYCD                                       258669
     C                   MOVEL     FE_FECNUM     BYCUST                                       258669
     C                   MOVEL     'LE'          KTRTY                                        258669
     C     EXSTK         CHAIN     SDEXSTL1                           80                      258669
      *                                                                                       258669
      ** If none, get instructions for deal type = 'ALL TYPES' (AT).                          258669
      *                                                                                       258669
     C     *IN80         IFEQ      *ON                                                        258669
     C                   MOVEL     'AT'          KTRTY                                        258669
     C     EXSTK         CHAIN     SDEXSTL1                           80                      258669
     C     *IN80         IFEQ      *ON                                                        258669
     C                   MOVE      *BLANKS       ##IERI            1                          258669
     C                   ELSE                                                                 258669
     C                   MOVEL     BYIERI        ##IERI                                       258669
     C                   ENDIF                                                                258669
      *                                                                                       258669
     C                   ELSE                                                                 258669
     C                   MOVEL     BYIERI        ##IERI                                       258669
     C                   ENDIF                                                                258669
      *                                                                                       258669
     C     ##IERI        IFEQ      'Y'                                                        258669
     C                   MOVEL     S#FCCY        FLIC72                                       258669
     C                   ENDIF                                                                258669
     C                   ENDIF                                                                258669
     C                   Z-ADD     *ZEROS        FLPEXR                                       258669
     C                   MOVEL     *BLANKS       FLPEXI                                       258669
      *                                                                                       258669
     C                   ENDSR                                                                258669
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check fee settlement                                          *
      *****************************************************************
     C     CHKFEES       BEGSR
 
      **Read*all*authorised*settlements*for*the*fee**************                             223947
      * Read all settlements for the fee                                                      223947
 
     C                   Z-ADD     FE_FEAMTP     W#CPAM
     C     PDFeeSet      IFEQ      'Y'                                                      MD054354
      *                                                                                     MD026969
      ** If W#CPAM is zero check new file if                                                MD026969
      ** settlement will be allowed                                                         MD026969
      *                                                                                     MD026969
     C*****WKFZAS        CHAIN(E)  LEFZASL2                           80          MD026969 MD026969A
     C     WKFZAS        CHAIN(N)  LEFZASL2                           81                   MD026969A
     C                   ENDIF                                                              MD054354
      *                                                                                     MD022368
      ** Do not allow insert of fee settlement if past due is zero.                         MD022368
      *                                                                                     MD022368
     C     S#ACTN        IFEQ      'I'                                                      MD022368
     C     W#CPAM        ANDEQ     0                                                        MD022368
     C******IN80         ANDEQ     '1'                                            MD026969 MD026969A
     C     *IN81         ANDEQ     '1'                                                     MD026969A
     C                   MOVE      'N'           S#CSSNok                                   MD022368
     C                   MOVE      'N'           S#FACTok                                   MD022368
     C                   MOVE      'N'           S#FCNOok                                   MD022368
     C                   MOVE      'N'           S#FSEQok                                   MD022368
     C                   MOVE      'N'           S#VDATok                                   MD022368
     C                   ADD       1             Ix                                         MD022368
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)                             MD022368
     C                   MOVEL     'LER0179'     MsgIdArr(Ix)                               MD022368
     C                   LEAVESR                                                            MD022368
     C                   ENDIF                                                              MD022368
 
     C     FEEAK         SETLL     LEFEEAL2
     C     *IN80         DOUEQ     *ON
     C     FEEAK         READE     LEFEEAL2                               80
      *
     C     *IN80         IFEQ      *ON
     C*****FA_SSTS       ORNE      'A'                                                        223947
     C                   ITER
     C                   ENDIF
 
      **If*an*authorised*full*payment*has*been*made*to*the*fee,******                         223947
      * If a full payment has been made against the fee,                                      223947
      * no more fee settlement can be input
 
     C     FA_FATYPE     IFEQ      'F'
     C     S#ACTN        IFEQ      'I'
     C*****S#ACTN******* OREQ      'X'                                                        223947
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#FSEQok
     C                   IF        CLE073 = 'Y' And                                           CLE073
     C                             S#LOAN <> *Blanks                                          CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ENDIF                                                                CLE073
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0178'     MsgIdArr(Ix)
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
      * Accumulate the current total amount past due
 
     C                   SUB       FA_FASADJ     W#CPAM
 
     C                   ENDDO
 
      * If insert, the record mustn't exist
      * If not insert, the record must exist
 
     C                   Z-ADD     W#VDAT        K#VDAT
 
     C     FEESK         CHAIN     LEFEEAL2                           80
      *
     C     S#ACTN        IFEQ      'I'
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#FSEQok
     C                   MOVE      'N'           S#VDATok
     C                   IF        CLE073 = 'Y' And                                           CLE073
     C                             S#LOAN <> *Blanks                                          CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ENDIF                                                                CLE073
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0187'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     *IN80         IFEQ      *ON
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#FSEQok
     C                   MOVE      'N'           S#VDATok
     C                   IF        CLE073 = 'Y' And                                           CLE073
     C                             S#LOAN <> *Blanks                                          CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ENDIF                                                                CLE073
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0188'     MsgIdArr(Ix)
     C                   ELSE
     C*****FA_SSTS**     IFEQ      'A'                                                        223947
     C                   ADD       FA_FASADJ     W#CPAM
     C**************     ENDIF                                                                223947
     C*****S#ACTN***     IFEQ      'X'                                                        223947
     C**************     SUB       FA_FASADJ     W#CPAM                                       223947
     C**************     ENDIF                                                                223947
     C                   ENDIF
 
     C                   ENDIF
 
      ** For full settlement, issue a warning message if                        BUG1644
      ** not the full fee amount past due is being settled                      BUG1644
                                                                                BUG1644
     C                   SELECT                                                 BUG1644
     C     FA_FATYPE     WHENEQ    'F'                                          BUG1644
                                                                                BUG1644
     C     FA_FASADJ     IFNE      W#CPAM                                       BUG1644
     C                   MOVE      'W'           S#CSSNok                       BUG1644
     C                   ADD       1             Wx                             BUG1644
     C                   MOVEL     'S#CSSN    '  WFldNamArr(Wx)                 BUG1644
     C     FA_FASADJ     IFLT      W#CPAM                                       BUG1644
     C                   MOVEL     'LER0180'     WMsgIDArr(Wx)                  BUG1644
     C                   ELSE                                                   BUG1644
     C                   MOVEL     'LER0181'     WMsgIDArr(Wx)                  BUG1644
     C                   ENDIF                                                  BUG1644
     C                   ENDIF                                                  BUG1644
                                                                                BUG1644
     C                   OTHER                                                  BUG1644
      * If the record is being inserted, amended or authorised when the
      * total amount past due has reached zero, settlement is not allowed
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C     S#ACTN        OREQ      'X'
     C     W#CPAM        IFLT      *ZEROS
     C     PDFeeSet      ANDNE     'Y'                                                      MD054354
     C******IN80         ANDEQ     '1'                                            MD026969 MD026969A
     C     W#CPAM        ORLT      *ZEROS                                                   MD054354
     C     *IN81         ANDEQ     '1'                                                     MD026969A
     C     PDFeeSet      ANDEQ     'Y'                                                      MD054354
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#FSEQok
     C                   MOVE      'N'           S#VDATok
     C                   IF        CLE073 = 'Y' And                                           CLE073
     C                             S#LOAN <> *Blanks                                          CLE073
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ENDIF                                                                CLE073
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0179'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL                                                  BUG1644
                                                                                BUG1644
      *                                                                                     MD026969
      ** If FEAMTP = 0 and record exist in LEFZASPD,                                        MD026969
      ** reset W#CPAM to FEAMTP.                                                            MD026969
      *                                                                                     MD026969
     C**********         IF        *IN80 = '0' and FE_FEAMTP = 0                  MD026969 MD026969A
     C                   IF        *IN81 = '0' and FE_FEAMTP = 0                           MD026969A
     C                             AND PDFeeSet = 'Y'                                       MD054354
     C                   Z-ADD     FE_FEAMTP     W#CPAM                                     MD026969
     C                   ENDIF                                                              MD026969
                                                                                            MD026969
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action                                           *
      *****************************************************************
     C     VLDACT        BEGSR
 
     C                   SELECT
 
      * Amendments are only allowed:
 
     C     S#ACTN        WHENEQ    'A'
 
      * . on live records
 
     C     FA_FARECI     IFNE      'S'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0230'     MsgIdArr(Ix)
     C                   ENDIF
 
      * Authorisations are only allowed:
 
     C     S#ACTN        WHENEQ    'X'
 
      * . if lending authorisations is installed
      *   and if fee settlements are to be authorised
 
     C     CLE002        IFEQ      'N'
     C     BPFSAU        ORNE      'Y'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0161'     MsgIdArr(Ix)
     C                   ELSE
 
      * . on live records
      * . records whose status is 'complete' or 'awaiting reauthorisation'
      * . if the user is different from the last insert or amend user
 
     C     FA_FARECI     IFNE      'S'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0230'     MsgIdArr(Ix)
     C                   ELSE
     C     FA_SSTS       IFNE      'C'
     C     FA_SSTS       ANDNE     'R'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0164'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   IF        USRID  <> *Blank                                           CAP084
     C                   EVAL      PSUser = USRID                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      *
     C     P#MODE        IFNE      'B'
      * If system value CLAuthORED = 'Y' allow authorise user to be same as                   240968
      * insert user if status is 'R'                                                          240968
      * Or system value CLAuthORED = 'Y' allow authorise user to be same as                   244314
      * insert user if status is 'R'                                                          244314
      *                                                                                       240968
     C     ATHRATH       IFEQ      'Y'                                                        240968
     C     ATHSMDT       OREQ      'Y'                                                        244314
      *                                                                                       240968
     C     PSUser        IFEQ      FA_AUSR                                                    240968
     C     PSUser        OREQ      FA_IUSR                                                    240968
     C     FA_SSTS       ANDNE     'R'                                                        240968
     C                   MOVE      'N'           S#ACTNok                                     240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)                               240968
     C                   MOVEL     'LER0163'     MsgIdArr(Ix)                                 240968
     C                   ENDIF                                                                240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     PSUser        IFEQ      FA_AUSR
     C     PSUser        OREQ      FA_IUSR
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0163'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF                                                                240968
     C                   ENDIF
                                                                                             BUG3760
      **  Watch List Checking Applied                                                        BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                   IF        (CSC011 = 'N' OR CSC011 = 'Y'                             BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       W2CNUM                                      BUG3760
     C                   MOVEL     *BLANKS       W2FACL                                      BUG3760
     C                   MOVEL     *BLANKS       W2FSEQ                                      BUG3760
     C                   MOVEL     *BLANKS       W2LOAN                                      BUG3760
     C                   MOVEL     S#CSSN        W2CNUM                                      BUG3760
     C     S#FACT        CAT       S#FCNO        W2FACL                                      BUG3760
     C                   MOVEL     S#FSEQ        W2FSEQ                                      BUG3760
     C                   MOVEL     *BLANKS       W2LOAN                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        W2LOAN = *Blanks                                          BUG3760
     C                   EVAL      WIdntifier = %TRIM(W2CNUM + W2FACL + W2FSEQ)              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      WIdntifier = %TRIM(W2LOAN + W2FSEQ)                       BUG3760
     C                   ENDIF                                                               BUG3760
     C                   EVAL      WFuncType = 'LEFEEAD'                                     BUG3760
     C                   EVAL      WBranch = FA_FABRCA                                       BUG3760
                                                                                             BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                        BUG3760
     C                   ADD       1             Ix                                          BUG3760
     C                   MOVEL     'LEL0564'     MsgIdArr(Ix)                                BUG3760
     C                   EVAL      FldNameArr(Ix)  = 'S#ACTN'                                BUG3760
     C                   MOVEL     'N'           S#ACTNok                                    BUG3760
     C                   GOTO      EVLDA                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
 
     C                   ENDIF
 
      * Deletions are only allowed:
 
     C     S#ACTN        WHENEQ    'D'
 
      * . on live records
     C     FA_FARECI     IFNE      'S'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0230'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSL
 
     C     EVLDA         ENDSR                                                               BUG3760
     C**********         ENDSR                                                               BUG3760
      *****************************************************************
      /SPACE 5
      ***********************************************************
      *  VLDAUT :   Validate Authority
      ***********************************************************
     C     VLDAUT        BEGSR
      *
      **  Validate users authority to usse this branch/action
     C                   Z-ADD     *ZERO         @ERR
      *
      **  If not a multi-branch
     C     MBIN          IFEQ      'N'
      *
     C                   CALL      'ZVACTU'
     C                   PARM      S#ACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFNE      *ZERO
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0009'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate facility branch if not an insert
     C     MBIN          IFEQ      'Y'
     C     S#ACTN        ANDNE     'I'
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      S#ACTN        @ZACTN            1
     C**********         PARM      FC_BRCA       @ZBR              3                         CLE073
     C                   PARM      FcbrBranch    @ZBR              3                         CLE073
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0010'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate Orig. Branch if used and validation required and
      **  is not an insert
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C     S#ACTN        ANDNE     'I'
      *
     C                   CALL      'ZVOBU'
     C**********         PARM      FC_ORBR       @ZOBRX            3                         CLE073
     C                   PARM      FcbrORBR      @ZOBRX            3                         CLE073
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0012'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0013'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     SRTEXT        BEGSR
 
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM      'LERMSGF '    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM      *BLANKS       ZAMSTX          132
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
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
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM                    RESPMODE          1
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#VDAT            6
     C                   PARM                    S#LOAN            6                          CLE073
 
      *
      * OUTPUTS
 
      * Fee Settlement Details in file format
     C                   PARM                    LEFEEADFmt
     C                   PARM                    InRecSttmt                                   258669
     C                   PARM                    InPaySttmt                                   258669
     C                   PARM                    ##RECF                                       258669
     C                   PARM                    ##PAYF                                       258669
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#VDATok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, fee amount due/past due
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#DUPD           18
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger Details
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       240968
      ** Check for auto allocation of loan numbers system value.                              240968
     C                   CALLB     'AOSVALR0'                                                 240968
     C                   PARM      *BLANKS       PRtCd             7                          240968
     C                   PARM      CLAuthORED    PSysVal01                                    240968
     C                   PARM      *BLANKS       PCurSet01                                    240968
     C**********         PARM      *BLANKS       PSysVal02                             240968 244314
     C                   PARM      CLAuthSMDT    PSysVal02                                    244314
     C                   PARM      *BLANKS       PCurSet02                                    240968
     C**********         PARM      *BLANKS       PSysVal03                           240968 MD054354
     C                   PARM      PDFeeSttmt    PSysVal03                                  MD054354
     C                   PARM      *BLANKS       PCurSet03                                    240968
     C                   PARM      *BLANKS       PSysVal04                                    240968
     C                   PARM      *BLANKS       PCurSet04                                    240968
     C                   PARM      *BLANKS       PSysVal05                                    240968
     C                   PARM      *BLANKS       PCurSet05                                    240968
     C                   PARM      *BLANKS       PSysVal06                                    240968
     C                   PARM      *BLANKS       PCurSet06                                    240968
     C                   PARM      *BLANKS       PSysVal07                                    240968
     C                   PARM      *BLANKS       PCurSet07                                    240968
     C                   PARM      *BLANKS       PSysVal08                                    240968
     C                   PARM      *BLANKS       PCurSet08                                    240968
     C                   PARM      *BLANKS       PSysVal09                                    240968
     C                   PARM      *BLANKS       PCurSet09                                    240968
     C                   PARM      *BLANKS       PSysVal10                                    240968
     C                   PARM      *BLANKS       PCurSet10                                    240968
                                                                                              240968
     C                   If        PRtCd <> *Blanks                                           240968
     C                   Eval      DBFile = 'SDSVALPD'                                        240968
     C                   Eval      DBase = 906                                                240968
     C                   Eval      DBKey = '*KEY    '                                         240968
     C                   ExSR      *PSSR                                                      240968
     C                   EndIf                                                                240968
     C                   MOVEL     PCurSet01     ATHRATH           1                          240968
     C                   MOVEL     PCurSet02     ATHSMDT           1                          244314
     C                   MOVEL     PCurSet03     PDFeeSet          1                        MD054354
 
      ** Check if CLE002 - Lending Authorisations - is Installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE002
     C                   ELSE
     C                   MOVEL     'N'           CLE002            1
     C                   ENDIF
 
      ** Retrieve customer lending data, if CLE002 is Installed
 
     C     CLE002        IFEQ      'Y'
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      *  GET MBIN FROM DTAARA/RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
                                                                                              CAP084
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-          CAP084 BUG7029
      **the*actual*user*name*is*stored*in*ZMUSER                                      CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029
                                                                                              CAP084
      ** Check if CSC011 is installed                                                         CAP084
     C                   CALL      'AOSARDR0'                                                 CAP084
     C                   PARM      *BLANKS       PRTCD                                        CAP084
     C                   PARM      '*VERIFY'     POPTN                                        CAP084
     C                   PARM      'CSC011'      PSARD                                        CAP084
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP084
                                                                                              CAP084
     C                   IN        SDSTAT                                                    BUG3760
     C                   IF        PRTCD = *Blanks                                            CAP084
                                                                                              CAP084
     C                   EVAL      CSC011 = 'Y'                                               CAP084
                                                                                              CAP084
     C                   IN        SC24X7                                                     CAP084
     C**********         IN        SDSTAT                                             CAP084 BUG3760
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
                                                                                              CAP084
      ** Database error                                                                       CAP084
     C                   IF        PRTCD <> '*NRF'                                            CAP084
     C     *LOCK         IN        LDA                                                        CAP084
     C                   EVAL      DBKEY = 'CSC011'                                           CAP084
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP084
     C                   EVAL      DBASE = 900                                                CAP084
     C                   OUT       LDA                                                        CAP084
     C                   EXSR      *PSSR                                                      CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** If 24X7 Midas availability is installed and support system is                        CAP084
      ** active, used processing date from dataarea SC24X7 as the                             CAP084
      ** rundate.                                                                             CAP084
     C                   IF        CSC011 = 'Y' AND                                           CAP084
     C                             S1SUPP = LIBR                                              CAP084
     C                   EVAL      WProcDate = S1DATE                                         CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      WProcDate = BJRDNB                                         CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                      BUG3760
      **  Access SAR details to see if CSD015 is switched on.                                BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 903                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 904                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRTCD                                        CAP086
     C                   PARM      '*VERIFY'     POPTN                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRTCD <> *BLANKS  AND                                      CAP086
     C                             PRTCD <> '*NRF'                                            CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 905                                               CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        PRTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE073
      ** Check if CLE083 - Calculation of loan based fees is installed                        CLE073
                                                                                              CLE073
     C                   CALL      'AOSARDR0'                                                 CLE073
     C                   PARM      *BLANKS       @RTCD                                        CLE073
     C                   PARM      '*KEY    '    @OPTN                                        CLE073
     C                   PARM      'CLE073'      @SARD             6                          CLE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
                                                                                              CLE073
     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
     C                   MOVEL     'Y'           CLE073                                       CLE073
     C                   ELSE                                                                 CLE073
     C                   MOVEL     'N'           CLE073            1                          CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
     C                   IF        CLE073 = 'Y'                                               258110
     C                   IF        S#LOAN <> *BLANKS                                          258110
     C                   IF        S#FACT = '000'                                             258110
     C                   MOVE      *BLANKS       S#FACT                                       258110
     C                   ENDIF                                                                258110
     C                   IF        S#FCNO = '00'                                              258110
     C                   MOVE      *BLANKS       S#FCNO                                       258110
     C                   ENDIF                                                                258110
     C                   ENDIF                                                                258110
     C                   ENDIF                                                                258110
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS  AND                                      CSD083
     C                             @RTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 907                                                CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
 
     C     *LIKE         DEFINE    FC_CNUM       K#CNUM
     C     *LIKE         DEFINE    FC_FACT       K#FACT
     C     *LIKE         DEFINE    FC_FCNO       K#FCNO
     C     *LIKE         DEFINE    FC_RCDT       K#RCDT
     C     *LIKE         DEFINE    FA_FAFACL     K#FACL
     C     *LIKE         DEFINE    FA_FALOAN     K#LOAN
     C     *LIKE         DEFINE    FA_FAFSEQ     K#FSEQ
     C     *LIKE         DEFINE    FA_FAVDAT     K#VDAT
 
      ** Key lists
 
     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCDT
     C     FEEAK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
     C     FEESK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
     C                   KFLD                    K#VDAT
                                                                                             BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
                                                                                             BUG3760
     C     WKFEE         KLIST                                                               BUG7528
     C                   KFLD                    K#CNUM                                      BUG7528
     C                   KFLD                    K#FACL                                      BUG7528
     C                   KFLD                    K#LOAN                                      BUG7528
     C                   KFLD                    K#FSEQ                                      BUG7528
                                                                                             BUG7528
     C     EXSTK         KLIST                                                                258669
     C                   KFLD                    BYCYCD                                       258669
     C                   KFLD                    BYCUST                                       258669
     C                   KFLD                    KTRTY             2                          258669
                                                                                              258669
     C     LOANKK        KLIST                                                                CLE073
     C                   KFLD                    K#LOAN                                       CLE073
     C                   KFLD                    K#RCDT                                       CLE073
      *                                                                                     MD026969
     C     WKFZAS        KLIST                                                              MD026969
     C                   KFLD                    FE_FECNUM                                  MD026969
     C                   KFLD                    FE_FEFACL                                  MD026969
     C                   KFLD                    FE_FEFSEQ                                  MD026969
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002