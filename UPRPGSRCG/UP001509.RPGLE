     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP set unique field to blank in GPTRIGPD')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP001509 - Set unique id in GPTRIGPD to blank.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP029  *CREATE    Date 21Oct04               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP029 - Not to use 'Unique id' field as key.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       60         EOF                                          *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FGPTRIGPD  UF   E             DISK    INFSR(*PSSR)
      * UPD : Midas GP Midas trigger programs
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Program data structure
     D/COPY GPCPYSRCG,PSDS
 
     D Wrun            S              1                                         *PSSR has been run?
 
      *****************************************************************
      * Set Unique Id. field to blank in GPTRIGPD                     *
      *****************************************************************
      *
      * Read in record from GPTRIGPD
     C                   READ      GPTRIGPD                               60    EOF
      *
     C                   DOW       *IN60  = '0'                                 NOT EOF
      *
     C                   EVAL      TRUNQI = *BLANK
     C                   UPDATE    SCTRIGD0
      *
     C                   READ      GPTRIGPD                               60    EOF
     C                   ENDDO
      *
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
