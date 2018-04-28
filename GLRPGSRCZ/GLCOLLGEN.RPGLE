     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details Generate Reference')       *
/*OVR *  OVRDBF FILE(GLCOLLX1) TOFILE(GLCOLLL1) SHARE(*NO)            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLGEN - Collateral Details Generate Reference            *
      *                                                               *
      *  Function: This module will generate a new Midas collateral   *
      *            item is to be inserted. It will check whether the  *
      *            value to be assigned exists and if so determine    *
      *            the next number. The generated reference will be   *
      *            returned to the collateral details screen input    *
      *            module, GLCOLLSIN.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG3069            Date 10Jun04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3069 - Record is not added to file GLGCOLPD when it is    *
      *            first used.  Reposition READ command to fix        *
      *            problem.                                           *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Collateral Details File
     FGLCOLLX1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Collateral Details Generated Reference File
     FGLGCOLPD  UF A E             DISK    INFSR(*PSSR)
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D Indicators      DS                  BASED(IndicatorP)
     D  RcdNotFnd             89     89
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
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
     C     PMODULE       IFNE      'GL'
     C     PTTYPE        ORNE      'C'
     C                   MOVEL     '*Error '     RetCodeIn
     C                   RETURN
     C                   ENDIF
      *
     C                   Z-ADD     0             @GenRef          10 0
     C                   MOVE      'N'           @GENWRAP          1
      *
     C     1             SETLL     GLGCOLD0                           89
     C                   READ      GLGCOLD0                               89                 BUG3069
      *
     C     RcdNotFnd     IFEQ      True
     C                   MOVE      'I'           @Action           1
     C                   Z-ADD     1             @GenRef
     C                   ELSE
     C**********         READ      GLGCOLD0                               89                 BUG3069
     C                   MOVE      'A'           @Action
     C     CGLCRF        ADD       1             @GenRef
     C                   ENDIF
      *
     C     RcdNotFnd     DOUEQ     True
     C                   MOVE      @GENREF       PGENREF
     C     PGENREF       CHAIN     GLCOLLX1                           89
     C     RcdNotFnd     IFEQ      False
     C                   ADD       1             @GenRef
     C     @GENREF       IFEQ      0
     C     @GENWRAP      IFEQ      'Y'
     C                   MOVEL     '*Error '     RetCodeIn
     C                   RETURN
     C                   ENDIF
     C                   MOVE      'Y'           @GENWRAP
     C                   ADD       1             @GenRef
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      @GENREF       PGENREF
     C                   Z-ADD     @GENREF       CGLCRF
      *
     C     @ACTION       IFEQ      'I'
     C                   WRITE     GLGCOLD0
     C                   ENDIF
      *
     C     @ACTION       IFEQ      'A'
     C                   UPDATE    GLGCOLD0
     C                   ENDIF
      *
     C                   MOVE      TRUE          *INLR
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Module
     C                   PARM                    PMODULE           2
      *
      ** Transaction Type
     C                   PARM                    PTTYPE            1
      *
      ** Front Office Id
     C                   PARM                    FOTRID           20
      *
      ** OUTPUT PARAMETER:
      *
      ** Generated Reference
     C                   PARM                    PGENREF          10
      *
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLGEN  ' DBPGM
     C                   OUT       LDA
      *
     C                   MOVE      'N'           @GENWRAP          1
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
