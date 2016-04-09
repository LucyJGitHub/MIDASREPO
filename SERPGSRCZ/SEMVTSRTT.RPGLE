     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Trade Trans. Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSRTT - Movements Status - Trade or WI/WO          *
      *                    Transaction Retrieve                       *
      *                                                               *
      *  Function:  This module retrieves and validates the transac-  *
      *             tion to which a movement record is to be linked.  *
      *             It is intended to be called only when a movement  *
      *             is to be inserted, as all other modes will change *
      *             movements which already exist in the database     *
      *             (i.e. no need to verify the linked transaction).  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 222727             Date 05Nov03               *
      *                 CSE039   *CREATE   Date 11Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
      ** Trades
 
     FSEDVPRL0  IF   E           K DISK    INFSR(*PSSR)
      ** DVP / RVP Trades
 
     FDPTMVDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Depot Movements by Reference Number
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       99  Multi Purpose                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Initialisations for each run
      *
     C                   EXSR      SRINIT
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Inititialisations to be done at each call
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Initialise the OK flags
      *
     C                   EVAL      DDTRRFOK = 'Y'
     C                   EVAL      DDTRTYOK = 'Y'
      *
      ** Initialise the other output parameters
      *
     C                   EVAL      P@BRCA = *Blanks
     C                   EVAL      P@TRDT = 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** 1. Blank Transaction Type validation:
      **    If it is blank, try to define it in accessing the database (note
      **    that the *BRW module forces 'W' in Transaction Type if the user
      **    wants to input a movement linked to a Walk In/Out transaction).
      *
     C                   IF        DDTRTY = *Blank
     C                   EXSR      TRTYSetup
     C                   ENDIF
      *
     C                   IF        DDTRTYOK = 'N'
     C                   GOTO      EndMAIN
     C                   ENDIF
      *
      ** 2. Transaction Reference Validation: access the database depending on
      **    Transaction Type, and verify that the transaction is OK to receive
      **    a new movement.
      *
 B1  C                   SELECT
      *
 X1  C                   WHEN      DDTRTY = 'T'
     C                   EXSR      TradVal
      *
 X1  C                   WHEN      DDTRTY = 'D'
     C                   EXSR      DvP_RvPVal
      *
 X1  C                   WHEN      DDTRTY = 'W'
     C                   EXSR      DptMvVal
 E1  C                   ENDSL
      *
     C     EndMAIN       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TRTYSetup - Attempts to set up the Transaction Type
      *****************************************************************
     C     TRTYSetup     BEGSR
      *
      ** We have to decide if the received Transaction Reference is for a
      ** "classic" trade or a DVP/RVP, or for a Walk In/Out.
      ** An error is issued if the Transaction Type can't be determined.
      *
     C                   Z-ADD     0             HitsCtr           3 0
      *
     C     DDTRRF        SETLL     TRADSDF                                99
     C   99              EVAL      HitsCtr = HitsCtr + 1
      *
     C     DDTRRF        SETLL     SEDVPRD0                               99
     C   99              EVAL      HitsCtr = HitsCtr + 1
      *
     C     DDTRRF        SETLL     DPTMVDF                                99
     C   99              EVAL      HitsCtr = HitsCtr + 1
      *
 B1  C                   SELECT
      *
 X1  C                   WHEN      HitsCtr = 0
     C                   EVAL      DDTRRFOK = 'N'
     C                   EVAL      DDTRTYOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03901'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRTY'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03903'
      *
 X1  C                   WHEN      HitsCtr > 1
     C                   EVAL      DDTRRFOK = 'N'
     C                   EVAL      DDTRTYOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03902'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRTY'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03903'
      *
 X1  C                   WHEN      %EQUAL(TRADS)
     C                   EVAL      DDTRTY = 'T'
      *
 X1  C                   WHEN      %EQUAL(SEDVPRL0)
     C                   EVAL      DDTRTY = 'D'
      *
 X1  C                   WHEN      %EQUAL(DPTMVDL1)
     C                   EVAL      DDTRTY = 'W'
 E1  C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TradVal - Validate Transaction Reference as a Trade
      *****************************************************************
     C     TradVal       BEGSR
      *
     C     DDTRRF        CHAIN     TRADSDF                            99
      *
 B1  C                   SELECT
      *
 X1  C                   WHEN      *IN99
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03904'
      *
 X1  C                   WHEN      RECI = '*' OR RECI = 'C' OR RECI = 'R'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03905'
      *
 X1  C                   WHEN      RECI = 'S'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03906'
      *
 X1  C                   WHEN      RECI = 'L'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03907'
 E1  C                   ENDSL
      *
      ** Sets output parameters up if all's right
      *
     C                   IF        DDTRRFOK = 'Y'
     C                   EVAL      P@BRCA = TDBA
     C                   EVAL      P@TRDT = TDDT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DvP_RvPVal - Validate Transaction Reference as a DVP / RVP
      *****************************************************************
     C     DvP_RvPVal    BEGSR
      *
     C     DDTRRF        CHAIN     SEDVPRD0                           99
      *
 B1  C                   SELECT
      *
 X1  C                   WHEN      *IN99
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03904'
      *
 X1  C                   WHEN      DVRECI = '*' OR DVRECI = 'C' OR DVRECI = 'R'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03905'
      *
 X1  C                   WHEN      DVRECI = 'S'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03906'
      *
 X1  C                   WHEN      DVRECI = 'L'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03907'
 E1  C                   ENDSL
      *
      ** Sets output parameters up if all's right
      *
     C                   IF        DDTRRFOK = 'Y'
     C                   EVAL      P@BRCA = DVBRCA
     C                   EVAL      P@TRDT = DVTDAT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DptMvVal - Validate Transaction Reference as a Depot Movement
      *****************************************************************
     C     DptMvVal      BEGSR
      *
     C     DDTRRF        CHAIN     DPTMVDF                            99
      *
 B1  C                   SELECT
      *
 X1  C                   WHEN      *IN99
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03908'
      *
 X1  C                   WHEN      RECI = 'M'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03909'
      *
 X1  C                   WHEN      RECI = '*'
     C                   EVAL      DDTRRFOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Ix = Ix + 1
     C   99              EVAL      FldNameArr(Ix) = 'DDTRRF'
     C   99              EVAL      MsgIdArr(Ix) = 'SE03910'
 E1  C                   ENDSL
      *
      ** Sets output parameters up if all's right
      *
 B1  C                   IF        DDTRRFOK = 'Y'
     C                   EVAL      P@BRCA = DPBA
      *
 B2  C                   IF        DPMV = 'WI'
     C                   EVAL      P@TRDT = DPMD
 X2  C                   ELSE
     C                   EVAL      P@TRDT = DPDO
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeIn
      ** Transaction Reference
     C                   PARM                    DDTRRF            6
      *
      ** INPUT/OUTPUT PARAMETERS:
      ** Transaction Type
     C                   PARM                    DDTRTY            1
      *
      ** OUTPUT PARAMETERS:
      ** OK Indicators
     C                   PARM                    DDTRRFOK          1
     C                   PARM                    DDTRTYOK          1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Ix                3 0
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA            3
     C                   PARM                    P@TRDT            5 0
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
