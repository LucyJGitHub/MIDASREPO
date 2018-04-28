     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CGL132')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000151 - Midas SD Initialisation program for CGL132        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** Midas SD Country Codes File
     FSDCTRYPD  UF   E             DISK    INFSR(*PSSR)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** For Mode 1 and 2 - default FATCA Agreement Type to blank and
      ** FATCA Indicia to 'N' in the country codes file
      ** Otherwise blank out FATCA fields in the country codes file if
      ** CGL132 is switched off
 
     C                   READ      SDCTRYPD
     C                   DOW       NOT %EOF(SDCTRYPD)
 
     C                   IF        Mode = '1' OR Mode = '2'
     C                   EVAL      A4FAAT = 'UKN'
     C                   EVAL      A4FAIN = 'N'
     C                   ELSE
     C                   EVAL      A4FAAT = ' '
     C                   EVAL      A4FAIN = ' '
     C                   ENDIF
 
     C                   UPDATE    SDCTRYD0
     C                   READ      SDCTRYPD
     C                   ENDDO
 
     C                   SETON                                        LR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode        7
     C                   PARM                    Mode              1
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
