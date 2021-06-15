     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/******  RPGBASEBND                                                   *                     MD057599
/*STD *  RPGSQLBND                                                    *                     MD057599
/*EXI *  TEXT('Midas SM Update GPBRCFLDPD header with *DONE')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1092  - Update SMBRCFLDPD header rec with '*DONE' to       *
      *            signify it has been processed                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD057599           Date 21Jan21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP025  *CREATE    Date 30Jan04               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD057599 - Deliverable Data Split for Bridge and Util files  *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP025 - Change branches utility                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       60         No record found in SMBRCFLDL2                *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************

     F*SMBRCFLDL2UF   E           K DISK    INFSR(*PSSR)                                    MD057599
      * UPD : Midas SM Not yet branch updated files (by file)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Program data structure
     D/COPY GPCPYSRCG,PSDS
     D X0FileName      S             10                                                     MD057599
     D SMBRCFLD      E DS                  Extname(SMBRCJW0)                                MD057599

     D Wrun            S              1                                         *PSSR has been run?

      *****************************************************************
      * Main processing                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    P0FileName       10            File name

      * Get record for the file from SMBRCFLDL2.
     C*****P0FileName    CHAIN     SMBRCFLDL2                         60        Record not fMD057599

      * If record not found, call *PSSR
     C**********         IF        *IN60  = '1'                                             MD057599
     C**********         EXSR      *PSSR                                                    MD057599
     C**********         ELSE                                                               MD057599

      * Else rec found, update the record
     C**********         EVAL      BFSTRP = '*DONE'                                         MD057599
     C**********         UPDATE    SMBRCFLDD0                                               MD057599
     C**********         END                                                                MD057599
     C                   eval      X0FileName = P0FileName                                  MD057599
     C/EXEC SQL                                                                             MD057599
     C+ update SMBRCXTD SET BFSTRP = '*DONE'                                                MD057599
     C+    where BFFILE = :X0FileName and BFRECI = 'H' and BFSTRP <> '*DONE'                MD057599
     C/END-EXEC                                                                             MD057599
     C                   If        SQLCODE <> 0                                             MD057599
     C                   EXSR      *PSSR                                                    MD057599
     C                   Endif                                                              MD057599

     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
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
      *****************************************************************
