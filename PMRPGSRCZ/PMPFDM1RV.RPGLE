     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Charges Details Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM1RV - Portfolio Charges Details Retrieve              *
      *                                                               *
      *  Function: This module retrieves the Portfolio Charges        *
      *            details from the database.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Portfolio Charges file keyed on Customer Number, Portfolio
      ** Reference and Sequence Number
     FPMCHRGL1  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D MaxChrgArr      C                   CONST(10)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Original Portfolio Charges details array - file format
     D CrChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EXSR      SRInit
      *
     C                   EXSR      SRRtvChrg
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Clear output.
      *
     C                   CLEAR                   CrChrgFileArr
     C                   CLEAR                   ChrgExists
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvChrg - Retrieve Portfolio Charges details               *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvChrg     BEGSR
      *
     C**********         MOVEL     PDDCSNM       WCNUM             6 0                        CSD027
     C                   MOVEL     PDDCSNM       WCNUM             6                          CSD027
     C                   Z-ADD     1             WCTR              2 0
      *
     C     WCTR          DOUGT     MaxChrgArr
      *
     C                   CLEAR                   PMCHRG
     C     WKEY1         CHAIN     PMCHRGL1                           01
      *
      ** If live Portfolio Charges record found, set on Charge
      ** Exists flag.
      *
     C     *IN01         IFEQ      '0'
     C                   EVAL      ChrgExists = 'Y'
      *
     C                   ELSE
      *
      ** If no record found, initialise data structure for update
      ** of Original Portfolio Charges details array in file format.
      *
     C                   CLEAR                   PMCHRG
     C                   Z-ADD     *ZERO         PODLUP
     C                   Z-ADD     *ZERO         POYLUP
     C                   Z-ADD     *ZERO         POTLUP
     C                   Z-ADD     *ZERO         POLCD
     C                   Z-ADD     *ZERO         POTNLU
     C**********         Z-ADD     *ZERO         POCNUM                                       CSD027
     C                   EVAL      POCNUM = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         POCGSQ
     C                   Z-ADD     *ZERO         POCGSP
     C                   Z-ADD     *ZERO         POCGDY
     C                   Z-ADD     *ZERO         POCGND
     C                   Z-ADD     *ZERO         POCSDY
     C                   Z-ADD     *ZERO         POCSND
     C                   Z-ADD     *ZERO         POCGAD
     C                   Z-ADD     *ZERO         POCGLD
     C                   Z-ADD     *ZERO         POCGLS
     C                   Z-ADD     *ZERO         POCSSP
     C                   Z-ADD     *ZERO         POCGAJ
     C                   Z-ADD     *ZERO         POCGAT
     C                   Z-ADD     *ZERO         POCSTT
     C                   ENDIF
      *
     C                   EVAL      CrChrgFileArr(WCTR) = PMCHRG
      *
     C                   ADD       1             WCTR
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Customer
     C                   PARM                    PDDCSNM          10
      *
      ** Portfolio Reference
     C                   PARM                    PDDPREF           4
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Charges details array - file format
     C                   PARM                    CrChrgFileArr
      *
      ** Charge Exists flag
     C                   PARM                    ChrgExists        1
      *
      ** Key List
      *
     C     WKEY1         KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    PDDPREF
     C                   KFLD                    WCTR
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
