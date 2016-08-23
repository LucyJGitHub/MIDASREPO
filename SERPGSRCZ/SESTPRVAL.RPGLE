     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRVAL - Statement Production Requests - Validations*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 217892             Date 16May03               *
      *                 CSE040   *CREATE   Date 19Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
/*    *  217892 - Do not limit to SWIFT and PAPER networks            *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCPOSCS    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CP_)
      ** Customer Positions by Customer
 
     FDPOSNL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DP_)
      ** Depot Positions by Customer
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SEC_)
      ** Midas Security Details
 
     FSESTHSL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Statement History by Message Reference
 
     FSESTPRL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SESTPRD0:SESTPRD2)
      ** Midas SE Statement Production Request - Index
 
      /COPY WNCPYSRC,SESTPRV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
 
     D CurStPRIFld   E DS                  EXTNAME(SESTPR1PD) PREFIX(C_)
      ** SESTPR Transaction Details in screen format
      ** Current state (i.e. before any amendment)
 
     D StPRScnIFld   E DS                  EXTNAME(SESTPR1PD)
      ** SESTPR Transaction Details in screen format
 
     D StPRScnOFld   E DS                  EXTNAME(SESTPR2PD)
      ** SESTPR Output only Screen Fields
 
     D StPROkFlags   E DS                  EXTNAME(SEESTPRPD)
      ** SESTPR Transaction Details OK indicators
 
     D NewSEStPR     E DS                  EXTNAME(SEVSTPRPD)
      ** New Statement Production Request in file format
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** External DS for Counterparty Nostro Details
 
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** External DS for Midas BIC Directory Details
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** External DS for Securities Customer Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
      ** External DS for Customer Details
 
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** External DS for Network Details
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
     D                                     PREFIX(ZMUS_)
      ** Midas ZMUSER Data Area Layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long DS for access programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for error message arrays
     D Idx             S              3P 0
     D SavIdx          S              3P 0
 
      ** Index for warning message arrays
     D WIdx            S              3P 0
 
      ** Fields for dates
     D StartDate       S               D   DATFMT(*ISO) INZ(D'1971-12-31')      Start Date
     D DftDate         S                   LIKE(DDMSTD)                         Run date screen fmt
     D NextWkDate      S                   LIKE(DDMSTD)                         Nxt Wk date scrn fmt
     D WkDate          S               D   DATFMT(*ISO)                         Work Date *ISO fmt
     D WkDateM         S                   LIKE(VSPMSTD)                        Work Date Midas fmt
     D WkDatTimD       S             11A                                        Start Date + Time
     D WkDatTimF       S             11A                                        End   Date + Time
     D X               S              2P 0                                      Day No decrease val.
     D WDay            S              2P 0                                      Working Day No
     D WxDay           S              2A                                        Idem, in alpha fmt
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SESTPRV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SESTPRV003
 
      ** Initializations
      *
                                                                                             BUG8550
      ** Retrieve the user's defaults                                                        BUG8550
                                                                                             BUG8550
     C                   IN        ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      INIT
 
      ** When the calling module is "*CTL" or "*RPR" and the mode is "Amend",
      ** we must first verify that only amendable fields are modified.
      ** The problem can't arise in the SIN function, as only the amendable
      ** fields are input-capable.
      ** When the caller is "*CTL", an individual error message is sent for
      ** each modified non-amendable field.
      ** When the caller is "*RPR", these fields are reset to their current
      ** value, and a global error message is sent to inform the user.
      *
     C                   IF        DDACTN = 'A' AND
     C                             (CallerCode = '*CTL' OR CallerCode = '*RPR')
     C                   EVAL      SavIdx = Idx
     C                   EXSR      ValAmdFlds
      *
     C                   IF        SavIdx <> Idx AND CallerCode = '*CTL'
     C                   GOTO      EndMod
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Validate Priority and Delivery Notification
      *
      /COPY WNCPYSRC,SESTPRV004
     C                   EXSR      ValPRNT
      /COPY WNCPYSRC,SESTPRV005
 
      ** Validate Sending Branch
      *
      /COPY WNCPYSRC,SESTPRV006
     C                   EXSR      ValSNDR
      /COPY WNCPYSRC,SESTPRV007
 
      ** Validate Originating Branch
      *
      /COPY WNCPYSRC,SESTPRV008
     C                   EXSR      ValORIG
      /COPY WNCPYSRC,SESTPRV009
 
      ** Validate Safekeeping Customer Number
      *
      /COPY WNCPYSRC,SESTPRV010
     C                   IF        DDACTN = 'I'
     C                   EXSR      ValCUST
     C                   ENDIF
      /COPY WNCPYSRC,SESTPRV011
 
      ** Validate Type of Statement
      *
      /COPY WNCPYSRC,SESTPRV012
     C                   EXSR      ValTYPE
      /COPY WNCPYSRC,SESTPRV013
 
      ** Validate Frequency
      *
      /COPY WNCPYSRC,SESTPRV014
     C                   EXSR      ValFREQ
      /COPY WNCPYSRC,SESTPRV015
 
      ** Validate Recipient
      *
      /COPY WNCPYSRC,SESTPRV016
     C                   EXSR      ValRECP
      /COPY WNCPYSRC,SESTPRV017
 
      ** Validate Start Date
      *
      /COPY WNCPYSRC,SESTPRV018
     C                   EXSR      ValMSTD
      /COPY WNCPYSRC,SESTPRV019
 
      ** Validate Start Time
      *
      /COPY WNCPYSRC,SESTPRV020
     C                   EXSR      ValSTTM
      /COPY WNCPYSRC,SESTPRV021
 
      ** Validate Day in Month
      *
      /COPY WNCPYSRC,SESTPRV022
     C                   EXSR      ValDAYM
      /COPY WNCPYSRC,SESTPRV023
 
      ** Validate End Date
      *
      /COPY WNCPYSRC,SESTPRV024
     C                   EXSR      ValMETD
      /COPY WNCPYSRC,SESTPRV025
 
      ** Validate End Time
      *
      /COPY WNCPYSRC,SESTPRV026
     C                   EXSR      ValENTM
      /COPY WNCPYSRC,SESTPRV027
 
      ** Validate Next Statement Date
      *
      /COPY WNCPYSRC,SESTPRV028
     C                   EXSR      ValNSTD
      /COPY WNCPYSRC,SESTPRV029
 
      ** Validate Next Statement Time
      *
      /COPY WNCPYSRC,SESTPRV030
     C                   EXSR      ValNSTT
      /COPY WNCPYSRC,SESTPRV031
 
      ** Validate Security Shortname
      *
      /COPY WNCPYSRC,SESTPRV032
     C                   EXSR      ValSESN
      /COPY WNCPYSRC,SESTPRV033
 
      ** Validate Network
      *
      /COPY WNCPYSRC,SESTPRV034
     C                   EXSR      ValNWRK
      /COPY WNCPYSRC,SESTPRV035
 
      ** Validate Related MT549 Message
      *
      /COPY WNCPYSRC,SESTPRV036
     C                   EXSR      ValR549
      /COPY WNCPYSRC,SESTPRV037
 
      ** Validate Message to Cancel
      *
      /COPY WNCPYSRC,SESTPRV038
     C                   EXSR      ValCANC
      /COPY WNCPYSRC,SESTPRV039
 
      ** Validate File Keys Consistency
      *
      /COPY WNCPYSRC,SESTPRV040
     C                   IF        StPROkFlags = *All'Y' AND DDACTN = 'I'
     C                   EXSR      ValFile
     C                   ENDIF
      /COPY WNCPYSRC,SESTPRV041
 
     C     EndMod        TAG
      *
     C                   RETURN
 
      /COPY WNCPYSRC,SESTPRV042
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValAmdFlds - Validate amended fields
      *****************************************************************
     C     ValAmdFlds    BEGSR
      *
     C                   MOVE      'N'           ErrorFound        1
      *
      ** Safekeeping Customer Number can never be changed
      ** The case can only arise when the current record has
      ** been retrieved using its main key (see the retrieve module)
      ** Note that the description may be wrong, due to the CVT module
      ** having used the wrong code to find it
      *
 B1  C                   IF        DDCUST <> C_DDCUST
      *
 B2  C                   IF        CallerCode = '*CTL'
     C                   EVAL      DDCUSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDCUST'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00057'
     C   99              EVAL      MsgDtaArr(Idx)  = 'Safekeeping Customer No'
 X2  C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      DDCUST = C_DDCUST
     C                   EXSR      CUSTDesc
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Send a global information message if needed
      *
     C                   IF        ErrorFound = 'Y'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = '*ANY'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00058'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValPRNT - Validate Priority and Delivery Notification
      *****************************************************************
     C     ValPRNT       BEGSR
      *
      ** Default values
      *
     C                   IF        DDPRTY = *Blanks
     C                   EVAL      DDPRTY = 'N'
     C                   ENDIF
      *
     C                   IF        DDNOTF = *Blanks
     C                   EVAL      DDNOTF = '2'
     C                   ENDIF
      *
      ** Question mark
      *
     C                   IF        DDPRTY = '?' OR DDNOTF = '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215011       @Y2LS
     C                   PARM      *Blanks       @INVL
      *
     C                   IF        @RtCd  = *Blanks
     C                   EVAL      DDPRTY = %Subst(@INVL:1:1)
     C                   EVAL      DDNOTF = %Subst(@INVL:3:1)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation
      *
     C                   EVAL      @INVL = DDPRTY + ' ' + DDNOTF
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215011       @Y2LS             7 0
     C                   PARM                    @INVL            20
     C                   PARM      *Blank        @VLMP             1
     C                   PARM                    @TEXT            50
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DDPRTYOK = 'N'
     C                   EVAL      DDNOTFOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDPRTY'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00002'
     C                   GOTO      EVlPRNT
     C                   ENDIF
      *
      ** Fields are valid
      *
     C                   EVAL      VSPPRTY = DDPRTY
     C                   EVAL      VSPNOTF = DDNOTF
      *
     C     EVlPRNT       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSNDR - Validate Sending Branch
      *****************************************************************
     C     ValSNDR       BEGSR
      *
      ** Default value
      *
     C                   IF        DDSNDR = *Blanks
     C                   EVAL      DDSNDR = ZMUS_DBRN
     C                   ENDIF
      *
      ** Question mark and validation
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      DDSNDR        @Brch             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      SndrSwftAddr = *Blanks
     C                   EVAL      DDSNDROK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSNDR'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00003'
     C                   GOTO      EVlSNDR
     C                   ELSE
     C                   EVAL      DDSNDR = A8BRCD
     C                   MOVEL     A8BTID        SndrSwftAddr     12
     C                   ENDIF
      *
     C                   IF        CallerCode <> '*CTL'
     C                   EVAL      ZACTN = DDACTN
     C                   EVAL      ZBR   = DDSNDR
     C                   EXSR      ChkAut
      *
     C                   IF        @@ERR <> 0
     C                   EVAL      DDSNDROK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSNDR'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00031'
     C                   GOTO      EVlSNDR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPSNDR = DDSNDR
      *
     C     EVlSNDR       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValORIG - Validate Originating Branch
      *****************************************************************
     C     ValORIG       BEGSR
      *
      ** Default value
      *
     C                   IF        DDORIG = *Blanks OR BJSBRC <> *Blanks
     C                   EVAL      DDORIG = DDSNDR
     C                   ENDIF
      *
      ** Question mark and validation
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      DDORIG        @Brch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DDORIGOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDORIG'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00005'
     C                   GOTO      EVlORIG
     C                   ELSE
     C                   EVAL      DDORIG = A8BRCD
     C                   ENDIF
      *
     C                   IF        CallerCode <> '*CTL'
     C                   EVAL      ZACTN = DDACTN
     C                   EVAL      ZBR   = DDORIG
     C                   EXSR      ChkAut
      *
     C                   IF        @@ERR <> 0
     C                   EVAL      DDORIGOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDORIG'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00031'
     C                   GOTO      EVlORIG
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPORIG = DDORIG
      *
     C     EVlORIG       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ChkAut - Check for user authority
      *****************************************************************
     C     ChkAut        BEGSR
      *
      ** If not multi-branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** If multi-branching
      *
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValCUST - Validate Safekeeping Customer Number
      *****************************************************************
     C     ValCUST       BEGSR
      *
      ** Validation
      *
     C                   CALLB     'AOSECSR0'                                   Question mark
     C                   PARM      *Blanks       @RtCd                                and
     C                   PARM      '*KEY'        @Optn                          Look for Classif.
     C                   PARM      DDCUST        @Cust             6
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C                   IF        @RtCd <> *Blanks OR
     C                             (BFCLAS <> 'S' AND BFCLAS <> 'D' AND
     C                              BFCLAS <> 'M' AND BFCLAS <> 'X' AND
     C                              BFCLAS <> 'E' AND BFCLAS <> 'C')
     C                   EVAL      DDCUSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDCUST'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00059'
     C                   GOTO      EVlCUST
     C                   ELSE
     C                   EVAL      DDCUST = BFCUST
     C                   ENDIF
      *
     C                   EXSR      CUSTDesc                                     Valid Cust No
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DDCUSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDCUST'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00059'
     C                   GOTO      EVlCUST
     C                   ENDIF
      *
     C                   MOVE      DDCUST        CP_CSCN                        Look if
     C                   IF        BFCLAS = 'S' OR  BFCLAS = 'D'
     C*****CP_CSCN       SETLL     CPOSNDF                                        originating
     C*****CP_CSCN       READE     CPOSNDF                                        branch
      *****                                                                       has a
     C*****              DOW       NOT %EoF(CPOSCS) AND CP_CSBA <> DDORIG         position
     C*****CP_CSCN       READE     CPOSNDF                                        for the
     C*****              ENDDO                                                    customer
      *****
     C*****              IF        %EoF(CPOSCS)                                 Warning if not
     C     CP_CSCN       SETLL     CPOSNDF                                        originating
     C                   IF        NOT %EQUAL(CPOSCS)
     C     WIdx          COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             WIdx
     C   99              EVAL      WFldNamArr(WIdx) = 'DDCUST'
     C   99              EVAL      WMsgIDArr(WIdx)  = 'ST00060'
     C                   ENDIF
     C                   ELSE
     C     CP_CSCN       SETLL     DPOSNL2
     C                   IF        NOT %EQUAL(DPOSNL2)
     C     WIdx          COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             WIdx
     C   99              EVAL      WFldNamArr(WIdx) = 'DDCUST'
     C   99              EVAL      WMsgIDArr(WIdx)  = 'ST00060'
     C                   ENDIF
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPCUST = DDCUST
      *
     C     EVlCUST       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * CUSTDesc - Retrieve the Safekeeping Customer Report Name
      *****************************************************************
     C     CUSTDesc      BEGSR
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      DDCUST        @Key1            10
     C                   PARM      *Blanks       @Kyst             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd = *Blanks
     C                   EVAL      DDCRNM = BBCRNM
     C                   ELSE
     C                   EVAL      DDCRNM = *Blanks
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValTYPE - Validate Type of Statement
      *****************************************************************
     C     ValTYPE       BEGSR
      *
      ** Question mark
      *
     C                   IF        %Scan('?':DDTYPE) > 0
     C                   CALL      'Y2VLLSR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215000       @Y2LS
     C                   PARM      *Blanks       @INVL
      *
     C                   IF        @RtCd  = *Blanks
     C                   EVAL      DDTYPE = @INVL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215000       @Y2LS
     C                   PARM      DDTYPE        @INVL
     C                   PARM      *Blank        @VLMP
     C     DDSTNM        PARM                    @TEXT
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DDSTNM = *BLANKS
     C                   EVAL      DDTYPEOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDTYPE'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00010'
     C                   GOTO      EVlTYPE
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPTYPE = DDTYPE
      *
     C     EVlTYPE       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValFREQ - Validate Frequency
      *****************************************************************
     C     ValFREQ       BEGSR
      *
      ** Default value
      *
     C                   IF        DDFREQ = *BLANKS
     C                   EVAL      DDFREQ = 'Z'
     C                   ENDIF
      *
      ** Question mark
      *
     C                   IF        DDFREQ = '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215001       @Y2LS
     C                   PARM      *Blanks       @INVL
      *
     C                   IF        @RtCd  = *Blanks
     C                   EVAL      DDFREQ = @INVL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215001       @Y2LS
     C                   PARM      DDFREQ        @INVL
     C                   PARM      *Blank        @VLMP
     C     DDFRNM        PARM                    @TEXT
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DDFRNM = *BLANKS
     C                   EVAL      DDFREQOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDFREQ'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00011'
     C                   GOTO      EVlFREQ
     C                   ENDIF
      *
     C                   IF        DDCANC <> *Blanks AND DDFREQ <> 'Z'
     C                   EVAL      DDFREQOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDFREQ'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00071'
     C                   GOTO      EVlFREQ
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPFREQ = DDFREQ
      *
     C     EVlFREQ       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValRECP - Validate Recipient (May be a BIC code)
      *****************************************************************
     C     ValRECP       BEGSR
      *
      ** Default value
      *
     C                   IF        DDRECP = *Blanks AND DDCUSTOK = 'Y'
     C                   EVAL      DDRECP = DDCUST
     C                   ENDIF
      *
      ** Question mark
      *
     C                   IF        %Scan('?':DDRECP) > 0
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      '?'           @Key1
     C                   PARM      *Blanks       @Kyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      DDRECP = BBCUST
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation
      *
     C                   MOVEL     DDRECP        @BICC
     C                   MOVE      DDRECP        @BICB
      *
     C                   CLEAR                   SDCUST
     C                   CLEAR                   SDCNST
     C                   CLEAR                   MEBICD
      *
     C                   CALL      'ME1400'
     C                   PARM      *Blanks       @RtCd
     C                   PARM                    @BICC             8
     C                   PARM                    @BICB             3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *Blanks       @ICUST            1
     C                   PARM      *Blanks       @ICNST            1
     C                   PARM      *Blanks       @IBICD            1
      *
 B1  C                   SELECT
 X1  C                   WHEN      @ICUST = 'Y'
     C                   EVAL      DDRECP = BBCUST
     C                   EVAL      DDRCNM = BBCRNM
     C                   MOVEL     BBCSID        RecpSwftAddr     12
      *
 X1  C                   WHEN      @IBICD = 'Y'
     C                   EVAL      DDRECP = BDBICC + BDBICB
     C                   EVAL      DDRCNM = BDINS1
     C                   EVAL      RecpSwftAddr = DDRECP
      *
 X1  C                   OTHER
     C                   CALLB     'AOCUSTR0'                                   May be a
     C                   PARM      *Blanks       @RtCd                            shortname
     C                   PARM      '*KEY'        @Optn
     C                   PARM      DDRECP        @Key1
     C                   PARM      *Blanks       @Kyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B2  C                   IF        @RtCd = *BLANKS
     C                   EVAL      DDRECP = BBCUST
     C                   EVAL      DDRCNM = BBCRNM
     C                   MOVEL     BBCSID        RecpSwftAddr
 X2  C                   ELSE
     C                   EVAL      DDRCNM = *Blanks
     C                   EVAL      RecpSwftAddr = *Blanks
     C                   EVAL      DDRECPOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDRECP'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00061'
     C                   GOTO      EVlRECP
 E2  C                   ENDIF
      *
 E1  C                   ENDSL
      *
      ** Field is valid
      *
     C                   EVAL      VSPRECP = DDRECP
      *
     C     EVlRECP       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValMSTD - Validate Start Date
      *****************************************************************
     C     ValMSTD       BEGSR
      *
      ** Default value
      *
     C                   IF        DDMSTD = *Blanks
     C                   EVAL      DDMSTD = DftDate
     C                   ENDIF
      *
      ** Validation
      *
     C  N98*DMY0         TEST(DE)                DDMSTD
     C   98*MDY0         TEST(DE)                DDMSTD
      *
     C                   IF        %Error
     C                   EVAL      DDMSTDOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDMSTD'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00012'
     C                   GOTO      EVlMSTD
     C                   ENDIF
      *
      ** Field is valid
      *
     C  N98*DMY0         MOVE      DDMSTD        WkDate
     C   98*MDY0         MOVE      DDMSTD        WkDate
     C     WkDate        SUBDUR    StartDate     VSPMSTD:*D
      *
     C     EVlMSTD       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSTTM - Validate Start Time
      *****************************************************************
     C     ValSTTM       BEGSR
      *
      ** Validation
      *
     C                   IF        DDSTTM <> *Blanks OR
     C                             (DDTYPE = 'MF' AND DDENTM <> *Blanks)
     C     *ISO0         TEST(ET)                DDSTTM
      *
     C                   IF        %Error
     C                   EVAL      DDSTTMOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSTTM'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00013'
     C                   GOTO      EVlSTTM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   IF        DDSTTM <> *Blanks
     C                   MOVE      DDSTTM        VSPSTTM
     C                   ELSE
     C                   MOVE      0             VSPSTTM
     C                   ENDIF
      *
     C     EVlSTTM       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValDAYM - Validate Day in Month
      *****************************************************************
     C     ValDAYM       BEGSR
      *
      ** Default value:
      ** For frequencies "M" and "Y" only, use the day of the start date unless
      ** it is the last working day of the month. In this case, use "31".
      *
 B1  C                   IF        DDDAYM = *Blanks AND
     C                             (DDFREQ = 'M' OR DDFREQ = 'Y') AND
     C                             DDMSTDOK = 'Y'
      *
 B2  C                   IF        (NOT *IN98 AND %Subst(NextWkDate:3:2) <>     Compare month values
     C                                                      %Subst(DDMSTD:3:2))   (i.e if different,
     C                                                  OR                         start date is
     C                             (*IN98 AND %Subst(NextWkDate:1:2) <>            the last working
     C                                                      %Subst(DDMSTD:1:2))    day of the month)
     C                   EVAL      DDDAYM = '31'
 X2  C                   ELSE
     C  N98              EVAL      DDDAYM = %Subst(DDMSTD:1:2)
     C   98              EVAL      DDDAYM = %Subst(DDMSTD:3:2)
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Validation
      *
     C                   IF        (DDDAYM = *Blanks AND
     C                              (DDFREQ = 'M' OR DDFREQ = 'Y'))
     C                                            OR
     C                             (DDDAYM <> *Blanks AND
     C                              (DDFREQ <> 'M' AND DDFREQ <> 'Y'))
     C                   EVAL      DDDAYMOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDDAYM'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00062'
     C                   GOTO      EVlDAYM
     C                   ENDIF
      *
 B1  C                   IF        DDDAYM <> *Blanks
      *
 B2  C                   IF        %Subst(DDDAYM:1:1) = *Blank
     C                   EVAL      %Subst(DDDAYM:1:1) = '0'
 E2  C                   ENDIF
      *
 B2  C                   IF        %Subst(DDDAYM:2:1) = *Blank
     C                   EVAL      %Subst(DDDAYM:2:1) = %Subst(DDDAYM:1:1)
     C                   EVAL      %Subst(DDDAYM:1:1) = '0'
 E2  C                   ENDIF
      *
     C                   MOVEL     DDDAYM        WTEST3            3
     C                   MOVE      0             WTEST3
     C                   TESTN                   WTEST3               99
      *
 B2  C                   IF        NOT *IN99 OR
     C                             DDDAYM < '01' OR DDDAYM > '31'
     C                   EVAL      DDDAYMOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDDAYM'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00063'
     C                   GOTO      EVlDAYM
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Field is valid
      *
     C                   IF        DDDAYM <> *Blanks
     C                   MOVE      DDDAYM        VSPDAYM
     C                   ELSE
     C                   MOVE      0             VSPDAYM
     C                   ENDIF
      *
     C     EVlDAYM       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValMETD - Validate End Date
      *****************************************************************
     C     ValMETD       BEGSR
      *
      ** Default value
      *
     C                   IF        DDMETD = *Blanks AND DDTYPE = 'MF' AND
     C                             DDMSTDOK = 'Y'
     C                   EVAL      DDMETD = DDMSTD
     C                   ENDIF
      *
      ** Validation
      *
 B1  C                   IF        DDTYPE <> 'MF'
      *
 B2  C                   IF        DDMETD <> *Blanks
     C                   EVAL      DDMETDOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDMETD'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00014'
     C                   GOTO      EVlMETD
 E2  C                   ENDIF
      *
 X1  C                   ELSE
     C  N98*DMY0         TEST(DE)                DDMETD
     C   98*MDY0         TEST(DE)                DDMETD
      *
 B2  C                   IF        %Error
     C                   EVAL      DDMETDOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDMETD'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00015'
     C                   GOTO      EVlMETD
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      *
      ** Field is valid
      *
     C                   IF        DDMETD <> *Blanks
     C  N98*DMY0         MOVE      DDMETD        WkDate
     C   98*MDY0         MOVE      DDMETD        WkDate
     C     WkDate        SUBDUR    StartDate     VSPMETD:*D
     C                   ELSE
     C                   MOVE      0             VSPMETD
     C                   ENDIF
      *
     C     EVlMETD       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValENTM - Validate End Time
      *****************************************************************
     C     ValENTM       BEGSR
      *
      ** Validation
      *
 B1  C                   IF        DDTYPE <> 'MF'
      *
 B2  C                   IF        DDENTM <> *Blanks
     C                   EVAL      DDENTMOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDENTM'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00016'
     C                   GOTO      EVlENTM
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
 B2  C                   IF        DDENTM <> *BLANKS
     C                             OR DDSTTM <> *BLANKS
     C     *ISO0         TEST(ET)                DDENTM
      *
 B3  C                   IF        %Error
     C                   EVAL      DDENTMOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDENTM'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00017'
     C                   GOTO      EVlENTM
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
 B1  C                   IF        DDTYPE = 'MF'  AND DDMSTDOK = 'Y' AND
     C                             DDSTTMOK = 'Y' AND DDMETDOK = 'Y'
     C                   MOVEL     VSPMSTD       WkDatTimD
     C                   MOVE      DDSTTM        WkDatTimD
     C                   MOVEL     VSPMETD       WkDatTimF
     C                   MOVE      DDENTM        WkDatTimF
      *
 B2  C                   IF        WkDatTimD > WkDatTimF
     C                   EVAL      DDMSTDOK = 'N'
     C                   EVAL      DDSTTMOK = 'N'
     C                   EVAL      DDMETDOK = 'N'
     C                   EVAL      DDENTMOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDMSTD'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00018'
     C                   GOTO      EVlENTM
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Field is valid
      *
     C                   IF        DDENTM <> *Blanks
     C                   MOVE      DDENTM        VSPENTM
     C                   ELSE
     C                   MOVE      0             VSPENTM
     C                   ENDIF
      *
     C     EVlENTM       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValNSTD - Validate Next Statement Date
      *****************************************************************
     C     ValNSTD       BEGSR
      *
      ** Default value: the greatest between start date and run date,
      **                taking into account "day in month" value
      *
 B1  C                   IF        DDNSTD = *Blanks AND DDMSTDOK = 'Y'
     C                                              AND DDDAYMOK = 'Y'
      *
 B2  C                   IF        VSPMSTD > BJRDNB
     C                   EVAL      DDNSTD = DDMSTD
 X2  C                   ELSE
     C                   EVAL      DDNSTD = DftDate
 E2  C                   ENDIF
      *
 B2  C                   IF        DDDAYM <> *Blanks                            Day in month<>Blank
     C                   EVAL      X = 0
      *
 B3  C                   DOU       NOT %Error                                   Resulting
     C                   EVAL      WDay = VSPDAYM - X                             date
     C                   MOVE      WDay          WxDay                            may
      *                                                                           be
     C  N98              EVAL      %Subst(DDNSTD:1:2) = WxDay                     greater
     C   98              EVAL      %Subst(DDNSTD:3:2) = WxDay                     than
      *                                                                           end
     C  N98*DMY0         TEST(DE)                DDNSTD                           of
     C   98*MDY0         TEST(DE)                DDNSTD                           month,
      *                                                                           so
 B4  C                   IF        %Error                                         gradually
     C                   EVAL      X = X + 1                                      decrease
 E4  C                   ENDIF                                                    it
      *
 E3  C                   ENDDO
      *
 E2  C                   ENDIF
      *
     C  N98*DMY0         MOVE      DDNSTD        WkDate
     C   98*MDY0         MOVE      DDNSTD        WkDate
     C     WkDate        SUBDUR    StartDate     WkDateM:*D
      *
 B2  C                   IF        WkDateM < BJRDNB
     C                   EVAL      DDNSTD = DftDate
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Validation
      *
     C  N98*DMY0         TEST(DE)                DDNSTD
     C   98*MDY0         TEST(DE)                DDNSTD
      *
     C                   IF        NOT %Error
     C  N98*DMY0         MOVE      DDNSTD        WkDate
     C   98*MDY0         MOVE      DDNSTD        WkDate
     C     WkDate        SUBDUR    StartDate     WkDateM:*D
     C                   ENDIF
 
     C                   IF        %Error OR WkDateM < BJRDNB
     C                   EVAL      DDNSTDOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNSTD'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00064'
     C                   GOTO      EVlNSTD
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   IF        DDNSTD <> *Blanks
     C                   EVAL      VSPNSTD = WkDateM
     C                   ELSE
     C                   MOVE      0             VSPNSTD
     C                   ENDIF
      *
     C     EVlNSTD       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValNSTT - Validate Next Statement Time
      *****************************************************************
     C     ValNSTT       BEGSR
      *
      ** Validation
      *
     C                   IF        DDNSTT <> *Blanks
     C     *ISO0         TEST(ET)                DDNSTT
      *
     C                   IF        %Error
     C                   EVAL      DDNSTTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNSTT'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00065'
     C                   GOTO      EVlNSTT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   IF        DDNSTT <> *Blanks
     C                   MOVE      DDNSTT        VSPNSTT
     C                   ELSE
     C                   MOVE      0             VSPNSTT
     C                   ENDIF
      *
     C     EVlNSTT       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValSESN - Validate Security Shortname
      *****************************************************************
     C     ValSESN       BEGSR
      *
      ** Question mark
      *
     C                   IF        %Scan('?':DDSESN) > *ZEROS
     C                   CALL      'SE0043'
     C                   PARM      *Blanks       @AcCd             1
     C                   PARM                    DDSESN
     C                   ENDIF
      *
      ** Validation
      *
     C                   IF        DDSESN <> *Blanks
     C     DDSESN        CHAIN     SECTYDF
      *
     C                   IF        NOT %Found(SECTY)
     C                   EVAL      DDSRPN = *Blanks
     C                   EVAL      DDSESNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSESN'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00023'
     C                   GOTO      EVlSESN
     C                   ELSE
     C                   EVAL      DDSRPN = SEC_SRPN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPSESN = DDSESN
      *
     C     EVlSESN       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValNWRK - Validate Network
      *****************************************************************
     C     ValNWRK       BEGSR
      *
      ** Default value
      *
     C                   IF        DDNWRK = *Blanks
      *
     C                   IF        SndrSwftAddr <> *Blanks And
     C                             RecpSwftAddr <> *Blanks
     C                   EVAL      DDNWRK = 'SWIFT'
     C*********          ELSE                                                                 217892
     C*********          EVAL      DDNWRK = 'PAPER'                                           217892
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation
      ***--*Network*must be "SWIFT" or "PAPER"                                                217892
      ** -- Network must be a valid network  "                                                217892
      *
     C                   CALL      'AONWRKR0'                                   Question mark 217892
     C                   PARM      *Blanks       @RtCd                                and     217892
     C                   PARM      '*KEY'        @Optn                          Verification  217892
     C                   PARM      DDNWRK        @Nwrk             6                          217892
     C     SDNWRK        PARM      SDNWRK        DSFDY                                        217892
      *                                                                                       217892
     C**********         IF        DDNWRK <> 'SWIFT' AND DDNWRK <> 'PAPER'                    217892
     C                   IF        @RtCd <> *Blanks                                           217892
     C                   EVAL      DDNWRKOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDNWRK'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00066'
     C                   GOTO      EVlNWRK
     C                   ELSE                                                                 217892
     C                   EVAL      DDNWRK = EDNWRK                                            217892
     C                   ENDIF
      *
      ** -- When "SWIFT", the sending branch must have a TID Address
      *
     C                   IF        DDNWRK = 'SWIFT' AND
     C                             SndrSwftAddr = *Blanks
     C                   EVAL      DDSNDROK = 'N'
     C                   EVAL      DDNWRKOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDSNDR'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00067'
     C                   ENDIF
      *
      ** -- When "SWIFT", the recipient must have a SWIFT addresss
      *
     C                   IF        DDNWRK = 'SWIFT' AND
     C                             RecpSwftAddr = *Blanks
     C                   EVAL      DDRECPOK = 'N'
     C                   EVAL      DDNWRKOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDRECP'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00068'
     C                   ENDIF
      *
      ***--*When*"PAPER", the recipient must be a valid Customer                              217892
      ********                                                                                217892
     C********           IF        DDNWRK = 'PAPER' AND                                       217892
     C********                     (%Subst(DDRECP:1:1) < '0' OR                               217892
     C********                      %Subst(DDRECP:1:1) > '9')                                 217892
     C********           EVAL      DDRECPOK = 'N'                                             217892
     C********           EVAL      DDNWRKOK = 'N'                                             217892
     C*****Idx           COMP      ArrayMax                             99      -Lower-       217892
     C***99***           ADD       1             Idx                                          217892
     C***99***           EVAL      FldNameArr(Idx) = 'DDRECP'                                 217892
     C***99***           EVAL      MsgIdArr(Idx)   = 'ST00069'                                217892
     C********           ENDIF                                                                217892
      *
      ** Field is valid
      *
     C                   EVAL      VSPNWRK = DDNWRK
      *
     C     EVlNWRK       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValR549 - Validate Related MT549 Message
      *****************************************************************
     C     ValR549       BEGSR
      *
      ** Validation
      *
      **                 >>  (No validations to do)  <<
      *
      ** Field is valid
      *
     C                   EVAL      VSPR549 = DDR549
      *
     C     EVlR549       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValCANC - Validate Message to Cancel
      *****************************************************************
     C     ValCANC       BEGSR
      *
      ** Validation
      *
     C                   IF        DDCANC <> *Blanks
     C     DDCANC        SETLL     SESTHSD0
      *
     C                   IF        NOT %Equal(SESTHSL0)
     C                   EVAL      DDCANCOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DDCANC'
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00070'
     C                   GOTO      EVlCANC
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field is valid
      *
     C                   EVAL      VSPCANC = DDCANC
      *
     C     EVlCANC       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValFile - Validate File Keys Consistency
      *****************************************************************
     C     ValFile       BEGSR
      *
      ***The*partial key of SESTPRL2 must exist only once, except
      ***for*"Z"*and "I" frequencies
      ***********
     C***********        IF        VSPFREQ <> 'I' AND VSPFREQ <> 'Z'
     C*****KSESTPRL2     SETLL     SESTPRD2
      ***********
     C***********        IF        %Equal(SESTPRL2)
     C***********        EVAL      DDCUSTOK = 'N'
     C***********        EVAL      DDTYPEOK = 'N'
     C***********        EVAL      DDSNDROK = 'N'
     C***********        EVAL      DDRECPOK = 'N'
     C***********        EVAL      DDFREQOK = 'N'
     C*****Idx***        COMP      ArrayMax                             99      -Lower-
     C***99******        ADD       1             Idx
     C***99******        EVAL      FldNameArr(Idx) = 'DDCUST'
     C***99******        EVAL      MsgIdArr(Idx)   = 'ST00072'
     C***********        ENDIF
      ***********
     C***********        ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initializations                                        *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Valid file keys in Insert mode
      ** The sequence number will be correctly set up by the UPD module
      *
 B1  C                   IF        DDACTN = 'I'
     C                   EVAL      VSPDATE = BJRDNB
     C                   EVAL      VSPRSEQ = 9999999
 E1  C                   ENDIF
      *
      /COPY WNCPYSRC,SESTPRV043
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** SESTPR Transaction Details in screen format
     C                   PARM                    StPRScnIFld
      ** SESTPR Output only Screen Fields
     C                   PARM                    StPRScnOFld
      ** Current SESTPR Transaction Details in screen format
     C                   PARM                    CurStPRIFld
      ** Calling Module Code (*SIN, *RPR, etc...)
     C                   PARM                    CallerCode        4
      *
      ** OUTPUT PARAMETERS
      ** SESTPR Transaction Details OK indicators
     C                   PARM                    StPROkFlags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** New Statement Production Request in file format from/to caller
     C                   PARM                    NewSEStPR
      *
      ** Define KLIST's
      *
     C     KSESTPRL2     KLIST
     C                   KFLD                    VSPCUST
     C                   KFLD                    VSPTYPE
     C                   KFLD                    VSPSNDR
     C                   KFLD                    VSPRECP
     C                   KFLD                    VSPFREQ
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BJDFIN        COMP      'M'                                    98
      *
      ** Default Date in Screen format
      *
     C     StartDate     ADDDUR    BJRDNB:*D     WkDate
     C  N98*DMY0         MOVE      WkDate        DftDate
     C   98*MDY0         MOVE      WkDate        DftDate
      *
      ** Next Working Date in Screen format
      *
     C     Startdate     ADDDUR    BJDNWD:*D     WkDate
     C  N98*DMY0         MOVE      WkDate        NextWkDate
     C   98*MDY0         MOVE      WkDate        NextWkDate
      *
      ** Retrieve the user's defaults
      *
     C**********         IN        ZMUSER                                                    BUG8550
      *
      /COPY WNCPYSRC,SESTPRV044
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
