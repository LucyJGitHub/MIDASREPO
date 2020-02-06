     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Dealing/Standing Data Drop Process 7')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001326 - Midas SD Dealing/Standing Data Drop Process 7     *
      *                                                               *
      *  Function:  Transactions that were deleted or have matured    *
      *             will be dropped from the system.                  *
      *                                                               *
      *  Called By: SDC001326 - Midas SD Dealing/Standing Data Drop   *
      *                         Process 7                             *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 CSW214  *CREATE    Date 25Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014                                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDEALSL51  IF   E           K DISK    INFSR(*PSSR)
      ** Confirmation Message Extract Historic Records Files
      ** It will be created by MGF600TR.

     FMGF600TR  UF   E             DISK    INFSR(*PSSR)
      ** Midas DL Dealing Reporting Information file.

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Work Fields

     D WTref           S              6S 0
     D WDtype          S              2
     D WDelete         S              1
     D WRun            S              1


      ** +--------------------------------------+
      ** ¦ C-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     C                   EXSR      INIT

      ** Read records in MGF600TR

     C     1             SETLL     MGF600TR
     C                   READ(E)   MGF600TR

     C                   DOW       NOT %EOF
     C                   MOVEL     MGTRRF        WTref
     C                   MOVEL     MGDTYP        WDtype
     C     WDeals        CHAIN     DEALSL51
     C                   IF        %FOUND
     C                   MOVE      'N'           WDelete
     C                   ELSE
     C                   MOVE      'Y'           WDelete
     C                   ENDIF

      ** If not existing on the file, delete the corresponding record.

     C     WDelete       IFEQ      'Y'
     C                   DELETE    MGF600TR
     C                   ELSE
     C                   UNLOCK    MGF600TR
     C                   ENDIF
     C                   READ(E)   MGF600TR
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *******************************************************************
      *                                                                 *
      *  INIT - Initialize workfields                                   *
      *                                                                 *
      *******************************************************************
     C     INIT          BEGSR

      ** Blank WTref, WDtype and WDelete.

     C                   MOVE      *BLANKS       WTref
     C                   MOVE      *BLANKS       WDtype
     C                   MOVE      *BLANKS       WDelete

      ** Define key list and Check if record in MGF600TR exist on DEALS file.

     C     WDeals        KLIST
     C                   KFLD                    WTref
     C                   KFLD                    WDtype
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      ** Check to see that *PSSR has not already been called.

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      ********************************************************************
