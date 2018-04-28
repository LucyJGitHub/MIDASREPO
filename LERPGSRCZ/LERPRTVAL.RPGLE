     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Risk participant validation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LERPRTVAL -  Risk Participant Validation                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP069   *CREATE   Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Facilities File
     FLEFCLTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FC_)
      **  Risk Participant Details File
     FLEPARTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PA_)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------
 
      **-----------------------------------------------------------------
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------
 
      **-----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------
 
      **-----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Risk Participant Details in screen format
     D RPRT          E DS                  EXTNAME(LERPRTPD)
 
      ** Risk Participant Details in file format
     D VRPRT         E DS                  EXTNAME(LEVRPRTPD)
 
      ** Risk Participant Details OK indicator
     D RPRT_OK       E DS                  EXTNAME(LEERPRTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Base Rate Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** External DS for Loan Type / Sub Type Details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CSC011          S              1A   INZ('N')
     D WProcDate       S                   LIKE(BJRDNB)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
      *                                                                                       CLE148
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
 
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
 
      ** Set up Key fields
 
     C                   MOVE      FcbrBranch    K#BRCA
     C                   MOVE      S#PMFC        K#PMFC
     C                   MOVE      S#PMFT        K#PMFT
     C                   MOVE      S#PMFN        K#PMFN
 
      ** Clear output fields
 
     C                   MOVE      *BLANKS       S#SRNM
     C                   MOVE      *BLANKS       S#SRTN
     C                   MOVE      *BLANKS       S#IRNM
     C                   MOVE      *BLANKS       S#IRTN
 
     C                   MOVEL     *ALL'Y'       RPRT_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   CLEAR                   VRPRT
      *
      **  Validate Syndicate Member
      *
     C                   EXSR      VLDCUS
      *
      **  Validate Introducing Customer
      *
     C                   EXSR      VLDINC
      *
      **  Validate Joining Date
      *
     C                   EXSR      VLDJDT
      *
      **  Validate Share
      *
     C     S#CSSNok      IFEQ      'Y'
     C                   EXSR      VLDSHR
     C                   ENDIF
      *
      **  Validate Fee Base Rate and Rate/Spread
      *
     C                   EXSR      VLDRAT
      *
      **  Validate Rate/Spread Sign
      *
     C                   EXSR      VLDSGN
      *
      **  Validate Risk Participation Loan Type/Sub-type
      *
     C                   EXSR      VLDLON
 
      * Set fields on insert, amend or delete
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C     S#ACTN        OREQ      'D'
     C                   EXSR      SETF_IA
     C                   ENDIF
      *
     C     ENDVAL        TAG
 
     C                   RETURN
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Syndicated Customer                                  *
      *****************************************************************
     C     VLDCUS        BEGSR
 
      **  The Syndicate member must be entered
 
     C     S#CSSN        IFEQ      *BLANKS
 
     C                   MOVE      'N'           S#CSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEK0008'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      **  Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#CSSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVE      'N'           S#CSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEK0001'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   MOVEL     BBCUST        S#CNUM
     C                   MOVEL     BBCRNM        S#SRNM
     C                   MOVEL     BBCRTN        S#SRTN
 
      * If insert
      * the risk participant can't already exist
 
     C     S#ACTN        IFEQ      'I'
     C                   MOVE      S#CNUM        K#MNUM
     C     LEPARTK       CHAIN     LEPARTL1                           70
 
     C     *IN70         IFEQ      *OFF
     C                   MOVE      'N'           S#CSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEK0011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Introducing Customer                                 *
      *****************************************************************
     C     VLDINC        BEGSR
      *
      * If it's not defined, default the introducing customer to the agent
     C     S#INUM        IFEQ      *BLANKS
     C     S#ANUM        ANDNE     *BLANKS
      *
      **  Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#ANUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   MOVE      *BLANKS       S#INUM
     C                   MOVEL(P)  BBCUST        S#INUM
 
     C                   ENDIF
      *
      **  Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#INUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVE      'N'           S#INUMOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#INUM      'FldNameArr(Ix)
     C                   MOVEL     'LEK0002'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      *BLANKS       S#INUM
     C                   MOVEL(P)  BBCUST        S#INUM
     C                   MOVEL     BBCRNM        S#IRNM
     C                   MOVEL     BBCRTN        S#IRTN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Joining Date                                         *
      *****************************************************************
     C     VLDJDT        BEGSR
      *
      ** If the joining date is not defined, default it to the run date
     C     S#JDTE        IFEQ      *BLANKS
 
     C                   MOVE      WProcDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#JDTE
      *
     C                   ELSE
 
      ** The date must be valid
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#JDTE        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN2
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
      *
     C                   MOVE      'N'           S#JDTEOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#JDTE      'FldNameArr(Ix)
     C                   MOVEL     'LEK0003'     MsgIdArr(Ix)
 
     C                   ELSE
      *
     C     ZDAYNO        IFGT      WProcDate
     C                   MOVE      'N'           S#JDTEOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#JDTE      'FldNameArr(Ix)
     C                   MOVEL     'LEK0014'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Share Type and Share Amount                          *
      *****************************************************************
     C     VLDSHR        BEGSR
      *
     C                   Z-ADD     *ZEROS        W#SHAR           15 0
     C                   Z-ADD     *ZEROS        W#FPAM           13 0
     C                   Z-ADD     *ZEROS        W#SHAM           13 0
     C                   Z-ADD     *ZEROS        W#RISK           13 0
      *
      **  The Share Type must be 'P' or 'A'
     C     S#SHTP        IFNE      'P'
     C     S#SHTP        ANDNE     'A'
      *
     C                   MOVE      'N'           S#SHTPOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHTP      'FldNameArr(Ix)
     C                   MOVEL     'LEK0004'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      **  Validate the Share %/amount
     C     S#SHAR        IFEQ      *BLANK
 
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEK0005'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C     S#SHTP        IFEQ      'P'
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SHAR        ZFIELD
     C                   Z-ADD     12            ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN2
     C                   ELSE
     C     S#SHTP        IFEQ      'A'
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SHAR        ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
     C     13            SUB       FccyNBDP      ZADIG
     C                   EXSR      ZALIGN2
     C                   ENDIF
     C                   ENDIF
      *
     C     ZFIELD        IFEQ      *BLANK
     C     ZALIGNok      OREQ      'N'
      *
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEK0005'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   Z-ADD     0             W#SHAR
     C                   MOVE      ZFIELD        W#SHAR
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#SHAR
 
      **  Calculate Amount if share type is percentage
 
     C     S#SHTP        IFEQ      'P'
     C                   MOVE      W#FAMT        P#PAMT           13
     C                   MOVE      W#SHAR        P#SHPC           15
     C                   MOVE      *BLANKS       P#FAMT           13
     C                   MOVE      S#SHTP        P#SHTP            1
     C                   CALLB     'LE2024'
     C                   PARM                    P#PAMT
     C                   PARM                    P#SHPC
     C                   PARM                    P#FAMT
     C                   PARM                    P#SHTP
      *
     C                   MOVE      P#FAMT        W#RISK
     C                   ELSE
     C                   MOVE      W#SHAR        W#RISK
     C                   ENDIF
      *
 
      ** Access funding participants to calculate amount of prime facility
      ** which has been sold. Use this to calculate share still held.
 
     C     PFCLTK        SETLL     LEFCLTL2
     C     PFCLTK        READE     LEFCLTL2                               80
     C     *IN80         DOWEQ     '0'
     C     FC_PRTR       IFEQ      'P'
     C                   SUB       FC_FAMT       W#FPAM
     C                   ENDIF
     C     PFCLTK        READE     LEFCLTL2                               80
     C                   ENDDO
 
     C                   ADD       W#FAMT        W#FPAM
 
      ** Access current risk particpations against prime
      ** facility to determine portion which has already been sold.
 
     C                   Z-ADD     0             W#SHAM           13 0
      *
     C     PFCLTK        SETLL     LEPARTL1
     C     PFCLTK        READE     LEPARTL1                               80
     C     *IN80         DOWEQ     '0'
     C                   ADD       PA_SHAM       W#SHAM
     C     PFCLTK        READE     LEPARTL1                               80
     C                   ENDDO
 
     C                   ADD       W#SHAM        W#RISK
 
      ** If action is to amend an existing part sold, subtract original
 
     C     S#ACTN        IFEQ      'A'
     C                   MOVE      S#CNUM        K#MNUM
     C     LEPARTK       CHAIN     LEPARTL1                           70
     C                   SUB       PA_SHAM       W#RISK
     C                   ENDIF
 
      ** Total risk sold should not exceed retained portion of facility
 
     C     W#RISK        IFGT      W#FPAM
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEK0033'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDRAT    : Validate Fee Base Rate and Fee Rate/Spread        *
      *****************************************************************
     C     VLDRAT        BEGSR
      *
     C                   Z-ADD     *ZEROS        W#FERA           11 7
      *
      **  At least one field should be entered
     C     S#FEBR        IFEQ      *BLANKS
     C     S#FERA        ANDEQ     *BLANKS
     C                   MOVE      'N'           S#FEBROK
     C                   MOVE      'N'           S#FERAOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#FEBR      'FldNameArr(Ix)
     C                   MOVEL     'LEK0012'     MsgIdArr(Ix)
     C                   ENDIF
      *
      **  Validate Fee Base Rate
     C     S#FEBR        IFNE      *BLANKS
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FccyFCCY      BKEY1             3
     C                   PARM      S#FEBR        BKEY2             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVE      'N'           S#FEBROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#FEBR      'FldNameArr(Ix)
     C                   MOVEL     'LEK0006'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      BABSRC        S#FEBR
     C                   ENDIF
     C                   ENDIF
      *
      **  Validate Fee Rate/Spread
      *
     C     S#FERA        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      S#FERA        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN2
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           S#FERAOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#FERA      'FldNameArr(Ix)
     C                   MOVEL     'LEK0007'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        W#FERA
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#FERA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Fee Rate/Spread Sign                                 *
      *****************************************************************
     C     VLDSGN        BEGSR
      *
      **  Default to '-' if Fee Rate/Spread Sign is equal to blank
     C     S#FERS        IFEQ      *BLANKS
     C                   MOVE      '-'           S#FERS
     C                   ENDIF
      *
      **  Validate Fee Rate/Spread Sign
     C     S#FERS        IFNE      '+'
     C     S#FERS        ANDNE     '-'
     C                   MOVE      'N'           S#FERSOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#FERS      'FldNameArr(Ix)
     C                   MOVEL     'LEK0009'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Risk Participation Loan Type/Sub-type                *
      *****************************************************************
     C     VLDLON        BEGSR
      *
      **  Entry not mandatory
     C     S#DRTP        IFNE      *BLANKS
     C     S#DRST        ORNE      *BLANKS
     C     S#DRCL        ORNE      *BLANKS                                                    CLE042
      *
     C                   MOVEL     S#DRTP        ATCD
     C                   MOVEL     S#DRST        AUCD
     C                   MOVEL     S#DRCL        AUCL                                         CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    ATCD              2
     C                   PARM                    AUCD              2
     C                   PARM                    AUCL              4                          CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVE      'N'           S#DRTPOK
     C                   MOVE      'N'           S#DRSTOK
     C                   MOVE      'N'           S#DRCLOK                                     CLE042
     C                   ADD       1             Ix
     C                   MOVEL     'S#DRTP      'FldNameArr(Ix)
     C                   MOVEL     'LEK0010'     MsgIdArr(Ix)
     C                   ELSE
     C     AYLNPT        IFEQ      70
     C     AYLNPT        OREQ      71
     C     AYLNPT        OREQ      72
     C                   MOVE      AYLNTY        S#DRTP
     C                   MOVE      AYLNST        S#DRST
     C                   MOVE      AYLNCL        S#DRCL                                       CLE042
     C                   ELSE
     C                   MOVE      'N'           S#DRTPOK
     C                   MOVE      'N'           S#DRSTOK
     C                   MOVE      'N'           S#DRCLOK                                     CLE042
     C                   ADD       1             Ix
     C                   MOVEL     'S#DRTP      'FldNameArr(Ix)
     C                   MOVEL     'LEK0028'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'N'           S#DRTPOK
     C                   MOVE      'N'           S#DRSTOK
     C                   MOVE      'N'           S#DRCLOK                                     CLE042
     C                   ADD       1             Ix
     C                   MOVEL     'S#DRTP      'FldNameArr(Ix)
     C                   MOVEL     'LEK0032'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
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
      * SETF_IA  : Set fields on insert and amend                     *
      *****************************************************************
     C     SETF_IA       BEGSR
 
      ** Branch, customer, facility type & facility number
 
     C                   MOVE      FcbrBranch    ASBRCA
     C                   MOVE      S#PMFC        ASCNUM
     C                   MOVE      S#PMFT        ASFACT
     C                   MOVE      S#PMFN        ASFCNO
 
      ** Member
 
     C                   MOVE      S#CNUM        ASMNUM
 
      ** Introducing customer
 
     C                   MOVEL     S#INUM        ASINUM
 
      ** Joining date
 
     C                   MOVE      S#JDTE        ZDATEI
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        ASJDTE
 
      ** Currency
 
     C                   MOVE      FccyFCCY      ASCCY
 
      ** Share type
 
     C                   MOVE      S#SHTP        ASSHTP
 
      ** If share type = 'A' -> share amount/percentage
 
     C     S#SHTP        IFEQ      'A'
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SHAR        ZFIELD
     C     13            SUB       FccyNBDP      ZADIG
     C                   Z-ADD     FccyNBDP      ZADEC
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        ASSHAM
     C                   MOVE      W#FAMT        P#PAMT           13
     C                   MOVE      *BLANKS       P#SHPC           15
     C                   MOVE      ZFIELD        P#FAMT           13
     C                   MOVE      S#SHTP        P#SHTP            1
     C                   CALLB     'LE2024'
     C                   PARM                    P#PAMT
     C                   PARM                    P#SHPC
     C                   PARM                    P#FAMT
     C                   PARM                    P#SHTP
     C                   MOVE      P#SHPC        ASSHPC
     C                   ENDIF
 
      ** If share type = 'P' -> share amount/percentage
 
     C     S#SHTP        IFEQ      'P'
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SHAR        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     12            ZADEC
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        ASSHPC
     C                   MOVE      W#FAMT        P#PAMT           13
     C                   MOVE      ZFIELD        P#SHPC           15
     C                   MOVE      *BLANKS       P#FAMT           13
     C                   MOVE      S#SHTP        P#SHTP            1
     C                   CALLB     'LE2024'
     C                   PARM                    P#PAMT
     C                   PARM                    P#SHPC
     C                   PARM                    P#FAMT
     C                   PARM                    P#SHTP
     C                   MOVE      P#FAMT        ASSHAM
     C                   ENDIF
 
      * Fee details
 
     C                   MOVE      S#FEBR        ASFEBR
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      S#FERA        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        ASFERA
     C                   MOVE      S#FERS        ASFERS
 
      * Default loan type/sub type
 
     C                   MOVE      S#DRTP        ASDRTP
     C                   MOVE      S#DRST        ASDRST
     C                   MOVE      S#DRCL        ASDRCL                                       CLE042
 
      * Participant Assignment Indicator
 
     C                   MOVE      'R'           ASPTAI
 
      * PC transaction reference
 
     C     P#MODE        IFEQ      'B'
     C     R1TNRF        ANDNE     *BLANK
     C                   MOVE      R1TNRF        ASPCRF
     C                   ELSE
     C     S#ACTN        IFEQ      'I'
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     FcbrBranch    W1ST11
     C                   MOVEL     W1ST11        ASPCRF
     C                   MOVE      '0001'        ASPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
     C                   ENDIF
 
      * PC originating branch
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      R1PCOB        ASPCOB
     C                   ELSE
     C                   MOVE      *BLANKS       ASPCOB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     ZEDIT2        BEGSR
     C                   CALLB     'ZEDIT2'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
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
 
      * Risk Participant Details in screen format
     C                   PARM                    RPRT
 
      * Agent number
     C                   PARM                    S#ANUM            6
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    R1PCOB            3
     C                   PARM                    R1TNRF           15
      *
      * OUTPUTS
 
      * Field OK flags
     C                   PARM                    RPRT_OK
      *
      * Syndicate customer number
     C                   PARM                    S#CNUM            6
      * Syndicate member customer name/town
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
      * Introducing customer name/town
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
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
 
      * Valid Risk Participant
     C                   PARM                    VRPRT
 
     C     *LIKE         DEFINE    PA_BRCA       K#BRCA
     C     *LIKE         DEFINE    PA_CNUM       K#PMFC
     C     *LIKE         DEFINE    PA_FACT       K#PMFT
     C     *LIKE         DEFINE    PA_FCNO       K#PMFN
     C     *LIKE         DEFINE    PA_MNUM       K#MNUM
 
      * Key lists
 
     C     PFCLTK        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
 
     C     LEPARTK       KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
     C                   KFLD                    K#MNUM
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF
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
