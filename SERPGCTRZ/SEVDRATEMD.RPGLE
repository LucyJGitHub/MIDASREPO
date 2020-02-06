     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Compute Exchange Rate and setup M/D Ind')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDRATEMD - This module computes for the Exchange Rate and  *
      *               Set-up the Multiply/Divide Indicator.           *
      *                                                               *
      *  Component of: SE0070 (Depot movements maintenance)           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CAP087             Date 17Aug05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 30Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FPMHSEXPD  IF   E           K DISK                                         S01486
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input field(s)
      ** --------------
 
      ** Screen fields
 
     D DDPTFR          S              4A
     D DDPTFROk        S              1A
     D DDDPDO          S              6A
     D DDDPID          S             10A
     D DDDPOD          S             10A
 
 
      ** ICD
      ** System Details
 
     D PBInd           S              1A                                        CPB001
     D PortModInd      S              1A
     D Rundate         S              5P 0
     D FCR997          S              4A
 
      ** Transaction Details
 
     D WWPLCS          S              1A
     D QBCSBY          S              3A
     D PNPTCY          S              3A
     D DPMD            S              5P 0
     D DPDO            S              5P 0
 
      ** Security Details
     D NMCY            S              3A
 
     ** Output
 
     D DDSPXR          S             14A
     D DDSPMD          S              1A
     D SPXR            S             13P 8
     D SPMD            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialization
      *
     C                   MOVE      *BLANKS       DDSPXR
     C                   MOVE      *BLANKS       DDSPMD
     C                   Z-ADD     0             SPXR
     C                   MOVE      *BLANKS       SPMD
 
     C     PortModInd    IFEQ      'Y'
     C     DDPTFROk      ANDNE     'N'
      *
      ** WWPLCS Processed in Portfolio Reference validation module.
      *
     C     WWPLCS        ANDEQ     'Y'
      *
      ** - Depot is either a Walk In nor a Walk Out
      *
     C     DDDPID        IFNE      *BLANK
     C     DDDPOD        ORNE      *BLANK
 
     C                   EXSR      SRCOMP
 
     C                   END
     C                   END
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCOMP - Subroutine to compute and set Exchange Rate and M/D  *
      *          Indicator fields respectively.                       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCOMP        BEGSR
      *
      ** Set Portfolio Currency to Customer Base Currency for 9997
      ** Portfolio
      *
     C     DDPTFR        IFEQ      FCR997
     C     PBInd         ANDNE     'Y'                                          CPB001
     C                   MOVE      QBCSBY        PNPTCY
     C                   END
      *
      ** If Nominal Currency and Portfolio Currency are the same
      ** set Cross Rate to 1 and M/D Indicator to 'M'
      ** and skip to Amount validation
      *
     C     NMCY          IFEQ      PNPTCY
     C                   MOVE      'M'           ZCRSMD            1
     C                   Z-ADD     1             ZCRSRT           13 8
     C                   GOTO      AMCHK
     C                   END
      *
      **  Format key HSEXKY using Nominal Ccy and Movement Date
      *
     C                   MOVE      NMCY          HSEXCY
 
     C     DDDPDO        IFEQ      *BLANK
     C                   MOVE      DPMD          WWVD
     C                   ELSE
     C                   MOVE      DPDO          WWVD
     C                   END
      *
      **  Obtain FX Rate for Trade Date between Nominal Currency
      **  and Base Currency for Accounting
      **  execpt if trade date is equal to the run date.
      *
     C     WWVD          IFLT      RunDate
     C     DPMD          IFNE      RunDate
     C     DPDO          ANDNE     RunDate
 
     C     HSEXKY        KLIST
     C                   KFLD                    HSEXCY            3
     C                   KFLD                    WWVD              5 0
 
     C     HSEXKY        SETGT     PMHSEXPD
     C                   READP     PMHSEXPD                               44
 
     C     *IN44         IFEQ      '1'
     C     NMCY          ORNE      Q8CCY
 
     C     HSEXKY        SETLL     PMHSEXPD
     C                   READ      PMHSEXPD                               44
     C                   END
 
     C                   END
     C                   ELSE
     C                   SETON                                            44
     C                   END
 
     C     *IN44         IFEQ      '1'
     C     NMCY          ORNE      Q8CCY
     C     WWVD          OREQ      RunDate
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      NMCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
     C                   Z-ADD     A6SPRT        Q8SPOT
     C                   MOVE      A6MDIN        Q8MDV1
     C                   Z-ADD     A6NBDP        Q8CDP
     C                   END
      *
      **  Set up SR/ZCCYCN with 'FROM' details for Nominal Currency
      *
     C                   Z-ADD     Q8SPOT        ZRATEF           13 8
     C                   MOVE      Q8MDV1        ZMDINF            1
     C                   Z-ADD     Q8CDP         ZCDPF             1 0
     C                   MOVE      NMCY          ZCCYF             3
      *
      **  Obtain FX Rate for Trade date between Portfolio Currency
      **  and Base Currency for Accounting
      **  execpt if trade date is equal to the run date.
      *
     C     DDPTFR        IFEQ      FCR997
     C     PBInd         ANDNE     'Y'                                          CPB001
     C                   MOVE      QBCSBY        HSEXCY
     C                   ELSE
     C                   MOVE      PNPTCY        HSEXCY
     C                   END
 
     C     DPMD          IFNE      RunDate
     C     DPDO          ANDNE     RunDate
 
     C     WWVD          IFNE      RunDate
     C     HSEXKY        SETGT     PMHSEXPD
     C                   READP     PMHSEXPD                               44
 
     C     *IN44         IFEQ      '1'
     C     HSEXCY        ORNE      Q8CCY
     C     HSEXKY        SETLL     PMHSEXPD
     C                   READ      PMHSEXPD                               44
     C                   END
 
     C                   END
     C                   ELSE
     C                   SETON                                            44
     C                   END
 
     C     *IN44         IFEQ      '1'
     C     HSEXCY        ORNE      Q8CCY
     C     WWVD          ORGE      RunDate
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      HSEXCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
     C                   Z-ADD     A6SPRT        Q8SPOT
 
     C                   Z-ADD     A6NBDP        Q8CDP
     C                   END
      *
      **  Set up SR/ZCCYCN with 'TO' details for Portfolio Currency
      *
     C                   Z-ADD     Q8SPOT        ZRATET           13 8
     C                   MOVE      Q8MDV1        ZMDINT            1
     C                   Z-ADD     Q8CDP         ZCDPT             1 0
 
     C                   MOVE      PNPTCY        ZCCYT             3
      *
      **  Calculate Cross Rate between Nominal Currency and Portfolio
      **  Currency using standard SR/ZCCYCN.
      *
     C                   Z-ADD     0             ZAMTF            15 0
 
     C                   CALLB     'ZCCYCN'
     C                   PARM                    ZAMTF
     C                   PARM                    ZCCYF
     C                   PARM                    ZCCYT
     C                   PARM                    ZRATEF
     C                   PARM                    ZRATET
     C                   PARM                    ZMDINF
     C                   PARM                    ZMDINT
     C                   PARM                    ZCDPF
     C                   PARM                    ZCDPT
     C                   PARM                    ZAMTT            15 0
     C                   PARM                    ZCRSRT
     C                   PARM                    ZCRSMD
      *
      **  If FX Rate details blank output default rate calculated in
      **  SR/ZCCYCN to screen with warning.
      *
     C     AMCHK         TAG
 
     C                   MOVE      *BLANKS       ZFIELD           16
     C                   MOVE      ZCRSRT        ZFIELD
     C                   Z-ADD     8             ZADEC             1 0
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   MOVE      ZFIELD        DDSPXR
     C                   MOVE      ZCRSMD        DDSPMD
     C                   Z-ADD     ZCRSRT        SPXR
     C                   MOVE      ZCRSMD        SPMD
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      ** Returned Fields
      ** ---------------
 
     ** Screen fields
      * Portfolio Reference (4A) / Field Ok Indicator (1A)
      * Out Date (6A)
      * In Depot (10A)
      * Out Depot (10A)
     C                   PARM                    DDPTFR
     C                   PARM                    DDPTFROk
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
 
     ** Transaction Details
      * Movement (In) Date (5P 0)
      * Movement (Out) Date (5P 0)
     C                   PARM                    DPMD
     C                   PARM                    DPDO
 
      ** Information from SEVDRTREF
      *  - OUTPUT of Portfolio Reference Validation Module
      * Portfolio Currency Code (3A) (PMPORTPD <DS PORTDET>)
      * Portfolio Customer Indicator (1A)
      * Customer Base Currency (3A) (SDPLCSPD <DS SDPLCS>)
     C                   PARM                    PNPTCY
     C                   PARM                    WWPLCS
     C                   PARM                    QBCSBY
 
      ** Security Details
     C                   PARM                    NMCY
 
     ** ICD
     ** System Details
      * Private Banking Indicator (1A)                                          CPB001
      * Portfolio Module Indicator (1A)
      * System Rundate (5P 0)
      * Reference Attached to 997 (4A) <SDPORTPD>
     C                   PARM                    PBInd                          CPB001
     C                   PARM                    PortModInd
     C                   PARM                    Rundate
     C                   PARM                    FCR997
 
      ** Returned Parameters
      ** -------------------
 
     ** Screen outputs
      * Exchange Rate (14A)
      * Spot Rate Mul/Div Ind (1A)
     C                   PARM                    DDSPXR
     C                   PARM                    DDSPMD
 
     ** File outputs
      * Exchange Rate (13P 8)
      * Spot Rate Mul/Div Ind (1A)
     C                   PARM                    SPXR
     C                   PARM                    SPMD
 
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
(c) Finastra International Limited 2001
