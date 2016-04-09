     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBI *  OVRDBF FILE(SM1089OF) TOFILE(QAFDMBRL)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Load file members info into GPFILMBRPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1089 - Load file members information into file SMFILMBRPD  *
      *                                                               *
      *  Function: This program will read records from file SM1089OF  *
      *            in QTEMP and add the file members info to          *
      *            SMFILMBRPD.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP025  *CREATE    Date 05Feb04               *
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
      *       50         EOF SM0189OF                                 *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
 
     FSM1089OF  IF   E             DISK    INFSR(*PSSR)
      * RTV : Output file for DSPFD TYPE(*MBRLIST)
 
     FSMFILMBRPDUF A E             DISK    INFSR(*PSSR)
      * UPD : File member list
 
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
 
      * Get first record from SM1089OF
     C                   READ      SM1089OF                               50    EOF
 
     C                   DOW       *IN50 = '0'
 
     C                   IF        P0FileName = MLFILE
 
     C                   IF        MLNAME <> *BLANK
 
      * If same file, output member name record to file SMFILMBRPD
     C                   EVAL      FMFILE = P0FileName
     C                   EVAL      FMFMBR = MLNAME                              member name
     C                   WRITE     SMFILMBRD0
     C                   ENDIF                                                  FI MLNAME = ' '
 
     C                   ENDIF                                                  FI P0FileName=MLFILE
 
      * Read next record from SM1089OF
     C                   READ      SM1089OF                               50    EOF
     C                   ENDDO                                                  ODW *IN50 = '0'
 
     C                   SETON                                        LR
     C                   RETURN
 
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
