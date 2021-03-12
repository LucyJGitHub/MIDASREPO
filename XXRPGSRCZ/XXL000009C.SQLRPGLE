     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas XX LUC109 Migration utility')
      *****************************************************************
      *                                                               *
      *  XXL000009C - Midas XX Migration utility for LUC109           *
      *                                                               *
      *  Function:  This program initialises DEALSGX0 from T_GZ*      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC109   *Create   Date 19Oct16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FBM 2.1)                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain    - Controls main flow of program                    *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
 
      ** Entry parameter fields
     D FrmLib          S             10
     D ToLib           S             10
 
      ** Work Variables
     D SQLString       S           5000
     D Quote           S              1    INZ('''')
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
 
     C                   EXSR      SRMain
 
      ** Termination
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain  - Controls main flow of program                      *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
      * Build SQL script for T_GZSIRSEX --> DEALSGX0
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'insert into ' + ToLib +
     C                             '/DEALSGX0 (mdlno, mxtrno, mxntaf,' +
     C                             ' mxcntl) select sdlno, ' +
     C                             'COALESCE(MXTRNO,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(R306,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(MXCNTL,' +
     C                             x'7D' + ' ' + x'7D' + ')'  +
     C                             ' from ' + FrmLib +
     C                             '/T_GZSIRSEX where zone <> ' + x'7D' +
     C                             ' ' + x'7D'
      *
     C                   EXSR      ExecuteSQL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ExecuteSQL - Execute SQL statement                            *
      *                                                               *
      * Called by: *multi                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ExecuteSQL    BEGSR
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     ExecuteSQLE   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    FrmLib
     C                   PARM                    ToLib
 
     C                   ENDSR
 
      *****************************************************************
