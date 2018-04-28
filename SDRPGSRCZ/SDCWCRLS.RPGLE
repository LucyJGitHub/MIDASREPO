     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Compliance watch case release')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCWCRLS - Compliance Watch Case Release Stored Procedure    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD015  *CREATE    Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
     FSDCWHTL0  UF A E           K DISK    USROPN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** parameters defined
     D returnCode      S             10A
     D functionType    S              8A
     D identifier      S             40A
     D branch          S              3A
     D system          S              2A
     D releaseFlag     S              2A
 
     C     MyKey         KLIST
     C                   KFLD                    functionType
     C                   KFLD                    identifier
     C                   KFLD                    branch
 
     C                   OPEN      SDCWHTL0
     C     MyKey         CHAIN     SDCWHTL0
 
      ** process if case found
     C                   IF        %found(SDCWHTL0)
 
     C                   SELECT
      ** temporary release
     C                   WHEN      releaseFlag = 'TR'
     C                   EVAL      W3TREL = 'Y'
     C                   UPDATE    SDCWHTD0
      ** false positive
     C                   WHEN      releaseFlag = 'FP'
     C                   EVAL      W3HSTS = 'FALSPOSITV'
     C                   EVAL      W3UNCF = *blanks
     C                   EVAL      W3TREL = *blanks
     C                   UPDATE    SDCWHTD0
      ** false positive
     C                   WHEN      releaseFlag = 'TP'
     C                   EVAL      W3HSTS = 'TRUEPOSITV'
     C                   UPDATE    SDCWHTD0
 
     C                   ENDSL
 
     C                   CLOSE     SDCWHTL0
 
     C                   ENDIF
 
     C                   MOVEL     *ON           *INLR
     C                   RETURN
 
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    returnCode
     C                   PARM                    functionType
     C                   PARM                    identifier
     C                   PARM                    branch
     C                   PARM                    system
     C                   PARM                    releaseFlag
 
     C                   ENDSR
      **********************************************************************
