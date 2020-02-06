     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP025  *CREATE    Date 30Jan04               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
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
 
     FSMBRCFLDL2UF   E           K DISK    INFSR(*PSSR)
      * UPD : Midas SM Not yet branch updated files (by file)
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    P0FileName       10            File name
 
      * Get record for the file from SMBRCFLDL2.
     C     P0FileName    CHAIN     SMBRCFLDL2                         60        Record not found
 
      * If record not found, call *PSSR
     C                   IF        *IN60  = '1'
     C                   EXSR      *PSSR
     C                   ELSE
 
      * Else rec found, update the record
     C                   EVAL      BFSTRP = '*DONE'
     C                   UPDATE    SMBRCFLDD0
     C                   END
 
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
