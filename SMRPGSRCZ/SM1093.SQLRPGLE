     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/******  RPGBASEBND                                                   *                     MD057599
/*STD *  RPGSQLBND                                                    *                     MD057599
/*EXI *  TEXT('Midas SM Reset BFSTRP in GPBRCFLDPD header w blank')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1093  - Reset SMBRCFLDPD header records with blank.        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD057599           Date 21Jan21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP025  *CREATE    Date 02Feb04               *
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
      *       60         EOF (SMBRCFLDL3)                             *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************

     F*SMBRCFLDL3UF   E           K DISK    INFSR(*PSSR)                                    MD057599
      * UPD : Midas SM Branch updated files (by file)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Program data structure
     D/COPY GPCPYSRCG,PSDS

     D Wrun            S              1                                         *PSSR has been run?

      *****************************************************************
      * Main processing                                               *
      *****************************************************************

      * Get first *DONE record from SMBRCFLDL3.
     C******LOVAL        SETLL     SMBRCFLDL3                                               MD057599
     C**********         READ      SMBRCFLDL3                             60    EOF         MD057599

     C**********         DOW       *IN60 = '0'                                  not EOF     MD057599
      *
      * Replace the *DONE with blanck
     C**********         EVAL      BFSTRP = *BLANK                                          MD057599
     C**********         UPDATE    SMBRCFLDD0                                               MD057599
      *
      * Read next *DONE record from SMBRCFLDL3.
     C**********         READ      SMBRCFLDL3                             60    EOF         MD057599
     C**********         ENDDO                                                              MD057599
     C/EXEC SQL                                                                             MD057599
     C+ update SMBRCXTD SET BFSTRP = '     '                                                MD057599
     C+    where BFRECI = 'H' and BFSTRP = '*DONE'                                          MD057599
     C/END-EXEC                                                                             MD057599

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
