     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVRF*: OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)             : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant validation')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFPRTVAL -  Funding Participant Validation                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 21Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CLE023             Date 12Apr02               *
      *                 CAP068 *CREATE     Date 20Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CRE026 - Consumer Banking                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *           Skim Signs not being updated properly.              *
      *  CLE023 - Recompiled due to changes to LEVFCLNPD.             *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as API's.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     FFCLTYXFN  IF   E           K DISK    INFSR(*PSSR) PREFIX(PFN)
     F                                     IGNORE(FCLTYFMF:FCLTYHHF:FCLTYZZF)
     F                                     RENAME(FCLTYFNF:PFCLTYFNF)
     FLEFCLTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTL0)
     FLEFCLTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTL2)
     FLEPARTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D OVRDBF          C                   'OVRDBF FILE(FCLTYXFN)-
     D                                       TOFILE(FCLTY) SHARE(*NO)'
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Funding Participant Details in screen format
     D FPRT          E DS                  EXTNAME(LEFPRTPD)
 
      ** Funding Participant Details in file format 'A'
     D VFCLM         E DS                  EXTNAME(LEVFCLMPD)
 
      ** Funding Participant Details in file format 'B'
     D VFCLN         E DS                  EXTNAME(LEVFCLNPD)
 
      ** Prime Facility details for record 'A'
     D PrimeFM       E DS                  EXTNAME(FCLTYFM)
 
      ** Prime Facility details for record 'B'
     D PrimeFN       E DS                  EXTNAME(FCLTYFN) PREFIX(PFN)
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
 
      ** Funding Participant Details OK indicator
     D FPRT_OK       E DS                  EXTNAME(LEEFPRTPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Facility Type Details
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
 
      ** Alternate Name and Addresses
     D SDALTN        E DS                  EXTNAME(SDALTNPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D                                     PREFIX(SC_)
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
 
     C                   MOVEL     *ALL'Y'       FPRT_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   CLEAR                   VFCLM
     C                   CLEAR                   VFCLN
 
      *
      ** Validate Syndicate Member
      *
     C                   EXSR      VLDCUS
      *
      ** Validate Facility Type
      *
     C                   EXSR      VLDFCT
      *
      **  Validate Joining Date
      *
     C                   EXSR      VLDJDT
      *
      **  Validate Introducing Customer
      *
     C                   EXSR      VLDINC
      *
      **  Validate Value Date
      *
     C                   EXSR      VLDVDT
      *
      **  Validate Share
      *
     C     S#CSSNok      IFEQ      'Y'
     C                   EXSR      VLDSHR
     C                   ENDIF
      *
      **  Validate Recourse Indicator
      *
     C                   EXSR      VLDRCI
      *
      **  Validate Assignment/Participation indicator
      *
     C                   EXSR      VLDAPI
      *
      **  Validate Skim
      *
     C                   EXSR      VLDSKM
      *
      **  Validate Alternate Name and Address Code
      *
     C                   EXSR      VLDALT
 
      * Set fields on insert
 
     C     S#ACTN        IFEQ      'I'
     C                   EXSR      SR_INSERT
     C                   ENDIF
      *
      * Set fields on Amend Or Reverse
 
     C     S#ACTN        IFEQ      'A'
     C     S#ACTN        OREQ      'R'
     C                   EXSR      SR_AMEND
     C                   ENDIF
      *
     C     ENDVAL        TAG
 
     C                   RETURN
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDCUS   : Validate Syndicate Member                          *
      *****************************************************************
     C     VLDCUS        BEGSR
 
      **  The Syndicate member must be entered
 
     C     S#CSSN        IFEQ      *BLANKS
 
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0004'     MsgIdArr(Ix)
      *
     C                   ELSE
 
      ** Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#CSSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0005'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   MOVEL     BBCUST        S#CNUM
     C                   MOVEL     BBCRNM        S#SRNM
     C                   MOVEL     BBCRTN        S#SRTN
 
      * If insert
      * the funding participant can't already exist
 
     C     S#ACTN        IFEQ      'I'
     C                   MOVE      BBCUST        K#CNUM
     C     K#LTL3        CHAIN     LEFCLTL2                           70
     C     *IN70         IFEQ      *OFF
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0006'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      * The syndicate member can't be a parent
     C     BBPAIN        IFEQ      'P'
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0028'     MsgIdArr(Ix)
     C                   ENDIF
 
      * Funding Participant is not allowed to be the Syndicate agent
     C                   MOVEL     BBCUST        W#CUST
     C     FcbrSYCU      IFEQ      W#CUST
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0040'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDFCT   : Validate Facility Type                             *
      *****************************************************************
     C     VLDFCT        BEGSR
      *
      **  The Facility Type must be entered
     C     S#FACT        IFEQ      *BLANKS
 
     C                   MOVE      'N'           S#FACTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FACT      'FldNameArr(Ix)
     C                   MOVEL     'LEP0009'     MsgIdArr(Ix)
 
     C                   ELSE
      *
     C                   CALL      'AOFACTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    S#FACT
     C     SDFACT        PARM      SDFACT        DSFDY
      *
      ** Record not found.
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#FACTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FACT      'FldNameArr(Ix)
     C                   MOVEL     'LEP0008'     MsgIdArr(Ix)
     C                   ELSE
      *
     C                   MOVEL     AMFCTY        S#FACT
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDJDT   : Validate Joining Date                              *
      *****************************************************************
     C     VLDJDT        BEGSR
 
     C                   Z-ADD     *ZERO         W#JDTE
      *
      ** If the joining date is not defined, default it to the run date
     C     S#JDTE        IFEQ      *BLANKS
 
     C                   MOVE      WProcDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#JDTE
     C                   MOVE      WProcDate     W#JDTE
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
     C                   MOVE      'N'           S#JDTEok
     C                   ADD       1             Ix
     C                   MOVEL     'S#JDTE      'FldNameArr(Ix)
     C                   MOVEL     'LEP0011'     MsgIdArr(Ix)
      *
     C                   ELSE
 
     C                   MOVE      ZDAYNO        W#JDTE
      *
     C     W#JDTE        IFGT      WProcdate
     C                   MOVE      'N'           S#JDTEok
     C                   ADD       1             Ix
     C                   MOVEL     'S#JDTE      'FldNameArr(Ix)
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
      * VLDINC   : Validate Introducing Customer                      *
      *****************************************************************
     C     VLDINC        BEGSR
      *
      * If it's not defined, default the introducing customer to the agent
     C     S#INUM        IFEQ      *BLANKS
     C     S#ANUM        ANDNE     *BLANKS
      *
      ** Access the Customer Details file
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
      ** Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S#INUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#INUMok
     C                   ADD       1             Ix
     C                   MOVEL     'S#INUM      'FldNameArr(Ix)
     C                   MOVEL     'LEP0010'     MsgIdArr(Ix)
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
      * VLDVDT   : Validate Value Date                                *
      *****************************************************************
     C     VLDVDT        BEGSR
      *
      ** If the value date is not defined, default it to the run date
     C     S#VDTC        IFEQ      *BLANKS
 
     C                   MOVE      WProcDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#VDTC
      *
     C                   ELSE
 
      ** The date must be valid
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#VDTC        ZFIELD
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
     C                   MOVE      'N'           S#VDTCok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VDTC      'FldNameArr(Ix)
     C                   MOVEL     'LEP0012'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C     ZDAYNO        IFGT      Wprocdate
     C     ZDAYNO        ORLT      W#JDTE
      *
     C                   MOVE      'N'           S#VDTCok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VDTC      'FldNameArr(Ix)
     C                   MOVEL     'LEP0012'     MsgIdArr(Ix)
      *
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
     C                   MOVE      'N'           S#SHTPok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHTP      'FldNameArr(Ix)
     C                   MOVEL     'LEP0013'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      **  Validate the Share %/amount
     C     S#SHAR        IFEQ      *BLANKS
      *
     C                   MOVE      'N'           S#SHARok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0014'     MsgIdArr(Ix)
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
     C                   MOVE      'N'           S#SHARok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0014'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      *  Save share for a later calculation
     C                   Z-ADD     0             W#SHRC
     C                   MOVE      ZFIELD        W#SHRC
      *
      **  Calculate share amount/percentage
      *
     C                   EXSR      CALCSO
      *
      **  Calculate available share amount/perecntage
     C                   EXSR      CALCAV
      *
      ** Obtain details of current risk participations against prime
      ** facility to determine portion which has already been sold.
      *
     C                   Z-ADD     W#EXPS        W#PTST           13 0
     C                   Z-ADD     *ZEROS        W#PTSA
     C                   Z-ADD     *ZEROS        W#PTSO
      *
     C                   Z-ADD     0             W#SHAM           13 0
     C     K#LTL2        SETLL     LEPARTL1
     C     K#LTL2        READE     LEPARTL1                               70
     C     *IN70         DOWEQ     '0'
     C                   ADD       SHAM          W#SHAM
     C     K#LTL2        READE     LEPARTL1                               70
     C                   ENDDO
      *
      ** W#SHAM equals total risk sold and should not exceed internally
      ** funded portion of facililty
      *
     C     S#SHTP        IFEQ      'P'
     C                   MOVE      W#FAMT        P#PAMT           13
     C                   MOVE      W#SHRC        P#SHPC           15
     C                   MOVE      *BLANKS       P#FAMT           13
     C                   MOVE      S#SHTP        P#SHTP            1
     C                   CALL      'LE2024'
     C                   PARM                    P#PAMT
     C                   PARM                    P#SHPC
     C                   PARM                    P#FAMT
     C                   PARM                    P#SHTP
      *
     C                   MOVE      P#FAMT        W#PTSO           13 0
     C                   ELSE
     C                   MOVE      W#SHRC        W#PTSO
     C                   ENDIF
      *
     C     S#ACTN        IFEQ      'I'
     C     S#CNUM        ANDNE     FcbrBICN
     C                   ADD       W#PTSO        W#PTST
     C                   ENDIF
      *
     C     S#ACTN        IFEQ      'A'
     C     S#CNUM        ANDNE     FcbrBICN
     C                   ADD       W#PTSO        W#PTST
     C                   MOVE      S#CNUM        K#CNUM
     C     K#LTL3        CHAIN     LEFCLTL2                           84
     C                   SUB       FAMT          W#PTST
     C                   ENDIF
      *
      ** Calculate amount of facility that has not been sold
      *
     C     W#FAMT        SUB       W#PTST        W#PTSA           13 0
      *
      ** Ensure that Risk sold is not greater than retained facility
      *
     C     W#SHAM        IFGT      W#PTSA
     C                   MOVE      'W'           S#SHARok
     C                   ADD       1             Wx
     C                   MOVEL     'S#SHAR      'WFldNamArr(Wx)
     C                   MOVEL     'LEP0042'     WMsgIDArr(Wx)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDRCI   : Validate recourse indicator                        *
      *****************************************************************
     C     VLDRCI        BEGSR
      *
      **  Validate Recourse Indicator
     C     S#RCSI        IFEQ      *BLANKS
     C                   MOVE      'N'           S#RCSI
      *
     C                   ELSE
      *
     C     S#RCSI        IFNE      'Y'
     C     S#RCSI        ANDNE     'N'
     C                   MOVE      'N'           S#RCSIok
     C                   ADD       1             Ix
     C                   MOVEL     'S#RCSI      'FldNameArr(Ix)
     C                   MOVEL     'LEP0019'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDAPI   : Validate Participation/Assignment indicator        *
      *****************************************************************
     C     VLDAPI        BEGSR
      *
      **  Validate Participation/Assignment indicator
     C     S#PASI        IFEQ      *BLANKS
     C                   MOVE      'P'           S#PASI
      *
     C                   ELSE
      *
     C     S#PASI        IFNE      'A'
     C     S#PASI        ANDNE     'P'
     C                   MOVE      'N'           S#PASIok
     C                   ADD       1             Ix
     C                   MOVEL     'S#PASI      'FldNameArr(Ix)
     C                   MOVEL     'LEP0041'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDSKM   : Validate Skim                                      *
      *****************************************************************
     C     VLDSKM        BEGSR
 
     C                   Z-ADD     *ZERO         W#SKIR
     C                   Z-ADD     *ZERO         W#SKFR
      *
      **  Validate Skim Interest Rate
     C     S#SKIR        IFNE      *BLANK
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SKIR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN2
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           S#SKIRok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SKIR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0015'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SKIR
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate Skim Interest Rate Sign
     C     S#SKIS        IFEQ      *BLANK
     C     S#SKIR        ANDNE     *BLANK
     C     W#SKIR        ANDNE     *ZEROS
     C                   MOVE      '-'           S#SKIS
     C                   ELSE
     C     S#SKIS        IFNE      '+'
     C     S#SKIS        ANDNE     '-'
     C     S#SKIS        ANDNE     *BLANKS
     C                   MOVE      'N'           S#SKISok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SKIS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0016'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      **  Validate Skim Fees Rate
     C     S#SKFR        IFNE      *BLANK
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SKFR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN2
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           S#SKFRok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SKFR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0017'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SKFR
     C                   ENDIF
     C                   ENDIF
      *
      **  Validate Skim Fees Rate Sign
     C     S#SKFS        IFEQ      *BLANK
     C     S#SKFR        ANDNE     *BLANK
     C     W#SKFR        ANDNE     *ZEROS
     C                   MOVE      '-'           S#SKFS
     C                   ELSE
     C     S#SKFS        IFNE      '+'
     C     S#SKFS        ANDNE     '-'
     C     S#SKFS        ANDNE     *BLANKS
     C                   MOVE      'N'           S#SKFSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SKFS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0018'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VLDALT   : Validate Alternate Name and Address Code           *
      *****************************************************************
     C     VLDALT        BEGSR
      *
      **  Must be valid name & address record on SDALTNPD
     C     S#NACD        IFEQ      *BLANKS
     C     S#NACD        OREQ      'B'
     C                   MOVE      'B'           S#NACD
      *
     C                   ELSE
      *
     C                   MOVEL     S#CNUM        WCUST             6
     C                   MOVEL     S#NACD        WADCD             1
     C                   CALL      'AOALTNR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM                    WCUST
     C                   PARM                    WADCD
     C     SDALTN        PARM      SDALTN        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     WCUST         ORNE      S#CNUM
     C                   MOVE      'N'           S#NACDok
     C                   ADD       1             Ix
     C                   MOVEL     'S#NACD      'FldNameArr(Ix)
     C                   MOVEL     'LEP0204'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     WADCD         S#NACD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CALCSO   : Calculate total share                              *
      *****************************************************************
     C     CALCSO        BEGSR
 
     C                   Z-ADD     0             W#TFAM           15 0
     C                   Z-ADD     0             W#TSHP           15 0
     C                   Z-ADD     0             W#EXPS           13 0
      *
     C     K#LTL2        SETLL     LEFCLTL2
     C     K#LTL2        READE     LEFCLTL2                               70
      *
     C     *IN70         DOWEQ     *OFF
     C                   ADD       FAMT          W#TFAM
     C                   ADD       SHPC          W#TSHP
     C     PRTR          IFEQ      'P'
     C                   ADD       FAMT          W#EXPS
     C                   ENDIF
     C     K#LTL2        READE     LEFCLTL2                               70
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CALCAV   : Calculate available share                          *
      *****************************************************************
     C     CALCAV        BEGSR
 
     C     S#ACTN        IFEQ      'A'
     C                   MOVE      S#CNUM        K#CNUM
     C                   MOVE      S#FACT        K#FACT
     C                   MOVE      S#FCNO        K#FCNO
     C     K#LTL0        CHAIN     LEFCLTL0                           70
     C                   MOVE      FAMT          H#FAMT           13 0
     C                   MOVE      SHPC          H#SHPC           15 0
     C                   ENDIF
      *
      **   Calculate available share amount
     C     W#FAMT        SUB       W#TFAM        W#AVAM
      *
     C     S#ACTN        IFEQ      'A'
     C     W#AVAM        ADD       H#FAMT        W#AVAM
     C                   ENDIF
      *
      **   Calculate available share percentage
     C                   MOVEL     1             W#100N           15 0
      *
     C     W#100N        SUB       W#TSHP        W#AVPC
      *
     C     S#ACTN        IFEQ      'A'
     C     W#AVPC        ADD       H#SHPC        W#AVPC
     C                   ENDIF
      *
     C     S#SHTP        IFEQ      'A'
     C     P#MODE        ANDNE     'B'
     C     W#SHRC        IFGT      W#AVAM
      *
     C                   MOVE      'N'           S#SHARok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0043'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     S#SHTP        IFEQ      'P'
     C     P#MODE        ANDNE     'B'
     C     W#SHRC        IFGT      W#AVPC
      *
     C                   MOVE      'N'           S#SHARok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SHAR      'FldNameArr(Ix)
     C                   MOVEL     'LEP0043'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SETF_I   : Set fields exclusively on insert                   *
      *****************************************************************
     C     SETF_I        BEGSR
 
      ** Joining date
 
     C                   MOVE      S#JDTE        ZDATEI
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        FPJDTE
 
      ** Start Date should be defaulted to the later of prime facility
      ** start date or the participant joining date
 
     C     FPJDTE        IFGT      FPDTAP
     C                   MOVE      FPJDTE        FPDTAP
     C                   ENDIF
 
      ** Closing date should be within the range of the approval date
      ** and the expiry date.
 
     C     FPCDTE        IFLT      FPDTAP
     C                   Z-ADD     FPDTAP        FPCDTE
     C                   ENDIF
 
      ** PC Originating branch
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F1PCOB        FPPCOB
     C                   ELSE
     C                   MOVE      *BLANKS       FPPCOB
     C                   ENDIF
 
      ** PC transaction reference
 
     C     P#MODE        IFEQ      'B'
     C     F1TNRF        ANDNE     *BLANK
     C                   MOVE      F1TNRF        FPPCRF
     C                   ELSE
     C                   MOVEL     FcbrMQSM      W#1ST3            3
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        FPPCRF
     C                   MOVE      '0001'        FPPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
      *
      ** For an agent primary facility, default the account officer of
      ** the primary facility customer onto internal facilities
      *
     C     PRTR          IFEQ      'A'
     C     FcbrBICN      ANDEQ     S#CNUM
      *
     C                   MOVEL     S#PMFC        PCNUM
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PCNUM            10
     C                   PARM                    PCNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     PCNUM         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BBACOC        FPACOF
      *
     C                   ENDIF
 
      **   Participant facility Indicator
 
     C     FcbrBICN      IFEQ      S#CNUM
     C                   MOVE      'I'           FPPRTR
     C                   ELSE
     C                   MOVE      'P'           FPPRTR
     C                   ENDIF
 
      ** There should be no C/A facility for the funding participant
      ** if the participant is created against a tranche facility.
 
     C     TRCA          IFEQ      'TR'
     C                   MOVE      *BLANKS       FPTRCA
     C**********         Z-ADD     0             FPCANM                                       CSD027
     C                   EVAL      FPCANM = *BLANKS                                           CSD027
     C                   Z-ADD     0             FPCAFT
     C                   Z-ADD     0             FPCAFN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SR_INSERT : Setup required for the insert action              *
      *****************************************************************
     C     SR_INSERT     BEGSR
 
      ** Determine facility sequence number
 
     C                   EXSR      DETFCNO
     C     Ix            CABNE     0             EINSERT
 
      ** Access the prime facility record so details can be defaulted.
 
     C                   MOVE      S#PMFC        K#CNUM
     C                   MOVE      S#PMFT        K#FACT
     C                   MOVE      S#PMFN        K#FCNO
     C                   MOVE      'A'           K#RCTP
 
     C     K#FCTY        CHAIN     FCLTYFMF                           70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'FCLTYFM '    DBFILE                         * DBERR 09 *
     C                   MOVEL     '001'         DBASE                          ************
     C                   MOVEL     S#PMFC        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Move the defaulted values into the Valid DS
     C                   MOVEL     PrimeFM       VFCLM
     C                   MOVEL     RONS          FPRONS                                       CGL029
     C                   MOVEL     PONS          FPPONS                                       CGL029
 
     C                   MOVE      S#CNUM        FPCNUM
     C                   MOVE      S#FACT        FPFACT
     C                   Z-ADD     K4FCNO        FPFCNO
      *
     C                   MOVE      S#PMFC        FPPMFC
     C                   MOVE      S#PMFT        FPPMFT
     C                   MOVE      S#PMFN        FPPMFN
      *
     C                   Z-ADD     0             FPMTDH
     C                   Z-ADD     0             FPMTDL
     C                   Z-ADD     0             FPMTDA
     C                   Z-ADD     0             FPQTDA
     C                   Z-ADD     0             FPYTDA
     C**********         Z-ADD     0             FPANUM                                       CSD027
     C                   EVAL      FPANUM  = *BLANKS                                          CSD027
 
      * Set fields exclusively on insert
 
     C                   EXSR      SETF_I
 
      * Set fields on insert and amend
 
     C                   EXSR      SETF_IA
 
     C                   Z-ADD     WProcDate     FPORED
 
      **  Access prime facility record so details can be defaulted.
 
     C                   MOVE      S#PMFC        K#CNUM
     C                   MOVE      S#PMFT        K#FACT
     C                   MOVE      S#PMFN        K#FCNO
     C                   MOVE      'B'           K#RCTP
 
     C     K#FCTY        CHAIN     PFCLTYFNF                          70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'FCLTYFN '    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     S#PMFC        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Move the defaulted values into the Valid DS
     C                   MOVEL     PrimeFN       VFCLN
 
     C                   MOVE      S#CNUM        FNCNUM
     C                   MOVE      S#FACT        FNFACT
     C                   MOVE      K4FCNO        FNFCNO
     C                   Z-ADD     NATN          FNTNLU
     C                   Z-ADD     WProcDate     FNORED
     C                   Z-ADD     WProcDate     FNLCD
     C                   MOVE      S#ACTN        FNCHTP
      *
     C                   Z-ADD     0             FNTOTD
     C                   Z-ADD     0             FNCAMD
     C                   Z-ADD     0             FNPEXP
     C                   Z-ADD     0             FNOAM1
     C                   Z-ADD     0             FNOAM2
     C                   Z-ADD     0             FNOAM3
     C                   Z-ADD     0             FNOAM4
     C                   Z-ADD     0             FNOAM5
     C                   Z-ADD     0             FNOAM6
     C                   Z-ADD     0             FNOAM7
     C                   Z-ADD     0             FNOAM8
     C                   Z-ADD     0             FNOAM9
     C                   Z-ADD     0             FNOA10
 
     C     EINSERT       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETF_IA  : Set fields on insert and amend                     *
      *****************************************************************
     C     SETF_IA       BEGSR
 
      * TNLU, last change date, last change type
 
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FPTNLU
     C                   Z-ADD     WProcDate     FPLCD
     C                   MOVE      S#ACTN        FPCHTP
 
      ** Introducing customer
 
     C                   MOVEL     S#INUM        FPINUM
 
      ** Value date
 
     C                   MOVE      S#VDTC        ZDATEI
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        FPVDTC
 
      ** Share Type
 
     C                   MOVE      S#SHTP        FPSHTP
 
      ** Facility Amount & Share Percentage
 
     C     S#SHTP        IFEQ      'A'
      *
      * Facility amount
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SHAR        ZFIELD
     C     13            SUB       FccyNBDP      ZADIG
     C                   Z-ADD     FccyNBDP      ZADEC
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        FPFAMT
      *
      *  Calculate percentage
     C                   MOVE      W#FAMT        P#PAMT           13
     C                   MOVE      *BLANKS       P#SHPC           15
     C                   MOVE      ZFIELD        P#FAMT           13
     C                   MOVE      S#SHTP        P#SHTP            1
     C                   CALL      'LE2024'
     C                   PARM                    P#PAMT
     C                   PARM                    P#SHPC
     C                   PARM                    P#FAMT
     C                   PARM                    P#SHTP
      *
     C                   MOVE      P#SHPC        FPSHPC
      *
     C                   ELSE
      *
      *  Percentage
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SHAR        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     12            ZADEC
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        FPSHPC
      *
      ** Calculate Facility Amount
     C                   MOVE      W#FAMT        P#PAMT           13
     C                   MOVE      ZFIELD        P#SHPC           15
     C                   MOVE      *BLANKS       P#FAMT           13
     C                   MOVE      S#SHTP        P#SHTP            1
     C                   CALL      'LE2024'
     C                   PARM                    P#PAMT
     C                   PARM                    P#SHPC
     C                   PARM                    P#FAMT
     C                   PARM                    P#SHTP
      *
     C                   MOVE      P#FAMT        FPFAMT
      *
     C                   ENDIF
 
      ** Recourse indicator
 
     C                   MOVE      S#RCSI        FPRCSI
 
      ** Agreement/Participan indicator
 
     C                   MOVE      S#PASI        FPPASI
 
      ** Skim interest rate & sign
 
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SKIR        ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        FPSKIR
     C*****SKIR********* IFEQ      0                                                          CAP084
     C     FPSKIR        IFEQ      0                                                          CAP084
     C                   MOVE      *BLANKS       FPSKIS
     C                   ELSE
     C                   MOVE      S#SKIS        FPSKIS
     C                   ENDIF
 
      ** Skim funding rate & sign
 
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SKFR        ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN2
     C                   MOVE      ZFIELD        FPSKFR
     C*****SKFR**********IFEQ      0                                                          CAP084
     C     FPSKFR        IFEQ      0                                                          CAP084
     C                   MOVE      *BLANKS       FPSKFS
     C                   ELSE
     C                   MOVE      S#SKFS        FPSKFS
     C                   ENDIF
 
      * Facility status
 
     C                   MOVE      'A'           FPFSTS
 
      ** Input, authorize, amend user
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F1IUSR        FPIUSR
     C                   MOVE      F1XUSR        FPXUSR
     C                   MOVE      F1AUSR        FPAUSR
     C                   ELSE
     C     S#ACTN        IFEQ      'A'
     C                   MOVE      PsUser        FPAUSR
     C                   ELSE
     C                   MOVE      PsUser        FPIUSR
     C                   MOVE      PsUser        FPXUSR
     C                   ENDIF
     C                   ENDIF
 
      ** Name & Address Code
 
     C                   MOVE      S#NACD        FPNACD
 
      ** Receive Settlement details
 
     C                   MOVE      FLRSTM        FPRSTM
     C                   MOVE      FLRONS        FPRONS
     C                   MOVEL     FLRIBN        FPRIBN
     C                   MOVEL     FLRIBA        FPRIBA
     C                   MOVE      FLROBN        FPROBN
     C                   MOVE      FLROCN        FPROCN
     C                   MOVE      FLROBR        FPOSDB
 
      ** Payment Settlement details
 
     C                   MOVE      FLPSTM        FPPSTM
     C                   MOVE      FLPONS        FPPONS
     C                   MOVE      FLPIBN        FPPIBN
     C                   MOVE      FLPIBA        FPPIBA
     C                   MOVE      FLPOBN        FPPOBN
     C                   MOVE      FLPOCN        FPPOCN
     C                   MOVE      FLRCRN        FPRCRN
     C                   MOVE      FLRCRA        FPRCRA
     C                   MOVE      FLRVNO        FPRVNO
     C                   MOVEL     FLAWBN        FPAWBN
     C                   MOVE      FLAWBA        FPAWBA
     C                   MOVEL     FLBENN        FPBENN
     C                   MOVE      FLBENA        FPBENA
     C                   MOVE      FLDTP1        FPDTP1
     C                   MOVE      FLDTP2        FPDTP2
     C                   MOVE      FLDTP3        FPDTP3
     C                   MOVE      FLDTP4        FPDTP4
     C                   MOVE      FLDCHG        FPDCHG
     C                   MOVEL     FLBTB1        FPBTB1
     C                   MOVEL     FLBTB2        FPBTB2
     C                   MOVEL     FLBTB3        FPBTB3
     C                   MOVEL     FLBTB4        FPBTB4
     C                   MOVEL     FLBTB5        FPBTB5
     C                   MOVEL     FLBTB6        FPBTB6
     C                   MOVE      FLPOBR        FPOMDB
     C                   MOVE      FLCVMR        FPCVMR
     C                   MOVE      FLPSCY        FPSCCY
     C                   MOVE      FLIC72        FPICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        FPREXR                                       CLE031
     C                   Z-ADD     FLPEXR        FPPEXR                                       CLE031
     C                   MOVE      FLREXI        FPREXI                                       CLE031
     C                   MOVE      FLPEXI        FPPEXI                                       CLE031
     C                   MOVE      FLRSCY        FPSCCY                                       CLE031
     C                   MOVE      FLPSCY        FPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SR_AMEND : Setup required for the amend action                *
      *****************************************************************
     C     SR_AMEND      BEGSR
 
      ** Set up the key to the facility file
 
     C                   MOVE      S#CNUM        K#CNUM
     C                   MOVE      S#FACT        K#FACT
     C                   MOVE      S#FCNO        K#FCNO
 
      ** Access facility record type 'A'
 
     C                   MOVE      'A'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAMEND
     C                   ENDIF
 
      * Move the defaulted values into the Valid DS
     C                   MOVEL     PrimeFM       VFCLM
     C                   MOVEL     RONS          FPRONS                                       CGL029
     C                   MOVEL     PONS          FPPONS                                       CGL029
      *
      * Set fields on insert and amend
 
     C                   EXSR      SETF_IA
 
      ** Access facility record type 'B'
 
     C                   MOVE      'B'           K#RCTP
     C     K#FCTY        CHAIN     PFCLTYFNF                          70
 
      * Move the defaulted values into the valid DS
     C                   MOVEL     PrimeFN       VFCLN
 
      ** Update facility record type 'B'
 
     C                   Z-ADD     NATN          FNTNLU
     C                   Z-ADD     WProcDate     FNLCD
     C                   MOVE      S#ACTN        FNCHTP
 
     C     EAMEND        ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DETFCNO  : Determine facility sequence number                 *
      *****************************************************************
     C     DETFCNO       BEGSR
      *
     C                   MOVE      S#CNUM        K#CNUM
     C                   MOVE      S#FACT        K#FACT
     C                   Z-ADD     1             K4FCNO
 
     C     K#FCTYP       SETLL     FCLTY                                  70
      *
     C                   MOVE      'N'           W#EXIT            1
     C     W#EXIT        DOWNE     'Y'
      *
     C     *IN70         IFEQ      *OFF
     C                   MOVE      'Y'           W#EXIT
     C                   ELSE
     C     K4FCNO        IFNE      99
     C                   ADD       1             K4FCNO
     C     K#FCTYP       SETLL     FCLTY                                  70
     C                   ELSE
     C                   MOVE      'Y'           W#EXIT
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEF0110'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
 
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
     C     ZTNLU1        BEGSR
 
     C                   CALLB     'ZTNLU1'
     C                   PARM                    RetCodeOut
     C                   PARM                    NATN              5 0
 
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
 
      * Funding Participant Details in screen format
     C                   PARM                    FPRT
 
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
 
      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU            5 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      *
      * OUTPUTS
 
      * Field OK flags
     C                   PARM                    FPRT_OK
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
      * Valid Funding Participant Record 'A'
     C                   PARM                    VFCLM
      * Valid Funding Participant Record 'B'
     C                   PARM                    VFCLN
 
     C     *LIKE         DEFINE    FcbrSYCU      W#CUST
     C     *LIKE         DEFINE    ZDAYNO        W#JDTE
     C     *LIKE         DEFINE    SHPC          W#SHRC
     C     *LIKE         DEFINE    SKIR          W#SKIR
     C     *LIKE         DEFINE    SKFR          W#SKFR
     C     *LIKE         DEFINE    FAMT          W#AVAM
     C     *LIKE         DEFINE    SHPC          W#AVPC
 
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
 
     C     *LIKE         DEFINE    FcbrBranch    K#BRCA
     C     *LIKE         DEFINE    PMFC          K#PMFC
     C     *LIKE         DEFINE    PMFT          K#PMFT
     C     *LIKE         DEFINE    PMFN          K#PMFN
     C     *LIKE         DEFINE    FCNO          K4FCNO
     C     *LIKE         DEFINE    RCTP          K#RCTP
 
      * Key lists
 
     C     K#LTL0        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
 
     C     K#LTL2        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
 
     C     K#LTL3        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
     C                   KFLD                    K#CNUM
 
     C     K#FCTYP       KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K4FCNO
 
     C     K#FCTY        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCTP
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
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
      ** OVRDBF FCLTYXFN to FCLTY then OPEN FCLTYX
 
     C                   EVAL      LENGTH = %SIZE(OVRDBF)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF        QCMD             70
     C                   PARM                    LENGTH           15 5
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
