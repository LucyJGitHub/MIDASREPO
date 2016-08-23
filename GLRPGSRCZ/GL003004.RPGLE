     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL RSACMTPD Replication Program')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003004 - Midas RSACMTPD Replication Program                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP203  *CREATE    Date 02Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDBRCHL1  IF   E           K DISK
     FRSACMTL3  IF   E           K DISK
 
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
 
      ** Data structure for Midas GL Account movements
     D RSACMT        E DS                  EXTNAME(RSACMTPD)
 
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
     C                   CALL      'GP003004'
     C                   PARM      'D'           MODE
     C                   PARM      A8BRCD        BRCH
     C                   PARM      *BLANKS       RSACMT
      *
      ** Read through zone file RSACMTPD whose branch code
      ** is equal to the current branch code
      *
     C     BRCH          SETLL     RSACMTL3
     C     BRCH          READE     RSACMTL3
     C                   DOW       NOT %EOF(RSACMTL3)
 
     C                   CALL      'GP003004'
     C                   PARM      'I'           MODE
     C                   PARM      A8BRCD        BRCH
     C                   PARM                    RSACMT
 
     C                   MOVEL     *BLANKS       RSACMT
     C     BRCH          READE     RSACMTL3
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
