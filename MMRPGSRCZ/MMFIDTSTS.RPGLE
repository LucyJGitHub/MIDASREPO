     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Fiduciary Takings Trust Sts. Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMFIDTSTS - MM Fiduciary Takings Trust Status Maintenance    *
      *                                                               *
      *  Function:  This module will allow for input of Trust status  *
      *             and restriction narratives for Fiduciary Loan     *
      *             Takings.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027A            Date 10May06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  209905 - Fiduciary API Enhancement                           *
      *  CDL006 - Dealing Fiduciary                                   *
      *                                                               *
      *****************************************************************
     FMMFIDTSDF CF   E             WORKSTN INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for access programs, very long data structure
 
      /EJECT
      *****************************************************************
      *                                                               *
      *    Main Routine                                               *
      *                                                               *
      *****************************************************************
 
      ** Retrieve passed parameters
 
     C     *ENTRY        PList
     C                   Parm                    #PGM             10
     C                   Parm                    ActionCode        1
     C                   Parm                    DealNo            6 0
     C*******************Parm                    CustNo            6 0                       CSD027A
     C                   Parm                    CustNo            6                         CSD027A
     C                   Parm                    TrustSts          1
     C                   Parm                    RestNarr1        60
     C                   Parm                    RestNarr2        60
     C                   Parm                    RestNarr3        60
     C                   Parm                    RestNarr4        60
     C                   Parm                    PProtect          1                          209905
     C                   Parm                    RetCode           7
 
     C                   Move      *On           *IN86
     C                   Move      *Off          *IN22
 
      ** Get corresponding Customer Shortname
 
     C                   Move      CustNo        Customer          6
 
     C                   CallB     'AOCUSTR1'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      Customer      @KEY1            10
     C                   Parm      '*BLANKS'     @KYST             7
     C     SDCUST        Parm      SDCUST        DSLDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDCUSTPD'    DBFILE
     C                   MoveL     '001'         DBASE
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
 
      ** Move right details to screen fields acc. to ActionCode
                                                                                              209905
     C                   Move      TrustSts      STRAS                                        209905
     C                   Move      RestNarr1     SNAR1                                        209905
     C                   Move      RestNarr2     SNAR2                                        209905
     C                   Move      RestNarr3     SNAR3                                        209905
     C                   Move      RestNarr4     SNAR4                                        209905
 
     C     ActionCode    IfEq      'E'
     C     PProtect      OREQ      'Y'                                                        209905
     C**********         Move      TrustSts      STRAS                                        209905
     C**********         Move      RestNarr1     SNAR1                                        209905
     C**********         Move      RestNarr2     SNAR2                                        209905
     C**********         Move      RestNarr3     SNAR3                                        209905
     C**********         Move      RestNarr4     SNAR4                                        209905
 
     C                   Move      *On           *IN21
 
     C                   Else
     C**********         Move      *BLANKS       STRAS                                        209905
     C**********         Move      *BLANKS       SNAR1                                        209905
     C**********         Move      *BLANKS       SNAR2                                        209905
     C**********         Move      *BLANKS       SNAR3                                        209905
     C**********         Move      *BLANKS       SNAR4                                        209905
 
     C                   Move      *Off          *IN21
 
     C                   EndIf
 
      ** Validate input
 
     C     *INKC         DoUEq     *On
     C     *INKL         OrEq      *On
     C     *IN22         Oreq      *On
 
     C                   Write     MMFIDSF3
     C                   Exfmt     MMFIDSF1
 
      ** If F3
 
     C     *INKC         IfEq      *On
     C                   Move      'Y2U9999'     RetCode
     C                   Else
 
      ** If F12
 
     C     *INKL         IfEq      *On
     C                   Move      'USR0790'     RetCode
     C                   Else
 
      ** Validate Trust Agreement Status
 
     C                   Move      *Off          *IN20
     C                   Move      *BLANKS       ZAMSID
 
     C                   Call      'Y2CLMSC'
     C                   Parm      #PGM          ZAPGM
     C                   Parm      '*SAME'       ZAPGRL
 
     C     STRAS         IfEq      *BLANKS
     C                   Move      *On           *IN20
     C                   MoveL     'USR8627'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Else
 
     C     STRAS         IfNe      '1'
     C     STRAS         AndNe     '2'
     C     STRAS         AndNe     '3'
     C     STRAS         AndNe     '4'
     C     STRAS         AndNe     '5'
     C                   Move      *On           *IN20
     C                   MoveL     'USR8628'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Else
 
     C                   Move      *On           *IN22
     C                   Move      STRAS         TrustSts
     C                   Move      SNAR1         RestNarr1
     C                   Move      SNAR2         RestNarr2
     C                   Move      SNAR3         RestNarr3
     C                   Move      SNAR4         RestNarr4
     C                   EndIf
 
     C                   EndIf
 
     C                   EndIf
 
     C                   EndIf
 
     C                   EndDo
 
     C                   Move      *On           *INLR
 
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS    - Send Message to Program's Message Queue          *
      *                                                               *
      *  Calls     - Y2SNMGC                                          *
      *                                                               *
      *  Called by - Main Routine                                     *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
 
     C                   MoveL     #PGM          ZAPGM
     C                   MoveL     *BLANK        ZAPGRL
     C                   MoveL     'SDUSRMSG'    ZAMSGF
     C                   MoveL     *BLANKS       ZAMSDA
     C                   MoveL     *BLANKS       ZAMSTP
 
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGM            10
     C                   Parm                    ZAPGRL            5
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C                   Parm                    ZAMSTP            7
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
