     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Depot a/c reference retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDORFRTV - SE Depot A/C Reference Retrieve                  *
      *                                                               *
      *  Function:  This module will retrieve the depot reference     *
      *             for a given depot.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27939           Date 30Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 244007             Date 01Dec06               *
      *                 BUG13172A          Date 01Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242372             Date 25Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 215058             Date 21feb03               *
      *                 BUG3122            Date 17Jul04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204584             Date 15Apr02               *
      *                 201228             Date 18Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022  *CREATE    Date 29Mar01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27939 - SEC0603 00001                                     *
      *  244007 - Align customer parameter when accessing it in       *
      *           AOSECSR0.                                           *
      *  BUG13172A - A serious midas error occurred (Recompile)       *
      *  242372 - Depot movement input caused DB error.               *
      *           Bypass checking of counterparty customer in         *
      *           customer securities file if field is *BLANKS/*ZEROS *
      *           Applied as CSD027.
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  215058 - Ensure depot reference reset to blanks at each call *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  204584 - Invalid Depot reference comming out incorrectly.    *
      *  201228 - Depo movement input caused DB error.                *
      *           Bypass checking of counterparty customer in         *
      *           customer securities file if field is blank.         *
      *  CSE022 - Depository Definition Enhancement                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Record not found in SDCSRDL0                    *
      *    02         LOOKUP indicator                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Intialisation Processing                             *
      * *INZSR - Initialise                                           *
      * *PSSR  - Error processing                                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer Depository Reference File by Customer
     FSDCSDRL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Depot Reference Array
     D WDepotArr       S              6A   DIM(10)
 
      ** Depot Reference Array
     D WDepotArr2      S             20A   DIM(10)
 
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Externally described DS for
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
     D  LookUpFnd             02     02
 
      ** Depot Reference Data Structure from file SDSTRDPD
     D WDSDepotICD     DS
     D  WBVDR1                 1      6
     D  WBVDR2                 7     12
     D  WBVDR3                13     18
     D  WBVDR4                19     24
     D  WBVDR5                25     30
     D  WBVDR6                31     36
     D  WBVDR7                37     42
     D  WBVDR8                43     48
     D  WBVDR9                49     54
     D  WBVDR10               55     60
 
      ** Depot Reference Data Structure from file SDSECSPD
     D WDSDepotSEC     DS
     D  WBFNDR1                1     20
     D  WBFNDR2               21     40
     D  WBFNDR3               41     60
     D  WBFNDR4               61     80
     D  WBFNDR5               81    100
     D  WBFNDR6              101    120
     D  WBFNDR7              121    140
     D  WBFNDR8              141    160
     D  WBFNDR9              161    180
     D  WBFNDR0              181    200
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Return Code
     D PReturnCode     S             10
 
      ** Entry Depot Customer Number
     D PDepotCnum      S              6
 
      ** Entry Counterparty Customer Number
     D PCntrPCNum      S              6
 
      ** Safekeeping Account Reference
     D PSKALRef        S             20
 
      ** First 6 character of Depot Reference
     D WBFNDRX         S              6
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PKey            S              6
 
      ** Work Variables
     D Wx              S              3  0
     D WClassCP        S              1
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Perform Initial Processing
 
     C                   EXSR      SRINIT
 
      ** Check if Depot Customer Number is present
 
     C                   Z-ADD     1             Wx
 
     C     PDepotCNum    LOOKUP    WDepotArr(Wx)                          02
 
      ** Entry Depot Customer Number is not present from file SDSTRDPD
 
     C                   IF        LookUpFnd = *OFF
 
      ** Use Entry Counterparty Customer number and Entry Depot Customer
      ** number as keys to chain file SDCSDRL0
 
     C     KCtrDep       KLIST
     C                   KFLD                    PCntrPCNum
     C                   KFLD                    PDepotCNum
 
     C     KCtrDep       CHAIN     SDCSDRL0                           01
 
     C                   IF        RecNotFnd = *OFF
 
     C                   EVAL      PSKALRef = DRREFN
 
     C                   ENDIF
 
      ** If Depot Customer Number is present
 
     C                   ELSE
 
      ** Validate customer counterparty if field is entered.                                  201228
                                                                                              201228
     C**********         IF        PCntrPCNum <> *ZEROS                                201228 CSD027
     C                   IF        PCntrPCNum <> *BLANKS                                      CSD027
                                                                                              201228
      ** Access Securities Clients Details
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      PCntrPCNum    PKey
     C     SDSECS        PARM      SDSECS        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
 
     C                   EVAL      PReturnCode = '*ERROR'
 
     C                   MOVEL     PCntrPCNum    DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
 
     C                   ENDIF
                                                                                              201228
     C********           ENDIF                                                         201228 204584
 
     C                   EVAL      WClassCP = BFCLAS
 
      ** Move Depot References to work variables
 
     C                   EVAL      WBFNDR1 = BFNDR1
     C                   EVAL      WBFNDR2 = BFNDR2
     C                   EVAL      WBFNDR3 = BFNDR3
     C                   EVAL      WBFNDR4 = BFNDR4
     C                   EVAL      WBFNDR5 = BFNDR5
     C                   EVAL      WBFNDR6 = BFNDR6
     C                   EVAL      WBFNDR7 = BFNDR7
     C                   EVAL      WBFNDR8 = BFNDR8
     C                   EVAL      WBFNDR9 = BFNDR9
     C                   EVAL      WBFNDR0 = BFNDR0
 
     C                   MOVEA     WDSDepotSEC   WDepotArr2
                                                                                              204584
     C                   ENDIF                                                                204584
      ********                                                                                204584
     C********           Z-ADD     1             Wx                                           204584
      ********                                                                                204584
     C********           DO        10                                                         204584
      ********                                                                                204584
     C********           MOVEA     WDepotArr2(Wx)WDepotArr(Wx)                                204584
      ********                                                                                204584
     C********           EVAL      Wx = Wx + 1                                                204584
      ********                                                                                204584
     C********           ENDDO                                                                204584
 
      ** Check if Depot Customer Number is present
 
     C                   Z-ADD     1             Wx
 
     C     PDepotCNum    LOOKUP    WDepotArr(Wx)                          02
 
      ** If Depot Customer Number is present
 
     C                   IF        LookUpFnd = *ON
 
     C*******************                                                                     204584
     C*******************IF        WClassCP = 'M' OR                                          204584
     C*******************          WClassCP = 'X' OR                                          204584
     C*******************          WClassCP = 'E' OR                                          204584
     C*******************          WClassCP = 'C'                                             204584
 
     C                   EVAL      PSKALRef = WDepotArr2(Wx)
 
     C*******************ELSE                                                                 204584
     C*******************                                                                     204584
     C*******************IF        WClassCP = 'I' OR                                          204584
     C*******************          WCLassCP = 'S' OR                                          204584
     C*******************          WClassCP = 'D'                                             204584
     C*******************                                                                     204584
     C*******************EVAL      WBFNDRX = WDepotArr2(Wx)                                   204584
     C*******************                                                                     204584
     C*******************EVAL      PSKALRef = WBFNDRX                                         204584
     C*******************                                                                     204584
     C*******************ENDIF                                                                204584
     C*******************                                                                     204584
     C*******************ENDIF                                                                204584
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Access Securities Trading Details
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
 
     C                   EVAL      PReturnCode = '*ERROR'
 
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   EVAL      WBVDR1 = BVDR1
     C                   EVAL      WBVDR2 = BVDR2
     C                   EVAL      WBVDR3 = BVDR3
     C                   EVAL      WBVDR4 = BVDR4
     C                   EVAL      WBVDR5 = BVDR5
     C                   EVAL      WBVDR6 = BVDR6
     C                   EVAL      WBVDR7 = BVDR7
     C                   EVAL      WBVDR8 = BVDR8
     C                   EVAL      WBVDR9 = BVDR9
     C                   EVAL      WBVDR10 = BVDR10
 
     C                   MOVEA     WDSDepotICD   WDepotArr
 
     C                   EVAL      PSKALRef = *BLANKS                           215058
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PDepotCNum
     C                   PARM                    PCntrPCNum
     C                   PARM                    PSKALRef
 
     C*******            EVAL      PSKALRef = *BLANKS                           215058
     C                   IF        PCntrPCNum <> *BLANKS                                    BUG27939
     C                   CALLB     'ZALIGN'                                                   244007
     C                   PARM      'Y'           ZOK               1                          244007
     C                   PARM      PCntrPCnum    ZFIELD           16                          244007
     C                   PARM      0             ZADEC             1 0                        244007
     C                   PARM      6             ZADIG             2 0                        244007
     C                   MOVE      ZFIELD        PCntrPCnum                                   244007
     C                   ENDIF                                                              BUG27939
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
