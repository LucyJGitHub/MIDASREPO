     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment retrieve')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFAMDRTV - Facility Amendment Retrieve                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD024809           Date 06Nov19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 261287             Date 31Jul09               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246694             Date 13Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244314             Date 11Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 240968             Date 10Jul06               *
      *                 240202             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10384           Date 06Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 07Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6728            Date 11May05               *
      *                 CSW037A            Date 02May05               *
      *                 CLE041             Date 15Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4555            Date 19Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 19Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CAP071             Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024809 - Also execute holiday check during authorise.      *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CSC054 - Period End Adjustments                              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00227                                 *
      *             WNCPYSRC,LEH00228                                 *
      *             WNCPYSRC,LEH00229                                 *
      *             WNCPYSRC,LEH00265                                 *
      *             WNCPYSRC,LEH00230                                 *
      *             WNCPYSRC,LEH00231                                 *
      *             WNCPYSRC,LEH00232                                 *
      *             WNCPYSRC,LEH00233                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  261287 - Cannot authorize Facility increase due to 000 seq.  *
      *           If sequence is '000', blank it out to prevent wrong *
      *           validation.                                         *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246694 - Reactivation of tranch allowed if CA is active.     *
      *         - or if CA is expired/deleted, reactivation will be   *
      *           allowed when FR amendment already exist.            *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  CAP185 - MQ Series Interface                                 *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if Fcty Amendment was amended after ORED       *
      *  240202 - Allow entry of FD or RC for an expired facility     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10384 - Display Facility UTN and Facility Event UTN       *
      *             correctly.                                        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. Recompiled.                   *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSC024 - Open Month End                                      *
      *  BUG6728- Move check on ZMUSER out of *INZSR                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4555 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs. Additional fix for BUG3760.          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus change                                    *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as API's                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
 
     FFCLTY     IF   E           K DISK
     F                                     PREFIX(FC_)
     FFCLTYL1   IF   E           K DISK                                                       246694
     F                                     PREFIX(CA_)                                        246694
     F                                     RENAME(FCLTYFMF:FCLTYFM1)                          246694
     FLEAGFCL0  IF   E           K DISK                                                       CLE041
     F                                     PREFIX(AGFC_)                                      CLE041
     F                                     IGNORE(FCLTYHHF)                                   CLE041
     F                                     RENAME(FCLTYFMF:AGFCLTFMF)                         CLE041
     F                                     RENAME(FCLTYFNF:AGFCLTFNF)                         CLE041
     F                                     RENAME(FCLTYZZF:AGFCLTZZF)                         CLE041
 
     FLEFCAML3  IF   E           K DISK
     F                                     RENAME(LEFCAMPF:LEFCAMP3)
     F                                     PREFIX(FA_)
     FLEAGAML3  IF   E           K DISK                                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMP3)                          CLE041
     F                                     PREFIX(AGFA_)                                      CLE041
 
     FLEFCAML6  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FA_)
     FLEAGAML2  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMP2)                          CLE041
     F                                     PREFIX(AGFA_)                                      CLE041
     FSDCWHTL1  IF   E           K DISK                                                     BUG4555
      ** Compliance Watch Hit List by Function Type/Identifier/Branch                       BUG4555
      *                                                                                     BUG4555
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
     F/COPY WNCPYSRC,LEH00457
                                                                                              CAP185
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
      ** Facility Amendment Details in file format
     D LEFCAMPDFmt   E DS                  EXTNAME(LEFCAMPD)
     D                                     PREFIX(FA_)
 
      ** Facility Amendment Details in file format (Aggregate)                                CLE041
     D LEAGAMPDFmt   E DS                  EXTNAME(LEAGAMPD)                                  CLE041
     D                                     PREFIX(AGFA_)                                      CLE041
 
      * Facility run dates
     D  @RUNA          DS
     D  FC_RUN0                1      5  0
     D  FC_RUN1                6     10  0
     D  FC_RUN2               11     15  0
     D  FC_RUN3               16     20  0
     D  FC_RUN4               21     25  0
     D  FC_RUN5               26     30  0
     D  FC_RUN6               31     35  0
     D  FC_RUN7               36     40  0
     D  FC_RUN8               41     45  0
     D  FC_RUN9               46     50  0
     D  @FC_RUN                1     50  0
     D                                     DIM(10)
 
      * Facility drawn amounts
     D  @OAMA          DS
     D  FC_OAM1                1     13  0
     D  FC_OAM2               14     26  0
     D  FC_OAM3               27     39  0
     D  FC_OAM4               40     52  0
     D  FC_OAM5               53     65  0
     D  FC_OAM6               66     78  0
     D  FC_OAM7               79     91  0
     D  FC_OAM8               92    104  0
     D  FC_OAM9              105    117  0
     D  FC_OA10              118    130  0
     D  @FC_OAM                1    130  0
     D                                     DIM(10)
 
 
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
     D SDBRCHDFAC    E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    CAP084
      ** Java user information                                                               CAP084
                                                                                             CAP084
      ** First DS for access programs, short data structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                   BUG4555
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                   BUG4555
      *                                                                                     BUG4555
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                BUG4555
      ** Midas Functions for Watch List Checking Details File                               BUG4555
      *                                                                                     BUG4555
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                BUG4555
      ** Midas SD Watch List Configuration Data File                                        BUG4555
      *                                                                                     BUG4555
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** RUNDAT DATA AREA
     D RUNDAT          DS
     D  MBIN                  13     13
                                                                                              CLE041
     D WAggregate      S              1A                                                      CLE041
     D WkFound         S              1A                                                      CLE041
     D CLE025          S              1A                                                      CLE041
                                                                                              CLE041
      ** SAR Indicators (on/off)                                                            BUG4555
     D CCF001          S              1                                                     BUG4555
     D CSC011          S              1                                                     BUG4555
     D CSD015          S              1                                                     BUG4555
      *                                                                                     BUG4555
     D WFuncType       S              8                                                     BUG4555
     D WIdntifier      S             40                                                     BUG4555
     D WBranch         S              3                                                     BUG4555
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
                                                                                              CSC024
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
 
     D CAP086          S              1A                                                      CAP086
     D CLE056          S              1A                                                      CLE056
     D CA#FATPok       S              1A                                                      246694
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      *                                                                                      BUG6728
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6728
      * their user name is stored in ZMUSER                                                  BUG6728
     C                   IN        ZMUSER                                                    BUG6728
      * CLEAR OUTPUTS
 
     C                   CLEAR                   LEFCAMPDFmt
     C                   MOVE      'Y'           S#ACTNok
     C                   MOVE      'Y'           S#CSSNok
     C                   MOVE      'Y'           S#FACTok
     C                   MOVE      'Y'           S#FCNOok
     C                   MOVE      'Y'           S#FATPok
     C                   MOVE      'Y'           S#VLDTok
     C                   MOVE      'Y'           S#SQNOok
     C                   MOVE      *BLANK        S#CNUM
     C                   Z-ADD     *ZERO         W#VLDT
 
     C                   Z-ADD     *ZERO         W#FAMT
     C                   MOVEL     *BLANK        FcbrBranch
     C                   MOVEL     *BLANK        FcbrBICN
     C                   MOVEL     *BLANK        FcbrMQSM
     C**********         Z-ADD     *ZERO         FcbrSYCU                                     CSD027
     C                   EVAL      FcbrSYCU = *BLANKS                                         CSD027
     C                   MOVEL     *BLANK        FccyFCCY
     C                   Z-ADD     *ZERO         FccyNBDP
     C                   MOVEL     *BLANK        FctrTRCA
     C                   MOVEL     *BLANK        FcrvRVCR
     C                   MOVEL     *BLANK        FcRECI
     C                   Z-ADD     *ZERO         FcDTEX
     C                   Z-ADD     *ZERO         FcCDTE
     C/COPY WNCPYSRC,LEH00227
 
     C                   Z-ADD     *ZERO         @FC_RUN
     C                   Z-ADD     *ZERO         @FC_OAM
 
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIdArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             P#MODE   = *BLANKS                                         CAP086
     C                   EVAL      FA_AUTO = *BLANKS                                          CAP086
     C                   ENDIF                                                                CAP086
     C                   EVAL      WAggregate = 'N'                                           CLE041
 
      **  Valid action code
 
     C                   EXSR      VALACTN
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#ACTNok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      ** Validate customer, facility type and facility number
 
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
 
      ** Validate facility amendment type
      *
     C                   EXSR      VLDFATP
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#FATPok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      * Validate Value Date
 
     C                   EXSR      VLDVLDT
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#VLDTok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      * Validate Sequence Number
 
     C                   EXSR      VLDSQNO
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#SQNOok      IFEQ      'N'
     C                   RETURN
     C                   END
 
      ** If not insert, check facility amendment exists
 
     C     S#ACTN        IFNE      'I'
     C                   EXSR      CHKFCAM
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     S#CSSNok      IFEQ      'N'
     C     S#FACTok      OREQ      'N'
     C     S#FCNOok      OREQ      'N'
     C     S#VLDTok      OREQ      'N'
     C     S#SQNOok      OREQ      'N'
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
     C                   MOVEL     '*ERROR '     RetCodeIn
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
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     FC_FCCY       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     'B'           K#RCDT
 
     C     FCLTYK        CHAIN     FCLTYFNF                           80
 
     C                   Z-ADD     FC_FAMT       W#FAMT
     C                   MOVEL     FC_BRCA       FcbrBranch
     C                   MOVEL     A8BICN        FcbrBICN
     C                   MOVEL     A8MQSM        FcbrMQSM
     C**********         Z-ADD     A8SYCU        FcbrSYCU                                     CSD027
     C                   EVAL      FcbrSYCU = A8SYCU                                          CSD027
     C                   MOVEL     FC_FCCY       FccyFCCY
     C                   MOVEL     A6NBDP        FccyNBDP
     C                   MOVEL     FC_TRCA       FctrTRCA
     C                   MOVEL     FC_RVCR       FcrvRVCR
     C                   MOVEL     FC_RECI       FcRECI
     C                   Z-ADD     FC_DTEX       FcDTEX
     C                   Z-ADD     FC_CDTE       FcCDTE
     C                   EVAL      S#FUTN = FC_PCRF                                         BUG10384
     C/COPY WNCPYSRC,LEH00228
 
     C                   ELSE
     C                   EVAL      WkFound = 'N'                                              CLE041
      **  If not found, check if existing in aggregates file LEAGFCL0                         CLE041
     C                   IF        CLE025='Y'                                                 CLE041
     C                   EXSR      SRAggregate                                                CLE041
     C                   ENDIF                                                                CLE041
     C                   IF        WkFound = 'N'                                              CLE041
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0006'     MsgIdArr(Ix)
     C                   EVAL      S#FUTN = *BLANKS                                         BUG10384
     C                   ENDIF                                                                CLE041
     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Validate facility amendment type
      ***********************************************************
     C     VLDFATP       BEGSR
      *
      ** Amendment type must be 'FI', 'FD', 'FR' or 'RC'
      *
     C     S#FATP        IFNE      'FI'
     C     S#FATP        ANDNE     'FD'
     C     S#FATP        ANDNE     'FR'
     C     S#FATP        ANDNE     'RC'
     C/COPY WNCPYSRC,LEH00229
     C                   MOVE      'N'           S#FATPok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0216'     MsgIdArr(Ix)
     C/COPY WNCPYSRC,LEH00265
      *
     C                   ELSE
      *
      * On insert
      *
     C     S#ACTN        IFEQ      'I'
      *
      * Reactivation of live facilities is not allowed
      *
     C     S#FATP        IFEQ      'FR'
     C     FC_RECI       ANDEQ     'D'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     S#FATP        OREQ      'FR'                                                       CLE041
     C     AGFC_RECI     ANDEQ     'D'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#FATPok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0218'     MsgIdArr(Ix)
     C                   ENDIF
      *
      * Reactivation of deleted facilities is not allowed
      *
     C     S#FATP        IFEQ      'FR'
     C     FC_RECI       ANDEQ     'R'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     S#FATP        OREQ      'FR'                                                       CLE041
     C     AGFC_RECI     ANDEQ     'R'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#FATPok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0279'     MsgIdArr(Ix)
     C                   ENDIF
      *                                                                                       246694
     C     KEY#CA        Klist                                                                246694
     C                   Kfld                    FC_BRCA                                      246694
     C                   Kfld                    FC_CANM                                      246694
     C                   Kfld                    FC_CAFT                                      246694
     C                   Kfld                    FC_CAFN                                      246694
      *                                                                                       246694
     C     KY#AMD        Klist                                                                246694
     C                   Kfld                    FC_CANM                                      246694
     C                   Kfld                    FC_CAFT                                      246694
     C                   Kfld                    FC_CAFN                                      246694
      *                                                                                       246694
      ** Reactivation of closed/expired tranche                                               246694
      *                                                                                       246694
     C                   If        ((S#FATP='FR') And (FC_TRCA='TR') And                      246694
     C                                 (FC_RECI='C'))                                         246694
     C                             Or ((S#FATP='FR') And (FC_TRCA='TR') And                   246694
     C                                   (FC_RECI='E'))                                       246694
     C     KEY#CA        CHAIN     FCLTYL1                            81                      246694
     C                   If        (*IN81=*OFF)                                               246694
      *                                                                                       246694
      ** (1) A pending 'FR' for close/expired CA must exist|                                  246694
      *                                                                                       246694
     C                   If        (CA_RECI='E') Or (CA_RECI='C')                             246694
      *                                                                                       246694
     C                   Eval      CA#FATPok = 'N'                                            246694
      *                                                                                       246694
     C                   If        (WAggregate='Y')                                           246694
     C     KY#AMD        Setll     LEAGAML3                                                   246694
     C     KY#AMD        Reade     LEAGAML3                               82                  246694
     C                   Dow       (*IN82=*OFF) And (CA#FATPok='N')                           246694
     C                   If        (AGFA_FATP='FR') And (AGFA_ASTS='A')                       246694
     C                   Eval      CA#FATPok = 'Y'                                            246694
     C                   Else                                                                 246694
     C     KY#AMD        Reade     LEAGAML3                               82                  246694
     C                   Endif                                                                246694
     C                   Enddo                                                                246694
     C                   Else                                                                 246694
     C     KY#AMD        Setll     LEFCAML3                                                   246694
     C     KY#AMD        Reade     LEFCAML3                               82                  246694
     C                   Dow       (*IN82=*OFF) And (CA#FATPok='N')                           246694
     C                   If        (FA_FATP='FR') And (FA_ASTS='A')                           246694
     C                   Eval      CA#FATPok = 'Y'                                            246694
     C                   Else                                                                 246694
     C     KY#AMD        Reade     LEFCAML3                               82                  246694
     C                   Endif                                                                246694
     C                   Enddo                                                                246694
     C                   Endif                                                                246694
      *                                                                                       246694
     C                   If        (CA#FATPok='N')                                            246694
     C                   Eval      S#FATPok = 'N'                                             246694
     C                   Eval      Ix = Ix + 1                                                246694
     C                   Eval      FldNameArr(Ix) = 'S#FATP    '                              246694
     C                   Eval      MsgIdArr(Ix) = 'LEF0328'                                   246694
     C                   Endif                                                                246694
      *                                                                                       246694
     C                   Else                                                                 246694
      *                                                                                       246694
      ** (2) ... Or CA must be active                                                         246694
      *                                                                                       246694
     C                   If        (CA_RECI<>'D')                                             246694
     C                   Eval      S#FATPok = 'N'                                             246694
     C                   Eval      Ix = Ix + 1                                                246694
     C                   Eval      FldNameArr(Ix) = 'S#FATP    '                              246694
     C                   Eval      MsgIdArr(Ix) = 'LEF0328'                                   246694
     C                   Endif                                                                246694
     C                   Endif                                                                246694
     C                   Endif                                                                246694
     C                   Endif                                                                246694
      *
      ** If this not a reactivation
      ** and the facility is not live or expired
      *** here must be a reactivation due
      *
     C*****S#FATP        IFNE      'FR'                                                       240202
     C     S#FATP        IFEQ      'FI'                                                       240202
     C     FC_RECI       ANDNE     'D'
     C*****FC_RECI       ANDNE     'E'                                                        240202
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C*****S#FATP        ORNE      'FR'                                                CLE041 240202
     C     S#FATP        OREQ      'FI'                                                       240202
     C     AGFC_RECI     ANDNE     'D'                                                        CLE041
     C*****AGFC_RECI     ANDNE     'E'                                                 CLE041 240202
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C/COPY WNCPYSRC,LEH00474
      *
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#VLDT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   Z-ADD     *ZERO         W#VLDT
     C                   ELSE
     C                   Z-ADD     ZDAYNO        W#VLDT
     C                   ENDIF
      *
     C                   MOVE      'N'           FR_Due            1
     C                   IF        WAggregate = 'Y'                                           CLE041
     C     FCAMKP        SETLL     LEAGAML3                                                   CLE041
     C     FCAMKP        READE     LEAGAML3                               80                  CLE041
     C     *IN80         DOWEQ     '0'                                                        CLE041
     C     AGFA_VLDT     ANDLE     W#VLDT                                                     CLE041
     C                   EVAL      LEFCAMPDFmt = LEAGAMPDFmt                                  CLE041
     C     AGFA_FATP     IFEQ      'FR'                                                       CLE041
     C                   MOVE      'Y'           FR_Due                                       CLE041
     C                   LEAVE                                                                CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMKP        READE     LEAGAML3                               80                  CLE041
     C                   ENDIF                                                                CLE041
     C                   ENDDO                                                                CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMKP        SETLL     LEFCAML3
     C     FCAMKP        READE     LEFCAML3                               80
     C     *IN80         DOWEQ     '0'
     C     FA_VLDT       ANDLE     W#VLDT
     C     FA_FATP       IFEQ      'FR'
     C                   MOVE      'Y'           FR_Due
     C                   LEAVE
     C                   ELSE
     C     FCAMKP        READE     LEFCAML3                               80
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF                                                                CLE041
      *
     C     FR_Due        IFEQ      'N'
     C                   MOVE      'N'           S#FATPok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)
     C/COPY WNCPYSRC,LEH00475
     C                   MOVEL     'LEF0219'     MsgIdArr(Ix)
     C/COPY WNCPYSRC,LEH00476
     C                   ENDIF
      *
     C                   ENDIF
      *
      **If this is a reactivation, there can't be any others due
      *
     C     S#FATP        IFEQ      'FR'
     C     S#FATPok      ANDEQ     'Y'
      *
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
     C                   Z-ADD     *ZERO         K#VLDT
     C                   Z-ADD     *ZERO         K#SQNO
     C                   IF        WAggregate = 'Y'                                           CLE041
     C     FCAMK         SETLL     LEAGAML2                                                   CLE041
     C     FCAMKP        READE     LEAGAML2                               80                  CLE041
      *                                                                                       CLE041
     C     *IN80         DOWEQ     *OFF                                                       CLE041
     C                   EVAL      LEFCAMPDFmt = LEAGAMPDFmt                                  CLE041
     C     AGFA_FATP     IFEQ      'FR'                                                       CLE041
     C                   MOVE      'N'           S#FATPok                                     CLE041
     C                   ADD       1             Ix                                           CLE041
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)                               CLE041
     C                   MOVEL     'LEF0234'     MsgIdArr(Ix)                                 CLE041
     C                   LEAVE                                                                CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMKP        READE     LEAGAML2                               80                  CLE041
     C                   ENDIF                                                                CLE041
     C                   ENDDO                                                                CLE041
     C                   ELSE                                                                 CLE041
      *
     C     FCAMK         SETLL     LEFCAML6
     C     FCAMKP        READE     LEFCAML6                               80
      *
     C     *IN80         DOWEQ     *OFF
     C     FA_FATP       IFEQ      'FR'
     C                   MOVE      'N'           S#FATPok
     C                   ADD       1             Ix
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0234'     MsgIdArr(Ix)
     C                   LEAVE
     C                   ELSE
     C     FCAMKP        READE     LEFCAML6                               80
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF                                                                CLE041
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      *****************************************************************
      * Validate Value Date                                           *
      *****************************************************************
     C     VLDVLDT       BEGSR
 
      ** Value date must be defined
      ** (but is defaulted to the run date for reactivations)
 
     C     S#VLDT        IFEQ      *BLANKS
     C     S#FATP        IFEQ      'FR'
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#VLDT
     C                   ELSE
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0220'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      ** Value date must be valid
 
     C     S#VLDTok      IFEQ      'Y'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#VLDT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0220'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        W#VLDT
     C                   ENDIF
     C                   ENDIF
 
      ** Validation on insert only
 
     C     S#ACTN        IFEQ      'I'
 
      ** Value date can't be before the facility approval date
 
     C     S#VLDTok      IFEQ      'Y'
     C     W#VLDT        ANDLT     FC_DTAP
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     S#VLDTok      OREQ      'Y'                                                        CLE041
     C     W#VLDT        ANDLT     AGFC_DTAP                                                  CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0221'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** If value date is OK
 
     C     S#VLDTok      IFEQ      'Y'
      *
      **If the value date is after the expiry date
      **and this is not a reactivation, it's an error if no reactivation is
      **due or if a reactivation is due but the value date is > new expiry
      *
     C     W#VLDT        IFGT      FC_DTEX
     C     S#FATP        ANDNE     'FR'
     C     Waggregate    ANDNE     'Y'                                                        CLE041
     C     W#VLDT        ORGT      AGFC_DTEX                                                  CLE041
     C     S#FATP        ANDNE     'FR'                                                       CLE041
     C     Waggregate    ANDEQ     'Y'                                                        CLE041
     C     FR_Due        IFEQ      'N'
     C     FR_Due        OREQ      ' '
     C     FR_Due        OREQ      'Y'
     C     W#VLDT        ANDGT     FA_NDEX
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     FR_Due        OREQ      'Y'                                                        CLE041
     C     W#VLDT        ANDGT     AGFA_NDEX                                                  CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0222'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      * When reactivating an expired facility, value date must = expiry date
      *
     C     W#VLDT        IFNE      FC_DTEX
     C     S#FATP        ANDEQ     'FR'
     C     FC_RECI       ANDEQ     'E'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     W#VLDT        ORNE      AGFC_DTEX                                                  CLE041
     C     S#FATP        ANDEQ     'FR'                                                       CLE041
     C     AGFC_RECI     ANDEQ     'E'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0278'     MsgIdArr(Ix)
     C                   ENDIF
      *
      **If the facility is closed, check whether closed before or after
      **expiry, and condition value date validation on the result.
      *
     C     FC_DTEX       IFGT      BJRDNB
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     AGFC_DTEX     ORGT      BJRDNB                                                     CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
      *
     C     W#VLDT        IFNE      BJRDNB
     C     S#FATP        ANDEQ     'FR'
     C     FC_RECI       ANDEQ     'C'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     W#VLDT        ORNE      BJRDNB                                                     CLE041
     C     S#FATP        ANDEQ     'FR'                                                       CLE041
     C     AGFC_RECI     ANDEQ     'C'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0292'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     W#VLDT        IFNE      FC_DTEX
     C     S#FATP        ANDEQ     'FR'
     C     FC_RECI       ANDEQ     'C'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     W#VLDT        ORNE      AGFC_DTEX                                                  CLE041
     C     S#FATP        ANDEQ     'FR'                                                       CLE041
     C     AGFC_RECI     ANDEQ     'C'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#VLDTok
     C                   ADD       1             Ix
     C                   MOVEL     'S#VLDT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0292'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                              MD024809
 
      * If value date is OK
      * issue a warning if the date is a holiday
 
     C                   IF        S#ACTN = 'I' or S#ACTN = 'X' or S#ACTN = 'A'             MD024809
     C     S#VLDTok      IFEQ      'Y'
     C                   Z-ADD     W#VLDT        ZDAYNO
     C                   IF        WAggregate = 'Y'                                           CLE041
     C                   MOVEL     AGFC_FCCY     ZCCY                                         CLE041
     C                   ELSE                                                                 CLE041
     C                   MOVEL     FC_FCCY       ZCCY
     C                   ENDIF                                                                CLE041
     C                   EXSR      ZCHKH
     C     ZIND          IFEQ      'H'
     C                   MOVE      'W'           S#VLDTok
     C                   ADD       1             Wx
     C                   MOVEL     'S#VLDT    '  WFldNamArr(Wx)
     C                   MOVEL     'LEF0223'     WMsgIDArr(Wx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00458
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Sequence Number                                      *
      *****************************************************************
     C     VLDSQNO       BEGSR
 
      ** On insert, sequence number must be blank.
      ** Otherwise, it must be defined
 
     C     S#ACTN        IFEQ      'I'
 
     C     S#SQNO        IFEQ      '000'                                                      261287
     C                   MOVE      *BLANKS       S#SQNO                                       261287
     C                   ENDIF                                                                261287
                                                                                              261287
     C     S#SQNO        IFNE      *BLANKS
                                                                                              CSC024
      ***Allow*entry*for*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
                                                                                              CSC024
     C                   MOVE      'N'           S#SQNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SQNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0224'     MsgIdArr(Ix)
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         IF        CSC024 = 'Y' AND                                    CSC024 CSC054
     C**********                   WOMEInd = 'Y'                                       CSC024 CSC054
     C                   IF        CSC054 = 'Y' AND                                           CSC054
     C                             WPEAInd = 'Y'                                              CSC054
     C                   MOVEL     S#CSSN        K#CNUM                                       CSC024
     C                   MOVEL     S#FACT        K#FACT                                       CSC024
     C                   MOVEL     S#FCNO        K#FCNO                                       CSC024
     C                   Z-ADD     W#VLDT        K#VLDT                                       CSC024
     C                   MOVEL     S#SQNO        K#SQNO                                       CSC024
                                                                                              CSC024
     C     FCAMK         CHAIN     LEFCAML3                                                   CSC024
     C                   IF        %FOUND(LEFCAML3)                                           CSC024
     C                   MOVE      'N'           S#SQNOok                                     CSC024
     C                   ADD       1             Ix                                           CSC024
     C                   MOVEL     'S#SQNO'      FldNameArr(Ix)                               CSC024
     C                   MOVEL     'LEF0454'     MsgIdArr(Ix)                                 CSC024
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ENDIF
 
     C                   ELSE
 
     C     S#SQNO        IFEQ      *BLANKS
     C                   MOVE      'N'           S#SQNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SQNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0225'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#SQNO        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           S#SQNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SQNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0225'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        S#SQNO
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check facility amendment exists                               *
      *****************************************************************
     C     CHKFCAM       BEGSR
      *
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
     C                   Z-ADD     W#VLDT        K#VLDT
     C                   MOVEL     S#SQNO        K#SQNO
      *
     C                   IF        WAggregate = 'Y'                                           CLE041
     C     FCAMK         CHAIN     LEAGAML3                           80                      CLE041
     C                   EVAL      LEFCAMPDFmt = LEAGAMPDFmt                                  CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMK         CHAIN     LEFCAML3                           80
     C                   ENDIF                                                                CLE041
      *
     C     *IN80         IFEQ      *ON
     C                   MOVE      'N'           S#CSSNok
     C                   MOVE      'N'           S#FACTok
     C                   MOVE      'N'           S#FCNOok
     C                   MOVE      'N'           S#VLDTok
     C                   MOVE      'N'           S#SQNOok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0226'     MsgIdArr(Ix)
     C                   ENDIF
 
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
 
     C     FA_RECI       IFNE      'D'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     AGFA_RECI     ORNE      'D'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0227'     MsgIdArr(Ix)
     C                   ENDIF
 
      * Authorisations are only allowed:
 
     C     S#ACTN        WHENEQ    'X'
      *                                                                                     BUG4555
      ** If Compliance Watch Enhancement (CSD015) is installed, Watch                       BUG4555
      ** List Checking Applied and Authorization is allowed....                             BUG4555
      ** If 24x7 Midas Availability is not installed or it is installed and                 BUG4555
      ** in the main system...                                                              BUG4555
      ** Determine  if there is a pending case.                                             BUG4555
      ** If there no pending case or case has been temporarily released,                    BUG4555
      ** continue normal processing.  Otherwise send error message.                         BUG4555
      *                                                                                     BUG4555
     C                   IF        (CSD015 = 'Y') AND                                       BUG4555
     C                             (W1EWLC = 'Y')                                           BUG4555
      *                                                                                     BUG4555
     C                   IF        (CSC011 = 'N') OR                                        BUG4555
     C                             (S1MAIN = LIBR)                                          BUG4555
     C                   EVAL      WFuncType = 'LEFCAMPD'                                   BUG4555
     C                   MOVEL     '/'           Wrk3              3                        BUG4555
     C                   MOVE      FC_FCNO       Wrk3                                       BUG4555
     C                   MOVEL     FC_FACT       FCNbr             6                        BUG4555
     C                   MOVE      Wrk3          FCNbr                                      BUG4555
     C                   MOVEL     FC_CNUM       FIdentfr         13                        BUG4555
     C                   MOVE      FCNbr         FIdentfr                                   BUG4555
     C                   EVAL      WIdntifier = FIdentfr                                    BUG4555
     C                   EVAL      WBranch = FC_BRCA                                        BUG4555
      *                                                                                     BUG4555
     C     KCwFld        CHAIN     SDCWHTL1                                                 BUG4555
     C                   IF        %FOUND(SDCWHTL1) AND                                     BUG4555
     C                             (W3TREL <> 'Y')                                          BUG4555
     C                   EVAL      Ix = Ix + 1                                              BUG4555
     C                   MOVEL     'FIdentfr'    FldNameArr(Ix)                             BUG4555
     C                   EVAL      MsgIdArr(Ix) = 'LEL0564'                                 BUG4555
     C                   ENDIF                                                              BUG4555
     C                   ENDIF                                                              BUG4555
     C                   ENDIF                                                              BUG4555
 
      * . if lending authorisations is installed
      *   and if facility amendments are to be authorised
 
     C     CLE002        IFEQ      'N'
     C     BPFAAM        ORNE      'Y'
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0213'     MsgIdArr(Ix)
     C                   ELSE
 
      * . on live records
      * . records whose status is 'complete' or 'awaiting reauthorisation'
      * . if the user is different from the last insert or amend user
 
     C     FA_RECI       IFNE      'D'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     AGFA_RECI     ORNE      'D'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0227'     MsgIdArr(Ix)
     C                   ELSE
     C     FA_ASTS       IFNE      'C'
     C     FA_ASTS       ANDNE     'R'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     AGFA_ASTS     ORNE      'C'                                                        CLE041
     C     AGFA_ASTS     ANDNE     'R'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0228'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   IF        USRID  <> *Blank                                           CAP084
     C                   EVAL      PSUser = USRID                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ***  Authorised user must be different from the insert and amend users                  CLE056
      ***  Unless CLE056 is enabled and not day of input and not last amender                 CLE056
                                                                                              CLE056
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C     CAP185        IFEQ      'N'                                                        CAP185
     C     CAP185        OREQ      'Y'                                                        CAP185
     C     @AUTHO        ANDEQ     'N'                                                        CAP185
     C     CAP185        OREQ      'Y'                                                        CAP185
     C     @AUTHO        ANDEQ     'Y'                                                        CAP185
     C     @TYPE         ANDEQ     '1'                                                        CAP185
      *                                                                                       CAP185
     C     P#MODE        IFNE      'B'
      *                                                                                       CAP185
      * If system value CLAuthORED = 'Y' and last amend date is later than                    240968
      * original entry date then allow authorise user to be same as orignal insert user       240968
      *                                                                                       244314
      * Or if CLAuthSameORED = 'Y' then allow authorise user to be same as original           244314
      * insert user as long as the last change type was an amendment and the                  244314
      * current status of transaction is 'Reauthorise Required'                               244314
      *                                                                                       240968
     C     ATHORED       IFEQ      'Y'                                                        240968
     C     ATHOSMDT      ANDNE     'Y'                                                        244314
     C     FA_TLCD       ANDGT     FA_ORED                                                    240968
     C     FA_CHTP       ANDEQ     'A'                                                        240968
     C     BJRDNB        ANDGT     FA_ORED                                                    240968
     C     WAggregate    ANDNE     'Y'                                                        240968
     C     ATHOSMDT      OREQ      'Y'                                                        244314
     C     WAggregate    ANDNE     'Y'                                                        244314
     C     FA_CHTP       ANDEQ     'A'                                                        244314
     C     FA_ASTS       ANDEQ     'R'                                                        244314
      *                                                                                       240968
     C     PSUser        IFEQ      FA_AUSR                                                    240968
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and WAggregate = 'Y' and                     CLE056
     C                              PSUser = AGFA_IUSR and                                    CLE056
     C                              AGFA_ORED = BJRDNB)                      or               CLE056
     C                             (CLE056 = 'Y' and WAggregate <> 'Y' and                    CLE056
     C                              PSUser = FA_IUSR and                                      CLE056
     C                              FA_ORED = BJRDNB)                        or               CLE056
     C                             (CLE056 = 'Y' and WAggregate = 'Y' and                     CLE056
     C                              AGFA_CHTP = 'A' and PSUser = AGFA_AUSR and                CLE056
     C                              AGFA_TLCD = BJRDNB)                      or               CLE056
     C                             (CLE056 = 'Y' and WAggregate <> 'Y' and                    CLE056
     C                              FA_CHTP = 'A' and PSUser = FA_AUSR and                    CLE056
     C                              FA_TLCD = BJRDNB)                                         CLE056
     C                   MOVE      'N'           S#ACTNok                                     240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)                               240968
     C                   MOVEL     'LEF0231'     MsgIdArr(Ix)                                 240968
     C                   ENDIF                                                                CLE056
     C                   ENDIF                                                                240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     PSUser        IFEQ      FA_AUSR
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     PSUser        OREQ      AGFA_AUSR                                                  CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C     PSUser        OREQ      FA_IUSR
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     PSUser        OREQ      AGFA_IUSR                                                  CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0231'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF                                                                240968
     C                   ENDIF
     C                   ENDIF                                                                CAP185
 
     C                   ENDIF
 
      * Deletions are only allowed:
 
     C     S#ACTN        WHENEQ    'D'
 
      * . on live records
     C     FA_RECI       IFNE      'D'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
     C     AGFA_RECI     ORNE      'D'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
     C                   MOVE      'N'           S#ACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ACTN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0229'     MsgIdArr(Ix)
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
     C                   IF        CLE025 = 'Y' AND WAggregate = 'Y'                          CLE041
     C                   EVAL      @ZBR = AGFC_BRCA                                           CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      @ZBR = FC_BRCA                                             CLE041
     C                   ENDIF                                                                CLE041
      *                                                                                       CLE041
     C                   CALL      'ZVACTBU'
     C                   PARM      S#ACTN        @ZACTN            1
     C**********         PARM      FC_BRCA       @ZBR              3                          CLE041
     C                   PARM                    @ZBR              3                          CLE041
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
     C                   IF        CLE025 = 'Y' AND WAggregate = 'Y'                          CLE041
     C                   EVAL      @ZOBRX = AGFC_ORBR                                         CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      @ZOBRX = FC_ORBR                                           CLE041
     C                   ENDIF                                                                CLE041
      *                                                                                       CLE041
     C                   CALL      'ZVOBU'
     C**********         PARM      FC_ORBR       @ZOBRX            3                          CLE041
     C                   PARM                    @ZOBRX            3                          CLE041
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
      *****************************************************************                       CLE041
      * Access Aggregate Facility File                                *                       CLE041
      *****************************************************************                       CLE041
     C     SRAggregate   BEGSR                                                                CLE041
     C     FCLTYK        CHAIN     LEAGFCL0                                                   CLE041
     C                   IF        %FOUND(LEAGFCL0)                                           CLE041
     C                   EVAL      LEFCAMPDFmt = LEAGAMPDFmt                                  CLE041
     C                   EVAL      WAggregate = 'Y'                                           CLE041
     C                   EVAL      WkFound = 'Y'                                              CLE041
     C                   CALL      'AOBRCHR1'                                                 CLE041
     C                   PARM      '       '     @RTCD                                        CLE041
     C                   PARM      '*KEY   '     @OPTN                                        CLE041
     C                   PARM      AGFC_BRCA     @BRCA             3                          CLE041
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CLE041
      *                                                                                       CLE041
     C     @RTCD         IFNE      *BLANK                                                     CLE041
     C                   MOVEL     '*ERROR '     RetCodeIn                                    CLE041
     C                   MOVEL     'SDBRCHPD'    DBFILE                                       CLE041
     C                   MOVEL     '001'         DBASE                                        CLE041
     C                   MOVEL     AGFC_BRCA     DBKEY                                        CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   CALL      'AOCURRR0'                                                 CLE041
     C                   PARM      '       '     @RTCD                                        CLE041
     C                   PARM      '*KEY   '     @OPTN                                        CLE041
     C                   PARM      AGFC_FCCY     @CCY              3                          CLE041
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE041
      *                                                                                       CLE041
     C     @RTCD         IFNE      *BLANK                                                     CLE041
     C                   MOVEL     '*ERROR '     RetCodeIn                                    CLE041
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CLE041
     C                   MOVEL     '002'         DBASE                                        CLE041
     C                   MOVEL     AGFC_FCCY     DBKEY                                        CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   MOVEL     'B'           K#RCDT                                       CLE041
     C     FCLTYK        CHAIN     LEAGFCL0                                                   CLE041
     C                   Z-ADD     AGFC_FAMT     W#FAMT                                       CLE041
     C                   MOVEL     AGFC_BRCA     FcbrBranch                                   CLE041
     C                   MOVEL     A8BICN        FcbrBICN                                     CLE041
     C                   MOVEL     A8MQSM        FcbrMQSM                                     CLE041
     C**********         Z-ADD     A8SYCU        FcbrSYCU                              CLE041 CSD027
     C                   EVAL      FcbrSYCU = A8SYCU                                          CSD027
     C                   MOVEL     AGFC_FCCY     FccyFCCY                                     CLE041
     C                   MOVEL     A6NBDP        FccyNBDP                                     CLE041
     C                   MOVEL     AGFC_TRCA     FctrTRCA                                     CLE041
     C                   MOVEL     AGFC_RVCR     FcrvRVCR                                     CLE041
     C                   MOVEL     AGFC_RECI     FcRECI                                       CLE041
     C                   Z-ADD     AGFC_DTEX     FcDTEX                                       CLE041
     C                   Z-ADD     AGFC_CDTE     FcCDTE                                       CLE041
     C                   EVAL      S#FUTN = AGFC_PCRF                                       BUG10384
     C/COPY WNCPYSRC,LEH00230
     C                   ELSE                                                                 CLE041
     C                   EVAL      WkFound = 'N'                                              CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   ENDSR                                                                CLE041
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
      * Response Code
     C                   PARM                    RESPMODE          1
 
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FATP            2
     C                   PARM                    S#VLDT            6
     C                   PARM                    S#SQNO            3
 
      *
      * OUTPUTS
 
      * Facility Amendment Details in file format
     C                   PARM                    LEFCAMPDFmt
 
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FATPok          1
     C                   PARM                    S#VLDTok          1
     C                   PARM                    S#SQNOok          1
 
      * Customer number
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
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
     C                   PARM                    W#FAMT           13 0
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
     C/COPY WNCPYSRC,LEH00231
 
      * Facility run dates
      * Facility drawn amounts
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
                                                                                            BUG10384
      ** Facility UTN                                                                       BUG10384
     C                   PARM                    S#FUTN           15                        BUG10384
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
      *                                                                                       CLE041
      ** Access Switchable SAR details for the existence of CLE025                            CLE041
     C                   CALLB     'AOSARDR0'                                                 CLE041
     C                   PARM      *BLANK        @RTCD                                        CLE041
     C                   PARM      '*VERIFY'     @OPTN                                        CLE041
     C                   PARM      'CLE025'      @SARD                                        CLE041
      *                                                                                       CLE041
     C                   IF        @RTCD = *BLANK                                             CLE041
     C                   EVAL      CLE025 = 'Y'                                               CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      CLE025 = 'N'                                               CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Database Error                                                                       CLE041
                                                                                              CLE041
     C                   IF        @RTCD <> *BLANKS AND                                       CLE041
     C                             @RTCD <> '*NRF   '                                         CLE041
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE041
     C                   EVAL      DBASE  = 3                                                 CLE041
     C                   EVAL      DBKEY  = @SARD                                             CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
 
      *  GET MBIN FROM DTAARA/RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
                                                                                              CAP084
      **If*the*user*is connected via a browser, the job user name is QUSER -          CAP084 BUG6728
      **their*user*name is stored in ZMUSER                                           CAP084 BUG6728
     C**********         IN        ZMUSER                                             CAP084 BUG6728
 
     C     *LIKE         DEFINE    FC_CNUM       K#CNUM
     C     *LIKE         DEFINE    FC_FACT       K#FACT
     C     *LIKE         DEFINE    FC_FCNO       K#FCNO
     C     *LIKE         DEFINE    FC_RCDT       K#RCDT
     C     *LIKE         DEFINE    FA_VLDT       K#VLDT
     C     *LIKE         DEFINE    FA_SQNO       K#SQNO
 
      ** Key lists
 
     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCDT
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
      **  Used for SDCWHTL1                                                                 BUG4555
      *                                                                                     BUG4555
     C     KCwFld        KLIST                                                              BUG4555
     C                   KFLD                    WFuncType                                  BUG4555
     C                   KFLD                    WIdntifier                                 BUG4555
     C                   KFLD                    WBranch                                    BUG4555
      *                                                                                     BUG4555
      ** Determine if 24x7 Midas Availability active?                                       BUG4555
      *                                                                                     BUG4555
     C                   CALL      'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANK        @RTCD                                      BUG4555
     C                   PARM      '*VERIFY'     @OPTN                                      BUG4555
     C                   PARM      'CSC011'      @SARD                                      BUG4555
     C*                                                                                     BUG4555
     C     @RTCD         IFEQ      *BLANKS                                                  BUG4555
     C                   EVAL      CSC011  = 'Y'                                            BUG4555
     C                   ELSE                                                               BUG4555
     C                   EVAL      CSC011 = 'N'                                             BUG4555
     C                   ENDIF                                                              BUG4555
     C*                                                                                     BUG4555
     C                   IN        SDSTAT                                                   BUG4555
     C                   IN        SC24X7                                                   BUG4555
      *                                                                                     BUG4555
      ** Access SAR Details to see if COMPLIANCE WATCH ENHANCEMENT (CSD015)                 BUG4555
      ** is installed.                                                                      BUG4555
      *                                                                                     BUG4555
     C                   EVAL      CSD015 = 'N'                                             BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*VERIFY '    @OPTN                                      BUG4555
     C                   PARM      'CSD015'      @SARD                                      BUG4555
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        @RTCD = *BLANKS                                          BUG4555
     C                   EVAL      CSD015 = 'Y'                                             BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   IF        (@RTCD <> '*NRF    ') AND                                BUG4555
     C                             (@RTCD <> *BLANKS)                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG4555
     C                   EVAL      DBASE = 56                                               BUG4555
     C                   EVAL      DBKEY = @SARD                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
      ** Access SAR Details to see if Concord Interface Development (CCF001)                BUG4555
      ** is installed.                                                                      BUG4555
      *                                                                                     BUG4555
     C                   EVAL      CCF001 = 'N'                                             BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*VERIFY '    @OPTN                                      BUG4555
     C                   PARM      'CCF001'      @SARD                                      BUG4555
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        @RTCD = *BLANKS                                          BUG4555
     C                   EVAL      CCF001 = 'Y'                                             BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   IF        (@RTCD <> '*NRF    ') AND                                BUG4555
     C                             (@RTCD <> *BLANKS)                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG4555
     C                   EVAL      DBASE = 57                                               BUG4555
     C                   EVAL      DBKEY = @SARD                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   IF        CSD015 = 'Y'                                             BUG4555
      *                                                                                     BUG4555
      ** Access Compliance Watch Configuration file to get the                              BUG4555
      ** Private Customer Industry Codes                                                    BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOCWCDR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*FIRST '     @OPTN                                      BUG4555
     C     SDCWCD        PARM      SDCWCD        DSSDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        @RTCD <> *BLANKS                                         BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SDCWCDPD'                                      BUG4555
     C                   EVAL      DBASE = 58                                               BUG4555
     C                   EVAL      DBKEY = @OPTN                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
      ** Check if function code is being monitored by compliance watch.                     BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOWLCCR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*KEY   '     @OPTN                                      BUG4555
     C                   PARM      'LENDING'     @FUNC             8                        BUG4555
     C     SDWLCC        PARM      SDWLCC        DSFDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        (@RTCD <> '*NRF    ') AND                                BUG4555
     C                             (@RTCD <> *BLANKS)                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SDWLCCPD'                                      BUG4555
     C                   EVAL      DBASE = 59                                               BUG4555
     C                   EVAL      DBKEY = @FUNC                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   ENDIF                                                              BUG4555
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
     C                   EVAL      DBase  = 3                                                 CSC024
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
     C                   ENDIF                                                                240968
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C**********         PARM      *BLANKS       P@OP02                                CSC024 240968
     C                   PARM      CLAuthORED    P@OP02                                       240968
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C**********         PARM      *BLANKS       P@OP03                                CSC024 244314
     C                   PARM      CLAuthSMDT    P@OP03                                       244314
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
     C                   EVAL      DBase = 4                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C**********         ENDIF                                                         CSC024 240968
     C                   MOVEL     P@VL02        ATHORED           1                          240968
     C                   MOVEL     P@VL03        ATHOSMDT          1                          244314
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 7                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE056
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        CLE056
                                                                                              CLE056
     C                   EVAL      CLE056 = 'N'                                               CLE056
     C                   CALLB     'AOSARDR0'                                                 CLE056
     C                   PARM      *BLANKS       @RTCD                                        CLE056
     C                   PARM      '*VERIFY'     @OPTN                                        CLE056
     C                   PARM      'CLE056'      @SARD                                        CLE056
                                                                                              CLE056
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE056
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE056
     C                   EVAL      DBKey  = 'CLE056'                                          CLE056
     C                   EVAL      DBase  = 8                                                 CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056
     C/COPY WNCPYSRC,LEH00232
      *
      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   If        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'FAMD'        @APINAME                                     CAP185
     C     @APINAME      CHAIN     APICFGL0                                                   CAP185
     C                   IF        %FOUND(APICFGL0)                                           CAP185
     C                   MOVE      APAUT         @AUTHO            1                          CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
     C                   ELSE                                                                 CAP185
     C                   IF        @RTCD = '*NRF'                                             CAP185
     C                   MOVE      'N'           CAP185                                       CAP185
     C                   ELSE                                                                 CAP185
     C*                                                                                       CAP185
     C**    Database error processing                                                         CAP185
     C*                                                                                       CAP185
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CAP185
     C                   MOVEL     '185'         DBASE                          * DBERR 185 * CAP185
     C                   MOVEL     'CAP185'      DBKEY                          ************* CAP185
     C                   EXSR      *PSSR                                                      CAP185
     C                   ENDIF                                                                CAP185
     C                   ENDIF                                                                CAP185
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 09                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C*                  EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,LEH00233
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
