     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Initialise non-core SAR password files')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  SC1200 - Initialise/update switchable features password file *
      *           for non-core features.                              *
      *                                                               *
      *  Function:  This program is called once the 'Passwd'          *
      *             switchable feature has been switched on.          *
      *             All-none core features at this point must have    *
      *             passwords, and further details regarding the      *
      *             features must be entered. If the details are      *
      *             entered correctly the switchable features will    *
      *             remain active in the password enabled version of  *
      *             the system.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054346           Date 18Jul21               *
      *  Prev Amend No. MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 171530  *CREATE    Date 13Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC007  *CREATE    Date 08May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054346 - Switchable Features Password Encryption           *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  171530 - SCSAUDPD made redundant                             *
      *  CSC007 - Switchable Features Enhancements phase 2.           *
      *           Amendments to Switchable Features suite of          *
      *           programs to allow switching on via passwords.       *
      *           New code to coincide with these amendments are      *
      *           under CSC005.                                       *
      *           Recompiled over changed SCSARSL1.                   *
      *****************************************************************
     F*SCSARDPD* IF   E             DISK    INFSR(*PSSR)                                    MD055681
     F*SCSARSL1* IF   E           K DISK    INFSR(*PSSR)                         CSC007     MD055681
     F*SCPASSPD* UF A E           K DISK    INFSR(*PSSR)                                    MD054346
     F******SCSAUDPDO   E           K        DISK         KINFSR *PSSR                        171530
      /EJECT
      *
      ** Table containing switchable features and passwords
      *
     D************        TABSAR  1 170  6   TABPAS 16                    CSC007
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Program Date and Time Data Structure
      *
     D                 DS
     D  TMSTMP                 1     12  0
     D  AUTIME                 1      6  0
     D  DATE                   7     12  0
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*                                                                   S01486
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     I* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
      *
     D PReturnCode     S              7A                                                    MD054346
     D PAction         S              1A                                                    MD054346
     D PValidList      S             10A   INZ('SCFEATVL')                                  MD054346
     D PLibrary        S             10A                                                    MD054346
     D PIDName         S            100A                                                    MD054346
     D PPass1          S            600A                                                    MD054346
     D PPass2          S            600A                                                    MD054346
     D PDescr          S           1000A                                                    MD054346
      * Action codes.                                                                       MD054346
     D Insert          C                   CONST('A')                                       MD054346
     D Modify          C                   CONST('M')                                       MD054346
     D Reset           C                   CONST('R')                                       MD054346
     D Delete          C                   CONST('D')                                       MD054346
     D Find            C                   CONST('F')                                       MD054346
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      EXIT
      *
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *
      ** Read first record of switchable features client already has
      ** switched on.
      *
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Set up date and time for audit file
      *
     C                   TIME                    TMSTMP
      *
      **  Call Access Program for Bank Details - Title, Run Date and
      **  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C**********         READ      SCSARDPD                               89                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare ACursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRDJW0                                                              MD055681
     C+ order by SARN                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open ACursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
      *
      ** Move Midas date into AUDAT, and SAR number into AUSARN so they
      ** will be written to audit file.
      *
     C******               MOVE BJMRDT    AUDAT                                               171530
     C******               MOVE SARN      AUSARN  6                                           171530
     C                   ENDSR
      *
     C     PROCES        BEGSR
     C******IN89         DOWEQ     *OFF                                                     MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
     C******     SARN      LOKUPTABSAR    TABPAS         25               CSC007
     C******     *IN25     IFEQ *OFF                                      CSC007
     C*****SARN*         CHAIN     SCSARSL1                           25              CSC00 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :SARN and AXMODE = 'C'                                               MD055681
     C/END-EXEC                                                                             MD055681
     C******IN25         IFEQ      *ON                                                CSC00 MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C*****SARN          CHAIN     SCPASSPD                           74                    MD054346
     C                   CALL      'UT000033'                                               MD054346
     C                   PARM      *Blanks       PReturnCode                                MD054346
     C                   PARM      Find          PAction                                    MD054346
     C                   PARM                    PValidList                                 MD054346
     C                   PARM                    PLibrary                                   MD054346
     C                   PARM      SARN          PIDName                                    MD054346
     C                   PARM      *Blanks       PPass1                                     MD054346
     C                   PARM      *Blanks       PPass2                                     MD054346
     C                   PARM      *Blanks       PDescr                                     MD054346
                                                                                            MD054346
      *
      ** Check to see if an entry already exists on password file -
      ** ie user may have run this program once, terminated it and
      ** already entered some details on the password file.
      *
     C******IN74         IFEQ      *ON                                                      MD054346
     C     PReturnCode   IFNE      *Blanks                                                  MD054346
      *
      ** Call command SCCRTKEYB via CL program to update and allow
      ** use of passwords.
      *
     C                   CALL      'SCC4200'
     C                   PARM                    SARN
     C                   PARM                    SARD
     C**********         PARM                    PASS                                       MD054346
     C                   PARM                    PASS             16                        MD054346
     C                   PARM                    RTNCDE            7
      *
      ** F3 pressed - exit program.
      *
     C     RTNCDE        IFEQ      'F3'
     C                   EXSR      EXIT
     C                   ENDIF
      *
      ** Write to the password file.
      *
     C     RTNCDE        IFEQ      *BLANKS
     C**********         MOVE      SARN          P@SARN                                     MD054346
     C******IN74         IFEQ      *OFF                                                     MD054346
     C**********         UPDATE    SCPASSD0                                                 MD054346
     C**********         ELSE                                                               MD054346
     C**********         WRITE     SCPASSD0                                                 MD054346
     C**********         ENDIF                                                              MD054346
     C                   CALL      'UT000033'                                               MD054346
     C                   PARM      *Blanks       PReturnCode                                MD054346
     C                   PARM      Insert        PAction                                    MD054346
     C                   PARM                    PValidList                                 MD054346
     C                   PARM                    PLibrary                                   MD054346
     C                   PARM      SARN          PIDName                                    MD054346
     C                   PARM      PASS          PPass1                                     MD054346
     C                   PARM      PASS          PPass2                                     MD054346
     C                   PARM      *Blanks       PDescr                                     MD054346
                                                                                            MD054346
      *
      ** Write the event to the audit report.
      *
     C******               MOVE SARN      AUSARN                                              171530
     C******               MOVE 'Y'       AUECOD                                              171530
     C******               WRITESCSAUDD0                                                      171530
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C**********         READ      SCSARDPD                               89                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDDO
     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDSR
      *
      * Exit the program - password file has been updated.
     C     EXIT          BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
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
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALL      'DBERRCTL'
      *
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
