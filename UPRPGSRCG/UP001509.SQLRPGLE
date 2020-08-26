     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055682
/*STD *  RPGSQLBND                                                    *                     MD055682
/*EXI *  TEXT('Midas UP set unique field to blank in GPTRIGPD')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP001509 - Set unique id in GPTRIGPD to blank.               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD055682           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP029  *CREATE    Date 21Oct04               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055682 - Deliverable Data Split for TRIG                   *
      *  MD046248 - Finastra Rebranding                               *
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
     F*GPTRIGPD* UF   E             DISK    INFSR(*PSSR)                                    MD055682
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
     C**********         READ      GPTRIGPD                               60    EOF         MD055682
      **********                                                                            MD055682
     C**********         DOW       *IN60  = '0'                                 NOT EOF     MD055682
      **********                                                                            MD055682
     C**********         EVAL      TRUNQI = *BLANK                                          MD055682
     C**********         UPDATE    SCTRIGD0                                                 MD055682
      **********                                                                            MD055682
     C**********         READ      GPTRIGPD                               60    EOF         MD055682
     C**********         ENDDO                                                              MD055682
     C/EXEC SQL                                                                             MD055682
     C+ update SCTRGCTD set TRUNQI = '         '                                            MD055682
     C/END-EXEC                                                                             MD055682
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
