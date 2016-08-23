     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade charges and commissions defaulting')    *
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETCHCMDFT - Trade Charges & Commissions Defaulting          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 31Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP050             Date 28Jul98               *
      *                 CAP003  *CREATE    Date 18Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSECGT     IF   E           K DISK
     FCUBRD     IF   E           K DISK
     FSECUBRL0  IF   E           K DISK
     F                                     RENAME(CUBRDDF:CUBRDDFX)
     FPMPORTPD  IF   E           K DISK
 
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
      ** Trade charges & commissions in screen format
     D TrChCm        E DS                  EXTNAME(SETRCCPD)
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
     ICUBRDDF
     I              C1DI                        C1DI_R
     I              SITP                        SITP_R
     I              TBCC                        DBCC
     I              TCCC                        DCCC
     ICUBRDDFX
     I              C1DI                        C1DI_R
     I              SITP                        SITP_R
     I              TBCC                        DBCC
     I              TCCC                        DCCC
      *****************************************************************
      /EJECT
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      * Initialize default codes
      *
     C                   MOVE      *BLANK        DBCC
     C                   MOVE      *BLANK        DCCC
     C                   MOVE      *BLANKS       DCC1
     C                   MOVE      *BLANKS       DCC2
 
      * Initialize Commission Rebate %
     C                   Z-ADD     *ZERO         CMRP
      *
      * All charge codes are in nominal currency
      *
     C                   MOVE      NMCY          @C_CCY
      *
      ** If not client agency trade
      *
     C     DDBLKR        IFEQ      *BLANK
     C     CustClass     ORNE      'S'
     C     CustClass     ANDNE     'D'
      *
      ** Get Customer/Broker Defaults
      *
     C                   EXSR      GETCBDEFS
      *
      ** Apply Customer/Broker Defaults
      *
     C                   EXSR      APLCBDEFS
     C                   END
      *
      ** If portfolio management, default portfolio ref
      ** Or Private Banking Module                                              CPB001
      *
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   EXSR      PTFRDEF
     C                   END
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETCBDEFS Get Customer/Broker Defaults                       *
      *                                                               *
      *****************************************************************
     C     GETCBDEFS     BEGSR
      *
      * Access CUSTOMER/BROKER DEFAULTS FILE for default codes
      *
     C     S01496        IFNE      'Y'
     C                   EXSR      GETDCN1496
     C                   ELSE
     C                   EXSR      GETDC_1496
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GETDCN1496 - Get default codes if NOT S01496                  *
      *                                                               *
      *****************************************************************
     C     GETDCN1496    BEGSR
      *
      * Define key list for file CUBRD
      *
     C     KLCUBRD       KLIST
     C                   KFLD                    CustClass         1
     C                   KFLD                    @@SITP            3
     C                   KFLD                    @@SMCC            2
     C**********         KFLD                    @@CNUM            6 0                        CSD027
     C                   KFLD                    @@CNUM            6                          CSD027
 
      * Initial investment type, market and customer
 
     C                   MOVEL     SITP          @@SITP
     C                   MOVEL     DDMRKT        @@SMCC
     C                   MOVEL     TCNR          @@CNUM
      *
      * CHAIN using CUSTOMER, MARKET CENTRE, INVESTMENT TYPE
      *
     C     KLCUBRD       CHAIN     CUBRD                              44
      *
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      * CHAIN again using blank CUSTOMER
      *
     C**********         Z-ADD     *ZEROS        @@CNUM                                       CSD027
     C                   EVAL      @@CNUM = *BLANKS                                           CSD027
      *
     C     KLCUBRD       CHAIN     CUBRD                              44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      * CHAIN again using blank MARKET CENTRE
      *
     C                   MOVE      *BLANK        @@SMCC
      *
     C     KLCUBRD       CHAIN     CUBRD                              44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      * CHAIN again using blank INVESTMENT TYPE
      *
     C                   MOVE      *BLANK        @@SITP
      *
     C     KLCUBRD       CHAIN     CUBRD                              44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      * If no defaults have been set up on the file blank out the
      * default codes.
      *
     C                   Z-ADD     *ZERO         CMRP
     C                   MOVE      *BLANK        DBCC
     C                   MOVE      *BLANK        DCCC
     C                   MOVE      *BLANKS       DCC1
     C                   MOVE      *BLANKS       DCC2
     C                   END
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GETDC_1496 - Get default codes if S01496                      *
      *                                                               *
      *****************************************************************
     C     GETDC_1496    BEGSR
      *
      * Define key list for file SECUBRL0
      *
     C     KLSECUB       KLIST
     C                   KFLD                    WWCLGR            2
     C                   KFLD                    WWSITP            3
     C                   KFLD                    WWSMCC            2
     C**********         KFLD                    WWCNUM            6 0                        CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
      *
      ** USE CUSTOMER TRADE CHARGES GROUP CODE
      ** ELSE CUSTOMER CLASSIFICATION
      *
     C     BVACOP        IFEQ      'Y'
     C                   MOVEL     CustTDCG      WWCLGR
     C                   ELSE
     C                   MOVEL     *BLANKS       WWCLGR
     C                   MOVEL     CustClass     WWCLGR
     C                   END
 
      * Initial investment type, market and customer
 
     C                   MOVEL     SITP          WWSITP
     C                   MOVEL     DDMRKT        WWSMCC
     C                   MOVE      TCNR          WWCNUM
 
     C     KLSECUB       CHAIN     SECUBRL0                           44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      ***  Record not found on LF/SECUBRL0, chain to LF/SECUBRL0
      ***  again with only first three priorities.
      *
     C                   MOVEL     BVPCSD        PCSD              1 0
     C                   MOVEL     BVPIDF        PIDF              1 0
     C                   MOVEL     BVPMDF        PMDF              1 0
     C                   MOVEL     BVPOCD        POCD              1 0
      *
     C                   EXSR      SUB4A
     C     KLSECUB       CHAIN     SECUBRL0                           44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      ***  If record not found, chain to LF/SECUBRL0 again with
      ***  only the first two priorities.
      *
     C                   EXSR      SUB4A
     C     KLSECUB       CHAIN     SECUBRL0                           44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      ***  If record not found, chain to LF/SECUBRL0 again with
      ***  only first priority
      *
     C                   EXSR      SUB4A
     C     KLSECUB       CHAIN     SECUBRL0                           44
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      * If no defaults have been set up on the file blank out the
      * default codes.
      *
     C                   Z-ADD     *ZERO         CMRP
     C                   MOVE      *BLANK        DBCC
     C                   MOVE      *BLANK        DCCC
     C                   MOVE      *BLANKS       DCC1
     C                   MOVE      *BLANKS       DCC2
     C                   END
      *
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    SUB4A - Determine Highest priority for customer charges    *
      *                                                               *
      *****************************************************************
     C     SUB4A         BEGSR
      *
     C                   MOVEL     'N'           CHANGE            1
     C     PCSD          IFGT      PIDF
     C     PCSD          ANDGT     PMDF
     C     PCSD          ANDGT     POCD
     C                   MOVE      *BLANKS       WWCLGR
     C                   Z-ADD     0             PCSD
     C                   MOVEL     'Y'           CHANGE            1
     C                   ELSE
      *
     C     PIDF          IFGT      PCSD
     C     PIDF          ANDGT     PMDF
     C     PIDF          ANDGT     POCD
     C                   MOVE      *BLANKS       WWSITP
     C                   Z-ADD     0             PIDF
     C                   MOVEL     'Y'           CHANGE            1
     C                   ELSE
      *
     C     PMDF          IFGT      PIDF
     C     PMDF          ANDGT     PCSD
     C     PMDF          ANDGT     POCD
     C                   MOVE      *BLANKS       WWSMCC
     C                   Z-ADD     0             PMDF
     C                   MOVEL     'Y'           CHANGE            1
     C                   ELSE
      *
     C     POCD          IFGT      PCSD
     C     POCD          ANDGT     PMDF
     C     POCD          ANDGT     PIDF
     C                   MOVE      *BLANKS       WWCNUM
     C                   Z-ADD     0             POCD
     C                   MOVEL     'Y'           CHANGE            1
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     CHANGE        IFNE      'Y'
      *
     C     PCSD          IFEQ      PIDF
     C     PCSD          OREQ      PMDF
     C     PCSD          OREQ      POCD
      *
     C     PCSD          IFEQ      PIDF
     C                   MOVE      *BLANKS       WWSITP
     C                   Z-ADD     0             PIDF
     C                   END
      *
     C     PCSD          IFEQ      PMDF
     C                   MOVE      *BLANKS       WWSMCC
     C                   Z-ADD     0             PMDF
     C                   END
      *
     C     PCSD          IFEQ      POCD
     C                   MOVE      *BLANKS       WWCNUM
     C                   Z-ADD     0             POCD
     C                   END
      *
     C                   MOVE      *BLANKS       WWCLGR
     C                   Z-ADD     0             PCSD
     C                   END
      *
     C     PIDF          IFEQ      PMDF
     C     PIDF          OREQ      POCD
      *
     C     PIDF          IFEQ      PMDF
     C                   MOVE      *BLANKS       WWSMCC
     C                   Z-ADD     0             PMDF
     C                   END
      *
     C     PIDF          IFEQ      POCD
     C                   MOVE      *BLANKS       WWCNUM
     C                   Z-ADD     0             POCD
     C                   END
      *
     C                   MOVE      *BLANKS       WWSITP
     C                   Z-ADD     0             PIDF
     C                   END
      *
     C     PMDF          IFEQ      POCD
     C                   MOVE      *BLANKS       WWCNUM
     C                   Z-ADD     0             POCD
     C                   MOVE      *BLANKS       WWSMCC
     C                   Z-ADD     0             PMDF
     C                   END
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  APLCBDEFS  Apply Customer/Broker Defaults                    *
      *                                                               *
      *****************************************************************
     C     APLCBDEFS     BEGSR
      *
      * If Broker Commission code is blank
      * then default it
      *
     C     DDTBCC        IFEQ      *BLANK
     C     DBCC          ANDNE     *BLANK
     C                   MOVE      DBCC          @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              21
     C     *IN21         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      DBCC          DDTBCC
     C                   MOVE      DBCC          TBCC
     C                   END
     C                   END
      *
      * If Customer Commission code is blank
      * If trade is complete or adjust same day comm not present
      * then default it
      *
     C     DDTCCC        IFEQ      *BLANK
     C     DCCC          ANDNE     *BLANK
     C     DDINCS        IFEQ      'C'
     C     BVACSD        ORNE      'Y'
     C                   MOVE      DCCC          @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              21
     C     *IN21         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      DCCC          DDTCCC
     C                   MOVE      DCCC          TCCC
     C                   END
     C                   END
     C                   END
      *
      * If Charge Code 1 is blank
      * then default it
      *
     C     DDTCC1        IFEQ      *BLANK
     C     DCC1          ANDNE     *BLANK
     C                   MOVE      DCC1          @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              21
     C     *IN21         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      DCC1          DDTCC1
     C                   MOVE      DCC1          TCC1
     C                   END
     C                   END
      *
      * If Charge Code 2 is blank
      * then default it
      *
     C     DDTCC2        IFEQ      *BLANK
     C     DCC2          ANDNE     *BLANK
     C                   MOVE      DCC2          @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              21
     C     *IN21         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      DCC2          DDTCC2
     C                   MOVE      DCC2          TCC2
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PTFRDEF Default Portfolio Reference                          *
      *                                                               *
      *****************************************************************
     C     PTFRDEF       BEGSR
 
      * If bank portfolios, portfolio reference is that of that book
      * UNCONDITIONALLY
 
     C     FCPORS        IFEQ      'B'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVEL     PortRef       DDPTFR
     C                   GOTO      EPTFRDEF
     C                   END
 
      * If customer portfolios
      *                                                                         CAP050
      * If Midas/Tof Interface presents,                                        CAP050
      * Check if customer has a defined portfolio reference                     CAP050
      *                                                                         CAP050
     C*****CAP050******* IFEQ      'Y'                                   CAP050 CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     DDPTFR        ANDEQ     *BLANK                                       CAP050
      *                                                                         CAP050
     C                   MOVEL     CustNum       PNCNUM                         CAP050
     C     PMKEY         SETLL     PMPORTPD                                     CAP050
     C     PNCNUM        READE     PMPORTPD                               65    CAP050
     C     *IN65         IFEQ      '0'                                          CAP050
     C                   MOVEL     PNPTFR        DDPTFR                         CAP050
     C                   ENDIF                                                  CAP050
     C                   ENDIF                                                  CAP050
 
      * If still blank, default portfolio to that of customer
 
     C     DDPTFR        IFEQ      *BLANK
     C     CustPMDFPO    IFEQ      '9997'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVEL     FCR997        DDPTFR
     C                   ELSE
     C                   MOVEL     CustPMDFPO    DDPTFR
     C                   END
     C                   END
 
     C     EPTFRDEF      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Bulk reference
      ** Incomplete Ind.
      ** Market Centre
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDINCS            1
     C                   PARM                    DDMRKT            2
      *
      ** Trade Counterparty
     C                   PARM                    TCNR
      *
      ** Security details
     C                   PARM                    SECTY
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** ICD
      ** PM installed
      ** Bank Portfolios installed
      ** Ref applied to 9997 portfolio
      ** Autocharge Option
      ** Adjust Commission Same Day T
      ** Priority of Cust Grp Dft
      ** Priority of Invst typ Dft
      ** Priority of Market Dft
      ** Priority of Cust Chrg Dft
      ** Midas/TOF I/F installed
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BVACOP            1
     C                   PARM                    BVACSD            1
     C                   PARM                    BVPCSD            1
     C                   PARM                    BVPIDF            1
     C                   PARM                    BVPMDF            1
     C                   PARM                    BVPOCD            1
     C                   PARM                    S01496            1
     C*****************  PARM                    CAP050            1     CAP050 CPB001
     C                   PARM                    BGN4ST            1            CPB001
 
      * OUTPUTS
 
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
 
      ** Trade Charges & Commissions screen fields
 
     C                   PARM                    TrChCm
 
      ** Trade Charges & Commissions file fields
 
     C                   PARM                    TBCC              2
     C                   PARM                    TCCC              2
     C                   PARM                    TCC1              2
     C                   PARM                    TCC2              2
 
     C     KLSECGT       KLIST
     C                   KFLD                    @C_CCY            3
     C                   KFLD                    @C_CCOM           2
 
      ** Define key for PMPORTPD                                                CAP050
     C     PMKEY         KLIST                                                  CAP050
     C                   KFLD                    PNCNUM                         CAP050
     C                   KFLD                    DDPTFR                         CAP050
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
