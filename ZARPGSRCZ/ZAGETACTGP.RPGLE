     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Get the activation group of a program')
      *****************************************************************
      *                                                               *
      *  Midas - General functions                                    *
      *                                                               *
      *  ZAGETACTGP - Get the activation group of a program           *
      *                                                               *
      *  Function:  This module returns the name of a program's       *
      *             activation group.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002  *CREATE    Date 11Mar98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY lines include the structures necessary for the
      ** QCLRPGMI API.  The first is specific to that API; the second is
      ** the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QCLRPGMI
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D SpecVals        C                   '*NEW                          +
     D                                     *DFTACTGRP                    +
     D                                     *CALLER                       '
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **--- Parameter list -------------------------------------------------------------------------
 
      ** Activation group name
     D ActGroup        S             10A
 
      ** Program name
     D Program         S             10A
 
      **--- End of parameter list ------------------------------------------------------------------
 
      **--- Parameters for QCLRPGMI API ------------------------------------------------------------
 
      ** Length of receiver variable
     D RcvrLen         S              9B 0 INZ(536)
 
      ** Format name
     D Format          S              8A   INZ('PGMI0100')
 
      ** Qualified program name
     D QualPgm         S             20A   INZ('          *LIBL     ')
 
      **--- End of parameters for QCLRPGMI API -----------------------------------------------------
 
      ** Position of string in the scanned data
     D*Position********S              5I 0
     D Position        S              5S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Ensure the returned fields start out blank
     C                   CLEAR                   ReturnCode
     C                   CLEAR                   ActGroup
 
      ** Set up the qualified program name from the input value
     C                   EVAL      %subst(QualPgm : 1 : 10) = Program
 
      ** Set up the 'Bytes provided' field for the API error structure
     C                   EVAL      QUSBPRV = 16
 
     C                   CALL      'QCLRPGMI'
      **                                      Receiver variable
     C                   PARM                    QCLI0100
      **                                      Length of receiver variable
     C                   PARM                    RcvrLen
      **                                      Format name for returned data
     C                   PARM                    Format
      **                                      Qualified program name
     C                   PARM                    QualPgm
      **                                      Error structure
     C                   PARM                    QUSEC
 
      ** If the API returned an error, set the return code and end
      ** processing.
     C                   IF        QUSEI <> *blanks
     C                   EVAL      ReturnCode = 'Error'
 
     C                   ELSE
 
      ** If the 'Activation Group Attribute' field contains one of
      ** the special values, this procedure cannot return an activation
      ** group name, so indicate this to the caller.
     C     QCLAGA        SCAN      SpecVals      Position
     C                   IF        Position <> 0
     C                   EVAL      ReturnCode = 'SpecVal'
 
     C                   ELSE
 
      ** If The activation group attribute is blank, an OPM program name
      ** has been provided.  Indicate this to the caller
     C                   IF        QCLAGA = *blanks
     C                   EVAL      ReturnCode = 'OPMProgram'
 
     C                   ELSE
 
      ** Otherwise an activation group name has been returned; return it to
      ** the caller
     C                   EVAL      ActGroup = %subst(QCLAGA : 1 : 10)
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Returned parameters
      ** -------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
     C                   PARM                    ActGroup
 
      ** Received parameters
      ** -------------------
     C                   PARM                    Program
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
