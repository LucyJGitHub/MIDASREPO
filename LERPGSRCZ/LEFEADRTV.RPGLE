     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment retrieve')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFEADRTV - Fee Adjustment Retrieve                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR750553           Date 29Apr11               *
      *                 258110             Date 22Jan09               *
      *                 CLE073             Date 07Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244314             Date 11Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240968             Date 10Jul06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6944            Date 27Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4110            Date 24Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG0707            Date 26May04               *
      *                 CLE025             Date 20Oct03               *
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
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR750553 - Wrong total accrued to date for calc 98           *
      *             (Child:AR750554)                                  *
      *  258110 - Java returns '000' so loan processing not done.     *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if adjustment has status 'R'                   *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG6944- Incorrect total accrued to date for newly inserted  *
      *           fees based on actual amounts when there is a        *
      *           movement for the facility in PF/FACHISA.            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4110- Unable to authorise transaction.                    *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG0707- New ICD setting for Authorisation of Fee Adjustments*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *         - Use 24x7 runday, and user from ZMUSER               *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
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
 
     FLEFEEAL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:LEFEEAD0)
     F                                     PREFIX(FA_)
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FE_)
     FCLOAN     IF   E           K DISK    INCLUDE(CLOANCLF)                                  CLE073
 
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Fee Adjustment Details in file format
     D LEFEEADFmt    E DS                  EXTNAME(LEFEEAD)
     D                                     PREFIX(FA_)
 
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
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
 
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
 
      ** Java user information                                                                CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
                                                                                              CAP084
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
 
      * CLEAR OUTPUTS
 
     C                   CLEAR                   LEFEEADFmt
     C                   MOVE      'Y'           S#ACTNok
     C                   MOVE      'Y'           S#CSSNok
     C                   MOVE      'Y'           S#FACTok
     C                   MOVE      'Y'           S#FCNOok
     C                   MOVE      'Y'           S#FSEQok
     C                   MOVE      'Y'           S#LOANok                                     CLE073
     C                   MOVE      *BLANK        S#CNUM
     C                   MOVE      *BLANK        S#FCCY
     C                   Z-ADD     *ZERO         FecyNBDP
     C                   MOVE      *BLANK        S#FTYP
     C                   MOVE      *BLANK        S#FCOD
     C                   MOVE      *BLANK        S#FENV
     C                   MOVE      *BLANK        S#ACCD
     C                   Z-ADD     *ZERO         W#SADD
     C                   MOVE      *BLANK        W#PTFI
 
     C                   Z-ADD     *ZERO         W#FAMT
     C                   MOVEL     *BLANK        FcbrOrbr          3                          CLE073
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
      * If the user is connected via a browser, the job user name is QUSER -                 BUG4110
      * their user name is stored in ZMUSER                                                  BUG4110
     C                   IN        ZMUSER                                                    BUG4110
 
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
     C                   EndIf                                                                CLE073
                                                                                              CLE073
      ** Validate loan of fee                                                                 CLE073
                                                                                              CLE073
     C                   If        CLE073 = 'Y' And                                           CLE073
     C                             S#FACT = *Blanks                                           CLE073
     C                   EXSR      CHKLOAN                                                    CLE073
                                                                                              CLE073
     C     S#LOANok      IFEQ      'N'                                                        CLE073
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
 
      ** Check fee details exist
 
     C                   EXSR      CHKFEEDT
 
      ** Check fee adjustment
 
     C                   EXSR      CHKFEEA
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#CSSNok      IFEQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C     S#FSEQok      OREQ      'N'
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
                                                                                              CAP086
      ** If the P#MODE field is blanks do authorisation is                                    CAP086
      ** required                                                                             CAP086
                                                                                              CAP086
     C                   IF        P#MODE = ' '                                               CAP086
     C                   EVAL      FA_AUTH = *BLANK                                           CAP086
     C                   ENDIF                                                                CAP086
 
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
     C                   EXSR      ZALIGN2
 
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
     C                   EXSR      ZALIGN2
 
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
     C                   If        S#LOAN <> *Blanks                                          CLE073
     C                   MOVEL     S#LOAN        K#LOAN                                       CLE073
     C                   MOVEL     'A'           K#RCDT                                       CLE073
                                                                                              CLE073
     C     LOANKK        CHAIN     CLOAN                              80                      CLE073
                                                                                              CLE073
     C     *IN80         IFEQ      *OFF                                                       CLE073
                                                                                              CLE073
     C                   CALL      'AOBRCHR1'                                                 CLE073
     C                   PARM      '       '     @RTCD                                        CLE073
     C                   PARM      '*KEY   '     @OPTN                                        CLE073
     C                   PARM      BRCA          @BRCA                                        CLE073
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CLE073
      *                                                                                       CLE073
     C     @RTCD         IFNE      *BLANK                                                     CLE073
     C                   MOVEL     'SDBRCHPD'    DBFILE                                       CLE073
     C                   MOVEL     '905'         DBASE                                        CLE073
     C                   MOVEL     BRCA          DBKEY                                        CLE073
     C                   EXSR      *PSSR                                                      CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
     C                   CALL      'AOCURRR0'                                                 CLE073
     C                   PARM      '       '     @RTCD                                        CLE073
     C                   PARM      '*KEY   '     @OPTN                                        CLE073
     C                   PARM      CCY           @CCY                                         CLE073
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE073
      *                                                                                       CLE073
     C     @RTCD         IFNE      *BLANK                                                     CLE073
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CLE073
     C                   MOVEL     '906'         DBASE                                        CLE073
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
     C                   EXSR      ZALIGN2
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
      * Check fee details exist                                       *
      *****************************************************************
     C     CHKFEEDT      BEGSR
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACL
     C                   MOVE      S#FCNO        K#FACL
     C                   IF        CLE073 = 'N' Or                                            CLE073
     C                             CLE073 = 'Y' And                                           CLE073
     C                             S#LOAN = *Blanks                                           CLE073
     C**********         Z-ADD     *ZEROS        K#LOAN                                       CLE148
     C                   MOVEL     *BLANKS       K#LOAN                                       CLE148
     C                   Else                                                                 CLE073
     C                   MOVEL     S#LOAN        K#LOAN                                       CLE073
     C                   EndIf                                                                CLE073
     C                   MOVE      S#FSEQ        K#FSEQ
 
     C     FEEAK         CHAIN     LEFEEDL1                           80
 
     C     *IN80         IFEQ      *ON
     C     FE_FERECI     ORNE      'D'
 
     C                   MOVE      'N'           S#FSEQok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FSEQ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0073'     MsgIdArr(Ix)
 
     C                   ELSE
 
      * Adjustments cannot be done for fixed fees
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
 
      * Calculate fee accrued to date
 
     C     S#FSEQok      IFEQ      'Y'
     C                   EXSR      CAL_FEACCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check fee adjustment                                          *
      *****************************************************************
     C     CHKFEEA       BEGSR
      *
     C                   EVAL      FA_FASIGN = *BLANK                                       AR750553
     C                   Z-ADD     0             FA_FASADJ                                  AR750553
      *                                                                                     AR750553
     C     FEEAK         CHAIN     LEFEEAL0                           80
      *
     C     S#ACTN        IFEQ      'I'
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#FSEQok
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0189'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     *IN80         IFEQ      *ON
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#FSEQok
     C                   MOVE      'N'           S#LOANok                                     CLE073
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0190'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        FE_FECALT =  '97' OR                                     AR750553
     C                             FE_FECALT =  '98' OR                                     AR750553
     C                             FE_FECALT =  '99'                                        AR750553
     C                   IF        FA_FASIGN = '+'                                          AR750553
     C                   ADD       FA_FASADJ     W#FEE                                      AR750553
     C                   ELSE                                                               AR750553
     C                   SUB       FA_FASADJ     W#FEE                                      AR750553
     C                   ENDIF                                                              AR750553
                                                                                            AR750553
      ** Edit fee amount                                                                    AR750553
                                                                                            AR750553
     C                   MOVE      *BLANKS       S#ACCD                                     AR750553
     C     W#FEE         IFEQ      *ZEROS                                                   AR750553
     C                   MOVE      *BLANKS       S#ACCD                                     AR750553
     C                   ELSE                                                               AR750553
     C                   Z-ADD     W#FEE         ZFLD15                                     AR750553
     C                   Z-ADD     A6NBDP        ZDECS                                      AR750553
     C                   EXSR      ZSEDIT                                                   AR750553
     C                   MOVE      ZOUT21        S#ACCD                                     AR750553
     C                   ENDIF                                                              AR750553
     C                   ENDIF                                                              AR750553
                                                                                            AR750553
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
 
     C     FA_FARECI     IFNE      'A'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0230'     MsgIdArr(Ix)
     C                   ENDIF
 
      * Authorisations are only allowed:
 
     C     S#ACTN        WHENEQ    'X'
 
      * . if lending authorisations is installed
      *   and if fee adjustments are to be authorised
 
     C     CLE002        IFEQ      'N'
     C*****BPFSAU        ORNE      'Y'                                                       BUG0707
     C     BPFJAU        ORNE      'Y'                                                       BUG0707
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0161'     MsgIdArr(Ix)
     C                   ELSE
 
      * . on live records
      * . records whose status is 'complete' or 'awaiting reauthorisation'
      * . if the user is different from the last insert or amend user
 
     C     FA_FARECI     IFNE      'A'
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
      *
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   IF        USRID  <> *Blank                                           CAP084
     C                   EVAL      PSUser = USRID                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C     P#MODE        IFNE      'B'
      * If system value CLAuthORED = 'Y' and status is R then allow                           240968
      * authorise user to be same as original insert user                                     240968
      *                                                                                       240968
      * Or if CLAuthSameORED = 'Y' and status is R then allow authorise                       244314
      * user to be the same as original insert user                                           244314
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
 
     C                   ENDIF
 
      * Deletions are only allowed:
 
     C     S#ACTN        WHENEQ    'D'
 
      * . on live records
     C     FA_FARECI     IFNE      'A'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0230'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
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
     C**********         PARM      FC_BRCA       @ZBR              3                          CLE073
     C                   PARM      FcbrBranch    @ZBR              3                          CLE073
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
     C**********         PARM      FC_ORBR       @ZOBRX            3                          CLE073
     C                   PARM      FcbrOrbr      @ZOBRX            3                          CLE073
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
      *  CAL_FEACCD :   Calculate Fee Accrued to Date
      *****************************************************************
     C     CAL_FEACCD    BEGSR
 
     C                   Z-ADD     *ZERO         W#FEE            13 0
 
      *  Non-calculated fees
      *  -------------------
 
     C     FE_FECALT     IFEQ      '  '
 
     C*****FE_FEPEND     IFLE      BJRDNB                                                     CAP084
     C     FE_FEPEND     IFLE      WProcDate                                                  CAP084
     C                   Z-ADD     FE_FEFAMT     W#FEE
     C                   ELSE
 
      *  Do straight-line accrual to today
 
     C*****FE_FEPSTD     IFNE      BJRDNB                                                     CAP084
     C*****BJRDNB        SUB       FE_FEPSTD     FLATDays          5 0                        CAP084
     C     FE_FEPSTD     IFNE      WProcDate                                                  CAP084
     C     WProcDate     SUB       FE_FEPSTD     FLATDays          5 0                        CAP084
     C                   SUB       1             FLATDays
     C     FLATDays      IFNE      0
     C     FE_FEADAT     DIV(H)    FLATDays      FLATAmnt         13 0
     C                   ADD       1             FLATDays
     C     FLATAmnt      MULT      FLATDays      FLATAmnt
     C                   Z-ADD     FLATAmnt      W#FEE
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     FE_FEADAT     W#FEE
     C                   END
     C                   END
 
     C                   ELSE
 
      * Calculated fees
      * ---------------
 
     C     FE_FECALT     IFEQ      '01'
     C     FE_FECALT     OREQ      '02'
     C     FE_FECALT     OREQ      '03'
     C     FE_FECALT     OREQ      '11'
     C     FE_FECALT     OREQ      '12'
     C     FE_FECALT     OREQ      '13'
     C     FE_FECALT     OREQ      '21'
 
     C                   EXSR      FECALAV
     C**********         ADD       FE_FEAMTP     W#FEE                                       BUG6944
 
     C                   ELSE
     C                                                                                        CLE073
     C                   IF        CLE073 = 'N' Or                                            CLE073
     C                             CLE073 = 'Y' And                                           CLE073
     C                             FE_FECALT <> '97' And                                      CLE073
     C                             FE_FECALT <> '98' And                                      CLE073
     C                             FE_FECALT <> '99'                                          CLE073
 
      * Actual amount Fees
      * ------------------
 
     C                   EXSR      FECALAV
     C                   ADD       FE_FEADAT     W#FEE
     C                   ADD       FE_FELPAM     W#FEE
     C**********         ADD       FE_FEAMTP     W#FEE                                       BUG6944
 
     C                                                                                        CLE073
     C                   Else                                                                 CLE073
     C                                                                                        CLE073
     C                   If        CLE073 = 'Y'                                               CLE073
     C                                                                                        CLE073
     C                   If        FE_FECALT =  '97' Or                                       CLE073
     C                             FE_FECALT =  '98' Or                                       CLE073
     C                             FE_FECALT =  '99'                                          CLE073
     C                                                                                        CLE073
     C                   EXSR      CALCLOAN                                                   CLE073
     C                   ADD       FE_FEADAT     W#FEE                                      AR750553
     C                   ADD       FE_FEAMTA     W#FEE                                      AR750553
     C                   IF        FE_FECALT =  '97' OR                                     AR750553
     C                             FE_FECALT =  '98'                                        AR750553
     C                   ADD       FE_FETADJ     W#FEE                                      AR750553
     C                   SUB       FE_FEAMTS     W#FEE                                      AR750553
     C                   SUB       FE_FEAMTP     W#FEE                                      AR750553
     C                   SUB       FE_FEAMTW     W#FEE                                      AR750553
     C                   SUB       FE_FEWOFF     W#FEE                                      AR750553
     C                   ENDIF                                                              AR750553
     C                                                                                        CLE073
     C                   EndIf                                                                CLE073
     C                   EndIf                                                                CLE073
     C                   EndIf                                                                CLE073
     C                                                                                        CLE073
     C                   END
 
     C                   END
 
      * Edit fee amount
 
     C     W#FEE         IFEQ      *ZEROS
     C                   MOVE      *BLANKS       S#ACCD
     C                   ELSE
     C                   Z-ADD     W#FEE         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        S#ACCD
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     FECALAV       BEGSR
 
     C                   CALLB     'LEFECALAV'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeOut
 
      * Branch, customer, facility type, facility number
      * and fee sequence number
     C                   PARM                    FcbrBranch
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
     C                   PARM                    S#FCNO
     C                   PARM                    S#FSEQ
 
      * Fee details
      * -----------
      * Last Payment Date
      * Last Accrual Date
      * Period Start Date
      * Period End Date
      * Fee Calculation type
      * Calculation basis
      * Percent Indicator
      * Fee currency
      * Exchange rate
      * Multiply/Divide indicator
      * Fee amounts x 5
      * Fee rates x 5
     C                   PARM      FE_FELPDT     FELPDT            5 0
     C                   PARM      FE_FELADT     FELADT            5 0
     C                   PARM      FE_FEPSTD     FEPSTD            5 0
     C                   PARM      FE_FEPEND     FEPEND            5 0
     C                   PARM      FE_FECALT     FECALT            2
     C                   PARM      FE_FECALC     FECALC            1 0
     C                   PARM      FE_FEPIND     FEPIND            1
     C                   PARM      FE_FEFCCY     FEFCCY            3
     C                   PARM      FE_FEERAT     FEERAT           13 8
     C                   PARM      FE_FEMDIN     FEMDIN            1
     C                   PARM                    @FEAMA
     C                   PARM                    @FRTA
      *
      * OUTPUTS
      *
      * Fee amount
     C                   PARM      *ZERO         W#FEE            13 0
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5                                                                                CLE073
      *****************************************************************                       CLE073
     C     CALCLOAN      BEGSR                                                                CLE073
                                                                                              CLE073
     C                   CALLB     'LEFECALLN'                                                CLE073
      *                                                                                       CLE073
      * INPUTS                                                                                CLE073
      *                                                                                       CLE073
      * Return Code                                                                           CLE073
     C                   PARM      *BLANKS       RetCodeOut                                   CLE073
                                                                                              CLE073
      * Loan                                                                                  CLE073
     C                   PARM                    S#LOAN                                       CLE073
                                                                                              CLE073
      * Fee details                                                                           CLE073
      * -----------                                                                           CLE073
      * Fee Branch Code                                                                       CLE073
      * Fee Customer Number                                                                   CLE073
      * Fee Amount                                                                            CLE073
      * Fee Next Pay Date                                                                     CLE073
      * Last Payment Date                                                                     CLE073
      * Last Accrual Date                                                                     CLE073
      * Period Start Date                                                                     CLE073
      * Period End Date                                                                       CLE073
      * Fee Calculation type                                                                  CLE073
      * Calculation basis                                                                     CLE073
      * Percent Indicator                                                                     CLE073
      * Fee currency                                                                          CLE073
      * Exchange rate                                                                         CLE073
      * Multiply/Divide indicator                                                             CLE073
      * Fee amounts x 5                                                                       CLE073
      * Fee rates x 5                                                                         CLE073
     C                   PARM      FE_FEBRCA     FEBRCA            3                          CLE073
     C                   PARM      FE_FECNUM     FECNUM            6                          CLE073
     C                   PARM      FE_FEFAMT     FEFAMT           13 0                        CLE073
     C                   PARM      FE_FENPYD     FENPYD            5 0                        CLE073
     C                   PARM      FE_FELPDT     FELPDT            5 0                        CLE073
     C                   PARM      FE_FELADT     FELADT            5 0                        CLE073
     C                   PARM      FE_FEPSTD     FEPSTD            5 0                        CLE073
     C                   PARM      FE_FEPEND     FEPEND            5 0                        CLE073
     C                   PARM      FE_FECALT     FECALT            2                          CLE073
     C                   PARM      FE_FECALC     FECALC            1 0                        CLE073
     C                   PARM      FE_FEPIND     FEPIND            1                          CLE073
     C                   PARM      FE_FEFCCY     FEFCCY            3                          CLE073
     C                   PARM      FE_FEERAT     FEERAT           13 8                        CLE073
     C                   PARM      FE_FEMDIN     FEMDIN            1                          CLE073
     C                   PARM                    @FEAMA                                       CLE073
     C                   PARM                    @FRTA                                        CLE073
     C                   PARM                    CLE005                                     AR750553
      *                                                                                       CLE073
      * OUTPUTS                                                                               CLE073
      *                                                                                       CLE073
      * Fee amount                                                                            CLE073
     C                   PARM      *ZERO         W#FEE            13 0                        CLE073
                                                                                              CLE073
     C                   ENDSR                                                                CLE073
      *****************************************************************                       CLE073
     C/SPACE 5
      *****************************************************************
     C     ZALIGN2       BEGSR
     C                   CALLB     'ZALIGN2'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
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
 
      * Action, customer, facility type, facility number
      * and fee sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#LOAN            6                          CLE073
 
      *
      * OUTPUTS
 
      * Fee Adjustment Details in file format
     C                   PARM                    LEFEEADFmt
 
      * Action, customer, facility type, facility number
      * and fee sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, total fee accrued to date
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#ACCD           18
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
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
     C                   PARM      *BLANKS       PSysVal03                                    240968
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
     C                   Eval      DBase = 903                                                240968
     C                   Eval      DBKey = '*KEY    '                                         240968
     C                   ExSR      *PSSR                                                      240968
     C                   EndIf                                                                240968
     C                   MOVEL     PCurSet01     ATHRATH           1                          240968
     C                   MOVEL     PCurSet02     ATHSMDT           1                          244314
 
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
      ** Check if CLE005 - Lending Enhancements - Tranche 3                                 AR750553
                                                                                            AR750553
     C                   CALL      'AOSARDR0'                                               AR750553
     C                   PARM      *BLANKS       @RTCD                                      AR750553
     C                   PARM      '*KEY    '    @OPTN                                      AR750553
     C                   PARM      'CLE005'      @SARD                                      AR750553
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR750553
                                                                                            AR750553
     C     @RTCD         IFEQ      *BLANKS                                                  AR750553
     C                   MOVEL     'Y'           CLE005                                     AR750553
     C                   ELSE                                                               AR750553
     C                   MOVEL     'N'           CLE005            1                        AR750553
     C                   ENDIF                                                              AR750553
                                                                                            AR750553
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
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-           CAP084BUG4110
      **their*user*name*is*stored*in*ZMUSER                                            CAP084BUG4110
     C*******************IN********ZMUSER                                              CAP084BUG4110
                                                                                              CAP084
      ** Check if CSC011 is installed                                                         CAP084
     C                   CALL      'AOSARDR0'                                                 CAP084
     C                   PARM      *BLANKS       PRTCD                                        CAP084
     C                   PARM      '*VERIFY'     POPTN                                        CAP084
     C                   PARM      'CSC011'      PSARD                                        CAP084
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP084
                                                                                              CAP084
     C                   IF        PRTCD = *Blanks                                            CAP084
                                                                                              CAP084
     C                   EVAL      CSC011 = 'Y'                                               CAP084
                                                                                              CAP084
     C                   IN        SC24X7                                                     CAP084
     C                   IN        SDSTAT                                                     CAP084
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
 
     C                   IF        CLE073 = 'Y'                                               258110
     C                   IF        S#LOAN <> *Blanks                                          258110
     C                   IF        S#FACT = '000'                                             258110
     C                   MOVE      *BLANKS       S#FACT                                       258110
     C                   ENDIF                                                                258110
     C                   IF        S#FCNO = '00'                                              258110
     C                   MOVE      *BLANKS       S#FCNO                                       258110
     C                   ENDIF                                                                258110
     C                   ENDIF                                                                258110
     C                   ENDIF                                                                258110
     C     *LIKE         DEFINE    FC_CNUM       K#CNUM
     C     *LIKE         DEFINE    FC_FACT       K#FACT
     C     *LIKE         DEFINE    FC_FCNO       K#FCNO
     C     *LIKE         DEFINE    FC_RCDT       K#RCDT
     C     *LIKE         DEFINE    FA_FAFACL     K#FACL
     C     *LIKE         DEFINE    FA_FALOAN     K#LOAN
     C     *LIKE         DEFINE    FA_FAFSEQ     K#FSEQ
 
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
     C     LOANKK        KLIST                                                                CLE073
     C                   KFLD                    K#LOAN                                       CLE073
     C                   KFLD                    K#RCDT                                       CLE073
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
(c) Misys International Banking Systems Ltd. 2002
