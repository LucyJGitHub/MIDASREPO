     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Load Retail Inter Scale Qualifying Acct cods')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  CG7190 - Load Retail Interest Scale Qualifying Account       *
      *           Codes From Midas Account Codes File                 *
      *                                                               *
      *  Called By: CGC7190                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  80 - CHAIN/ End of file                                      *
      *  81 - SETLL                                                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Midas Account Codes File
     FSDACODPD  IF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
      ** Interest Scale Retail Qualifying Account Codes
     FCGISRQL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CGISRQD0:ZRQPL0)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Working variables
     D WSRUN           S              1A
     D WSCRTR          S              3A
 
      ** Copyright statement array
     D CPY             S             80    DIM(1) CTDATA PERRCD(1)
      ** Midas Account Codes INFDS
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
 
      ** Database error details DA
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Installation control details DS
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      *****************************************************************
      *                                                               *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls:                                                        *
      * CRTRE  - Create Retail Account Code Record                    *
      *                                                               *
      *****************************************************************
 
      ** Read first midas account code record
     C                   READ      SDACODPD                               80
 
     C     *IN80         DOWEQ     *OFF
      ** If retail account type & account code NOT blank
     C     A5ACTY        IFEQ      'R'
     C     A5ACCD        ANDNE     *BLANK
 
      ** Create retail account code record
     C                   EXSR      CRTRE
     C                   ENDIF
 
      ** Read next midas account code record
     C                   READ      SDACODPD                               80
     C                   ENDDO
 
      ** Record/s created
     C     WSCRTR        IFEQ      'YES'
     C                   COMMIT
     C                   ENDIF
 
      ** Terminate function
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CRTRE  - Create Retail Account Code Record                    *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     CRTRE         BEGSR
 
     C                   MOVE      A5ACCD        Z6ACOD
     C                   MOVE      *BLANKS       Z6DLTP
     C                   MOVE      *BLANKS       Z6DLST
     C                   MOVE      *BLANKS       Z6CLAS
 
      ** Check to see if record already exists
     C     Z6ACOD        SETLL     ZRQPL0                                 81
 
      ** Create record
     C     *IN81         IFEQ      *OFF
     C                   Z-ADD     AGRDNB        Z6LCDT
     C                   MOVE      'I'           Z6LCTP
     C                   WRITE     ZRQPL0
      ** Record/s created flag
     C                   MOVE      'YES'         WSCRTR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - First Time In Processing                             *
      *                                                               *
      * Called by:                                                    *
      * Automatically                                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     CPY           CPY2             80
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      ** Record/s created flag
     C                   MOVE      'NO '         WSCRTR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - File exception/ error subroutine                     *
      *                                                               *
      * Called by:                                                    *
      * Automatically                                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
     C     WSRUN         IFEQ      *BLANK
     C                   MOVE      'Y'           WSRUN
 
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   ENDIF
 
      ** If *PSSR already run, then end the program here
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CPY
(c) Misys International Banking Systems Ltd. 2011
