     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Update Generation Indicator for MG0565')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE1878 - SE Update Generation Indicator for MG0565           *
      *                                                               *
      *  Function:  This module updates the MG565 generation indicator*
      *             to 'R' for all the position settlement records    *
      *             with the same security, event, event date and     *
      *             depot.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185571             Date 26Oct00               *
      *                 185397  *CREATE    Date 24Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  185571 - Unable to re-generate MG0565 message                *
      *           (CSE023 - Treaty Withholding Tax)                   *
      *  185397 - Problem with generation of MG565 message for        *
      *           manual input/deleted position settlement.           *
      *           (CSE023 - Treaty Withholding Tax)                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPOSETW7   UF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
 
     D @BRCH           S                   LIKE(PBCA)
     D @SECT           S                   LIKE(PSSH)
     D @PDUD           S                   LIKE(PDUD)
     D @PEVT           S                   LIKE(PEVT)
     D @PCPY           S                   LIKE(PCPY)
     D @PREF           S                   LIKE(PREF)
     D @PSEQ           S                   LIKE(PSEQ)
     D PgmErr          S              1
 
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
 
      ** Process inputs.
 
     C                   EXSR      SRProc
 
      ** Return.
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C                   EVAL      *IN01 = *OFF
      *
      ** If Depot/Counterparty is *BLANK then use the key without
      ** Counterparty.
      *
     C**********         IF        @PCPY <> 0                                                 CSD027
     C                   IF        @PCPY <> *BLANKS                                           CSD027
     C     W7KEY         SETLL     POSETW7                            01
     C                   ELSE
     C     W7KEY2        SETLL     POSETW7
     C                   ENDIF
      *
      ** Process all the record with the same key.
      *
     C                   DOW       *IN01 = *OFF
      *
      ** If Depot/Counterparty is *BLANK then use the key without
      ** Counterparty.
      *
     C**********         IF        @PCPY <> 0                                                 CSD027
     C                   IF        @PCPY <> *BLANKS                                           CSD027
     C     W7KEY         READE     POSETW7                                01
     C                   ELSE
     C     W7KEY2        READE     POSETW7                                01
     C                   ENDIF
 
     C                   IF        *IN01 <> '1' and RECI <> '*'
 
     C                   IF        MT5R = 'Y'
     C                   EVAL      @PREF = PREF
     C                   EVAL      @PSEQ = PSEQ
      *
      ** If MG565 already generated then set it to 'R' for re-generation.
      *
     C                   IF        MT5G = 'Y'
     C                   EVAL      MT5G = 'R'
     C                   UPDATE    POSETDF
     C                   ENDIF
      *                                                                         185571
      ** If position settlement is for depot, and MG565 is not requested        185571
      ** before, then set it up for generation.                                 185571
      *                                                                         185571
     C                   ELSE                                                   185571
                                                                                185571
     C                   IF        CTYP = 'D'                                   185571
     C                   EVAL      MT5R = 'Y'                                   185571
     C                   UPDATE    POSETDF                                      185571
     C                   ENDIF                                                  185571
                                                                                185571
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
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
      ** Key fields for POSETW7 - with depot
      *
     C     W7KEY         KLIST
     C                   KFLD                    @BRCH
     C                   KFLD                    @SECT
     C                   KFLD                    @PDUD
     C                   KFLD                    @PEVT
     C                   KFLD                    @PCPY
      *
      ** Key fields for POSETW7 - without depot
      *
     C     W7KEY2        KLIST
     C                   KFLD                    @BRCH
     C                   KFLD                    @SECT
     C                   KFLD                    @PDUD
     C                   KFLD                    @PEVT
 
      *
      ** Program Input Paramenters
      *
     C     *Entry        PLIST
      *
      ** INPUT fields
      *
     C                   PARM                    @BRCH
     C                   PARM                    @SECT
     C                   PARM                    @PDUD
     C                   PARM                    @PEVT
     C                   PARM                    @PCPY
      *
      ** OUTPUT fields
      *
     C                   PARM                    @PREF                          No of record written
     C                   PARM                    @PSEQ
     C
      *
      ** Initialise Output fields
      *
     C                   EVAL      PSEQ = 001
     C                   EVAL      PREF = *BLANKS
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
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
