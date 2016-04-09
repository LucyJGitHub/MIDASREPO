     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Reset BFSTRP in GPBRCFLDPD header w blank')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1093  - Reset SMBRCFLDPD header records with blank.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP025  *CREATE    Date 02Feb04               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
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
 
     FSMBRCFLDL3UF   E           K DISK    INFSR(*PSSR)
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
     C     *LOVAL        SETLL     SMBRCFLDL3
     C                   READ      SMBRCFLDL3                             60    EOF
 
     C                   DOW       *IN60 = '0'                                  not EOF
      *
      * Replace the *DONE with blanck
     C                   EVAL      BFSTRP = *BLANK
     C                   UPDATE    SMBRCFLDD0
      *
      * Read next *DONE record from SMBRCFLDL3.
     C                   READ      SMBRCFLDL3                             60    EOF
     C                   ENDDO
 
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
