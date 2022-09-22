     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTM display attention key options')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8006 - Midas UP OTM retrieve halt status                   *
      *                                                               *
      *  Function: This program retrieves halt status.                *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP046 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP046 - One Touch Bridge - refresh                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File

     DHalt             S              1
     DINCNO            S              5  0
      ** Declared Variables
       /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Halt
     C                   PARM                    INCNO

      * make sure component has not run yet
     C/exec SQL
     C+ select MIGHLT into :Halt
     C+ from SMMIGRTD where MIGINC = :INCNO
     C/end-exec


      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
