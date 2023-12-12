     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD061706
/*STD *  RPGSQLBND                                                    *                     MD061706
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
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. MD061706           Date 01Aug23               *
      *                 CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  MD061706 - Various changes for transition to aDBU            *
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
     DADBU             S              1                                                     MD061706
     DGLOB             S              2                                                     MD061706
     DPFX              S              2                                                     MD061706
     D*GLOBREF*        S              2                                            MD061706 MD061992
     D*ZONEREF*        S              2                                            MD061706 MD061992
     DGLOBREF          S              3                                                     MD061992
     DZONEREF          S              3                                                     MD061992
     DBRIDGE           S             10                                                     MD061706
     DERROR            S             10                                                     MD061706
     DCMP4             S              1                                                     MD061706
     D RcdCount        S              5  0                                                  MD061706
      *****************************************************************

      * Check if database upgrade is to be done with aDBU                                   MD061706
     C/exec SQL                                                                             MD061706
     C+ select UCADBU into :ADBU                                                            MD061706
     C+ from UPCCSITD                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
      * If 'Y', display aDBU function key only if active                                    MD061706
     C                   setoff                                       90                    MD061706
     C                   If        ADBU = 'Y'                                               MD061706
     C/exec SQL                                                                             MD061706
     C+ select DCMPG4 into :CMP4                                                            MD061706
     C+ from UPOTBMTD                                                                       MD061706
     C/end-exec                                                                             MD061706
     C                   If        CMP4 = 'R' or CMP4 = 'F'                                 MD061706
     C                   seton                                        90                    MD061706
     C                   Endif                                                              MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
      ** Process first screen.
     C                   EXFMT     UP6005F0

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   CALL      'UPC6999'
     C                   ENDIF

      ** Display aDBU screens is F24 is pressed                                             MD061706
     C                   IF        *INKY = *ON                                              MD061706
      ** Retrieve Global and Active layer                                                   MD061706
     C/exec SQL                                                                             MD061706
     C+ select DGPRFX, DACTVL into :GLOB, :PFX                                              MD061706
     C+ from UPOTBMTD                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
      ** Retrieve Bridge library                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ declare CursorA cursor for                                                          MD061706
     C+ select GIVAL from GPSVLXTD                                                          MD061706
     C+ where GISVAL = 'BrgDeliveredBrgLib'                                                 MD061706
     C+  for read only                                                                      MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ open CursorA                                                                        MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ fetch next                                                                          MD061706
     C+ from CursorA                                                                        MD061706
     C+ into :BRIDGE                                                                        MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ close CursorA                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
      ** Retrieve Global Ref System                                                         MD061706
     C/exec SQL                                                                             MD061706
     C+ declare CursorB cursor for                                                          MD061706
     C+ select GIVAL from GPSVLXTD                                                          MD061706
     C+ where GISVAL = 'BrgADBUGlobalRefer'                                                 MD061706
     C+  for read only                                                                      MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ open CursorB                                                                        MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ fetch next                                                                          MD061706
     C+ from CursorB                                                                        MD061706
     C+ into :GLOBREF                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ close CursorB                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
      ** Retrieve Zone Ref System                                                           MD061706
     C/exec SQL                                                                             MD061706
     C+ declare CursorC cursor for                                                          MD061706
     C+ select GIVAL from SDSVLXTD                                                          MD061706
     C+ where GISVAL = 'BrgADBUSystemRefer'                                                 MD061706
     C+  for read only                                                                      MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ open CursorC                                                                        MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ fetch next                                                                          MD061706
     C+ from CursorC                                                                        MD061706
     C+ into :ZONEREF                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
     C/exec SQL                                                                             MD061706
     C+ close CursorC                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
      * If *GLOBAL is being upgraded                                                        MD061706
     C                   eval      RcdCount = 0                                             MD061706
                                                                                            MD061706
     C                   IF        PFX = GLOB                                               MD061706
      * Display either the compare or the update monitor                                    MD061706
     C/EXEC SQL                                                                             MD061706
     C+ select count(*) into :RcdCount from UPGUPDTD                                        MD061706
     C+ where UPPRFX = :PFX                                                                 MD061706
     C/END-EXEC                                                                             MD061706
     C                   IF        RcdCount > 0                                             MD061706
     C                   CALL      'UP4014'                                                 MD061706
     C                   PARM                    PFX                                        MD061706
     C                   PARM                    GLOBREF                                    MD061706
     C                   PARM                    ERROR                                      MD061706
     C                   PARM                    ADBU                                       MD061706
     C                   ELSE                                                               MD061706
     C                   CALL      'UP4004'                                                 MD061706
     C                   PARM                    PFX                                        MD061706
     C                   PARM                    GLOBREF                                    MD061706
     C                   PARM                    BRIDGE                                     MD061706
     C                   PARM                    ERROR                                      MD061706
     C                   PARM                    ADBU                                       MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
     C                   ELSE                                                               MD061706
      * If *ZONE   is being upgraded                                                        MD061706
      * Display either the compare or the update monitor                                    MD061706
     C/EXEC SQL                                                                             MD061706
     C+ select count(*) into :RcdCount from UPZUPDTD                                        MD061706
     C+ where UPPRFX = :PFX                                                                 MD061706
     C/END-EXEC                                                                             MD061706
     C                   IF        RcdCount > 0                                             MD061706
     C                   CALL      'UP4015'                                                 MD061706
     C                   PARM                    PFX                                        MD061706
     C                   PARM                    GLOBREF                                    MD061706
     C                   PARM                    ERROR                                      MD061706
     C                   PARM                    ADBU                                       MD061706
     C                   ELSE                                                               MD061706
     C                   CALL      'UP4005'                                                 MD061706
     C                   PARM                    PFX                                        MD061706
     C                   PARM                    ZONEREF                                    MD061706
     C                   PARM                    BRIDGE                                     MD061706
     C                   PARM                    ERROR                                      MD061706
     C                   PARM                    ADBU                                       MD061706
     C                   ENDIF                                                              MD061706
     C                   ENDIF                                                              MD061706
                                                                                            MD061706
     C                   ENDIF                                                              MD061706


      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
