     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas XX LUC109 Migration utility')
      *****************************************************************
      *                                                               *
      *  XXL000009A - Midas XX Migration utility for LUC109           *
      *                                                               *
      *  Function:  This program initialises DEALSBX0 from T_GZ*      *
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
     D FrmLibDft       S             10    INZ('*LIBL')
     D ToLib           S             10
     D ToLibDft        S             10    INZ('*LIBL')
 
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
 
      * Build SQL script for T_GZFXDLEX --> DEALSBX0
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'insert into ' +
     C                             %trim(ToLib) +
     C                             '/DEALSBX0 (mdlno, mxtrno, mxntaf, ' +
     C                             'mxcntl, swpleg) select ' +
     C                             'cast(dddlno as int) as dddlnoint, ' +
     C                             'COALESCE(MXTRNO,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(R306,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(MXCNTL,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             'coalesce(swpleg, ' + x'7D' + ' ' +
     C                             x'7D' + ') from ' + %trim(FrmLib) +
     C                             '/T_GZFXDLEX where zone <> ' + x'7D' +
     C                             ' ' + x'7D'
 
     C                   EXSR      ExecuteSQL
 
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
 
     C                   IF        ToLib = *BLANKS
     C                   EVAL      ToLib = ToLibDft
     C                   ENDIF
 
     C                   IF        FrmLib = *BLANKS
     C                   EVAL      FrmLib = FrmLibDft
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
