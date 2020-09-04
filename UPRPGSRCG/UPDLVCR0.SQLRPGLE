     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UPDLVCR0 - Driving file access object                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CUP042 *REWRITE    Date 26May15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK018  *MOVED     Date 22Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP002 *CREATE     Date 12Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Simplification of driving file                      *
      *  CPK018 - Moved to global layer.                              *
      *  CUP002 - Part of special handling for field reference files  *
      *                                                               *
      *****************************************************************
      *                                                               *
      /EJECT
      *
     D POption         S              7A
     D PReturnCode     S              7A
     D PKey01          S             10A
     D PKey02          S             10A
      *
     D UPDLVCDS      E DS                  EXTNAME(UPDLVCPD)
     D PData         E DS                  EXTNAME(DSSDY)
      *
      ** Main process.
     C                   IF        POption = '*KEY'
     C                   EXSR      GetRecord
     C                   ENDIF
      *
      ** End of program.
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetRecord - Find record based on key.                        *
      *                                                               *
      *****************************************************************
     C     GetRecord     BEGSR
      *
     C/exec SQL
     C+ select * into :UPDLVCDS
     C+ from UPDLVCPD
     C+ where
     C+     AUMBNM = :PKey01
     C+ and AUMBTP = :PKey02
     C/end-exec
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      PReturnCode = '*NRF'
     C                   ELSE
     C                   EVAL      PData = UPDLVCDS
     C                   ENDIF
      *
     C     GetRecordE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    POption
     C                   PARM                    PKey01
     C                   PARM                    PKey02
     C                   PARM                    PData
      *
     C     INZSRE        ENDSR
      *
      *****************************************************************
