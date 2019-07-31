     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Overridable Error Message Configuration')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  GPAOOVCFR0 - Midas GP Overridable Error Message Config       *
      *                                                               *
      *  Function:  This program will retrieve the details of an      *
      *             Overridable Error Message                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27776           Date 10Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27299 *CREATE   Date 19Apr10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27776 - Missing Overridable Errors for RATM and RABC      *
      *  BUG27299 - Account is not in transaction branch should not   *
      *             be in the failed account transfers list           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR    - Error processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPOVCFL0  IF   E           K DISK
      ** Midas GP Bank Details ICD
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D***/COPY*ZACPYSRC,PSDS                                                                BUG27776
     D/COPY GPCPYSRCG,PSDS                                                                  BUG27776
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D O#MSGD          S             10A   DIM(100)
     D O#ERCL          S              1A   DIM(100)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D I#API           S              4A
     D WIndx           S              3S 0
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
 
      ** Access the overridable messages file
 
     C     I#API         SETLL     GPOVCFL0
     C     I#API         READE     GPOVCFL0
 
      ** Retrieve all records pertaining to the API Name
 
     C                   DOW       NOT(%EOF(GPOVCFL0))
     C                   EVAL      WIndx = WIndx + 1
     C                   EVAL      O#MSGD(WIndx) = A2MSGD
     C                   EVAL      O#ERCL(WIndx) = A2CLAS
     C     I#API         READE     GPOVCFL0
     C                   ENDDO
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR --- INITIAL PROCESSING                                 *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input
 
     C                   PARM                    I#API
 
      ** Output
     C                   PARM                    O#MSGD
     C                   PARM                    O#ERCL
 
     C                   CLEAR                   O#MSGD
     C                   CLEAR                   O#ERCL
     C                   EVAL      WIndx = 0
 
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
