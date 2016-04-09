     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment validation')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFAMDVAL -  Facility Amendment Validation                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002'           *
      *                                                               *
      *  Last Amend No. MD024398           Date 11May14               *
      *  Prev Amend No. AR693564           Date 08Oct12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR819417           Date 24Aug11               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 07Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6318            Date 18Mar05               *
      *                 CLE041             Date 11Oct04               *
      *                 BUG5592            Date 31Jan05               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 24Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071  *CREATE    Date 11Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024398 - API Performance Optimisation                      *
      *  AR693564 - API: LEFAMD duplicate amend sequence record in    *
      *             LEVFAMDPD. Duplicate SeqNo use when updater       *
      *             DBU_FAMD is Held. Check also the SeqNo of records *
      *             from valid files. LF build from LEVFAMDPD         *
      *             (Child: AR693565).                                *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  AR819417 - Delayed display of warning message                *
      *             (Child:AR819418)                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00239                                 *
      *             WNCPYSRC,LEH00240                                 *
      *             WNCPYSRC,LEH00241                                 *
      *             WNCPYSRC,LEH00242                                 *
      *             WNCPYSRC,LEH00243                                 *
      *             WNCPYSRC,LEH00244                                 *
      *             WNCPYSRC,LEH00245                                 *
      *             WNCPYSRC,LEH00246                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSC024 - Open Month End                                      *
      *  BUG6318- Move check on ZMUSER out of *INZSR                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  BUG5592- When the Facility Decrease is more than the         *
      *           Available Amount, send a warning message and not an *
      *           error message.(218732) Also do not skip this        *
      *           processing if user is a java user                   *
      *  CLE025 - Credit Lines                                        *
      *  CAP084 - MidasPlus changes                                   *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as API's.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Facility amendments
     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMQ1)
     F                                     PREFIX(SQ)
                                                                                              CLE041
     FLEAGAML3  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMD3)                          CLE041
     F                                     PREFIX(SQ)                                         CLE041
 
     FLEFCAML6  IF   E           K DISK    INFSR(*PSSR)
                                                                                              CLE041
     FLEAGAML2  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMD4)                          CLE041
     F/COPY WNCPYSRC,LEH00239
 
     FLEVFAMDL2 IF   E           K DISK    INFSR(*PSSR)                                     AR693564
     F                                     PREFIX(SQ)                                       AR693564
      ** Logical file for  LEVFAMDPD                                                        AR693564
      *                                                                                     AR693564
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
 
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Facility Amendment Details in screen format
     D FAMD          E DS                  EXTNAME(LEFAMDPD)
 
      ** Facility Amendment Details in file format
     D VFAMD         E DS                  EXTNAME(LEVFAMDPD)
 
      ** Facility Amendment Details OK indicator
     D FAMD_OK       E DS                  EXTNAME(LEEFAMDPD)
 
      * Facility run dates
     D  @RUNA          DS
     D  @RUN                   1     50  0
     D                                     DIM(10)
 
      * Facility drawn amounts
     D  @OAMA          DS
     D  @OAM                   1    130  0
     D                                     DIM(10)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer lending details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
                                                                                             CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    CAP084
      ** Java user information                                                               CAP084
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CLE106          S              1A   INZ('N')                                           CLE106
     D CSC011          S              1A   INZ('N')
     D CLE025          S              1A   INZ('N')                                           CLE041
     D WProcDate       S                   LIKE(BJRDNB)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
     D PRetCode        S              7A                                                      CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                              CSC024
     D wSeqFlag        S              1A                                                    MD024398
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
 
      ** Clear output fields
 
     C                   Z-ADD     *ZERO         W#AAMT
 
     C                   MOVEL     *ALL'Y'       FAMD_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
                                                                                            AR819417
      ** If the user is connected via a browser, the job user name                          AR819417
      ** is QUSER their user name is stored in ZMUSER                                       AR819417
                                                                                            AR819417
     C                   IN        ZMUSER                                                   AR819417
                                                                                              CAP084
     ** Only clear warning error fields if not coming from MidasPlus                          CAP084
                                                                                              CAP084
     C     USRID         IFEQ      *BLANKS                                                    CAP084
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   ENDIF                                                                CAP084
      *****************************************************************             BUG6318 AR819417
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER -        BUG6318 AR819417
      **their*user*name*is*stored*in*ZMUSER****************************             BUG6318 AR819417
     C**********         IN        ZMUSER                                           BUG6318 AR819417
      *
      * Validate Amendment Currency
      *
     C                   EXSR      VLACCY
      *
      * Validate Amendment Amount
      *
     C                   EXSR      VLAAMT
      *
      * Validate Revolving Credit indicator
      *
     C                   EXSR      VLRVCR
      *
      * Validate New Expiry Date
      *
     C                   EXSR      VLNDEX
     C/COPY WNCPYSRC,LEH00240
 
      * Set fields on insert
 
     C     S#ACTN        IFEQ      'I'
     C                   EXSR      SETF_I
     C                   ENDIF
 
      * Set fields on amend
 
     C     S#ACTN        IFEQ      'A'
     C                   EXSR      SETF_A
     C                   ENDIF
 
      * Set fields on delete
 
     C     S#ACTN        IFEQ      'D'
     C                   EXSR      SETF_A
     C                   ENDIF
 
     C     ENDVAL        TAG
 
     C                   RETURN
      *
     C/COPY WNCPYSRC,LEH00241
      /SPACE 5
      *****************************************************************
      * Validate Amendment Currency
      *****************************************************************
     C     VLACCY        BEGSR
 
      * The currency must exist
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      S#ACCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           S#ACCYok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACCY    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0018'     MsgIdArr(Ix)
     C                   ELSE
 
      * The currency must be the same as the facility currency
 
     C                   MOVEL     A6CYCD        S#ACCY
 
     C     S#ACCY        IFNE      FccyFCCY
     C                   MOVE      'N'           S#ACCYok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACCY    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0201'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Amendment Amount
      *****************************************************************
     C     VLAAMT        BEGSR
 
      ** For amendment type FR, default the amendment amount to the
      ** available absolute amount at expiry (setting the sign accordingly)
 
     C     S#FATP        IFEQ      'FR'
     C     S#AAMT        ANDEQ     *BLANKS
 
     C     W#FAMTSV      IFLT      0
     C                   Z-SUB     W#FAMTSV      W#AAMT
     C                   MOVE      '-'           S#SIGN
     C                   ELSE
     C                   Z-ADD     W#FAMTSV      W#AAMT
     C                   MOVE      '+'           S#SIGN
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      W#AAMT        ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        S#AAMT
 
     C                   ENDIF
 
      * For amendment types FI and FD, amount must be defined
 
     C     S#FATP        IFEQ      'FI'
     C     S#FATP        OREQ      'FD'
     C     S#AAMT        IFEQ      *BLANKS
     C                   MOVE      'N'           S#AAMTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#AAMT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0202'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      * For amendment types RC, amount mustn't be defined
 
     C     S#FATP        IFEQ      'RC'
     C     S#AAMT        IFNE      *BLANKS
     C                   MOVE      'N'           S#AAMTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#AAMT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0203'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00242
 
      * If amendment amount is OK so far, check it is a valid amount
 
     C     S#AAMTok      IFEQ      'Y'
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#AAMT        ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
     C     13            SUB       ZADEC         ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           S#AAMTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#AAMT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0204'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        W#AAMT
 
      ** Reformat amount field if valid                                                       CLE025
     C     S#FATP        IFEQ      'FD'                                                       CLE025
     C                   MOVE      *BLANKS       ZFIELD                                       CLE025
     C                   MOVE      W#AAMT        ZFIELD                                       CLE025
     C                   Z-ADD     FccyNBDP      ZADEC                                        CLE025
     C                   EXSR      ZEDIT                                                      CLE025
     C                   MOVE      ZFIELD        S#AAMT                                       CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ENDIF
 
      * For amendment types FI and FD, amount must not be zero
 
     C     S#FATP        IFEQ      'FI'
     C     S#FATP        OREQ      'FD'
     C     S#AAMTok      IFEQ      'Y'
     C     W#AAMT        ANDEQ     *ZERO
     C                   MOVE      'N'           S#AAMTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#AAMT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0202'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
      ** For facility decreases check that
      ** the available amount is not exceeded by the decrease
 
     C     S#AAMTok      IFEQ      'Y'
     C     S#FATP        ANDEQ     'FD'
     C     A5GASS        ANDNE     'A'
     C*****PSJobName     ANDNE     'QZDASOINIT'                                       CLE025 BUG5592
      *
     C                   Z-ADD     *ZERO         W#AVAIL          13 0
     C                   Z-ADD     1             WI                3 0
      *
     C     WI            DOWLE     10
     C     W#FAMTSV      SUB       @OAM(WI)      W#AVAIL
     C     @RUN(WI)      IFGE      W#VLDT
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             WI
     C                   ENDDO
      *
     C     W#VLDT        IFLT      @RUN(1)
     C     W#FAMTSV      SUB       @OAM(1)       W#AVAIL
     C                   ENDIF
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
     C                   Z-ADD     *ZERO         K#VLDT
     C                   Z-ADD     *ZERO         K#SQNO
 
     C                   IF        CLE025 = 'Y'  AND                                          CLE041
     C                             FctrTRCA = 'AG'                                            CLE041
                                                                                              CLE041
     C     FCAMK         SETLL     LEAGAML2                                                   CLE041
     C                   MOVE      S#SQNO        K#SQNO                                       CLE041
     C     FCAMKP        READE     LEAGAML2                               80                  CLE041
                                                                                              CLE041
     C                   ELSE                                                                 CLE041
                                                                                              CLE041
     C     FCAMK         SETLL     LEFCAML6
     C                   MOVE      S#SQNO        K#SQNO
     C     FCAMKP        READE     LEFCAML6                               80
                                                                                              CLE041
     C                   ENDIF                                                                CLE041
      *
     C     *IN80         DOWEQ     *OFF
     C     VLDT          ANDLE     W#VLDT
      *
     C     FATP          IFEQ      'FI'
     C                   ADD       AAMT          W#AVAIL
     C                   ENDIF
      *
     C     FATP          IFEQ      'FD'
     C     VLDT          IFNE      W#VLDT
     C     SQNO          ORNE      K#SQNO
     C                   SUB       AAMT          W#AVAIL
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        CLE025 = 'Y'  AND                                          CLE041
     C                             FctrTRCA = 'AG'                                            CLE041
     C     FCAMKP        READE     LEAGAML2                               80                  CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMKP        READE     LEFCAML6                               80
     C                   ENDIF                                                                CLE041
     C                   ENDDO
      *
     C     W#AAMT        IFGT      W#AVAIL
     C                   MOVE      'N'           S#AAMTok
     C**********         ADD       1             Ix                                          BUG5592
     C**********         MOVEL     'S#AAMT    '  FldNameArr(Ix)                              BUG5592
     C**********         MOVEL     'LEF0205'     MsgIdArr(Ix)                                BUG5592
     C                   ADD       1             Wx                                          BUG5592
     C                   MOVEL     'S#AAMT    '  WFldNamArr(Wx)                              BUG5592
     C                   MOVEL     'LEF0325'     WMsgIDArr(Wx)                               BUG5592
     C                   ENDIF
      *
     C                   ENDIF
 
      * Validate amendment amount sign
 
     C     S#FATP        IFEQ      'FR'
     C     S#SIGN        ANDNE     ' '
     C     S#SIGN        ANDNE     '-'
     C     S#SIGN        ANDNE     '+'
     C     S#FATP        ORNE      'FR'
     C     S#SIGN        ANDNE     ' '
     C                   MOVE      'N'           S#SIGNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SIGN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0326'     MsgIdArr(Ix)
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Revolving Credit indicator
      *****************************************************************
     C     VLRVCR        BEGSR
 
      * If the amendment type is 'RC',
      * the revolving credit indicator must be defined
 
     C     S#FATP        IFEQ      'RC'
      *
     C                   SELECT
      *
     C     CLE014        WHENEQ    'Y'
     C     FctrTRCA      ANDEQ     'CA'
     C     CLE014        OREQ      'Y'                                                        CLE041
     C     CLE025        ANDEQ     'Y'                                                        CLE041
     C     FctrTRCA      ANDEQ     'AG'                                                       CLE041
     C     S#RVCR        IFNE      'Y'
     C     S#RVCR        ANDNE     'N'
     C     S#RVCR        ANDNE     'T'
     C                   MOVE      'N'           S#RVCRok
     C                   ADD       1             Ix
     C                   MOVEL     'S#RVCR    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0351'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   OTHER
      *
     C     S#RVCR        IFNE      'Y'
     C     S#RVCR        ANDNE     'N'
     C                   MOVE      'N'           S#RVCRok
     C                   ADD       1             Ix
     C                   MOVEL     'S#RVCR    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0206'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDSL
 
      * If the revolving credit indicator is ok so far,
      * issue a warning if the revolving credit indicator
      * differs from that on the facility
 
     C     S#RVCRok      IFEQ      'Y'
     C     S#RVCR        ANDEQ     FcrvRVCR
     C                   MOVE      'W'           S#RVCRok
     C                   ADD       1             Wx
     C                   MOVEL     'S#RVCR    '  WFldNamArr(Wx)
     C                   MOVEL     'LEF0236'     WMsgIDArr(Wx)
     C                   ENDIF
      *
     C                   ELSE
 
      * Otherwise the revolving credit indicator must be blank
 
     C     S#RVCR        IFNE      *BLANKS
     C                   MOVE      'N'           S#RVCRok
     C                   ADD       1             Ix
     C                   MOVEL     'S#RVCR    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0207'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate New Expiry Date
      *****************************************************************
     C     VLNDEX        BEGSR
 
      * Expiry date is mandatory for amendment type FR
 
     C     S#FATP        IFEQ      'FR'
 
      * New expiry date can't be blank or an invalid date
 
     C     S#NDEX        IFEQ      *BLANKS
     C                   MOVE      'N'           S#NDEXok
     C                   ADD       1             Ix
     C                   MOVEL     'S#NDEX    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0208'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#NDEX        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           S#NDEXok
     C                   ADD       1             Ix
     C                   MOVEL     'S#NDEX    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0210'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        W#NDEX            5 0
     C                   ENDIF
      *
     C                   ENDIF
 
      * If the new expiry date is ok so far
      * if can't be prior to the current facility expiry/closure date
 
     C     S#NDEXok      IFEQ      'Y'
     C     fcRECI        IFEQ      'E'
     C     W#NDEX        ANDLT     fcDTEX
     C     FcRECI        OREQ      'C'
     C     W#NDEX        ANDLT     fcCDTE
     C                   MOVE      'N'           S#NDEXok
     C                   ADD       1             Ix
     C                   MOVEL     'S#NDEX    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0211'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      * If the new expiry date is ok so far
      * issue a warning if it falls on a holiday
 
     C     S#NDEXok      IFEQ      'Y'
     C                   Z-ADD     W#NDEX        ZDAYNO
     C                   MOVEL     S#ACCY        ZCCY
     C                   EXSR      ZCHKH
     C     ZIND          IFEQ      'H'
     C                   MOVE      'W'           S#NDEXok
     C                   ADD       1             Wx
     C                   MOVEL     'S#NDEX    '  WFldNamArr(Wx)
     C                   MOVEL     'LEF0212'     WMsgIDArr(Wx)
     C                   ENDIF
     C                   ENDIF
 
      * Otherwise, expiry date must not be defined
 
     C                   ELSE
 
     C     S#NDEX        IFNE      *BLANKS
     C                   MOVE      'N'           S#NDEXok
     C                   ADD       1             Ix
     C                   MOVEL     'S#NDEX    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0209'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETF_I  : Set fields on insert                                *
      *****************************************************************
     C
     C     SETF_I        BEGSR
 
      ** Record Id, Branch, Facility Customer Number
 
     C                   MOVEL     'D'           AMRECI
     C                   MOVE      FcbrBranch    AMBRCA
     C                   MOVEL     S#CSSN        AMCNUM
 
     ** Facility Type, Facility Number, Amendment sequence number
 
     C                   MOVE      S#FACT        AMFACT
     C                   MOVE      S#FCNO        AMFCNO
 
     ** Value Date, Amendment Type, Amendment ccy & Amendment Amount
 
     ** Convert Screen Value date to Midas day number
 
     C                   MOVE      S#VLDT        ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        AMVLDT
                                                                                              CSC024
      ***Bypass*generate*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Bypass generate Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C     S#SQNO        OREQ      *BLANKS                                                    CSC024
 
      ** Get the next available sequence no.
 
     C                   EXSR      SRSQNO
     C                   MOVE      W#SQNO        AMSQNO
     C                   ELSE                                                                 CSC024
     C                   MOVE      S#SQNO        AMSQNO                                       CSC024
     C                   ENDIF                                                                CSC024
 
     C                   MOVE      S#FATP        AMFATP
     C                   MOVE      S#ACCY        AMACCY
     C                   MOVE      W#AAMT        AMAAMT
 
     ** Revolving Credit Indicator, Next expiry date & record status
 
     C                   MOVE      S#RVCR        AMRVCR
     C                   MOVE      S#NDEX        ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        AMNDEX
 
     ** User
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   IF        USRID  <> *Blank                                           CAP084
     C                   EVAL      PSUser = USRID                                             CAP084
     C                   ENDIF                                                                CAP084
     C                   MOVE      PSUser        AMIUSR
 
     ** Status
      * Set record status if CLE002 is present and
      * Facility Amendment Authorise = Y.
 
     C     CLE002        IFEQ      'Y'
     C     BPFAAM        ANDEQ     'Y'
     C                   MOVEL     'C'           AMASTS
     C                   ELSE
     C                   MOVEL     'A'           AMASTS
     C                   ENDIF
 
     ** Original Entry Date
     C                   MOVE      BJRDNB        AMORED
 
     ** PC Transaction Reference
 
     C     P#MODE        IFEQ      'B'
     C     A5TNRF        ANDNE     *BLANK
     C     CLE106        OREQ      'Y'                                                        CLE106
     C                   MOVE      A5TNRF        AMPCRF
     C                   ELSE
     C     S#ACTN        IFEQ      'I'
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
                                                                                              CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD             7                          CLE148
     C                   PARM      'Y'           PUPDT             1                          CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT            8                          CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     FcbrBranch    W1ST11
     C                   MOVEL     W1ST11        AMPCRF
     C                   MOVE      '0001'        AMPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
     C                   ENDIF
 
      * PC Originating Branch
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      A5PCOB        AMPCOB
     C                   ELSE
     C                   MOVE      *BLANKS       AMPCOB
     C                   ENDIF
 
      * Last change Date
     C                   MOVE      WProcDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         AMTLCD
     C                   MOVE      S#ACTN        AMCHTP
 
     C/COPY WNCPYSRC,LEH00243
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETF_A  : Set fields on Amend and Delete                      *
      *****************************************************************
     C
     C     SETF_A        BEGSR
     C
      * Record id
     C                   MOVE      FcbrBranch    AMBRCA
     C                   MOVEL     S#CSSN        AMCNUM
 
     ** Facility Type, Facility Number, Amendment sequence number
 
     C                   MOVE      S#FACT        AMFACT
     C                   MOVE      S#FCNO        AMFCNO
     C                   MOVE      S#SQNO        AMSQNO
 
     ** Convert Screen Value date to Midas day number
 
     C                   MOVE      S#VLDT        ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        AMVLDT
 
     C                   MOVE      S#FATP        AMFATP
 
      * Currency
     C                   MOVE      S#ACCY        AMACCY
 
      * Amount
     C                   MOVE      W#AAMT        AMAAMT
 
      * Revolving Credit ind, new expiry date
 
     C                   MOVE      S#RVCR        AMRVCR
 
     C                   MOVE      S#NDEX        ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        AMNDEX
 
     ** User
     C                   MOVE      PSUser        AMAUSR
     ** Status
      * Set record status if CLE002 is present and
      * Facility Amendment Authorise = Y.
 
     C     CLE002        IFEQ      'Y'
     C     BPFAAM        ANDEQ     'Y'
 
      * Status = 'R' if previous status was 'A', otherwise status = 'C'
 
     C     AMASTS        IFEQ      'A'
     C     AMASTS        OREQ      'R'
     C                   MOVEL     'R'           AMASTS
     C                   ELSE
     C                   MOVEL     'C'           AMASTS
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     'A'           AMASTS
     C                   ENDIF
 
     ** Original Entry Date
     C                   MOVE      *BLANKS       AMORED
 
      * Last change Date
     C                   MOVE      WProcDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         AMTLCD
     C                   MOVE      S#ACTN        AMCHTP
 
 
     C/COPY WNCPYSRC,LEH00244
     C                   ENDSR
     C
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSQNO  -  Get Sequence No.                                   *
      *****************************************************************
     C     SRSQNO        BEGSR
 
      * Set up FCAMK key
 
     C                   MOVE      AMCNUM        K#CNUM
     C                   MOVE      AMFACT        K#FACT
     C                   MOVE      AMFCNO        K#FCNO
     C                   MOVE      AMVLDT        K#VLDT
     C**********         Z-ADD     *ZERO         K#SQNO                                     MD024398
     C                   Z-ADD     999           K#SQNO                                     MD024398
     C                   Z-ADD     1             W#SQNO            3 0
 
     C                   EVAL      wSeqFlag = 'N'                                           MD024398
                                                                                            MD024398
     C                   IF        CLE025 = 'Y'  AND                                          CLE041
     C                             FctrTRCA = 'AG'                                            CLE041
                                                                                              CLE041
      ** Get the highest seq no. using SETGT                                                MD024398
      ** If unique seq has reached the max no. 999 then use SETLL                           MD024398
                                                                                            MD024398
     C     FCAMK         SETGT     LEAGAML3                                                 MD024398
     C     FCAMKV        READPE    LEAGAML3                                                 MD024398
     C                   IF        SQSQNO = 999                                             MD024398
     C                   EVAL      wSeqFlag = 'Y'                                           MD024398
     C                   EVAL      K#SQNO = *ZERO                                           MD024398
     C                   ELSE                                                               MD024398
     C                   EVAL      W#SQNO =  SQSQNO + 1                                     MD024398
     C                   ENDIF                                                              MD024398
     C                                                                                      MD024398
     C                   IF        wSeqFlag = 'Y'                                           MD024398
                                                                                            MD024398
     C     FCAMK         SETLL     LEAGAML3                                                   CLE041
     C     FCAMKV        READE     LEAGAML3                               80                  CLE041
                                                                                              CLE041
     C     *IN80         DOWEQ     *OFF                                                       CLE041
     C     SQSQNO        ANDEQ     W#SQNO                                                     CLE041
     C                   ADD       1             W#SQNO                                       CLE041
     C     FCAMKV        READE     LEAGAML3                               80                  CLE041
     C                   ENDDO                                                                CLE041
                                                                                              CLE041
     C                   ENDIF                                                              MD024398
                                                                                            MD024398
     C                   ELSE                                                                 CLE041
                                                                                              CLE041
      ** Get the highest seq no. using SETGT                                                MD024398
      ** If unique seq has reached the max no. 999 then use SETLL                           MD024398
                                                                                            MD024398
     C     FCAMK         SETGT     LEFCAML3                                                 MD024398
     C     FCAMKV        READPE    LEFCAML3                                                 MD024398
     C                   IF        SQSQNO = 999                                             MD024398
     C                   EVAL      wSeqFlag = 'Y'                                           MD024398
     C                   EVAL      K#SQNO = *ZERO                                           MD024398
     C                   ELSE                                                               MD024398
     C                   EVAL      W#SQNO =  SQSQNO + 1                                     MD024398
     C                   ENDIF                                                              MD024398
                                                                                            MD024398
     C                   IF        wSeqFlag = 'Y'                                           MD024398
     C                                                                                      MD024398
     C     FCAMK         SETLL     LEFCAML3
     C     FCAMKV        READE     LEFCAML3                               80
 
     C     *IN80         DOWEQ     *OFF
     C     SQSQNO        ANDEQ     W#SQNO
     C                   ADD       1             W#SQNO
     C     FCAMKV        READE     LEFCAML3                               80
     C                   ENDDO
                                                                                            MD024398
     C                   ENDIF                                                              MD024398
      *                                                                                     AR693564
      ** Also check records in valid file to see whether seq. no. is                        AR693564
      ** not used already.                                                                  AR693564
      *                                                                                     AR693564
     C     FCAMK         SETLL     LEVFAMDL2                                                AR693564
     C     FCAMKV        READE     LEVFAMDL2                              80                AR693564
                                                                                            AR693564
     C     *IN80         DOWEQ     *OFF                                                     AR693564
     C     SQAMSQNO      ANDEQ     W#SQNO                                                   AR693564
     C                   ADD       1             W#SQNO                                     AR693564
     C     FCAMKV        READE     LEVFAMDL2                              80                AR693564
     C                   ENDDO                                                              AR693564
                                                                                              CLE041
     C                   ENDIF                                                                CLE041
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
     ******************************************************************
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
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
     C/SPACE 5
      *****************************************************************
     C     ZCHKH         BEGSR
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
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
 
      * Facility Amendment Details in screen format
     C                   PARM                    FAMD
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Generated by assignment
     C                   PARM                    A5GASS            1
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMTSV         13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00245
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    A5PCOB            3
     C                   PARM                    A5TNRF           15
 
      * Facility run dates
      * Facility drawn amount
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
      *
      * OUTPUTS
 
      * Amendment amount
     C                   PARM                    W#AAMT           13 0
 
      * Field OK flags
     C                   PARM                    FAMD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
      * Valid Amendment from/to caller
     C                   PARM                    VFAMD
 
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
     C     SDCLND        PARM      SDCLND        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSC011 is installed
      ** CSC011 is made redundant feature, no need to check                                 MD024398
 
     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       PRTCD                                      MD024398
     C**********         PARM      '*VERIFY'     POPTN                                      MD024398
     C**********         PARM      'CSC011'      PSARD                                      MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
      **********                                                                            MD024398
      **********                                                                            MD024398
     C**********         IF        PRTCD = *Blanks                                          MD024398
      **********                                                                            MD024398
     C**********         EVAL      CSC011 = 'Y'                                             MD024398
      **********                                                                            MD024398
     C**********         IN        SC24X7                                                   MD024398
     C**********         IN        SDSTAT                                                   MD024398
      **********                                                                            MD024398
     C**********         ELSE                                                               MD024398
      ***Database*error************************************************                     MD024398
      **********                                                                            MD024398
     C**********         IF        PRTCD <> '*NRF'                                          MD024398
     C**********         MOVEL     '*ERROR '     RetCodeIn                                  MD024398
     C**********         EVAL      DBKEY = 'CSC011'                                         MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                                      MD024398
     C**********         EVAL      DBASE = 905                                              MD024398
     C**********         EXSR      *PSSR                                                    MD024398
     C**********         ENDIF                                                              MD024398
      **********                                                                            MD024398
     C**********         ENDIF                                                              MD024398
 
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF
 
      ** Determine if CLE014 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C                   ENDIF
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 1                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C                   PARM      *BLANKS       P@OP02                                       CSC024
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 2                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
 
      ** Access Switchable SAR details for the existence of CLE025                            CLE041
                                                                                              CLE041
     C                   CALLB     'AOSARDR0'                                                 CLE041
     C                   PARM      *BLANK        @RTCD                                        CLE041
     C                   PARM      '*VERIFY'     @OPTN                                        CLE041
     C                   PARM      'CLE025'      @SARD                                        CLE041
                                                                                              CLE041
     C                   IF        @RTCD = *BLANK                                             CLE041
     C                   EVAL      CLE025 = 'Y'                                               CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Database Error                                                                       CLE041
                                                                                              CLE041
     C                   IF        @RTCD <> *BLANKS AND                                       CLE041
     C                             @RTCD <> '*NRF   '                                         CLE041
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE041
     C                   EVAL      DBASE  = 902                                               CLE041
     C                   EVAL      DBKEY  = @SARD                                             CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER -          CAP084 BUG6318
      **their*user*name*is*stored*in*ZMUSER                                           CAP084 BUG6318
     C**********         IN        ZMUSER                                             CAP084 BUG6318
      *                                                                                       CLE106
      ** Determine if CLE106 is installed                                                     CLE106
      *                                                                                       CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALL      'AOSARDR0'                                                 CLE106
     C                   PARM      '       '     @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSSDY                                        CLE106
      *                                                                                       CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
     C/COPY WNCPYSRC,LEH00246
      *                                                                                       CLE106
 
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
     C     *LIKE         DEFINE    VLDT          K#VLDT
     C     *LIKE         DEFINE    SQNO          K#SQNO
 
      ** Key lists
 
     C     FCAMKP        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
 
     C     FCAMK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#VLDT
     C                   KFLD                    K#SQNO
 
     C     FCAMKV        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#VLDT
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
