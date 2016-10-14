     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas XX LUC109 Migration utility')
      *****************************************************************
      *                                                               *
      *  XXL000003 - Midas XX Migration utility for LUC109            *
      *                                                               *
      *  Function:  This program initialises XXINCPPD and XXFACTX0    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC109   *Create   Date 10Oct16               *
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
     D ExcFil          S             10    INZ('T_GZLDNIEX')
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
 
      * Build SQL script to clear files
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'delete from ' +
     C                             ToLib + '/XXFACTX0'
     C                   EXSR      ExecuteSQL
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'delete from ' +
     C                             ToLib + '/XXINCPPD'
     C                   EXSR      ExecuteSQL
 
      * Build SQL script for SDFACTX0 --> XXFACTX0
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'insert into ' + ToLib +
     C                             '/XXFACTX0 select * from ' +
     C                             FrmLib + '/SDFACTX0'
     C                   EXSR      ExecuteSQL
 
      * Build SQL script for GLINCPPP --> XXINCPPD
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'insert into ' + ToLib +
     C                             '/XXINCPPD select * from ' +
     C                             FrmLib + '/GLINCPPP'
     C                   EXSR      ExecuteSQL
 
      * Build SQL script for Delete from XXINCPPD
 
     C                   Clear                   SQLString
     C                   Eval      SQLString = 'delete from ' + ToLib +
     C                             '/XXINCPPD where IMDFN = ' + Quote +
     C                             ExcFil + Quote
     C                   EXSR      ExecuteSQL
 
     C                   CALL      'XXL000001'
     C                   CALL      'XXL000002'
 
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
