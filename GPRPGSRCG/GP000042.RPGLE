     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Account Transfer Conversion Utility')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000042 - Midas GP Account Transfer Conversion Utility      *
      *                                                               *
      *  Function:  This program will read GPSATPPD Selected Account  *
      *             Temporary File and apply account transfer to      *
      *             selected global files                             *
      *                                                               *
      *  Called By: GLC003700                                         *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR719317 *CREATE   Date 19Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR719317 - Include T_GZAMADEX in ATU processing              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *****************************************************************
 
     FGPSATPL0  IF   E           K DISK
 
      ** Array containing Copyright statement
 
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Data Area giving Installation Control Details
 
     D/COPY GPCPYSRCG,PSDS
 
      ** Program Status Data Structure
 
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D @RUN            S              1A
     D P@FRAC          S             24A
     D P@TOAC          S             24A
     D PZONE           S             10A
     D PRFNO           S             10A
     D I#ERMS          S             50A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C     KSATP         SETLL     GPSATPL0
     C     KSATP         READE     GPSATPL0
 
      ** Process all selected accounts
 
     C                   DOW       NOT %EOF(GPSATPL0)
 
     C                   EXSR      XMPROC
     C     KSATP         READE     GPSATPL0
 
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMPROC -   Process Global File                               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     GP000043                                          *
      *                                                               *
      *****************************************************************
 
     C     XMPROC        BEGSR
 
     C                   CALL      'GP000043'
     C                   PARM                    PZONE
     C                   PARM      GPRFNO        PRFNO
     C                   PARM      GPFRAC        P@FRAC
     C                   PARM      GPTOAC        P@TOAC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialise and define fields                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Receive Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PZone
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Key lists
 
     C     KSATP         KLIST
     C                   KFLD                    PZONE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
