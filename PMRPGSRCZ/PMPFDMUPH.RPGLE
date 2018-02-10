     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Charges Database Update')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMUPH - Portfolio Charges Database Update                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      ** Portfolio Charge Details file
     FPMCHRGPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
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
      **    False      logical = *off (for indcator processing)
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
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG1       E DS                  EXTNAME(PMCHRGPD)
     D                                     PREFIX(P1)
      *
      ** Charges details array - for file update
     D NwChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG1)
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
     C                   EXSR      SRMainP
      *
      ** Return to calling program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainP - Main processing for Charges file update            *
      *                                                               *
      *****************************************************************
      *
     C     SRMainP       BEGSR
      *
     C                   Z-ADD     1             WCntr             2 0
      *
      ** Do until all charges are updated/written to file.
      *
     C     WCntr         DOUGT     MaxChrgArr
      *
     C                   EXSR      SRRESET
      *
     C                   EVAL      PMCHRG1 = NwChrgFileArr(WCntr)
      *
      ** Write/Update charge details.
      *
     C     P1POCGCO      IFNE      *BLANKS
      *
     C     KLCHRGS       CHAIN     PMCHRGPD                           01
      *
     C                   EVAL      PMCHRG = PMCHRG1
      *
      ** If no record found, insert record.  Otherwise,
      ** amend it.
      *
     C     *IN01         IFEQ      '1'
     C                   WRITE     PMCHRGP0
     C                   ELSE
     C                   UPDATE    PMCHRGP0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Increment counter for next record in array.
      *
     C                   ADD       1             WCntr
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESET - Reset data structures for file update              *
      *            (PMCHRG and PMCHRG1)                               *
      *                                                               *
      *****************************************************************
      *
     C     SRRESET       BEGSR
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
      *
     C                   CLEAR                   PMCHRG1
     C                   Z-ADD     *ZERO         P1PODLUP
     C                   Z-ADD     *ZERO         P1POYLUP
     C                   Z-ADD     *ZERO         P1POTLUP
     C                   Z-ADD     *ZERO         P1POLCD
     C                   Z-ADD     *ZERO         P1POTNLU
     C**********         Z-ADD     *ZERO         P1POCNUM                                     CSD027
     C                   EVAL      P1POCNUM = *BLANKS                                         CSD027
     C                   Z-ADD     *ZERO         P1POCGSQ
     C                   Z-ADD     *ZERO         P1POCGSP
     C                   Z-ADD     *ZERO         P1POCGDY
     C                   Z-ADD     *ZERO         P1POCGND
     C                   Z-ADD     *ZERO         P1POCSDY
     C                   Z-ADD     *ZERO         P1POCSND
     C                   Z-ADD     *ZERO         P1POCGAD
     C                   Z-ADD     *ZERO         P1POCGLD
     C                   Z-ADD     *ZERO         P1POCGLS
     C                   Z-ADD     *ZERO         P1POCSSP
     C                   Z-ADD     *ZERO         P1POCGAJ
     C                   Z-ADD     *ZERO         P1POCGAT
     C                   Z-ADD     *ZERO         P1POCSTT
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Charges details array - for file update
     C                   PARM                    NwChrgFileArr
      *
      ** Define key list for PMCHRGPD.
      *
     C     KLCHRGS       KLIST
     C                   KFLD                    P1POCNUM
     C                   KFLD                    P1POPTFR
     C                   KFLD                    P1POCGSQ
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
(c) Finastra International Limited 2001
