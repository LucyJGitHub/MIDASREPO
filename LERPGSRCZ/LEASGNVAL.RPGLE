     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment validation')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEASGNVAL -  Assignment Validation                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
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
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Recompiled over changed LEVASGNPD file.             *
      *           Recompiled over changed LEASGNPD format.            *
      *           Do not set up ASTYLC, not on LEASGNPD.              *
      *           Set Front office ID to PC reference if blank.       *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Assignment Details File
     FLEPARTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AS_)
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Assignment Details in screen format
     D ASGN          E DS                  EXTNAME(LEASGNPD)
 
      ** Assignment Details in file format
     D VASGN         E DS                  EXTNAME(LEVASGNPD)
 
      ** Assignment Details OK indicator
     D ASGN_OK       E DS                  EXTNAME(LEEASGNPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
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
 
     C                   MOVE      *BLANKS       S#ATNM
     C                   MOVE      *BLANKS       S#ATTN
     C                   MOVE      *BLANKS       S#AFNM
     C                   MOVE      *BLANKS       S#AFTN
 
     C                   MOVEL     *ALL'Y'       ASGN_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
      *
      ** Validate Assignment To Customer
      *
     C                   EXSR      VLAST
      *
      ** Validate Assignment From Customer
      *
     C                   EXSR      VLASF
      *
      **  On insert
      **  Validate Assignment To and Assignment From Customers
      *
     C     S#ASTSok      IFEQ      'Y'
     C     S#ASFSok      ANDEQ     'Y'
     C     S#ACTN        ANDEQ     'I'
     C                   EXSR      VLASTASF
     C                   ENDIF
      *
      ** Validate Assignment Date
      *
     C                   EXSR      VLADT
      *
      **  Validate Share
      *
     C     S#ASTSok      IFEQ      'Y'
     C     S#ASFSok      ANDEQ     'Y'
     C                   EXSR      VLDSHR
     C                   ENDIF
      *
 
      * Set fields on insert and amend
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C     S#ACTN        OREQ      'R'
     C                   EXSR      SETF_IA
     C                   ENDIF
      *
     C**********         MOVEL     S#ACTN        ASTYLC                         CAP084
      *
     C     ENDVAL        TAG
 
     C                   RETURN
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Assignment To Customer                               *
      *****************************************************************
     C     VLAST         BEGSR
 
      ** It is an error if assignment to customer has not been entered
 
     C     S#ASTS        IFEQ      *BLANKS
      *
     C                   MOVE      'N'           S#ASTSOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0036'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      ** Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#ASTS        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#ASTSOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0032'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#ASTS
     C                   MOVEL     BBCUST        S#ASTS
     C                   MOVEL     BBCUST        S#ASTN
     C                   MOVEL     BBCRNM        S#ATNM
     C                   MOVEL     BBCRTN        S#ATTN
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Assignment From Customer
      *****************************************************************
     C     VLASF         BEGSR
      *
      ** If the assignment from customer is not defined
      ** set the assignment from customer to the branch internal customer
      *
     C     S#ASFS        IFEQ      *BLANKS
     C                   MOVEL     FcbrBICN      S#ASFS
     C                   ENDIF
      *
      ** Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#ASFS        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#ASFSOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASFS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0031'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#ASFS
     C                   MOVEL     BBCUST        S#ASFS
     C                   MOVEL     BBCUST        S#ASFN
     C                   MOVEL     BBCRNM        S#AFNM
     C                   MOVEL     BBCRTN        S#AFTN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Assignment To and Assignment From Customers
      *****************************************************************
     C     VLASTASF      BEGSR
 
     C                   MOVE      S#ASTN        K#MNUM
     C                   MOVE      S#ASFN        K#INUM
     C                   MOVE      WProcDate     K#VDTC
 
     C     LEPARTK       CHAIN     LEPARTL2                           70
     C     *IN70         IFEQ      *OFF
     C                   MOVE      'N'           S#ASTSOK
     C                   MOVE      'N'           S#ASFSOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0033'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Assignment Date                                      *
      *****************************************************************
     C     VLADT         BEGSR
      *
      ** If the assignment date is not defined, default it to the run date
     C     S#ADTE        IFEQ      *BLANKS
 
     C                   MOVE      WProcDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#ADTE
      *
     C                   ELSE
 
      ** The date must be valid
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#ADTE        ZFIELD
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
     C                   MOVE      'N'           S#ADTEOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#ADTE      'FldNameArr(Ix)
     C                   MOVEL     'LEP0011'     MsgIdArr(Ix)
 
     C                   ELSE
      *
     C     ZDAYNO        IFGT      WProcDate
     C                   MOVE      'N'           S#ADTEOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#ADTE      'FldNameArr(Ix)
     C                   MOVEL     'LEP0011'     MsgIdArr(Ix)
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
      * VLDSHR   : Validate Share (Amount/Percentage)                 *
      *****************************************************************
     C     VLDSHR        BEGSR
      *
      **  The Share Type must be 'P' or 'A'
     C     S#SHTP        IFNE      'P'
     C     S#SHTP        ANDNE     'A'
      *
     C                   MOVE      'N'           S#SHTPOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHTP      'FldNameArr(Ix)
     C                   MOVEL     'LEP0034'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      **  Validate the Share %/amount
     C     S#SHAR        IFEQ      *BLANKS
 
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0035'     MsgIdArr(Ix)
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
     C                   MOVEL     'LEP0035'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      *  Save share for a later calculation
     C                   Z-ADD     0             W#SHRC           15 0
     C                   MOVE      ZFIELD        W#SHRC
      *
     C     W#SHRC        IFEQ      0
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0035'     MsgIdArr(Ix)
     C                   ENDIF
      *
      **  Calculate share amount/percentage
      *
     C                   EXSR      CALCSO
      *
      **  Calculate available share amount/perecntage
      *
     C                   EXSR      CALCAV
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Calculate total share                                         *
      *****************************************************************
     C     CALCSO        BEGSR
      *
     C                   Z-ADD     0             W#TSAM           15 0
     C                   Z-ADD     0             W#TSHP           15 0
      *
     C     PFCLTK        SETLL     LEPARTL2
     C     PFCLTK        READE     LEPARTL2                               70
      *
     C     *IN70         DOWEQ     *OFF
     C                   ADD       AS_SHAM       W#TSAM
     C                   ADD       AS_SHPC       W#TSHP
     C     PFCLTK        READE     LEPARTL2                               70
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Calculate available share                                     *
      *****************************************************************
     C     CALCAV        BEGSR
 
     C     S#ACTN        IFEQ      'A'
     C                   MOVE      S#ASTN        K#MNUM
     C                   MOVE      S#ASFN        K#INUM
     C                   MOVE      WProcDate     K#VDTC
     C     LEPARTK       CHAIN     LEPARTL2                           70
     C                   MOVE      AS_SHAM       H#SHAM           13 0
     C                   MOVE      AS_SHPC       H#SHPC           15 0
     C                   ENDIF
      *
      **   Calculate available share amount
     C     W#FAMTSV      SUB       W#TSAM        W#AVAM           13 0
      *
     C     S#ACTN        IFEQ      'A'
     C     W#AVAM        ADD       H#SHAM        W#AVAM
     C                   ENDIF
      *
      **   Calculate available share percentage
     C                   MOVEL     1             W#100N           15 0
      *
     C     W#100N        SUB       W#TSHP        W#AVPC
      *
     C     S#ACTN        IFEQ      'A'
     C     W#AVPC        ADD       H#SHPC        W#AVPC           15 0
     C                   ENDIF
      *
     C     S#SHTP        IFEQ      'A'
     C     P#MODE        ANDNE     'B'
     C     W#SHRC        IFGT      W#AVAM
      *
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0044'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     S#SHTP        IFEQ      'P'
     C     P#MODE        ANDNE     'B'
     C     W#SHRC        IFGT      W#AVPC
      *
     C                   MOVE      'N'           S#SHAROK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0044'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
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
 
      ** Member = Assigned To Customer
 
     C                   MOVE      S#ASTN        ASMNUM
 
      ** Introducing customer = Assigned From Customer
 
     C                   MOVEL     S#ASFN        ASINUM
 
      ** Joining Date = Assignment date
 
     C                   MOVE      S#ADTE        ZDATEI
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        ASJDTE
 
      ** Value date
 
     C                   MOVE      WProcDate     ASVDTC
 
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
     C                   MOVE      W#FAMTSV      P#PAMT           13
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
     C                   MOVE      W#FAMTSV      P#PAMT           13
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
 
     C                   Z-ADD     *ZERO         ASFERA
     C                   MOVE      *BLANK        ASFERS
 
      * Default loan type/sub type
 
     C                   MOVE      *BLANK        ASDRTP
     C                   MOVE      *BLANK        ASDRST
     C                   MOVE      *BLANK        ASDRCL                                       CLE042
 
      * Participant/Assignment Indicator
 
     C                   MOVE      'A'           ASPTAI
 
      * PC transaction reference
 
     C     P#MODE        IFEQ      'B'
     C     R1TNRF        ANDNE     *BLANK
     C                   MOVE      R1TNRF        ASPCRF
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
     C                   MOVEL     W1ST11        ASPCRF
     C                   MOVE      '0001'        ASPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C     ASFRNT        IFEQ      *BLANK                                       CAP084
     C                   MOVEL     ASPCRF        ASFRNT                         CAP084
     C                   ENDIF                                                  CAP084
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
 
      * Assignment Details in screen format
     C                   PARM                    ASGN
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMTSV         13 0
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
     C                   PARM                    ASGN_OK
      *
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
      *
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      * Assigned to customer name/town
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
      * Assigned from customer name/town
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
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
 
      * Valid Assignment
     C                   PARM                    VASGN
 
     C     *LIKE         DEFINE    AS_BRCA       K#BRCA
     C     *LIKE         DEFINE    AS_CNUM       K#PMFC
     C     *LIKE         DEFINE    AS_FACT       K#PMFT
     C     *LIKE         DEFINE    AS_FCNO       K#PMFN
     C     *LIKE         DEFINE    AS_MNUM       K#MNUM
     C     *LIKE         DEFINE    AS_INUM       K#INUM
     C     *LIKE         DEFINE    AS_VDTC       K#VDTC
 
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
     C                   KFLD                    K#INUM
     C                   KFLD                    K#VDTC
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
     C                   MOVEL     '*ERROR '     RetCodeIn
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
(c) Finastra International Limited 2002
