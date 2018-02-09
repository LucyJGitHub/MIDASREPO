     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Update of SCDRSTAT')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000071 - Updates SCDRSTAT                                  *
      *                                                               *
      *  Function:  This module will update accordingly the data area *
      *             SCDRSTAT                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    60         End of File for PF/SCFDTLPD                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSCFDTLL1  IF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SCDRSTAT      E DS                  EXTNAME(SCDRSTAT) DTAARA(SCDRSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D WkCtr0          S              5  0 INZ(0)
     D WkCtr1          S              5  0 INZ(0)
     D WkCtr2          S              5  0 INZ(0)
     D WkCtr3          S              5  0 INZ(0)
     D WkCtr4          S              5  0 INZ(0)
     D WkCtr5          S              5  0 INZ(0)
     D WkCtr6          S              5  0 INZ(0)
     D WkCtr7          S              5  0 INZ(0)
     D WkCtr8          S              5  0 INZ(0)
     D WkCtr9          S              5  0 INZ(0)
 
     D WkBatch         S              2  0 INZ(0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *LOVAL        SETLL     SCFDTLL1
     C                   READ      SCFDTLL1                               60
 
      ** Count the number of files in each batch
 
     C                   DOW       *IN60 = *Off
 
     C                   SELECT
     C                   WHEN      FDBATN = '0'
     C                   EVAL      WkCtr0 = WkCtr0 + 1
 
     C                   WHEN      FDBATN = '1'
     C                   EVAL      WkCtr1 = WkCtr1 + 1
 
     C                   WHEN      FDBATN = '2'
     C                   EVAL      WkCtr2 = WkCtr2 + 1
 
     C                   WHEN      FDBATN = '3'
     C                   EVAL      WkCtr3 = WkCtr3 + 1
 
     C                   WHEN      FDBATN = '4'
     C                   EVAL      WkCtr4 = WkCtr4 + 1
 
     C                   WHEN      FDBATN = '5'
     C                   EVAL      WkCtr5 = WkCtr5 + 1
 
     C                   WHEN      FDBATN = '6'
     C                   EVAL      WkCtr6 = WkCtr6 + 1
 
     C                   WHEN      FDBATN = '7'
     C                   EVAL      WkCtr7 = WkCtr7 + 1
 
     C                   WHEN      FDBATN = '8'
     C                   EVAL      WkCtr8 = WkCtr8 + 1
 
     C                   WHEN      FDBATN = '9'
     C                   EVAL      WkCtr9 = WkCtr9 + 1
     C                   ENDSL
 
     C                   READ      SCFDTLL1                               60
     C                   ENDDO
 
      ** Update Batch number used
 
     C     *LOCK         IN        SCDRSTAT
     C                   IF        WkCtr0 <> 0
     C                   EVAL      DABCH0 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH0 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr1 <> 0
     C                   EVAL      DABCH1 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH1 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr2 <> 0
     C                   EVAL      DABCH2 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH2 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr3 <> 0
     C                   EVAL      DABCH3 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH3 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr4 <> 0
     C                   EVAL      DABCH4 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH4 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr5 <> 0
     C                   EVAL      DABCH5 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH5 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr6 <> 0
     C                   EVAL      DABCH6 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH6 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr7 <> 0
     C                   EVAL      DABCH7 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH7 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr8 <> 0
     C                   EVAL      DABCH8 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH8 = 'N'
     C                   ENDIF
 
     C                   IF        WkCtr9 <> 0
     C                   EVAL      DABCH9 = 'Y'
     C                   EVAL      WkBatch = WkBatch + 1
     C                   ELSE
     C                   EVAL      DABCH9 = 'N'
     C                   ENDIF
 
      ** Check if Single batch is used
 
     C                   IF        WkBatch = 1
     C                   EVAL      DASBCH = 'Y'
     C                   ELSE
     C                   EVAL      DASBCH = 'N'
     C                   ENDIF
 
      ** Check for the number of files in each batch
 
     C                   EVAL      DAERR = 'N'
     C                   EVAL      DABTCH = *Blanks
 
     C                   IF        DASBCH <> 'Y'
     C                   IF        WkCtr0 > 299 or WkCtr1 > 299 or
     C                             WkCtr2 > 299 or WkCtr3 > 299 or
     C                             WkCtr4 > 299 or WkCtr5 > 299 or
     C                             WkCtr6 > 299 or WkCtr7 > 299 or
     C                             WkCtr8 > 299 or WkCtr9 > 299
     C                   EVAL      DAERR = 'Y'
 
     C                   SELECT
     C                   WHEN      WkCtr0 > 299
     C                   EVAL      DABTCH = '0'
 
     C                   WHEN      WkCtr1 > 299
     C                   EVAL      DABTCH = '1'
 
     C                   WHEN      WkCtr2 > 299
     C                   EVAL      DABTCH = '2'
 
     C                   WHEN      WkCtr3 > 299
     C                   EVAL      DABTCH = '3'
 
     C                   WHEN      WkCtr4 > 299
     C                   EVAL      DABTCH = '4'
 
     C                   WHEN      WkCtr5 > 299
     C                   EVAL      DABTCH = '5'
 
     C                   WHEN      WkCtr6 > 299
     C                   EVAL      DABTCH = '6'
 
     C                   WHEN      WkCtr7 > 299
     C                   EVAL      DABTCH = '7'
 
     C                   WHEN      WkCtr8 > 299
     C                   EVAL      DABTCH = '8'
 
     C                   WHEN      WkCtr9 > 299
     C                   EVAL      DABTCH = '9'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   OUT       SCDRSTAT
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
