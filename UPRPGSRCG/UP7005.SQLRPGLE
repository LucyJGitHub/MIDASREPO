     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR display attention key options')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7005 - Midas UP OTR display attention key options          *
      *                                                               *
      *  Function: This program displays options availalbe when       *
      *            attention key is pressed from refresh monitor      *
      *            screen.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP045 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP045 - One Touch Bridge - refresh                          *
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
     FUP7005GF  CF   E             WORKSTN

     DStatus           S              1
      ** Declared Variables
       /EJECT
      *****************************************************************

      * check if refresh is running
     C/exec SQL
     C+ select DCMPG4 into :Status
     C+ from UPOTRMTD
     C/end-exec

     C                   setoff                                       24
     C                   If        Status = 'R' or Status = 'F'
     C                   seton                                        24
     C                   Endif

      ** Process first screen.
     C                   EXFMT     UP7005F0

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   CALL      'UPC7999'
     C                   ENDIF

      ** End program if F4 is pressed.
     C                   IF        *INKD = *ON
     C                   CALL      'UPC700074'
     C                   ENDIF


      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
