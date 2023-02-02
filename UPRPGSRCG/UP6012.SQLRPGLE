     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU check CCSID')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6012 - Midas UP check CCSID                                *
      *                                                               *
      *  Function: This program retrieves CCSID for OTB installation  *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061004 *CREATE   Date 02Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061004 - Adding CCSID for database objects                 *
      *                                                               *
      *****************************************************************
      /EJECT
     D U_CCSID         S              5  0

     C     *ENTRY        PLIST
     C                   PARM                    ChgCCSID          1
     C                   PARM                    XCCSID            5 0

     C/exec SQL
      + select UCCSID into :U_CCSID
      + from UPCCSITD
     C/end-exec
     C                   If        SQLCode = 0
     C                             and U_CCSID > 0
     C                   eval      ChgCCSID = 'Y'
     C                   eval      XCCSID = U_CCSID
     C                   Endif

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************

