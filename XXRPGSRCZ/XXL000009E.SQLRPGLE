     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas XX LUC109 Migration utility')
      *****************************************************************
      *                                                               *
      *  XXL000009D - Midas XX Migration utility for LUC109           *
      *                                                               *
      *  Function:  This program initialises DEALSDX0 from T_GZ*      *
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
     D frmlibtxt       S             22
     D tolibtxt        S             22
     D tolibtxt2       S             22
     D tolibtxt3       S             22
     D mode            S              1
 
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
 
     C                   if        frmlib  <> *blanks
     C                   eval      frmlibtxt = ' ' + %trim(frmlib)
     C                             + '/T_GZNASPEX'
     C                   else
     C                   eval      frmlibtxt = ' T_GZNASPEX'
     C                   endif
      *
     C                   if        tolib <> *blanks
     C                   eval      tolibtxt = ' ' + %trim(tolib)
     C                             + '/DEALSDX0'
     C                   else
     C                   eval      tolibtxt = 'DEALSDX0'
     C                   endif
 
     C                   if        tolib <> *blanks
     C                   eval      tolibtxt2 = ' ' + %trim(tolib)
     C                             + '/DLDHISPD'
     C                   else
     C                   eval      tolibtxt2 = 'DLDHISPD'
     C                   endif
 
     C                   if        tolib <> *blanks
     C                   eval      tolibtxt3 = ' ' + %trim(tolib)
     C                             + '/DEALSDD'
     C                   else
     C                   eval      tolibtxt3 = 'DEALSDD'
     C                   endif
 
 
      * Build SQL script for T_GZNASPEX --> DEALSDX0
      *
 
     C                   clear                   SQLString
      *
      * Only DLDHISPD
     C                   if        mode = '1'
     C                   eval      SQLString = 'insert into ' + toLibtxt +
     C                             ' (mdlno, mxtrno,' +
     C                             ' mxcntl) select cast(dddlno as int)' +
     C                             ' as dddlnoint, COALESCE(MXTRNO,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(MXCNTL,' +
     C                             x'7D' + ' ' + x'7D' + ')'  +
     C                             ' from ' + frmlibtxt +
     C                             ' as a where zone <> ' +
     C                              x'7D' + ' ' + x'7D' +
     C                             ' and a.dddlno IN (SELECT cast(bb.dlno' +
     C                             ' as int) FROM ' + tolibtxt2 + ' bb)'
     C                   endif
      *
      * Only DEALSDD
     C                   if        mode = '2'
     C                   eval      SQLString = 'insert into ' + toLibtxt +
     C                             ' (mdlno, mxtrno,' +
     C                             ' mxcntl) select cast(dddlno as int)' +
     C                             ' as dddlnoint, COALESCE(MXTRNO,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(MXCNTL,' +
     C                             x'7D' + ' ' + x'7D' + ')'  +
     C                             ' from ' + frmlibtxt +
     C                             ' as a where zone <> ' +
     C                              x'7D' + ' ' + x'7D' +
     C                             ' and a.dddlno IN (SELECT cast(bb.dlno' +
     C                             ' as int) FROM ' + tolibtxt3 + ' bb)'
     C                   endif
      *
      * Both DEALSDD and DLDHISPD
     C                   if        mode = '3'
     C                   Eval      SQLString = 'insert into ' + toLibtxt +
     C                             ' (mdlno, mxtrno,' +
     C                             ' mxcntl) select cast(dddlno as int)' +
     C                             ' as dddlnoint, COALESCE(MXTRNO,' +
     C                             x'7D' + ' ' + x'7D' + '),' +
     C                             ' COALESCE(MXCNTL,' +
     C                             x'7D' + ' ' + x'7D' + ')'  +
     C                             ' from ' + frmlibtxt +
     C                             ' as a where zone <> ' +
     C                              x'7D' + ' ' + x'7D' +
     C                             ' and (a.dddlno IN (SELECT cast(bb.dlno' +
     C                             ' as int) FROM ' + tolibtxt2 + ' bb)' +
     C                             ' or a.dddlno IN (SELECT cast(cc.dlno' +
     C                             ' as int) FROM ' + tolibtxt3 + ' cc))'
     C                   endif
      *
      * Execute insert
     C                   exsr      ExecuteSQL
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
     C                   PARM                    Mode
     C                   PARM                    FrmLib
     C                   PARM                    ToLib
 
     C                   ENDSR
 
      *****************************************************************
