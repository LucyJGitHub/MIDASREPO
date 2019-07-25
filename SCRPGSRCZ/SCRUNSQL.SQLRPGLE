     H COPYRIGHT('(c) Finastra International Limited 2012')
     H DftActGrp(*No) ActGrp(*Caller)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('SC Run Dynamic SQL Statement')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRUNSQL - Run dynamic SQL statement                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CGL127  *CREATE    Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL127 - General Ledger  Module optimisation - Phase 1       *
      *                                                               *
      *****************************************************************
      ** Parmlist
     D parmSQL         S           5000    Varying
     D parmRowsAffect  S             15p 0
      *================================================================
      * Program Entry
      *================================================================
     C     *Entry        PList
     C                   Parm                    parmSQL
     C                   Parm                    parmRowsAffect
      *
      ** Set SQL Options
      *
     C/EXEC SQL
     C+ SET OPTION Commit=*NONE, Naming=*SYS, DynUsrPrf=*Owner
     C/END-EXEC
      *
      ** Execute statement passed from command line
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :parmSQL
     C/END-EXEC
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
      *
      ** If requested (parms passed=2), return number of rows affected
      *
      ** Variable SQLErrD(3) from the SQL communications area will
      ** contain information about the number of rows affected
      ** for a given statement.
      *
     C                   If        %Parms>=2
     C                   Eval      parmRowsAffect=SQLErrD(3)
     C                   EndIf
      *
      ** End the program
      *
     C                   Eval      *InLR=*On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
