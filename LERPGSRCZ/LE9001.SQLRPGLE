     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas CL Update Cancel Flag for CL files')
      *****************************************************************
      *                                                               *
      *  Midas - Collateralised Lending Module                        *
      *                                                               *
      *  LE9001 - Midas CL Update Cancel Flag on CL files             *
      *                                                               *
      *  Function:  This program updates the cancel flag on           *
      *             T_MLRSVEXT and T_CLRSVEXT from 'N' to 'Y'.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Called By: LEC0451                                           *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 247012  *CREATE    Date 12Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  247012 - Update the cancel flag on two Collateralised        *
      *           Lending files.                                      *
      *                                                               *
      *****************************************************************
      *
     C/EXEC SQL
     C+ UPDATE T_CLRSVEXT
     C+ SET CRCANCEL = 'Y'
     C+ WHERE CRRTID IN (SELECT CRRTID
     C+                  FROM T_CLRSVEXT
     C+                  LEFT JOIN T_MLRSVTRN ON RTID = CRRTID
     C+                  WHERE CRCANCEL = 'N' AND
     C+                        RTBRCHCODE IN (SELECT BRANCH FROM
     C+                        V_MLBRRNDT LEFT JOIN SDBANKPD
     C+                        ON ZONE = BJZONE))
     C/END-EXEC
      *
     C/EXEC SQL
     C+ UPDATE T_MLRSVEXT
     C+ SET MRCANCEL = 'Y'
     C+ WHERE MRRTID IN (SELECT MRRTID
     C+                  FROM T_MLRSVEXT
     C+                  LEFT JOIN T_MLRSVTRN ON RTID = MRRTID
     C+                  WHERE MRCANCEL = 'N' AND
     C+                        RTBRCHCODE IN (SELECT BRANCH FROM
     C+                        V_MLBRRNDT LEFT JOIN SDBANKPD
     C+                        ON ZONE = BJZONE))
     C/END-EXEC
      *
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
