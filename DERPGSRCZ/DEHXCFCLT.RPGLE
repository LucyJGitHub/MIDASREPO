     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext Ctlr for Lending Facilities')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  DEHXCFCLT - Historic Extract for Lending Facilities          *
      *                                                               *
      *  Function:  This module will control the extraction of        *
      *             Customer Lending Facilities for the analysis of   *
      *             revenue within CCRM. It may run in two modes,     *
      *             the first will extract a single Facility as       *
      *             defined as an input parameter. The second will    *
      *             extract all Facilities on file.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. AR674226           Date 04Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP073             Date 18Mar02               *
      *                 CLE029             Date 04Sep02               *
      *                 CLE028             Date 27Jun02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 25JUN02               *
      *                 205244             Date 25Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CAP068 - Recompiled for changes to FCLTYFM and FCLTYFN.      *
      *  205244 - DEHXCFCLT is setting up key to FACHSAL1 incorrectly *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File indicator                           *
      *    02         Record not found in file FCLTY                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrXCInit    - Initial Processing                              *
      * SrXCMain    - Main processing                                 *
      * SrExAll     - Extract *ALL process                            *
      * SrExSin     - Extract single transaction process              *
      * SrPrSpec    - Process specific extract                        *
      * SrXCWrite   - Extract error log                               *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer lending facilities
     FFCLTY     IF   E           K DISK    INFSR(*PsSR)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
     F                                     PREFIX(FC_)
      *
      ** Facilities details by date
     FFACHSAL1  IF   E           K DISK    INFSR(*PsSR)
     F                                     PREFIX(FH_)

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
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for facility details
     D FCLTYX        E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FC_)
      *
      ** Externally described DS for facility history details
     D FACHISX       E DS                  EXTNAME(FACHISA)
     D                                     PREFIX(FH_)
      *
      ** Externally described DS for period end date
     D PeriodEDT     E DS                  EXTNAME(DEPPERDPD)
      *
      ** Transaction reference
     D*PTrnsRef***     DS            20                                                       CGL029
     D PTrnsRef        DS            26                                                       CGL029
     D**WCnum***               1      6  0                                                    CSD027
     D  WCnum                  1      6A                                                      CSD027
     D  WFacT                  7      9  0
     D  WFcNo                 10     11  0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  RecNotFnd             02     02

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameter for Error log program
     D Buffer          S           4000A
      *
      ** Work Parameters
     D*PRetCode********S              7A                                                      208221
     D*PErrMs**********S             30A                                                      208221
     D I#RTCD          S              7A                                                      208221
     D I#ERMS          S             30A                                                      208221
     D PExtrctTp       S              4A
     D*PEndOfBk********S              1A                                                      208221
     D PrjHstFlg       S              1A
     D PAction         S              1A

     D*Run_Date********S              5P 0                                                    208221
     D*Date_NWD********S              5P 0                                                    208221
     D*HstCtlDat*******S              5P 0                                                    208221
     D*EvtCtlDat*******S              5P 0                                                    208221
     D*PrjCtlDat*******S              5P 0                                                    208221
     D I#RDNB          S              5P 0                                                    208221
     D I#DNWD          S              5P 0                                                    208221
     D I#HCOD          S              5P 0                                                    208221
     D I#EVCD          S              5P 0                                                    208221
     D I#PCOD          S              5P 0                                                    208221
      *
      ** Work Variables
     D WRcTp           S              1A
     D WAFcNo          S              2A
     D WAFacT          S              3A
     D WACnum          S              6A

     D WFcty           S              5P 0
     D WFctyA          S              5                                                       205244
      *
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
      *
      ** Initial processing
      *
     C                   EXSR      SrXCInit
      *
      ** Main processing
      *
     C                   EXSR      SrXCMain
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXCInit - Initial Processing                                *
      *                                                               *
      *****************************************************************
     C     SrXCInit      BEGSR
      *
      ** Obtain the revenue extract control data
      *
      * This is an historic extract                                                           208221
                                                                                              208221
     C                   MOVE      'H'           I#PH                                         208221
                                                                                              208221
      * Get Extract control information                                                       208221
                                                                                              208221
      /COPY DECPYSRC,DEXTGTCT                                                                 208221
                                                                                              208221
     C************       CALLB     'DEGETEXCT'                                                208221
      ************                                                                            208221
      ***Return*code**************************************************************************208221
      ***Error*message************************************************************************208221
     C************       PARM                    PRetCode                                     208221
     C************       PARM                    PErrMs                                       208221
      ************                                                                            208221
      **INPUTS****                                                                            208221
      ************                                                                            208221
      ***Projected*history*flag***************************************************************208221
      ***End*of*book*indicator****************************************************************208221
     C************       PARM      'H'           PrjHstFlg                                    208221
     C************       PARM                    PEndOfBk                                     208221
      ************                                                                            208221
      **OUTPUTS***                                                                            208221
      ************                                                                            208221
      ***Rundate**                                                                            208221
      ***Date*of*next*working*day*************************************************************208221
      ***History*control*date*****************************************************************208221
      ***Event*control*date*******************************************************************208221
      ***Projected*control*date***************************************************************208221
      ***Period*end*date*DS*******************************************************************208221
     C************       PARM      *ZEROS        Run_Date                                     208221
     C************       PARM      *ZEROS        Date_NWD                                     208221
     C************       PARM      *ZEROS        HstCtlDat                                    208221
     C************       PARM      *ZEROS        EvtCtlDat                                    208221
     C************       PARM      *ZEROS        PrjCtlDat                                    208221
     C************       PARM                    PeriodEDT                                    208221

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXCMain - Main Processing                                   *
      *                                                               *
      *****************************************************************
     C     SrXCMain      BEGSR
      *
      ** Extract all processes.
      *
     C                   IF        PExtrctTp = '*ALL'

     C                   EXSR      SrExAll

     C                   ELSE
      *
      ** Extract single process.
     C                   EXSR      SrExSin

     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExAll - Extract all processes                              *
      *                                                               *
      *****************************************************************
     C     SrExAll       BEGSR
      *
      ** Extract all customer lending facilities
      *
     C                   READ      FCLTY                                  01

     C                   DOW       EndOfFile = False
      *
      ** Extract record for the facility read.
     C                   EXSR      SrPrSpec
      *
      ** Read next facility.
     C                   READ      FCLTY                                  01
      *
     C                   ENDDO

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExSin - Extract single process                             *
      *                                                               *
      *****************************************************************
     C     SrExSin       BEGSR

     C                   EVAL      WRcTp = 'A'
     C     WKeyList1     CHAIN     FCLTY                              02
     C                   IF        RecNotFnd <> True
      *
      ** Extract record for the facility read.
     C                   EXSR      SrPrSpec
      *
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrSpec - Process specific extract                          *
      *                                                               *
      *****************************************************************
     C     SrPrSpec      BEGSR
      *
      ** Retrieve details for the customer, facility and date.
      ** Reset data structure if no record found.
      *
     C*******************Z-ADD     FC_FACT       WFcty                                        205244
     C                   MOVEL     FC_FACT       WFctyA                                       205244
     C                   MOVE      FC_FCNO       WFctyA                                       205244
     C                   MOVEL     WFctyA        WFcty                                        205244
     C     WKeyList2     SETLL     FACHSAL1
     C     WKeyList2     READE     FACHSAL1                               01

     C                   IF        EndOfFile = True
     C                   CLEAR                   FACHISX
     C                   ENDIF
      *
      ** Setup action code base on the record id.
      *
     C                   IF        FC_RECI = 'D' OR FC_RECI = 'E' OR
     C                             FC_RECI = 'C'
     C                   EVAL      PAction = 'I'
     C                   ELSE
     C                   EVAL      PAction = 'D'
     C                   ENDIF
      *
      ** Extract cutomer lending facilities
      *
     C                   CALLB     'DEHXTFCLT'
      *
      ** Return code
      ** Error message
     C***************    PARM      *BLANKS       PRetCode                                     208221
     C***************    PARM      *BLANKS       PErrMs                                       208221
     C                   PARM      *BLANKS       I#RTCD                                       208221
     C                   PARM      *BLANKS       I#ERMS                                       208221
      *
      ** Action code
      ** Extract type
      ** Projected history flag
      ** End of book indicator
     C                   PARM                    PAction
     C                   PARM                    PExtrctTp
     C                   PARM      'H'           PrjHstFlg
     C*************      PARM                    PEndOfBk                                     208221
     C                   PARM                    I#EOB                                        208221
      *
      ** Rundate
      ** Date of next working day
      ** History control date
      ** Event control date
      ** Projected control date
      ** Period end date
     C*************      PARM                    Run_Date                                     208221
     C*************      PARM                    Date_NWD                                     208221
     C*************      PARM                    HstCtlDat                                    208221
     C*************      PARM                    EvtCtlDat                                    208221
     C*************      PARM                    PrjCtlDat                                    208221
     C                   PARM                    I#RDNB                                       208221
     C                   PARM                    I#DNWD                                       208221
     C                   PARM                    I#HCOD                                       208221
     C                   PARM                    I#EVCD                                       208221
     C                   PARM                    I#PCOD                                       208221
     C                   PARM                    PeriodEDT
      *
      ** Facility details
      ** Facility history details
     C                   PARM                    FCLTYX
     C                   PARM                    FACHISX
     C                   PARM                    Dataarea                                     208221
      *
      ** If error, write a record to PF/DEELOGPD
      *
     C**************     IF        PRetCode = '*ERROR'                                        208221
     C                   IF        I#RTCD = '*ERROR'                                          208221
     C                   EXSR      SrXCWrite
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXCWrite - Write error log                                  *
      *                                                               *
      *****************************************************************
     C     SrXCWrite     BEGSR

     C                   MOVE      FC_CNUM       WACnum
     C                   MOVE      FC_FACT       WAFacT
     C                   MOVE      FC_FCNO       WAFcNo

     C                   EVAL      Buffer = PrjHstFlg + 'FCLT' + PExtrctTp +
     C                                      WACnum + WAFacT + WAFcNo +
     C***************                       ' ' + PRetCode + PErrMs + FCLTYX                  208221
     C                                      ' ' + I#RTCD + I#ERMS + FCLTYX                    208221

     C                   CALLB     'DEWRTELOG'
     C                   PARM                    Buffer

     C                   ENDSR
      *
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
      *
      ** Return code
      ** Error message
     C**************     PARM                    PRetCode                                     208221
     C**************     PARM                    PErrMs                                       208221
     C                   PARM                    I#RTCD                                       208221
     C                   PARM                    I#ERMS                                       208221
      *
      ** Extract type
      ** End of book
      ** Transaction reference
     C                   PARM                    PExtrctTp
     C***************    PARM                    PEndOfBk                                     208221
     C                   PARM                    I#EOB                                        208221
     C                   PARM                    PTrnsRef
      *
      ** Key list for facility details
      *
     C     WKeyList1     KLIST
     C                   KFLD                    WCnum
     C                   KFLD                    WFacT
     C                   KFLD                    WFcNo
     C                   KFLD                    WRcTp
      *
      ** Key list for facility details by date
      *
     C     WKeyList2     KLIST
     C                   KFLD                    FC_CNUM
     C                   KFLD                    WFcty
     C                   KFLD                    FC_DTAP
     C*******************KFLD                    FC_FCNO                                      205244
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      *COPY*ZACPYSRC,PSSR_ILE*****************************************************************208221
      /COPY DECPYSRC,DEPSSR                                                                   208221

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
