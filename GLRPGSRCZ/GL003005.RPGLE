     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*S*D ***RPGBASEBNC****************************************************                     BUG27914
/*STD *  RPGBASEBNC                                                   *            BUG27914 BUG28163
/*EXI *  TEXT('Midas GL CLEARPD Replication Program')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003005 - Midas CLEARPD Replication Program                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG28163           Date 05Oct10               *
      *                 BUG27914           Date 09Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP203  *CREATE    Date 02Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG28163 - Forward movements does not appear on PABE         *
      *             (Recompile due to GPCLEARPD reinstatement)        *
      *  BUG27914 - RAME Design Changes                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDBRCHL1  IF   E           K DISK
     FCLEAR1    IF   E           K DISK
     F                                     RENAME(APOSTPDF:CLEAR1DF)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure for Midas GL Items in Clearing Detail file
     D CLEAR         E DS                  EXTNAME(CLEARPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D MODE            S              1A
     D BRCH            S              3A
     D WRUN            S              1A
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1
     C                   DOW       NOT %EOF(SDBRCHL1)
      *
      ** Delete all records in global file whose branch code
      ** is equal to the current branch code
      *
     C                   CALL      'GP003005'
     C                   PARM      'D'           MODE
     C                   PARM      A8BRCD        BRCH
     C                   PARM      *BLANKS       CLEAR
      *
      ** Read through zone file CLEARPD whose branch code
      ** is equal to the current branch code
      *
     C     BRCH          SETLL     CLEAR1DF
     C     BRCH          READE     CLEAR1DF
     C                   DOW       NOT %EOF(CLEAR1)
 
     C                   CALL      'GP003005'
     C                   PARM      'I'           MODE
     C                   PARM      A8BRCD        BRCH
     C                   PARM                    CLEAR
 
     C                   MOVEL     *BLANKS       CLEAR
     C     BRCH          READE     CLEAR1DF
     C                   ENDDO
 
     C                   READ      SDBRCHL1
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
