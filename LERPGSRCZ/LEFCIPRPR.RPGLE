     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility input repair')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIPRPR - LE Facility Input Repair                         *
      *                                                               *
      *  Function:  This is the screens input repair function for     *
      *             Facility                                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG6689            Date 13Aug12               *
      *                 LLN022A            Date 13Aug12               *
      *                 LLN022             Date 13Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR937578A          Date 04Apr12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 28May07               *
      *                 245219             Date 13Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027A            Date 08May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9077            Date 08Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 07Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG6689 - Program should execute the confirmation screen     *
      *            before executing the update.                       *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *           /COPY members and add switchability.                *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LEFCIPRF01,LEFCIPU011,LEFCIPDTA    *
      *                            LEFCIPRC05,LEFCIPRC01,LEFCIPRC07   *
      *                            LEFCIPRMV1                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR937578A - In Collateral and Credit Lines Enquiry, availed  *
      *              loans are both in reservation and exposure       *
      *              columns                                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE147 - Aggregate Facility                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00357                                 *
      *             WNCPYSRC,LEH00319                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  245219 - Missing facilities in extension file LEFCLTQD       *
      *           (Usually added by java layer)                       *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9077 - Action 'N' updates the database files even with    *
      *            errors.                                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3723 - Recompile due to changes to LEFCSPPD, LEEFCISPD,   *
      *            and LEFCIPPD.                                      *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Lending API enhancements - Facility input           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
     FLEIFCIPL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIFCIPD0 : LEIFCIPX0)
     FLEIFCIPL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *                                                                                       CER001
     FLEIFCLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
      ** LE facility invalid extension file                                                   CER001
      *                                                                                       CER001
      ** Midas LE Facilities Extension file                                                   245219
     FLEFCLTLH  UF A E           K DISK    INFSR(*PSSR)                                       245219
 
      ***  Hook to enable non-core files to be included
      *
     FLEIFCIPY0 UF   E           K DISK    INFSR(*PSSR) COMMIT                               LLN022A
     F                                     RENAME(LEIFCIX0:IFCIPD0)                          LLN022A
                                                                                             LLN022A
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
     D @EI             S              1    DIM(60)
      *
     D CrFcFilFmtFm  E DS                  EXTNAME(FCLTYFM)
      ***  Current Fclty in File Format FM
     D                                     PREFIX(M)
      *
     D CrFcFilFmtFn  E DS                  EXTNAME(FCLTYFN)
      ***  Current Fclty in File Format FN
     D                                     PREFIX(N)
      *
     D CrFcScnFmt1   E DS                  EXTNAME(LEFCPPPD)
      ***  (Current) Fclty in Screen Format - Screen 1
     D                                     PREFIX(@)
      *
     D CrFcScnFmt2   E DS                  EXTNAME(LEFCSPPD)
      ***  (Current) Fclty in Screen Format - Screen 2
     D                                     PREFIX(@)
      *
     D NwFcFilFmtFM  E DS                  EXTNAME(LEVFCIMPD)
      ***  New Fclty in File Format FM
      *
     D NwFcFilFmtFN  E DS                  EXTNAME(LEVFCINPD)
      ***  New Fclty in File Format FN
     D                                     PREFIX(N_)
     D NwFCIPFilFmt  E DS                  EXTNAME(LEVFCLX1PD)                                CER001
      *                                                                                       CER001
      ** LE Facility LUX Valid File                                                           CER001
      *
     D NwFcScnFmt1   E DS                  EXTNAME(LEFCPPPD)
      ***  New Fclty in Screen Format - Screen 1
      *
     D NwFcScnFmt2   E DS                  EXTNAME(LEFCSPPD)
      ***  New Fclty in Screen Format - Screen 2
      *
     D NwFCIPScnFmt  E DS                  EXTNAME(LEFCRXPD)                                  CER001
      *                                                                                       CER001
      ** LE Facility input extra data layout                                                  CER001
      *                                                                                       CER001
     D LEEFCIP1      E DS                  EXTNAME(LEEFCIPPD)
      ***  Error indicators Screen 1
      *
     D LEEFCIP2      E DS                  EXTNAME(LEEFCISPD)
      ***  Error indicators Screen 2
      *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ** First DS for access programs, long data structure                                    CGL029
                                                                                              CGL029
     D ExtData       E DS                  EXTNAME(LEFCEXPD)
      ***  LE (FCIP) Extra Data - File (D/B) format
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
                                                                                             LLN022A
     D ValidFCIPEx   E DS                  EXTNAME(LEVFCIPX0)                                LLN022A
     D                                     Prefix(N)                                         LLN022A
 
     D                 DS
     D  @SIFACR                1     11
     D  @SICSSN                1      6
     D  @SIFACT                7      9
     D  @SIFCNO               10     11
     D/COPY QWINDSRC,LEFCIPDTA                                                                LLN022
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S             26Z
                                                                                              CER001
     D DATALUX         DS          1024                                                       CER001
      *                                                                                       CER001
      **  Data  Structure for LUX Data                                                        CER001
      *                                                                                       CER001
     D  #1CNUM                 1      6                                                       CER001
     D  #1FACT                 7      9                                                       CER001
     D  #1FCNO                10     11                                                       CER001
     D  #1RCTP                12     12                                                       CER001
     D  #1CCY                 13     15                                                       CER001
     D  #1AMNT                16     30S 0                                                    CER001
     D  #1TMSP                31     56Z                                                      CER001
     D  #1FOID                57     76                                                       CER001
     D  #1DEXT                77     77                                                       CER001
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ***  -------------------------------------------------------------------
      ***  Fields for getting the starting field number from file (parameters
      ***  to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('LEFCIPPD')
      *
     D Field           S             10A   INZ('DDACTN')
     D FieldLx         S             10A   INZ('LSUBR')                                       CER001
      *
     D FieldNo         S              5P 0
      *
     D FldOffset       S              5P 0
     D FldOffsetLx     S              5P 0                                                    CER001
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
     D ULX004          S              1A   INZ                                                CER001
     D W8RTN           S              7A                                                      CER001
     D DDACTNB         S                   LIKE(DDACTN)                                       CER001
      *
      ***  End of fields for getting starting field number
      ***  -------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      ***  Do screen: Browse invalid Fclty
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      *
      ***  Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      ***  Do while screen: Screen details 1
     C     @SCRN         DOWEQ     '1'
     C                   EXSR      SCRN@1
     C                   END
      *
      ***  Do while screen: Screen details 2
     C     @SCRN         DOWEQ     '2'
     C                   EXSR      SCRN@2
     C                   END
      *                                                                                       LLN022
      ** Window: Display window if necessary                                                  LLN022
      *                                                                                       LLN022
     C     @SCRN         IFEQ      'W'                                                        LLN022
     C                   EXSR      WINDOW                                                     LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       CER001
      ** Process LUX additional screen fields                                                 CER001
      *                                                                                       CER001
     C     @SCRN         IFEQ      'L'                                                        CER001
     C                   EXSR      SRLuxDet                                                   CER001
     C                   ENDIF                                                                CER001
      *
      ***  Screen: Confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      ***  Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      ***  Terminate program
     C     @SCRN         IFEQ      'T'
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   CLOSE     LEIFCLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      * SRLuxDet                                                                              CER001
      *****************************************************************                       CER001
     C     SRLuxDet      BEGSR                                                                CER001
     C                   EVAL      #1CNUM  = DDCSSN                                           CER001
     C                   EVAL      #1FACT  = DDFACT                                           CER001
     C                   EVAL      #1FCNO  = DDFCNO                                           CER001
     C                   EVAL      #1CCY   = DDFCCY                                           CER001
     C                   MOVE      DDFAMT        #1AMNT                                       CER001
     C                   EVAL      #1TMSP  = @TMESTPSEL                                       CER001
     C                   EVAL      #1FOID  = DDFOTRANID                                       CER001
     C                   IF        @OPSEL  = 'N'                                              CER001
     C                   EVAL      DDACTNB = DDACTN                                           CER001
     C                   EVAL      DDACTN  = 'E'                                              CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** LE facility LUX repair                                                               CER001
      *                                                                                       CER001
     C                   CALL      'LEFCIP2RP'                                                CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANK        W8RTN                                        CER001
     C                   PARM                    NwFCIPScnFmt                                 CER001
     C                   PARM                    NwFCIPFilFmt                                 CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
     C                   IF        @OPSEL  = 'N'                                              CER001
     C                   EVAL      DDACTN  = DDACTNB                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      W8RTN  = 'Y2U9999'                                         CER001
     C                   EVAL      @SCRN  = 'T'                                               CER001
      *                                                                                       CER001
     C                   WHEN      W8RTN  = 'USR0790'                                         CER001
     C                   IF        @RDNB = 'R'                                                CER001
     C                   EVAL      @SCRN = 'R'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = '2'                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   WHEN      W8RTN  = *BLANKS And @OPSEL <> 'N'                         CER001
     C                   EVAL      @SCRN  = 'C'                                               CER001
      *                                                                                       CER001
     C                   WHEN      @OPSEL = 'N'                                               CER001
     C                   IF        @RDNB = 'Y'                                                CER001
     C                   EVAL      @SCRN  = 'R'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN  = 'B'                                               CER001
     C                   ENDIF                                                                CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Fclty
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LEFCIPRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
      *
      ***  Error in update of previous Fclty
     C                   PARM                    @ERRUP            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
     C                   PARM                    @OPSEL            1
      *
      ***  Action selected
     C                   PARM                    @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  Successfully Inserted Fclty Number
     C                   PARM                    @SIFACR
      *
      ***  If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANKS
     C                   MOVE      '1'           *INU6
     C                   END
      *
      ***  If CK/3 or CK/12 taken in browse, or error message
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      ***  Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LEFCIPRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      *BLANK        @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      'Y'           @RDSFL            1
      *
      ***  Error in update of previous Fclty
     C                   PARM                    @ERRUP            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Action selected
     C                   PARM      *BLANK        @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  Successfully Inserted Fclty Number
      *
     C                   PARM                    @SIFACR
      *
      ***  If CK/3 taken within invalid transaction deletion function,
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      ***  If invalid Fclty read from subfile
      *
     C     @OPSEL        IFNE      *BLANK
      *
      ***  Blank all screens
      *
     C                   MOVEL     *BLANK        NwFcScnFmt1
     C                   MOVEL     *BLANK        NwFcScnFmt2
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       LEEFCIP1
     C                   MOVE      *ALL'Y'       LEEFCIP2
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  Retrieve Fclty details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      ***  Make sure Invalid transaction's  details are passed to 'Retrieve'
      ***  module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     LEIFCIPX0                          99
      *
      ***  Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ***  if insert
      ***  if not insert and Midas transaction ID is not present
      ***  Otherwise
      ***  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C     DDCSSN        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVFclty
      *
      ***  If Fclty details were retrieved
      ***  Put the Fclty on the first details screen
      *
     C     DDACTN        IFNE      'I'
     C     Idx           ANDEQ     *ZERO
     C                   EXSR      PUTD@1
     C                   END
      *
      ***  Now overwite the fields on the main details screen with those
      ***  on the invalid Fclty file (except for the Midas Fclty number
      ***  and Midas associated Fclty number retrieved above using the
      ***  front office transaction and associated transaction IDs).
      ***  Access invalid Fclty with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDCSSN        ##DDCSSN         10
     C                   MOVEL     DDFACT        ##DDFACT          3
     C                   MOVEL     DDFCNO        ##DDFCNO          2
 
     C     ZATRNKX0      CHAIN     LEIFCIPX0                          99
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDCSSN      DDCSSN
     C                   MOVEL     ##DDFACT      DDFACT
     C                   MOVEL     ##DDFCNO      DDFCNO
     C                   END
      *
      ***  If Fclty details were retrieved and this is an amendment
      *
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDEQ     'A'
      *
      ***  Data Substitution - Transaction Details
      *
     C     GHSUBS        IFNE      *blank
     C     GHSUBS        SCAN      NwFcScnFmt1                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C     GHSUBS        SCAN      NwFcScnFmt2                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C                   END
 
     C                   END
      *
      ***  If action code, or Fclty number were NOT OK
      ***  blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      ***  Send the Fclty error messages to the main details screen
      *
     C                   EXSR      SNDM@1
      *
      ***  Go to first details screen
      *
     C                   MOVE      '1'           @SCRN
      *                                                                                       CER001
      ** retrieve invalid extension file if switchable is on                                  CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C     ZATRNKX0      CHAIN     LEIFCLX1L0                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   EVAL      LSUBR   = LISUBR                                           CER001
     C                   EVAL      LMOBL   = LIMOBL                                           CER001
     C                   EVAL      LDGRI   = LIDGRI                                           CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   RESET                   NwFCIPScnFmt                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
      ***  else if no invalid Fclty read from subfile
      *
     C                   ELSE
      *
      ***  Go to browse screen
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@1 - Send a message to first screen
      *****************************************************************
     C     SNDM@1        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ***  If there are fundamental errors in this transaction
      ***  Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ***  Initialize error indicators
      *
     C                   MOVEA     LEEFCIP1      @EI
      *
      ***  Read error messages for Fclty
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ***  Add error message to array passed to detail screen
      ***  and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C     ULX004        ANDNE     'Y'                                                        CER001
     C     *IN99         OREQ      '0'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
     C     ABFIELDID     ANDLE     FldOffsetLx                                                CER001
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           LEEFCIP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@1 - Process first screen
      *****************************************************************
     C     SCRN@1        BEGSR
      *
      ***  Enable/disable detail fields on main details screen
      ***  if changes to the data are allowed
      ***  (key fields = action code & Fclty number; detail fields = rest)
      ***  (Action code can only be 'I', 'A', 'R', 'C' or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD            1
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      ***  KJ = Command kay 10 = Delete
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      ***  Write/read display screen
      *
     C                   CALLB     'LEFCIP1DP'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty(in screen format)
     C                   PARM                    NwFcScnFmt1
      *
      ***  Fields in error
      *
     C                   PARM                    LEEFCIP1
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKV            1
     C                   PARM                    @EINKW            1
     C                   PARM                    @EINKX            1
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFACR          11
      * General ledger details used for Profit center validation
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
      * Switchable features
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE007
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKV             1
     C                   PARM                    @INKW             1
     C                   PARM                    @INKX             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       LEEFCIP1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on first screen
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  Validate input to first screen
      *
     C                   CAS                     VAL@1
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@2 - Process second screen
      *****************************************************************
     C     SCRN@2        BEGSR
      *
      ***  If action code is delete, close, enquire, authorize or amend
      ***  Put the Fclty on the details screen 2
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C                   EXSR      PUTD@2
     C                   END
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LEFCIP2DP'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty(in screen format 1 )
     C                   PARM                    NwFcScnFmt1
      *
      ***  Fclty(in screen format 2 )
     C                   PARM                    NwFcScnFmt2
      *
      ***  Fields in error
      *
     C                   PARM                    LEEFCIP2
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP
     C                   PARM                    @EINKV
     C                   PARM                    @EINKW
     C                   PARM                    @EINKX
      *
      ***  Action code
      *
     C                   PARM      DDACTN        PActionCode       1
      *
      ***  Switchable features
      *
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE008
 
      * Participant Facility ind. from FCLTYFM file
     C                   PARM                    H#PRTR
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM                    @INKC
     C                   PARM                    @INKJ
     C                   PARM                    @INKL
     C                   PARM                    @INKP
     C                   PARM                    @INKV
     C                   PARM                    @INKW
     C                   PARM                    @INKX
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       LEEFCIP2
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on first screen
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  Validate input to first screen
      *
     C                   CAS                     VAL@2
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@1  - Validate input to first screen
      *****************************************************************
     C     VAL@1         BEGSR
      *
      ***  Retrieve Fclty details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVFclty
      *
      ***  If action code, or Fclty number are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C                   GOTO      EVAL@1
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete or close
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
      *
      ***  Update Fclty in File Format
      *
     C                   MOVEL     CrFcFilFmtFM  NwFcFilFmtFM
     C                   MOVEL     CrFcFilFmtFN  NwFcFilFmtFN
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@1
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Fclty in File Format
      *
     C                   MOVEL     CrFcFilFmtFM  NwFcFilFmtFM
     C                   MOVEL     CrFcFilFmtFN  NwFcFilFmtFN
      *
      ***  Continue to second screen
      *
     C                   MOVEL     '2'           @SCRN
      *
     C                   GOTO      EVAL@1
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Fclty in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       LEEFCIP1
     C                   CLEAR                   NwFcFilFmtFM
     C                   CLEAR                   NwFcFilFmtFN
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update Fclty in File Format
      *
     C                   MOVEL     CrFcFilFmtFM  NwFcFilFmtFM
     C                   MOVEL     CrFcFilFmtFN  NwFcFilFmtFN
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LEFCIPAMD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Fclty in Screen Format
     C                   PARM                    NwFcScnFmt1
     C                   PARM                    NwFcScnFmt2
      *
      ***  Current Fclty in Screen Format
     C                   PARM                    CrFcScnFmt1
     C                   PARM                    CrFcScnFmt2
      *
      ***  Current Fclty in file format
     C                   PARM                    CrFcFilFmtFM
     C                   PARM                    CrFcFilFmtFN
      * Switchable features
     C                   PARM                    CLE005            1
     C                   PARM                    CLE006            1
     C                   PARM                    CLE007            1
     C                   PARM                    CLE008            1
      *
      * Screen to validate
     C                   PARM      '1'           SCREEN            1
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    LEEFCIP1
     C                   PARM                    LEEFCIP2
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    @@AMOK            1
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      ***  Validate Fcltydetails
      *
     C                   CALLB     'LEFCIP1VL'
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
     C                   PARM                    NwFcScnFmt1
     C                   PARM                    NwFcScnFmt2                                  CLE106
     C                   PARM                    CrFcFilFmtFM
     C                   PARM                    CrFcFilFmtFN
      * Front Office ID
     C                   PARM                    APFOTranID       20
     C                   PARM                    CLE002            1
     C                   PARM                    CLE005            1
     C                   PARM                    CLE007            1
     C                   PARM                    CLE014            1
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
     C                   PARM                    ExtData         500
 
      * OUTPUTS
     C                   PARM                    LEEFCIP1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwFcFilFmtFM
     C                   PARM                    NwFcFilFmtFN
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
      * Start date used in another module
     C                   PARM                    WWDTAP            5
      * Expiry date used in another module
     C                   PARM                    WWDTEX
      * Decimal places
     C                   PARM                    WWNBDP            1
      * CA currency
     C                   PARM                    WCACCY            3
      * Facility amount
     C                   PARM                    W#FAMT           13 0
      * Account officer to default
     C                   PARM                    WBLACF            1
      * Credit Agreement Change Flag                                                          CLE147
     C                   PARM                    CADetails        33                          CLE147
      *
     C     DDACTN        IFEQ      'I'
     C     DDFCNO        ANDNE     *BLANKS
     C                   MOVEL     DDFCNO        WWFCNO            2
     C                   MOVEL     *BLANKS       DDFCNO
     C                   END
      *
      ***  If errors returned
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C                   GOTO      EVAL@1
     C                   END
      *
      ***  Continue
      *
     C                   MOVEL     '2'           @SCRN
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@2  - Validate input to second screen
      *****************************************************************
     C     VAL@2         BEGSR
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@2
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert, amend or close
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       LEEFCIP2
      *
      ***  If amend or close
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'C'
      *
      ***  Validate whether non-amenable fields have been changed
     C                   CALLB     'LEFCIPAMD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Fclty in Screen Format
     C                   PARM                    NwFcScnFmt1
     C                   PARM                    NwFcScnFmt2
      *
      ***  Current Fclty in Screen Format
     C                   PARM                    CrFcScnFmt1
     C                   PARM                    CrFcScnFmt2
      *
      ***  Current Fclty in file format
     C                   PARM                    CrFcFilFmtFM
     C                   PARM                    CrFcFilFmtFN
      * Switchable features
     C                   PARM                    CLE005            1
     C                   PARM                    CLE006            1
     C                   PARM                    CLE007            1
     C                   PARM                    CLE008            1
      *
      * Screen to validate
     C                   PARM      '2'           SCREEN            1
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    LEEFCIP1
     C                   PARM                    LEEFCIP2
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    @@AMOK            1
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      ***  Validate Fcltydetails
      *
     C                   CALLB     'LEFCIP2VL'
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
     C                   PARM                    NwFcScnFmt1
     C                   PARM                    NwFcScnFmt2
      * Facility - file formats
     C                   PARM                    CrFcFilFmtFM
     C                   PARM                    CrFcFilFmtFN
      * Front Office ID
     C                   PARM                    APFOTranID       20
      * Start date
     C                   PARM                    WWDTAP            5
      * Expiry date
     C                   PARM                    WWDTEX            5
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * Next expiry date
     C                   PARM                    WNDTEX            5
      * Facility decimal places
     C                   PARM                    WWNBDP            1
      * OK indicator - filed TRCA
     C                   PARM                    OKTRCA            1
 
      * OK indicator - filed CAFT
     C                   PARM                    OKCAFT            1
      * OK indicator - filed CAFN
     C                   PARM                    OKCAFN            1
      * CA currency
     C                   PARM                    WCACCY            3
      * Facilty amount
     C                   PARM                    W#FAMT           13 0
      * Account officer to default
     C                   PARM                    WBLACF            1
      * Participant Facility ind. from FCLTYFM file
     C                   PARM                    H#PRTR
 
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
      * CLE005
     C                   PARM                    CLE005            1
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
      * CSC011
     C                   PARM                    CSC011            1
      * CEU013
     C                   PARM                    CEU013            1
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    LEEFCIP2
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    NwFcFilFmtFM
     C                   PARM                    NwFcFilFmtFN
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
 
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C                   GOTO      EVAL@2
     C                   END
      *
      ***  Continue with updates
      *
     C                   IF        BGWDPR = 'Y'                                               LLN022
     C                   MOVE      @SCRN         B@SCRN            1                         BUG6689
     C                   EVAL      @SCRN = 'W'                                                LLN022
     C                   ELSE                                                                 LLN022
     C**********         MOVEL     'U'           @SCRN                                LLN022 BUG6689
     C                   EVAL      @SCRN = 'C'                                               BUG6689
     C                   ENDIF                                                                LLN022
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
     C**********         MOVEL     'U'           @SCRN                                       BUG9077
     C                   IF        @OPSEL <> 'N'                                             BUG9077
     C                   EVAL      @SCRN   = 'C'                                             BUG9077
     C                   ELSE                                                                BUG9077
     C     @RDNB         IFEQ      'Y'                                                       BUG9077
     C                   MOVEL     'R'           @SCRN                                       BUG9077
     C                   ELSE                                                                BUG9077
     C                   MOVEL     'B'           @SCRN                                       BUG9077
     C                   ENDIF                                                               BUG9077
     C                   ENDIF                                                               BUG9077
     C                   ENDIF                                                                CER001
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@2        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVFclty- Retrieve Fclty
      *****************************************************************
     C     RTVFclty      BEGSR
      *
      ***  Retrieve Fclty
      *
     C                   CALLB     'LEFCIPRTV'
      *
      ***  Inputs
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ***  Response mode SECURITY CKECKING
     C                   PARM      'S'           @@RSMD            1
      *
      ***  Action Code
     C                   PARM                    DDACTN
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C                   PARM                    DDCSSN           10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Branch
     C                   PARM                    DDBRCA            3
     C/COPY WNCPYSRC,LEH00357
      *
      ***  Outputs
      *
      ***  (Current) Fclty in file format
     C                   PARM                    CrFcFilFmtFM
     C                   PARM                    CrFcFilFmtFN
      *
      ***  OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ***  OK - Fclty Number
     C                   PARM      *BLANK        DDCSSNOK
     C                   PARM      *BLANK        DDFACTOK
     C                   PARM      *BLANK        DDFCNOOK
     C/COPY WNCPYSRC,LEH00319
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * New expiry date
     C                   PARM                    WNDTEX            5
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C                   MOVEL     MPRTR         H#PRTR            1
     C                   MOVEL     MTNLU         H#TNLU            5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@1 - Put a Fclty on the first details screen              *
      *****************************************************************
     C     PUTD@1        BEGSR
      *
      ***  Call program to fill screen fields with data from FCLTYFM and FCLTYFN
      *
     C                   CALLB     'LEFCIPCVT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Fclty in file format FM
     C                   PARM                    CrFcFilFmtFM
      *
      ***  Fclty in file format FN
     C                   PARM                    CrFcFilFmtFN
      *
      ***  Outputs
      *
      ***  Fclty in screen format
     C                   PARM                    NwFcScnFmt1
     C                   PARM                    NwFcScnFmt2
      *
      ***  Update 'Current' Fclty with Fclty in Screen Format
     C                   MOVEL     NwFcScnFmt1   CrFcScnFmt1
     C                   MOVEL     NwFcScnFmt2   CrFcScnFmt2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@2 - Put a Fclty on the second details screen             *
      *****************************************************************
     C     PUTD@2        BEGSR
      *
      ***  Call program to fill screen fields with data from FCLTYFM and FCLTYFN
      *
     C                   CALLB     'LEFCIPCVT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Fclty in file format FM
     C                   PARM                    CrFcFilFmtFM
      *
      ***  Fclty in file format FN
     C                   PARM                    CrFcFilFmtFN
      *
      ***  Outputs
      *
      ***  Fclty in screen format
     C                   PARM                    NwFcScnFmt1
     C                   PARM                    NwFcScnFmt2
      *
      ***  Update 'Current' Fclty with Fclty in Screen Format
     C                   MOVEL     NwFcScnFmt1   CrFcScnFmt1
     C                   MOVEL     NwFcScnFmt2   CrFcScnFmt2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@A - Cancel on all screens
      *****************************************************************
     C     CANC@A        BEGSR
      *
      ***  If records are still to be read from the subfile, read them
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C     @RDNB         ANDEQ     'Y'
     C                   MOVEL     'R'           @SCRN
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL     '1'           @SCRN
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *                                                                                       LLN022
      *****************************************************************                       LLN022
      /EJECT                                                          *                       LLN022
      *****************************************************************                       LLN022
      *                                                               *                       LLN022
      * WINDOW - Process window:                                      *                       LLN022
      *                                                               *                       LLN022
      *****************************************************************                       LLN022
      *                                                                                       LLN022
     C     WINDOW        BEGSR                                                                LLN022
      *                                                                                       LLN022
     C/COPY WNCPYSRC,LEFCIPRMV1                                                               LLN022
      *                                                                                       LLN022
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVEL     DDCSSN        BYCNUM                                      LLN022A
     C                   MOVE      DDFACT        BYFACT                                      LLN022A
     C                   MOVE      DDFCNO        BYFCNO                                      LLN022A
     C                   MOVE      DDFCCY        BYFCCY                                      LLN022A
     C                   MOVE      @FOTRANSEL    BYFRNT                                      LLN022A
     C                   MOVE      @TMESTPSEL    BYTIME                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Pass Action Code 'E' if option selected is 'N' otherwise,                            LLN022
      ** pass DDACTN                                                                          LLN022
      *                                                                                       LLN022
     C                   IF        @OPSEL = 'N'                                               LLN022
     C                   EVAL      ACTION = 'E'                                               LLN022
     C                   ELSE                                                                 LLN022
     C                   EVAL      ACTION = DDACTN                                            LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
      ** Call Window Processing program                                                       LLN022
      *                                                                                       LLN022
     C                   CALL      'WN0010'                                                   LLN022
     C                   PARM      'LEFCIPRPR'   #PGM             10                          LLN022
     C                   PARM                    FKEY              2                          LLN022
     C                   PARM                    ACTION            1                          LLN022
     C                   PARM                    DATA                                         LLN022
     C                   PARM      *BLANKS       #RTRN             7                          LLN022
     C                   PARM                    SPAREW          256                          LLN022
      *                                                                                       LLN022
     C                   SELECT                                                               LLN022
      *                                                                                       LLN022
      ** Return code is Y2U999, end processing                                                LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'Y2U9999'                                          LLN022
     C                   EXSR      ENDP                                                       LLN022
      *                                                                                       LLN022
      ** Return code is USR0790, return to previous screen                                    LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'USR0790'                                          LLN022
     C                   EVAL      @SCRN = B@SCRN                                             LLN022
      *                                                                                       LLN022
      ** ENTER key is pressed, if Enquiry proceed to next record else                         LLN022
      ** display confirmation screen                                                          LLN022
      *                                                                                       LLN022
     C                   OTHER                                                                LLN022
     C                   IF        ACTION = 'E' and                                           LLN022
     C                             @RDNB = 'Y'                                                LLN022
     C                   EVAL      @SCRN = 'R'                                                LLN022
     C                   ELSE                                                                 LLN022
     C                   EVAL      @SCRN = 'C'                                                LLN022
     C                   ENDIF                                                                LLN022
     C                   ENDSL                                                                LLN022
      *                                                                                       LLN022
     C                   ENDSR                                                                LLN022
      *                                                                                       LLN022
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process screen: Confirmation of input                *
      *          evoked for inserts, amends & authorizations          *
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      ***  Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
 
      ***  Write/read display screen
      *
     C                   CALLB     'LEFCIP1DP'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty (in screen format)
      *
     C                   PARM                    NwFcScnFmt1
      *
      ***  Fields in error
      *
     C                   PARM                    LEEFCIP1
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKV            1
     C                   PARM                    @EINKW            1
     C                   PARM                    @EINKX            1
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFACR
      *
      * General ledger details used for Profit center validation
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
      * Switchable features
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE007
      ***  Output parameters
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKV             1
     C                   PARM                    @INKW             1
     C                   PARM                    @INKX             1
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       LEEFCIP1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on confirmation screen
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      ***  Exit confirmation screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to second detail screen
      *
     C                   MOVEL     '2'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  Else, return to first details screen
      *
     C                   ELSE
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ** Restore Seq.number if Insert mode
     C     DDACTN        IFEQ      'I'
     C     DDFCNO        ANDEQ     *BLANKS
     C                   MOVEL     WWFCNO        DDFCNO
     C                   END
 
     C                   MOVEL     DDCSSN        @SICSSN
     C                   MOVEL     DDFACT        @SIFACT
     C                   MOVEL     DDFCNO        @SIFCNO
      *
      ***  Update valid Fclty: Fclty number
      *
     C                   MOVEL     DDCSSN        FPCNUM
     C                   MOVE      DDFACT        FPFACT
     C                   MOVE      DDFCNO        FPFCNO
 
     C                   MOVEL     DDCSSN        N_FNCNUM
     C                   MOVE      DDFACT        N_FNFACT
     C                   MOVE      DDFCNO        N_FNFCNO
      *
      ***  Update valid Fclty: Last action code
      *
     C                   MOVEL     DDACTN        FPCHTP
     C                   MOVEL     DDACTN        N_FNCHTP
      *
      ***  Update valid loan: Front office transaction ID
      *
     C                   MOVEL     @FOTRANSEL    FPFRNT
      *
      ***  Fclty updates
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C                   CALLB     'LEFCIPUPD'
     C                   PARM                    @RTCD
     C                   PARM                    P#MODE            1
     C                   PARM                    NwFcFilFmtFM
     C                   PARM                    NwFcFilFmtFN
     C                   PARM                    CLE008            1
     C                   PARM                    CSC011            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3                       AR937578A
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    H#TNLU
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    LEEFCIP1
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
 
     C                   END
      *                                                                                      LLN022A
      ** If LLN007 installed update BOE data                                                 LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   IF        @RTCD = *Blank                                            LLN022A
                                                                                             LLN022A
     C                   EVAL      NLVCNUM = BYCNUM                                          LLN022A
     C                   EVAL      NLVFACT = BYFACT                                          LLN022A
     C                   EVAL      NLVFCNO = BYFCNO                                          LLN022A
     C                   EVAL      NLVAFRT = BYFRNT                                          LLN022A
     C                   EVAL      NLVTMST = BYTIME                                          LLN022A
     C                   EVAL      NLVEURO = BYEURO                                          LLN022A
                                                                                             LLN022A
     C                   CALLB     'LEFCIPUPD1'                                              LLN022A
     C                   PARM      *Blanks       p_RTCD            7                         LLN022A
     C                   PARM      DDACTN        p_Actn            1                         LLN022A
     C                   PARM                    ValidFCIPEx                                 LLN022A
                                                                                             LLN022A
     C                   EVAL      @RTCD = p_RTCD                                            LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C                   IF        @RTCD   = *BLANK AND ULX004 = 'Y'                          CER001
     C                   EVAL      LVFCNO  =  FPFCNO                                          CER001
     C                   CALLB     'LEFCIP2UP'                                                CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    NwFCIPFilFmt                                 CER001
      *                                                                                       CER001
      ** If update not done due to record has been updated by another                         CER001
      ** workstation send message to screen.                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = '*RECUPD'                                        CER001
     C                   EVAL      Idx     = Idx + 1                                          CER001
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                   CER001
     C                   EVAL      MsgIdArr(Idx) = 'ER99919'                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If update not done due to record being locked by another                             CER001
      ** workstation send message to screen.                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = '*RECLCK'                                        CER001
     C                   EVAL      Idx     = Idx + 1                                          CER001
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                   CER001
     C                   EVAL      MsgIdArr(Idx)  = 'ERL0950'                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANK
      *   ROLLBACK data if either of the following is true:                                   CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N'                                              CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkipCommit = 'N'                                          CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Eval      *InU7 = *On                                                CSC022
     C                   Eval      *InU8 = *On                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
                                                                                              245219
      ** Add record within Facilities Extension File (done from Java layer).                  245219
     C**********         IF        DDACTN = 'I'                                         245219247888
     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
     C                   EXSR      WriteFCLTQD                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C     ZATRNKD0      CHAIN     LEIFCIPD0                          99
     C  N99              DELETE    LEIFCIPD0
     C                   IF        ULX004  = 'Y'                                              CER001
     C     ZATRNKX0      CHAIN     LEIFCLX1L0                                                 CER001
     C                   IF        %FOUND(LEIFCLX1L0)                                         CER001
     C                   DELETE    LEIFCIPXD6                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
      ***  Delete invalid record from the log file
      *
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
      *
     C                   EVAL      KMsgType = 'LEFCIP'
     C                   EVAL      KFrntOffID = DDFOTRANID
     C                   EVAL      KTimeStamp = DDTMESTMP
      *
     C     KAPLOG        CHAIN     APILOGL0                           99
      *
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C     ZATRNKD0      CHAIN     LEIFCIPY0                                                 LLN022A
     C                   IF        %Found(LEIFCIPY0)                                         LLN022A
     C                   DELETE    IFCIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
      ***  If error occurred in updating last transaction set on flag to
      ***  display message on 'browse' screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to first details screen
      *
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
      ** reset return code                                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   EVAL      @RTCD   = *BLANK                                           CER001
     C                   ENDIF                                                                CER001
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program
      *****************************************************************
     C     ENDP          BEGSR
      *
      ** Issue rollback                                                                       LLN022
      *                                                                                       LLN022
     C                   IF        BGWDPR = 'Y'                                               LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *****************************************************************
      *
     C     TDtDtaSubs    BEGSR
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL(P)  NwFcScnFmt1   IncDATA
     C                   MOVEL(P)  CrFcScnFmt1   CurDATA
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL(P)  NwFcScnFmt2   IncDATA
     C                   MOVEL(P)  CrFcScnFmt2   CurDATA
     C                   ENDSL
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode       10
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      *
      ***  Incoming Data
     C                   PARM                    IncDATA        2000
      *
      ***  Current Data
     C                   PARM                    CurDATA        2000
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL(P)  IncDATA       NwFcScnFmt1
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL(P)  IncDATA       NwFcScnFmt2
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  245219
      *****************************************************************                       245219
      *                                                               *                       245219
      * WriteFCLTQD - WRITE Facility record to extension file         *                       245219
      *               (Usually done from Java layer)                  *                       245219
      *                                                               *                       245219
      *****************************************************************                       245219
     C     WriteFCLTQD   BEGSR                                                                245219
      *                                                                                       245219
      ** When opening new facilities within FCLTYFM write a corresponding                     245219
      ** record in extension file LEFCLTQD.                                                   245219
      *                                                                                       245219
     C     @KeyFCIPH     KLIST                                                                245219
     C                   KFLD                    FCXFCU                                       245219
     C                   KFLD                    FCXFTP                                       245219
     C                   KFLD                    FCXFNO                                       245219
      *                                                                                       245219
     C                   MOVEL     DDCSSN        FCXFCU                                       245219
     C                   MOVE      DDFACT        FCXFTP                                       245219
     C                   MOVE      DDFCNO        FCXFNO                                       245219
      *                                                                                       245219
     C     @KeyFCIPH     CHAIN     LEFCLTD0                           82                      245219
      *                                                                                       245219
     C     *IN82         IFEQ      *ON                                                        245219
     C                   EVAL      FCXBRC = DDBRCA                                            245219
     C                   EVAL      FCTSTP = DDTMESTMP                                         247888
     C                   WRITE     LEFCLTD0                                                   245219
                                                                                              245219
     C                   ENDIF                                                                245219
                                                                                              245219
     C                   ENDSR                                                                245219
      *****************************************************************                       245219
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LEFCIPRPR'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      ***  Initialize program name
      *
     C                   MOVEL     'LEFCIPRPR'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      *
      ***  Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
 
      ** Determine if CLE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
 
      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
 
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
 
      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
      *
      ** Determine if CLE014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ENDIF
      *
      ** Determine if CEU013 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Determine if ULX004 is installed                                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD   = *BLANK                                           CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   IF        @RTCD   = '*NRF'                                           CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '005'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   OPEN      LEIFCLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      *
      ***  Key Lists
      *
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
      *
      ***  Get the field number for the action code field; the screen fields
      ***  start from that number.  Subtract one from it to give the value
      ***  to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ***  If there was an error default the offset to 13
      *
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *                                                                                       CER001
      ** Get field number of the first field from extension details screen                    CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   CALLB     'ZACGTFLDNO'                                               CER001
     C                   PARM      *BLANKS       ReturnCode                                   CER001
     C                   PARM                    Format                                       CER001
     C                   PARM                    FieldLx                                      CER001
     C                   PARM                    FieldNo                                      CER001
      *                                                                                       CER001
     C                   IF        ReturnCode = *BLANK                                        CER001
     C                   EVAL      FldOffsetLx = FieldNo - 1                                  CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      FldOffsetLx = FldOffset                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
      ***  Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
 
     C                   EVAL      @RTCD = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
