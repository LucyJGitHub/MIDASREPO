     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Reporting Info File Drop Process')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001301 - Midas SD Reporting Info File Drop Process         *
      *                                                               *
      *  Function:  Transactions that were deleted or have matured    *
      *             will be dropped from the system.                  *
      *                                                               *
      *  Called By: SDC001301 - Midas SD Dealing/Standing Data Drop   *
      *                         Process 1                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. CSW214             Date 02Jun14               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW213 - SWIFT 2013 Changes                                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXDEALL10 IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas Fx DEALPP Keyed on FHDN38 and FHTYPE
      *
     FDEALSL51  IF   E           K DISK    INFSR(*PSSR)
     FDEALSL52  IF   E           K DISK    INFSR(*PSSR)
      *
      ** DEALSDB and DEALSDG Files keyed on CNUM and Deal Type
      *
     FDLRPIFPD  UF   E             DISK    INFSR(*PSSR)
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
 
     D WDnum           S              6  0
     D WDtype          S              2
     D WDelete         S              1
     D WRun            S              1
 
      ** +--------------------------------------+
      ** ¦ C-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     C                   EXSR      INIT
      *
      ** Read records in DLRPIFPD
      *
     C     1             SETLL     DLRPIFPD
     C                   READ(E)   DLRPIFPD
      *
     C                   DOW       NOT %EOF
     C                   MOVEL     RITRRF        WDnum
     C                   MOVEL     RIDTYP        WDtype
      *
      ** Check if exist in FXDEALPP.
      *
     C     WDeals        CHAIN     FXDEALL10
     C                   IF        %FOUND
     C                   MOVE      'N'           WDelete
     C                   ELSE
     C                   MOVE      'Y'           WDelete
     C                   ENDIF
      *
      ** Check on Deals File if found in FXDEALL10.
      *
     C                   IF        WDelete = 'Y'
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
     C                   ENDIF
      *
      ** If not existing on both files, delete the corresponding record.
      *
     C     WDelete       IFEQ      'Y'
     C                   DELETE    DLRPIFPD
     C                   ELSE
     C                   UNLOCK    DLRPIFPD
     C                   ENDIF
 
     C                   READ(E)   DLRPIFPD
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
      ** Blank WDnum, WDtype, and WDelete.
      *
     C                   MOVE      *BLANKS       WDnum
     C                   MOVE      *BLANKS       WDtype
     C                   MOVE      *BLANKS       WDelete
      *
      ** Define key list and Check if record in DLRPIFPD exist on DEALS file.
      *
     C     WDeals        KLIST
     C                   KFLD                    WDnum
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
      *****************************************************************
