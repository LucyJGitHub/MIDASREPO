     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Update Currency Clearing System File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD81000 - SD Update SDCCSYPD                                 *
      *                                                               *
      *  Function:  This program will insert PLN currency in          *
      *             Currency Clearing System File(SDCCSYPD).          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW206C            Date 19Sep06               *
      *                 CSW206  *CREATE    Date 03Jul06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW206C - Update Standing Data Controls(SDFCTLPA)            *
      *  CSW206 - SWIFT 2006 Standard Changes                         *
      *                                                               *
      *****************************************************************
     FSDCCSYPD  IF A E             DISK
      ** Midas SD Standing Data Controls - Update Index                                      CSW206C
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)                                      CSW206C
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Data Area giving Installation Control Details
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
     D KFLNM           S                   LIKE(AHFLNM)                                      CSW206C
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Get date from data area RUNDAT.
 
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   EVAL      DPCYCD = 'PLN'
     C                   EVAL      DPCLSY = 'PL'
     C                   EVAL      DPLCD  = AGRDNB
     C                   EVAL      DPTYLC = 'I'
     C                   EVAL      DPEXPM = '*NONE'
     C                   EVAL      DPISCD = *BLANK
     C                   WRITE     SDCCSYD0                             80
 
     C                   IF        *IN80 = *OFF                                              CSW206C
     C                   EVAL      KFLNM = 'SDCCSYPD'                                        CSW206C
     C     KFLNM         CHAIN     SDFCTLL0                                                  CSW206C
                                                                                             CSW206C
     C                   IF        %FOUND                                                    CSW206C
     C                   EVAL      AHNORC = AHNORC + 1                                       CSW206C
     C                   EVAL      AHNOIN = AHNOIN + 1                                       CSW206C
     C                   UPDATE    @AHREAU                                                   CSW206C
     C                   ELSE                                                                CSW206C
     C                   EXSR      *PSSR                                                     CSW206C
     C                   ENDIF                                                               CSW206C
     C                   ELSE                                                                CSW206C
     C                   EXSR      *PSSR                                                     CSW206C
     C                   ENDIF                                                               CSW206C
                                                                                             CSW206C
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************                      CSW206C
      *                                                               *                      CSW206C
      *  *PSSR - Program exception subroutine.                        *                      CSW206C
      *                                                               *                      CSW206C
      *****************************************************************                      CSW206C
     C     *PSSR         BEGSR                                                               CSW206C
                                                                                             CSW206C
     C                   EVAL      *INLR = *ON                                               CSW206C
                                                                                             CSW206C
     C                   DUMP                                                                CSW206C
                                                                                             CSW206C
     C                   CALL      'DBERRCTL'                                                CSW206C
                                                                                             CSW206C
     C                   RETURN                                                              CSW206C
                                                                                             CSW206C
     C                   ENDSR                                                               CSW206C
