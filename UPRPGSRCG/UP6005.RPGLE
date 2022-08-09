     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP OTU attention key screen')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6005 - Midas UP OTU attention key screen                   *
      *                                                               *
      *  Function: This program displays the screen when attention    *
      *            key is pressed.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
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
     FUP6005GF  CF   E             WORKSTN


      ** Declared Variables
       /EJECT
      *****************************************************************


      ** Process first screen.
     C                   EXFMT     UP6005F0

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   CALL      'UPC6999'
     C                   ENDIF


      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
