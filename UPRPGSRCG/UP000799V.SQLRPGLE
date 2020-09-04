     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Action File handler - validity checker')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000799V - Action File handler validity checker.            *
      *              Check if the file exists on UPACTFPD and whether *
      *              it uses the new methodology.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CUP040  *REWRITE   Date 01Mar13               *
      *  Prev Amend No. CUP021             Date 09Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP022 *CREATE     Date 09Feb04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP040 - New deliverable data methodology.                   *
      *  CUP021 - Rewrite of Action File processing                   *
      *  CUP022 - Standardise action file processing.                 *
      *                                                               *
      *****************************************************************
      *
     D PFile           S             10
     D POriFile        S             10
     D PReturn         S              1
     D ExtFile         S             10
     D FileVar         S             10    INZ(*blanks)
     D OriVar          S             10    INZ(*blanks)
     D ChkRtn          S             10
     D ChkLib          S             10
     D ChkType         S              7
     D ChkMbr          S             10
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    POriFile
     C                   PARM                    PReturn
      *
      * Check if file has Action File.
     C/exec SQL
     C+ select
     C+   AABONF
     C+ , AAORIF
     C+ into
     C+   :FileVar
     C+ , :OriVar
     C+ from UPACTFPD
     C+ where
     C+    AABONF = :PFile
     C/end-exec
      *
      * If no Action File found then return 'Y' ...
     C                   IF        FileVar = *blanks
     C                   EVAL      PReturn = 'Y'
      * ... else check if it uses new methodology by seeing if extension table
      *  exists.
     C                   ELSE
     C                   EVAL      ExtFile = %SUBST(PFile:1:5) + 'XTD'
     C                   CALL      'UTCHKOBJ'
     C                   PARM                    ChkRtn
     C                   PARM                    ExtFile
     C                   PARM      '*LIBL'       ChkLib
     C                   PARM      '*FILE'       ChkType
     C                   PARM      *blanks       ChkMbr
      * If found then return 'New' ...
     C                   IF        ChkRtn = 'Exist'
     C                   EVAL      PReturn = 'N'
      * ... else return 'Old'.
     C                   ELSE
     C                   EVAL      PReturn = 'O'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      POriFile = OriVar
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
