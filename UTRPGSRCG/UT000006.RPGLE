     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBI *  OVRDBF FILE(UTC000002F) TOFILE(UPFDCSTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Change constraint names in outfile')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000006 - Change constraint names in outfile                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. BUG27980           Date 05Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG18582  *CREATE   Date 11Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27980 - Remove DBGVIEW (Recompile).                       *
      *  BG18582 - Enhancements to changing CCSIDs.                   *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
     FUTC000002FUF   E           K DISK
      *
     D PPrefix         S              2
     D PLibName        S              5
      *
     D Prefix          S              2
     D LibName         S              5
     D Position        S              2  0
     D Recursive       S              1    INZ('N')
      *
     C     *ENTRY        PLIST
     C                   PARM                    PPrefix
     C                   PARM                    PLibName
      *
     C                   EVAL      Prefix  = PPrefix
     C                   EVAL      LibName = PLibName
      *
     C                   READ      UTC000002F
      *
     C                   DOW       NOT(%EOF)
      *
     C                   EVAL      Position = %SCAN(LibName:PHCSTN)
     C                   IF        Position <> 0
     C                   EVAL      %SUBST(PHCSTN:(Position - 2):2) = Prefix
     C                   UPDATE    QWHFDCST
     C                   ENDIF
      *
     C                   READ      UTC000002F
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *ALL                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
