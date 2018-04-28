     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MM Fiduciary Takings Enquiry Module')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMFIDTENQ - MM Fiduciary Takings Enquiry Module              *
      *                                                               *
      *  Function:  This module will show details of Charges and      *
      *             Commissions for a particular Fiduciary Taking.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006   *CREATE   Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL006 - Dealing Fiduciary                                   *
      *                                                               *
      *****************************************************************
     FMMFIDTDDF CF   E             WORKSTN INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for bank details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for access programs, very long data structure
 
      /EJECT
      *****************************************************************
      *                                                               *
      *       Start of Main Processing                                *
      *                                                               *
      *****************************************************************
 
      ** Retrieve passed parameters
 
     C     *ENTRY        PList
     C                   Parm                    #PGM             10
     C                   Parm                    ActionCode        1
     C                   Parm                    DealNo            6 0
     C                   Parm                    Dealtype          2
     C                   Parm                    CustNo            6 0
     C                   Parm                    Currency          3
     C                   Parm                    DealAmt          13 0
     C                   Parm                    IntRate          11 7
     C                   Parm                    DealDate          5 0
     C                   Parm                    ValDate           5 0
     C                   Parm                    MatDate           5 0
     C                   Parm                    NotDays           3 0
     C                   Parm                    ChCode            2
     C                   Parm                    ChDesc           20
     C                   Parm                    ChAmt            13 0
     C                   Parm                    TaxOnCharge       9 0
     C                   Parm                    ComCode           2
     C                   Parm                    ComDesc          20
     C                   Parm                    ComAmt           13 0
     C                   Parm                    TaxOnComm         9 0
     C                   Parm                    TrustSts          1
     C                   Parm                    RestNarr1        60
     C                   Parm                    RestNarr2        60
     C                   Parm                    RestNarr3        60
     C                   Parm                    RestNarr4        60
     C                   Parm                    RetCode           7
 
      ** Access AO programs
 
     C                   CallB     'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSSDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   MoveL     '001'         DBASE
     C                   MoveL     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      Currency      @CurrCode         3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDCURRPD'    DBFILE
     C                   MoveL     '002'         DBASE
     C                   MoveL     Currency      DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Move      CustNo        Customer          6
 
     C                   CallB     'AOCUSTR1'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      Customer      @KEY1            10
     C                   Parm      '*BLANKS'     @KYST             7
     C     SDCUST        Parm      SDCUST        DSLDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDCUSTPD'    DBFILE
     C                   MoveL     '003'         DBASE
     C                   MoveL     CustNo        DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Format fields for output to screen
 
     C                   Move      PSUser        SUSER
     C                   Move      PSJobName     SWSID
     C                   Move      PSRunDate     SDATE
     C                   Move      DealNo        SDLNO
     C                   Move      CustNo        SCUST
     C                   Move      BBCSSN        SCSSN
     C                   Move      Currency      SCURR
     C                   Move      ChCode        SCHCO
     C                   Move      ChDesc        SCHCD
     C                   Move      ComCode       SCOCO
     C                   Move      ComDesc       SCOCD
     C                   Move      TrustSts      STRAS
     C                   Move      RestNarr1     SNAR1
     C                   Move      RestNarr2     SNAR2
     C                   Move      RestNarr3     SNAR3
     C                   Move      RestNarr4     SNAR4
 
     C                   CallB     'ZDATE2'
     C                   Parm      DealDate      ZDAYNO            5 0
     C                   Parm      BJDFIN        ZDATFM            1
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
     C                   Move      ZDATE         SDDAT
 
     C                   CallB     'ZDATE2'
     C                   Parm      ValDate       ZDAYNO
     C                   Parm      BJDFIN        ZDATFM
     C                   Parm                    ZDATE
     C                   Parm                    ZADATE
     C                   Move      ZDATE         SVDAT
 
     C                   Move      IntRate       ZFLD15
     C                   CallB     'ZSEDIT'
     C                   Parm                    ZFLD15           15 0
     C                   Parm      7             ZDECS             1 0
     C                   Parm      *BLANKS       ZECODE            1
     C                   Parm                    ZOUT21           21
     C                   Move      ZOUT21        SINTR
 
     C                   CallB     'ZSEDIT'
     C                   Parm      DealAmt       ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Move      ZOUT21        SAMT
 
     C                   CallB     'ZSEDIT'
     C                   Parm      ChAmt         ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Move      ZOUT21        SCHAM
 
     C                   CallB     'ZSEDIT'
     C                   Parm      ComAmt        ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Move      ZOUT21        SCOAM
 
     C                   CallB     'ZSEDIT'
     C                   Parm      TaxOnCharge   ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm                    ZECODE
     C                   Parm                    ZOUT21
     C                   Move      ZOUT21        STCHA
 
     C                   CallB     'ZSEDIT'
     C                   Parm      TaxOnComm     ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm                    ZECODE
     C                   Parm                    ZOUT21
     C                   Move      ZOUT21        STCOA
 
      ** Switch on indicator to non-display certain fields
 
     C
     C     #PGM          IfEq      'MMDEAMSIN'
     C                   Move      *On           *IN21
     C                   EndIf
 
     C     MatDate       IfEq      0
     C                   Movel     NotDays       SMDAT
     C                   Move      'DAYS'        SMDAT
     C                   Else
     C                   CallB     'ZDATE2'
     C                   Parm      MatDate       ZDAYNO
     C                   Parm      BJDFIN        ZDATFM
     C                   Parm                    ZDATE
     C                   Parm                    ZADATE
     C                   Move      ZDATE         SMDAT
     C                   EndIf
 
     C                   Exfmt     MMFIDTF1
 
     C     *INKC         IfEq      *On
     C                   Move      'Y2U9999'     RetCode
     C                   EndIf
 
     C     *INKL         IfEq      *On
     C                   Move      'USR0790'     RetCode
     C                   EndIf
 
     C                   Move      *On           *INLR
 
     C                   Return
 
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
