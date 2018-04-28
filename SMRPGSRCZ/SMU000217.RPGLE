     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM CRE041 Migration Utility for RECUSHPA')       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU000217 - CRE041 Migration Utility for RECUSHPA            *
      *                                                               *
      *  Function:  This program migrates RECUSHPA to CUSEXCE         *
      *             and updates RECI to 'H'                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD019999  *CREATE  Date 11Apr13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD019999 - RECUSHPA Migration issue                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Use of indicators                                             *
      *                                                               *
      *   20 - End of file                                            *
      *   U7 - Database Error                                         *
      *   U8 - Database Error                                         *
      *   LR - Last record found                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSMCUSXPD  IF   E             DISK    INFSR(*PSSR)
     FCUSEXCE   O    E             DISK    INFSR(*PSSR)
      ** Midas RE Customer Exchange details file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
 
     D PSDS           SDS
     D PSProcName        *PROC
     D PSJobName             244    253
     D PSUser                254    263
     D PSJobNo               264    269S 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read SMCUSXPD
 
     C     1             SETLL     SMCUSXPD
     C                   READ      SMCUSXPD                               20
 
     C                   DOW       *IN20 = *OFF
 
      ** Update RECI to 'H' then write to CUSEXCE
 
     C                   EVAL      RECI = 'H'
     C                   WRITE     CUSEXCEF
 
      ** Read next record
 
     C                   READ      SMCUSXPD                               20
 
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called By: Automatically if a program error occurs,           *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
