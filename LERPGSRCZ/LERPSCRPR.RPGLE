     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid Repayments Schedule - Repair')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCRPR - LE Invalid Repayments Schedule - Repair          *
      *                                                               *
      *  Function:  This is the screens input repair function for     *
      *             Repayments Schedule                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSD095             Date 08Apr14               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246770             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4960            Date 22Dec04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA070             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP079  *CREATE    Date 13Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246770 - Warning messages are blocking the repair, change    *
      *           process to continue with warning message(s).        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG4960 - Unable to enter repayment schedule with settlement *
      *            method 04.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
     FLEIRPSCL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIRPSCD0 : LEIRPSCX0)
     FLEIRPSCL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LERPSCR001
      *
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
     D @EI             S              1    DIM(60)
      *
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
     D CrRpScFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Current repayment in File Format
     D                                     PREFIX(L)
     D***RSREC**              321    389                                                      CGL029
     D***RSPAY**              390    948                                                      CGL029
     D  RSREC                335    389                                                       CGL029
     D  RSPAY                404    948                                                       CGL029
     D  RSRECEx             1195   1212                                                       CGL029
     D  RSPAYEx             1213   1230                                                       CGL029
      *
     D CrRpScScnFmt  E DS                  EXTNAME(LERPSCPD)
      ***  Current repayment in Screen Format
     D                                     PREFIX(@)
      *
     D NwRpScFilFmt  E DS                  EXTNAME(LEVRPSCPD)
      ***  New Repayment in File Format CL
     D***NRSREC*              321    389                                                      CGL029
     D***NRSPAY*              390    948                                                      CGL029
     D  NRSREC               335    389                                                       CGL029
     D  NRSPAY               404    948                                                       CGL029
     D  NRSRECEx            1195   1212                                                       CGL029
     D  NRSPAYEx            1213   1230                                                       CGL029
      *
     D NwRpScScnFmt  E DS                  EXTNAME(LERPSCPD)
      ***  New Repayment schedule in Screen Format
      *
     D ErrorRpSc     E DS                  EXTNAME(LEERPSCPD)
      ***  Error indicators Screen 1
      *
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ***  Midas API Message Header Format Definition
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * LE (LERI) Extra Data - File (D/B) format                                              CAP086
      *
      **********************************
      ** Settlement instructions part **
      **********************************
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** File payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS instructions
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen receive instructions
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen payment instructions
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS instructions
      *
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      ***  Pay Settlement Instructions - Current
      *
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      ***  Receive Settlement Instructions - Current
      *
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      ***  FRA/IRS Settlement Instructions - Current
      *
     D @SETIN          DS
      ***  Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D***@@RONS*                6     17                                                      CGL029
     D***@@PSCY*               18     20                                                      CGL029
     D***@@PSTM*               21     22  0                                                   CGL029
     D***@@PONS*               23     34                                                      CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer Lending ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D ExtData       E DS                  EXTNAME(LERPEXPD)
      ***  LE (RPSC) Extra Data - File (D/B) format
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CLE134
      ***  Second DS for access programs, long data structure                                 CLE134
      *                                                                                       CLE134
     D  OldStsDS       DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029
      *
     D  NewStsDS       DS
      ***  New settlement details
      *
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***WSPI1**               35     64                                                      CGL029
     D***WSPI2**               65     94                                                      CGL029
     D***WSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  WSPI1                 41     70                                                       CGL029
     D  WSPI2                 71    100                                                       CGL029
     D  WSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029
      *
     D  PasDtaDS       DS           256
      ***  New settlement details
      *
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ***  -------------------------------------------------------------------
      ***  Fields for getting the starting field number from file (parameters
      ***  to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('LERPSCPD')
      *
     D Field           S             10A   INZ('DDLNRF')
      *
     D FieldNo         S              5P 0
      *
     D FldOffset       S              5P 0
      *
      ***  End of fields for getting starting field number
      ***  -------------------------------------------------------------------
      *
      ***  Message type field for chaining to APIDSETPD; defined in terms
      ***  of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
      *
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                              TDA070  BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
                                                                                              TDA070
     D CAP086          S              1A                                                      CAP086
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
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
      /COPY WNCPYSRC,LERPSCR002
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
      /COPY WNCPYSRC,LERPSCR003
      ***  Do screen: Browse invalid Repayments schedule
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      /COPY WNCPYSRC,LERPSCR004
      *
      ***  Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      /COPY WNCPYSRC,LERPSCR005
      *
      ***  Do while screen: Screen details
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      /COPY WNCPYSRC,LERPSCR006
      *
      ***  Do while screen: Settlement details
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      /COPY WNCPYSRC,LERPSCR010
      *
      ***  Screen: Confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      /COPY WNCPYSRC,LERPSCR011
      *
      ***  Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      /COPY WNCPYSRC,LERPSCR012
      *
      ***  Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LERPSCR013
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Repayments
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LERPSCRPB'
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
      ***  Branch code
     C                   PARM                    @BRCA             3
      *
      ***  Error in update of previous repayment schedule
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
      ***  Successful Insert repayment schedule
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LSSQ             3
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
     C                   CALLB     'LERPSCRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      *BLANK        @BDSFL
      *
      ***  Read subfile record
     C                   PARM      'Y'           @RDSFL
      *
      ***  Branch code
     C                   PARM                    @BRCA
      *
      ***  Error in update of previous repayment schedule
     C                   PARM                    @ERRUP
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS
      *
      ***  Option selected
     C                   PARM      *BLANK        @OPSEL
      *
      ***  Action selected
     C                   PARM      *BLANK        @ACSEL
      *
      ***  FO transaction ID selected
     C                   PARM      *BLANK        @FOTRANSEL
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ***  Successful Insert repayment schedule
     C                   PARM                    @LNRF
     C                   PARM                    @VDAT
     C                   PARM                    @LSSQ
      *
      ***  If CK/3 taken within invalid transaction deletion function,
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      ***  If invalid repayment read from subfile
      *
     C     @OPSEL        IFNE      *BLANK
      *
      ***  Blank all screens
      *
     C                   MOVEL     *BLANK        NwRpScScnFmt
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  Retrieve Repayment details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      ***  Make sure Invalid transaction's  details are passed to 'Retreive'
      ***  module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     LEIRPSCX0                          99
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
     C     DDLNRF        IFEQ      *BLANK
     C     DDVDAT        OREQ      *BLANK
     C     DDSEQN        OREQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVRPSC
      *
      ***  If repayment schedule details were retrieved
      ***  Put the repayment schedule on the details screen
      *
     C     DDACTN        IFNE      'I'
     C     Idx           ANDEQ     *ZERO
     C                   EXSR      PUTD@M
     C                   END
      *
      ***  Now overwite the fields on the main details screen with those
      ***  on the invalid repayment sch. file
      ***  Access invalid repayment sch. with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDLNRF        ##DDLNRF          6
     C                   MOVEL     DDVDAT        ##DDVDAT          6
     C                   MOVEL     DDSEQN        ##DDSEQN          3
     C     ZATRNKX0      CHAIN     LEIRPSCX0                          99
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDLNRF      DDLNRF
     C                   MOVEL     ##DDVDAT      DDVDAT
     C                   MOVEL     ##DDSEQN      DDSEQN
     C                   END
      *
      ***  Access invalid repayment schedule settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *
      ***  If repayment sch. details were retrieved and this is an amendment
      *
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDEQ     'A'
      *
      ***  Data Substitution - Transaction Details
      *
     C     GHSUBS        IFNE      *blank
     C     GHSUBS        SCAN      NwRpScScnFmt                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C                   END
      *
      ***  Setup settlement instructions on amend
      *
     C                   EXSR      SetupAmend
      *
      ***  Data Substitution - Settlement Details
      *
     C     GHSUBS        ifne      *BLANKS
     C     GHSUBS        SCAN      ##PAYS                                 99
     C  N99GHSUBS        SCAN      ##RECS                                 99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   END
     C                   END
 
     C                   END
      *
      ***  If action code, or loan number, or value date, or sequence were NOT OK
      ***  blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDVDATOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      ***  Send the repayment sch. error messages to the details screen
      *
     C                   EXSR      SNDM@M
      *
      ***  Go to details screen
      *
     C                   MOVE      'M'           @SCRN
      *
      ***  else if no invalid repayment sch. read from subfile
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
      * SNDM@M - Send a message to first screen
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ***  If there are fundamental errors in this transaction
      ***  Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ***  Initialize error indicators
      *
     C                   MOVEA     ErrorRpSc     @EI
      *
      ***  Read error messages for repayment schedule
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ***  Add error message to array passed to detail screen
      ***  and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
      *
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           ErrorRpSc
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - Process details screen
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      ***  Enable/disable detail fields on main details screen
      ***  if changes to the data are allowed
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
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ***  KK = Command Key 11 = Authorize
      *
     C     DDACTN        IFEQ      'X'
     C     BPAURV        ANDEQ     'Y'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EINKK
     C                   ELSE
     C                   MOVEL     'N'           @EINKK
     C                   END
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LERPSCDSP'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Repayment schedule (in screen format)
     C                   PARM                    NwRpScScnFmt
      *
      ***  Fields in error
      *
     C                   PARM                    ErrorRpSc
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
     C                   PARM                    @EINKK            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ***  Succesful insert
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LSSQ             3
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKK             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
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
     C     @INKL         CASEQ     '1'           CANC@M
      *
      ***  Validate input to screen
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - Validate input to main screen
      *****************************************************************
     C     VAL@M         BEGSR
      *
      ***  Retrieve repayment schedule details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVRPSC
      *
      ***  If action code, loan number, value date or sequense are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDVDATOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update repayment schedule in File Format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update repayment schedule in File Format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear repayment schedule in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       ErrorRpSc
     C                   CLEAR                   NwRpScFilFmt
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update repayment schedule in File Format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LERPSCAMD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New repayment schedule in Screen Format
     C                   PARM                    NwRpScScnFmt
      *
      ***  Current repayment schedule in Screen Format
     C                   PARM                    CrRpScScnFmt
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    ErrorRpSc
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      ***  Validate repayment schedule details
      *
     C                   CALLB     'LERPSC1VL'
     C                   PARM                    RespMode
     C                   PARM                    NwRpScScnFmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    ErrorRpSc
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwRpScFilFmt
     C                   PARM                    PTypFilCLOAN      2
     C                   PARM                    BrcaFilCLOAN      3                         BUG4960
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C*****WIdx          ORNE      0                                                          246770
     C                   GOTO      EVAL@M
     C                   END
      *
      ***  Continue
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   END
                                                                                              CAP086
      * Setup Automatic Authorisation flag on the Valid file                                  CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      RPAUTH = DDAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - Additional validation                                *
      *****************************************************************
     C     VAL@S         BEGSR
      *
     C                   CALLB     'LERPSC2VL'
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      ***  Valid Repayment schedule
     C                   PARM                    NwRpScFilFmt
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  Field OK flags (DS)
     C                   PARM                    ErrorRpSc
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index
     C                   PARM                    WIdx
      *
     C*****WIdx          IFNE      *ZERO                                                      246770
     C**********         MOVEL     'M'           @SCRN                                        246770
     C**********         ELSE                                                                 246770
     C                   EXSR      EXIT@S
     C**********         ENDIF                                                                246770
      *
      *----------------------------------------------------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVRPSC - Retrieve repayment
      *****************************************************************
     C     RTVRPSC       BEGSR
      *
      ***  Retrieve repayment
      *
     C                   CALLB     'LERPSCRTV'
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
      ***  (Midas) Loan Number
     C                   PARM                    DDLNRF
      *
      ***  (Midas) Sequence no.
     C                   PARM                    DDSEQN
      *
      ***  (Midas) Value date
     C                   PARM                    DDVDAT
      *
      ***  Outputs
      *
      ***  (Current) Repayment schedule in file format
     C                   PARM                    CrRpScFilFmt
      *
      ***  OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ***  OK - Loan Number
     C                   PARM      *BLANK        DDLNRFOK
      *
      ***  OK - Sequence no.
     C                   PARM                    DDSEQNOK
      *
      ***  OK - Value date
     C                   PARM                    DDVDATOK
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
      *
      ***  Save the settlement details for update
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
     C                   MOVEL     LSPI1         OSPI1
     C                   MOVEL     LSPI2         OSPI2
     C                   MOVEL     LSPI3         OSPI3
      *
      ***  Save the last update for test
      *
     C                   Z-ADD     LLCD          WLCD
     C                   MOVE      LCHTP         WCHTP
     C                   Z-ADD     LTNLU         WTNLU
     C                   MOVE      WLSTC         SAVLC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a Repayment schedule on the details screen       *
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      ***  Call program to fill screen fields with data from LOAMSDK
      *
     C                   CALLB     'LERPSCCVT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  File format
     C                   PARM                    CrRpScFilFmt
      *
      ***  Outputs
      *
      ***  Screen format
     C                   PARM                    NwRpScScnFmt
      *
      ***  Update 'Current' Repayment sch. with the Repayment sch. in Screen Format
     C                   MOVEL     NwRpScScnFmt  CrRpScScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - Cancel on details screen
      *****************************************************************
     C     CANC@M        BEGSR
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to the browse screen
      *
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details
      *****************************************************************
     C     SCRN@S        BEGSR
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDLNRF        ORNE      ##LNRF
     C     DDVDAT        ORNE      ##VDAT
     C     DDSEQN        ORNE      ##SEQN
      *
     C                   MOVEL     DDVDAT        ##VDAT            6
     C                   MOVEL     DDSEQN        ##SEQN            3
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
     C                   END
      *
      ***  Determinate proctect fields in settlement instructions
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'
     C                   MOVEL     'Y'           ##PPAY
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C     PTypFilCLOAN  IFEQ      '66'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '69'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '72'
     C                   MOVEL     'Y'           ##PREC
     C                   MOVEL     'N'           ##PPAY
     C                   ELSE
     C                   MOVEL     'N'           ##PREC
     C                   MOVEL     'Y'           ##PPAY
     C                   ENDIF
     C                   ENDIF
      *
      ***  Settlement instructions input
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      ***  Action code
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Loan number
     C                   PARM      DDLNRF        ##LNRF            6
      *
      ***  Protect Payment
     C                   PARM                    ##PPAY            1
      *
      ***  Protect Receive
     C                   PARM                    ##PREC            1
      *
      ***  Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Transaction Type
     C**********         PARM      'LE'          ##TTYP            2                         BUG4960
     C                   PARM      PtypFilCLOAN  ##TTYP            2                         BUG4960
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Booking branch
     C**********         PARM      RPBRCA        ##BRCA            3                         BUG4960
     C                   PARM      BrcaFilCLOAN  ##BRCA            3                         BUG4960
      *
      ***  Receipt Date
     C                   PARM      RPVDAT        ##DATR            5 0
      *
      ***  Payment Date
     C                   PARM      RPVDAT        ##DATP            5 0
      *
      ***  Payment instructions
     C                   PARM                    ##PAYS
      *
      ***  Receive instructions
     C                   PARM                    ##RECS
      *
      ***  FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      ***  Outputs
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      ***  Function keys
     C                   PARM      *OFF          @INKC             1
      *
     C                   PARM      *OFF          @INKL             1
      *
      ***  Save the new settlement details for update
      *
     C     PTypFilCLOAN  IFEQ      '66'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '69'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '72'
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLPSCY        WSCCY             3
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLRSCY        WSCCY             3
     C                   ENDIF
      *
     C                   END
      *
     C                   MOVEL     FLBENN        WFACO            10
     C                   MOVE      WSETP         WTYPE             2
      *
      *
      ***  Update Repayment schedule in file format
      *
     C**********         MOVEL     ##PAYF        RSPAY                                        CGL029
     C**********         MOVEL     ##RECF        RSREC                                        CGL029
     C                   MOVEL     FLPAY         RSPAY                                        CGL029
     C                   MOVEL     FLREC         RSREC                                        CGL029
     C                   MOVEL     FLRONS        RSRECEx                                      CGL029
     C                   MOVEL     FLRSTM        RPRSTM                                       CGL029
     C                   MOVEL     FLPONS        RSPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        RPPSTM                                       CGL029
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        RPREXR                                       CLE031
     C                   Z-ADD     FLPEXR        RPPEXR                                       CLE031
     C                   MOVE      FLREXI        RPREXI                                       CLE031
     C                   MOVE      FLPEXI        RPPEXI                                       CLE031
     C                   MOVE      FLRSCY        RPSCCY                                       CLE031
     C                   MOVE      FLPSCY        RPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     NwRpScFilFmt  CrRpScFilFmt
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  CK/12 - Cancel on settlement details
      *
     C     @INKL         CASEQ     *ON           CANC@S
      *
      ***  Perform the additional validation
      *
     C                   CAS                     VAL@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - Determine parameters for settlement details screen   *
      *****************************************************************
     C     DETP@S        BEGSR
      *
      ***  Set up payment instructions from Repayment schedule
      ***  (on insertions, these fields will be zero/blank)
      *
     C                   MOVEL     RSPAY         FLPAY
     C                   MOVEL     RSPAYEx       FLPONS                                       CGL029
     C                   MOVEL     RPPSTM        FLPSTM                                       CGL029
     C                   MOVEL     RPCVMR        FLCVMR
     C                   MOVEL     RPSCCY        FLPSCY
     C                   MOVEL     RPICCY        FLIC72
      *
      ***  Set up receive instructions from Repayment schedule
      ***  (on insertions, these fields will be zero/blank)
      *
     C                   MOVEL     RSREC         FLREC
     C                   MOVEL     RSRECEx       FLRONS                                       CGL029
     C                   MOVEL     RPRSTM        FLRSTM                                       CGL029
     C                   MOVEL     RPSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     RPREXR        FLREXR                                       CLE031
     C                   Z-ADD     RPPEXR        FLPEXR                                       CLE031
     C                   MOVE      RPREXI        FLREXI                                       CLE031
     C                   MOVE      RPPEXI        FLPEXI                                       CLE031
     C                   MOVE      RPSCCY        FLRSCY                                       CLE031
     C                   MOVE      RPPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C     RPPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     RPPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     RPPTYP        ANDEQ     72
     C                   MOVE      RPOSBR        FLPOBR
     C                   MOVE      *BLANKS       FLROBR
     C                   ELSE
     C                   MOVE      RPOSBR        FLROBR
     C                   MOVE      *BLANKS       FLPOBR
     C                   END
      *
      ***  If settlement instructions are not defined,
      ***  and payment/receipt dates are ,no in the past, default them
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
      ***  Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan Type
     C                   PARM      'LE'          ##TTYP            2
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ***  Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ***  Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ***  Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      *
      ***  Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
     C                   END
      *
      ***  Convert settlement details from file to screen format
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      *
      ***  File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ***  File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ***  File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Outputs
      *
      ***  Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ***  Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ***  Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen
      *****************************************************************
     C     CANC@S        BEGSR
      *
      ***  Return to the details screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      ***  If settlement details invalid
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      ***  Return to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      ***  Continue
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'C'           @SCRN
     C                   ELSE
     C                   MOVEL     'U'           @SCRN
     C                   END
      *
      ***  Update valid Repayment schedule: payment settlement instructions
      *
     C                   MOVEL     FLPAY         RSPAY
     C                   MOVEL     FLPONS        RSPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        RPPSTM                                       CGL029
     C                   MOVEL     FLPOBR        RPOSBR
     C                   MOVEL     FLCVMR        RPCVMR
      *
      ***  Update valid Repayment schedule: receipt settlement instructions
      *
     C                   MOVEL     FLREC         RSREC
     C                   MOVEL     FLRONS        RSRECEx                                      CGL029
     C                   MOVEL     FLRSTM        RPRSTM                                       CGL029
     C                   MOVEL     FLROBR        RPROBR
      *
      ***  Update valid Repayment schedule: settlement currency & 'IN' ccy in field 72
      *
     C                   MOVEL     FLPSCY        RPSCCY
     C                   MOVEL     FLIC72        RPICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        RPREXR                                       CLE031
     C                   Z-ADD     FLPEXR        RPPEXR                                       CLE031
     C                   MOVE      FLREXI        RPREXI                                       CLE031
     C                   MOVE      FLPEXI        RPPEXI                                       CLE031
     C                   MOVE      FLRSCY        RPSCCY                                       CLE031
     C                   MOVE      FLPSCY        RPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   END
      *
     C                   ENDSR
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
     C                   MOVEL     'LES0611'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LERPSCDSP'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Repayment schedule (in screen format)
     C                   PARM                    NwRpScScnFmt
      *
      ***  Fields in error
     C                   PARM                    ErrorRpSc
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      ***  Enabled function keys
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKK
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      *
      ***  Succesful insert
     C                   PARM                    @LSSQ
     C                   PARM                    @LNRF
     C                   PARM                    @VDAT
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
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
      ***  Return to fourth details screen
      *
     C                   MOVEL     'M'           @SCRN
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
     C*****WIdx          ANDEQ     *ZERO                                                      246770
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  Else, return to first details screen
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
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
      ***  Update valid repayment: Last action code
      *
     C                   MOVEL     DDACTN        RPCHTP
      *
      ***  Update valid repayment: Front office transaction ID
      *
     C                   MOVEL     @FOTRANSEL    RPFRNT
      *
      *
      ***  Repayments schedule update
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C                   CALLB     'LERPSCUPD'
      *
      ***  Return code
     C                   PARM                    @RTCD
      *
      ***  New Repayment schedule in file format
     C                   PARM                    NwRpScFilFmt
      *
      ***  Old settlement details
     C                   PARM                    OldStsDS
      *
      ***  New settlement details
     C                   PARM                    NewStsDS
      *
      ***  Pass data
     C                   PARM                    PasDtaDS
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    ErrorRpSc
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) =  'LEL0817'                                 AR868380
     C                   ENDIF                                                              AR868380
     C                   END
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     Idx           ORNE      *ZERO
      *   ROLLBACK data if either of the following is true:                                   CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N'                                              CSC022
                                                                                              CSC022
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
     C     @RTCD         ANDNE     '*RECLCK'                                                AR868380
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     ZATRNKD0      CHAIN     LEIRPSCD0                          99
     C  N99              DELETE    LEIRPSCD0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
      *
     C                   END
      *
      ***  If error occurred in updating last transaction set on flag to
      ***  display message on 'browse' screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C     @RTCD         OREQ      '*RECLCK'                                                AR868380
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
      ***  Else, return to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program
      *****************************************************************
     C     ENDP          BEGSR
      *
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
     C                   MOVEL(P)  NwRpScScnFmt  IncDATA
     C                   MOVEL(P)  CrRpScScnFmt  CurDATA
     C                   RESET                   ReturnCode
      *
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
     C                   MOVEL(P)  IncDATA       NwRpScScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupAmend - Setup Settlement Instructions on Amendment       *
      *****************************************************************
      *
     C     SetupAmend    BEGSR
      *
      ***  Conversion of file fields to screen format
      *
     C                   MOVEL     RSREC         FLREC
     C                   MOVEL     RSRECEx       FLRONS                                       CGL029
     C                   MOVEL     RPRSTM        FLRSTM                                       CGL029
     C                   MOVEL     RPSCCY        FLRSCY
      *
     C                   MOVEL     RSPAY         FLPAY
     C                   MOVEL     RSPAYEx       FLPONS                                       CGL029
     C                   MOVEL     RPPSTM        FLPSTM                                       CGL029
     C                   MOVEL     RPCVMR        FLCVMR
     C                   MOVEL     RPSCCY        FLPSCY
     C                   MOVEL     RPICCY        FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     RPREXR        FLREXR                                       CLE031
     C                   Z-ADD     RPPEXR        FLPEXR                                       CLE031
     C                   MOVE      RPREXI        FLREXI                                       CLE031
     C                   MOVE      RPPEXI        FLPEXI                                       CLE031
     C                   MOVE      RPSCCY        FLRSCY                                       CLE031
     C                   MOVE      RPPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Current Settlement Instruction in input format
     C                   PARM      *BLANK        CrPaySttmt
     C                   PARM      *BLANK        CrRecSttmt
     C                   PARM      *BLANK        CrFRASttmt
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
      ***  If no Payment or Receive instructions have been supplied
      *
     C                   IF            (##PAYS = *blank)
     C                   EVAL      ##PAYS = CrPaySttmt
     C                   ENDIF
      *
     C                   IF            (##RECS = *blank)
     C                   EVAL      ##RECS = CrRecSttmt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *****************************************************************
      *
     C     SDtDtaSubs    BEGSR
      *
      ***  Payment instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      ##PAYS        IncDATA
      *
      ***  Current Data
     C                   PARM      CrPaySttmt    CurDATA
      *
     C                   MOVEL     IncDATA       ##PAYS
      *
      ***  Receipt instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      ##RECS        IncDATA
      *
      ***  Current Data
     C                   PARM      CrRecSttmt    CurDATA
      *
     C                   MOVEL     IncDATA       ##RECS
      *
     C                   ENDSR
      *****************************************************************
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
     C                   MoveL     'LERPSCRPR'   DBPGM                                        CSC022
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
     C                   MOVEL     'LERPSCRPR'   DBPGM
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
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
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
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
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
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Determine if feature are installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
     C                   MOVEL     'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
      *
      ***  Access Customer Lending ICD via access program
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
      *
      ***  Message Type
      *
     C                   MOVEL     'LERPSC'      @MSGTYPE
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
     C                   MOVEL     *BLANKS       @RTCD
      *
      ***  Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
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
     C                   EVAL      DBase  = 5                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCR014
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
(c) Misys International Banking Systems Ltd. 2002
