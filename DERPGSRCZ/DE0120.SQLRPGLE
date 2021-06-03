     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056612
/*STD *  RPGSQLBND                                                    *                     MD056612
/*EXI *  TEXT('Midas DE Default of next export date to run date')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export Module                                   *
      *                                                               *
      *  DE0120 - Default Next Export Date to Run Date                *
      *                                                               *
      *  Function:  This program is used to default Next Export Date  *
      *             field of PF/MXEXFDPD to Run Date of the current   *
      *             system.                                           *
      *                                                               *
      *  Called By: DEC0120 - Input Extract Control Information       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 01Jun01               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CDE002 - Date Export - CCRM Revenue Analysis                 *
      *                                                               *
      *****************************************************************
     F*MXEXFDL2* UF   E           K DISK    INFSR(*PSSR)                                    MD056612
      ** Midas MX Export Format Details
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D FMTARR          S             10    DIM(23) CTDATA PERRCD(1)
      ** Array containing format names
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short date structure
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D MXEXFD        E DS                  EXTNAME(MXEXDJW0)                                MD056612
     D   X_FMT         S             10A
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Initialise index value to 1
      *
     C                   Z-ADD     1             I                 4 0
      *
      ** Do this until all format names in the array have been chained
      *
     C     I             DOUGT     23
      *
      ** Chain LF/MXEXFDL2 using format stored in the array
      *
     C*****FMTARR(I)     CHAIN     MXEXFDL2                           99                    MD056612
     C                   eval      X_FMT = FMTARR(I)                                        MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :X_FMT                                                               MD056612
     C/END-EXEC                                                                             MD056612
      *
     C******IN99         IFEQ      *OFF                                                     MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
      *
      ** Default the field Next Export Date to the System's rundate
      *
     C                   MOVE      AGRDNB        EXEXND
      *
     C**********         UPDATE    MXEXFDP0                             81                  MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXEXDXTD set                                                                 MD056612
     C+   EXEXND = :EXEXND                                                                  MD056612
     C+ where EXFMT  = :X_FMT                                                               MD056612
     C/end-exec                                                                             MD056612
      *
     C******IN81         IFEQ      *ON                                                      MD056612
     C                   IF        SQLCODE <> 0                                             MD056612
     C                   MOVEL     'MXEXFDPD'    DBFILE
     C                   Z-ADD     02            DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             I
      *
     C                   ENDDO
      *
      *
      ** Return to the calling program
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     01            DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
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
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  FMTARR
MDEACEXPD
MDENEVNTPD
MDENPOSNPD
MDENTRANPD
MDETCASHPD
MDETEVNTPD
MDETPOSNPD
MDETTRANPD
MFDDTSTPD
MINVTPD
MSDACOFPD
MSDBANKPD
MSDBRCHPD
MSDCOMPPD
MSDCTRYPD
MSDCUHSPD
MSDCURRPD
MSDCUSTPD
MSDFACTPD
MSDFEEPD
MSDINDSPD
MSDINSTPD
MSDLOANPD
