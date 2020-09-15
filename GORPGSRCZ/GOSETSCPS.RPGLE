     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(PRICMXX   ) TOFILE(PRICM   ) SHARE(*NO)
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup SE Cust Position TRAP record')          *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETSCPS - Setup SE Cust Position TRAP record               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13281           Date 05Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11830           Date 11Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13281 - Set Transaction Date and Start Date to run date.  *
      *       Fix copied  by 246221 for MP121 version.                *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FPRICMXX   IF   E           K DISK    INFSR(*PSSR) PREFIX(PR_) USROPN
     FGPUTXSL0  IF A E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D SECTY         E DS                  EXTNAME(SECTYD)
     D PRICE         E DS                  EXTNAME(PRICED) PREFIX(PR_)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                BUG13281
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     D*CSCN*****       S              6S 0                                                    CSD027
     D CSCN            S              6A                                                      CSD027
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
 
      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    CSBA              3
     C                   PARM                    CSCN
     C                   PARM                    CSSC             10
     C                   PARM                    CSDA              5 0
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    PRICE
     C                   PARM                    NomCcyDec         1 0
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
 
      * Clear Transaction Index
 
     C                   CLEAR                   T_TRAP
 
      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'SE'          T_MOD
      * Sub module
     C                   MOVEL     'SCPS'        T_SMOD
      * Customer
     C                   MOVEL     CSCN          T_CNUM
      * Portfolio reference
     C                   MOVEL     *BLANK        T_PTFR
      * Booking Branch
     C                   MOVEL     CSBA          T_BRCA
      * Security Shortname
     C                   MOVEL     CSSC          T_SESN
      * Identifier
     C     GPUTXSK       CHAIN     GPUTXSD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XSZONE
     C                   MOVEL     T_SMOD        XSSMOD
     C                   MOVEL     T_CNUM        XSCNUM
     C                   MOVEL     T_PTFR        XSPTFR
     C                   MOVEL     T_BRCA        XSBRCA
     C                   MOVEL     T_BOOK        XSBOOK
     C                   MOVEL     T_SESN        XSSESN
     C                   MOVEL     T_MKTI        XSMKTI
     C                   Z-ADD     O#NTID        XSID
     C                   WRITE     GPUTXSD0
     C                   ENDIF
     C                   Z-ADD     XSID          T_ID
      * Shortname
     C                   MOVEL     T_CNUM        W#CNUM            6
     C                   EVAL      T_SNAM = T_BRCA+'-'+W#CNUM+'-'+T_SESN
      * Transaction Type
     C                   MOVEL     SITP          T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     NMCY          T_TRST
      * Transaction Profit Centre
     C                   MOVEL     *BLANK        T_TPFC
      * Risk Customer
     C                   MOVEL     ISSR          T_RCST
      * Risk Currency
     C                   MOVEL     NMCY          T_RCCY
      * Local Industry Code
     C                   MOVEL     SIDY          T_LICD
      * Country Code
     C                   MOVEL     SCOR          T_CNCD
      * Transaction Date
     C**********         Z-ADD     CSDA          T_TDAT
     C                   Z-ADD     BJRDNB        T_TDAT                                     BUG13281
      * Start Date
     C**********         Z-ADD     CSDA          T_SDAT
     C                   Z-ADD     BJRDNB        T_SDAT                                     BUG13281
      * End Date
     C                   Z-ADD     MATY          T_EDAT
      * Issuer Exposure
     C                   MOVEL     'Y'           T_ISEI
 
      * Determine market price of security
 
     C                   EXSR      MRKTPRC
      *
      * Valuation Currency
     C                   MOVEL     NMCY          T_VCCY
      * Valuation Ccy Dec Places = nominal currency decimal places
     C                   MOVEL     NMCY          @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        T_VCDP
     C                   MOVEL     A6NBDP        NomCcyDec
      * Omit from exposure
     C                   MOVEL     'Y'           T_OMEI
      * Matured?
     C     RECI          IFEQ      'M'
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C                   MOVEL     'A'           T_ACTN
      *
      * Customer branch                                                                     BUG11830
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
      * Risk customer branch                                                                BUG11830
     C     T_CNUM        IFNE      T_RCST                                                   BUG11830
     C                   MOVEL     T_RCST        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   ENDIF                                                              BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOCURRR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE MARKET PRICE OF SECURITY
      ********************************************************************
     C     MRKTPRC       BEGSR
 
     C                   CLEAR                   PRICE
      *
      * Get current market price
      *
     C     CSSC          SETGT     PRICEDF
     C     CSSC          READPE    PRICEDF                                99    *
     C     *IN99         DOWEQ     '0'
     C     PR_RECI       ANDNE     'D'
     C     CSSC          READPE    PRICEDF                                99    *
     C                   ENDDO
      *
      * If live price found, update security market price
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     PR_PPRC       MKPR
     C                   ENDIF
      *
     C     E_MRKTPRC     ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************                  BUG11830
      * Access customer details                                                             BUG11830
      ********************************************************************                  BUG11830
     C     ACS_CUST      BEGSR                                                              BUG11830
     C                   CALLB     'AOCUSTR0'                                               BUG11830
     C                   PARM      *BLANKS       @RTCD             7                        BUG11830
     C                   PARM      '*KEY   '     @OPTN             7                        BUG11830
     C                   PARM                    @KEY1            10                        BUG11830
     C                   PARM      *BLANKS       @KYST             7                        BUG11830
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG11830
     C     @RTCD         IFNE      *BLANK                                                   BUG11830
     C     @KYST         OREQ      '*ERROR'                                                 BUG11830
     C                   CLEAR                   SDCUST                                     BUG11830
     C                   ENDIF                                                              BUG11830
     C                   ENDSR                                                              BUG11830
      *****************************************************************                     BUG11830
      /SPACE 5                                                                              BUG11830
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
                                                                                            BUG13281
      * Access Bank Details                                                                 BUG13281
                                                                                            BUG13281
     C                   CALLB     'AOBANKR0'                                               BUG13281
     C                   PARM      '*DBERR  '    @RTCD             7                        BUG13281
     C                   PARM      '*FIRST  '    @OPTN             7                        BUG13281
     C     SDBANK        PARM      SDBANK        DSSDY                                      BUG13281
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
 
     C                   Z-ADD     60            MESLEN           15 5
 
      * Override/Open files
 
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   OPEN      PRICMXX
 
      * Key lists
 
     C     GPUTXSK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_PTFR
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_BOOK
     C                   KFLD                    T_SESN
     C                   KFLD                    T_MKTI
 
      * Parameter lists
 
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OV1
OVRDBF FILE(PRICMXX   ) TOFILE(PRICM   ) SHARE(*NO)
