     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Dealing/Standing Data Drop Process 5')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001324 - Midas SD Dealing/Standing Data Drop Process 5     *
      *                                                               *
      *  Function:  Transactions that were deleted or have matured    *
      *             will be dropped from the system.                  *
      *                                                               *
      *  Called By: SDC001324 - Midas SD Dealing/Standing Data Drop   *
      *                         Process 5                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027731           Date 26Jun14               *
      *                 MD023877           Date 30Nov13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD027731 - MT103 not generated for FXDL (Recompile)          *
      *  MD023877 - No arhive file generated in message extract.      *
      *  CSW213 - SWIFT 2013 Changes                                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDEALSL51  IF   E           K DISK    INFSR(*PSSR)
     FDEALSL52  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Confirmation Message Extract Historic Records Files
      ** It will be created by MGX360TR.
      *
     F***MGX360PD  UF   E             DISK    INFSR(*PSSR)                                  MD023877
     FMGX360TR  UF   E             DISK    INFSR(*PSSR)                                     MD023877
      *
      ** Midas DL Dealing Reporting Information file.
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Work Fields
      *
     D WTref           S              6  0
     D WDtype          S              2
     D WDelete         S              1
     D WRun            S              1
 
      ** +--------------------------------------+
      ** ¦ C-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     C                   EXSR      INIT
      *
      ** Read records in MGX360TR
      *
     C*****1****         SETLL     MGX360PD                                                 MD023877
     C**********         READ(E)   MGX360PD                                                 MD023877
     C     1             SETLL     MGX360TR                                                 MD023877
     C                   READ(E)   MGX360TR                                                 MD023877
      *
     C                   DOW       NOT %EOF
     C                   MOVEL     MGTRRF        WTref
     C                   MOVEL     MGDTYP        WDtype
     C     WDeals        CHAIN     DEALSL51
     C                   IF        %FOUND
     C                   MOVE      'N'           WDelete
     C                   ELSE
     C                   MOVE      'Y'           WDelete
     C     WDeals        CHAIN     DEALSL52
     C                   IF        %FOUND
     C                   MOVE      'N'           WDelete
     C                   ENDIF
     C                   ENDIF
      *
      ** If not existing on both files, delete the corresponding record.
      *
     C     WDelete       IFEQ      'Y'
     C**********         DELETE    MGX360PD                                                 MD023877
     C                   DELETE    MGX360TR                                                 MD023877
     C                   ELSE
     C**********         UNLOCK    MGX360PD                                                 MD023877
     C                   UNLOCK    MGX360TR                                                 MD023877
     C                   ENDIF
     C**********         READ(E)   MGX360PD                                                 MD023877
     C                   READ(E)   MGX360TR                                                 MD023877
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *******************************************************************
      *                                                                 *
      *  INIT - Initialize workfields                                   *
      *                                                                 *
      *******************************************************************
     C     INIT          BEGSR
      *
      ** Blank WTref, WDtype and WDelete.
      *
     C                   MOVE      *BLANKS       WTref
     C                   MOVE      *BLANKS       WDtype
     C                   MOVE      *BLANKS       WDelete
      *
      ** Define key list and Check if record in MGX360TR exist on DEALS file.
      *
     C     WDeals        KLIST
     C                   KFLD                    WTref
     C                   KFLD                    WDtype
     C                   ENDSR
      *********************************************************************
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
