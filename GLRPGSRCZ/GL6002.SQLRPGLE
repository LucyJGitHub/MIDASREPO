     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL APR ACCNTBXC take on')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL6002 - Utility program to update PF/ACCNTBXC with          *
      *           APR flag at take on                                 *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      *             S U B R O U T I N E    I N D E X                  *
      *             --------------------------------                  *
      * SRMAIN - Main processing                                      *
      *****************************************************************
      *
      *  Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *
      *****************************************************************
      *             M A I N    P R O C E S S I N G
      *****************************************************************
      *
     C                   MOVEA     ARRCPY        WCPY             80
      *
     C                   EXSR      SRMAIN
      *
      *****************************************************************
      * SRMAIN - Main processing                                      *
      *                                                               *
      *  Calls     -                                                  *
      *  Called by - Main Processing                                  *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
     C/exec SQL
     C+ update ACCNTBXC
     C+   set ATAPRC = 'Y'
     C+    where ATAPRC = ' '
     C/end-exec
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
** ARRCPY
(c) Finastra International Limited 2016
