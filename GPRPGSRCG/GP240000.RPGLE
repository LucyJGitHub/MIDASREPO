     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Retail Acct Balance Extract Housekeep')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP240000 - Retail Acct Balance Extract Housekeep             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR1067119          Date 11Dec12               *
      *  Prev Amend No. BUG27878           Date 06Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27288 *CREATE   Date 07Apr10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1067119 - REC240000 Component in MSGW status               *
      *  BUG27878 - Projected Available Balance Enquiry(recompile)    *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInit - Program Initialisation                              *
      *  SRProcess - Detail Processing                                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
 
      ** Midas GP Retail Account Balance Extract File
 
     F***GPRABEL1  UF   E           K DISK    INFSR(*PSSR) COMMIT                          AR1067119
     FGPRABEL1  UF   E           K DISK    INFSR(*PSSR)                                    AR1067119
 
     D LDA           E DS           256    EXTNAME(LDA)
     D                                     DTAARA(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      ** Entry Parameters
 
     D PRtcd           S              7A
     D PZone           S             10A
 
      ** Work fields
 
     D WRun            S              1A   INZ(' ')
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T
      *================================================================
 
      ** Read first record from File
 
     C                   READ      GPRABEL1
 
     C                   DOW       NOT %EOF(GPRABEL1)
 
     C                   IF        ABZONE = Pzone
     C                   DELETE    GPRABED0
     C                   ENDIF
     C                   READ      GPRABEL1
 
     C                   ENDDO
 
     C**********         COMMIT                                                            AR1067119
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *================================================================
      *  P R O G R A M   E N D
      *================================================================
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PZone
 
      ** Initialise LDA field
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 0
     C                   EVAL      DBPGM = 'GP240000'
     C                   OUT       LDA
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
 
     C                   EVAL      PRtcd = 'ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   ROLBK
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
