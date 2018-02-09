     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Case Management Update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDMCMGUPD - Midas SD Case Management Database Update         *
      *                                                               *
      *  Function: This module will perform the update of the Midas   *
      *            database for the Case Management                   *
      *                                                               *
      *  Component of: SDMCMGSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD015 - Midas Compliance Watch                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  LR  - Last record indicator (program termination)            *
      *  U7  - DB error processing indicator                          *
      *  U8  - DB error processing indicator                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAmend - Amend Account Codes Details                        *
      *  SRErr - Routine for Exception Errors                         *
      *  *INZSR - Initialise                                          *
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
 
     FSDCWHTL2  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Compliance Watch Hit List(FType/Identifier/Branch) - Update
 
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** Midas SD Compliance Watch Hit List File
     D NwCWFilFmt    E DS                  EXTNAME(SDCWHTPD)
     D                                     PREFIX(NW:2)
 
      ** Midas SD Compliance Watch Hit List File
     D CWHTUpdF      E DS                  EXTNAME(SDCWHTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Key Fields for SDCWHTL2
     D KFunt           S              8A
     D KIden           S             40A
     D KBrch           S              3A
 
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRAmend
 
      ** Return
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAmend - Amend Compliance Watch Hit List File               *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
     C                   MOVEL     NWFUNT        KFunt
     C                   MOVEL     NWIDEN        KIden
     C                   MOVEL     NWBRCH        KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL2
 
     C                   IF        NOT %FOUND(SDCWHTL2)
     C                   EVAL      DBKEY  = KFUNT + KIDEN + KBRCH
     C                   EVAL      DBFILE = 'SDCWHTPD'
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Apply changes to retrieved file.
 
     C                   MOVEL     NwCWFilFmt    CWHTUpdF
 
      ** Write to Update File
 
     C                   UPDATE    SDCWHTD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRErr - Routine for Exception Errors                         *
      *****************************************************************
 
     C     SRErr         BEGSR
 
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
      ** Terminate program
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input
      ** =====
 
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** SD Account Codes for file update - file format
 
     C                   PARM                    NwCWFilFmt
 
      ** Key fields for LF/SDCWHTL2
      ** Compliance Watch Hit List(FType/Identifier/Branch) - Update
 
     C     KSDCWHT       KLIST
     C                   KFLD                    KFunt
     C                   KFLD                    KIden
     C                   KFLD                    KBrch
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2002
