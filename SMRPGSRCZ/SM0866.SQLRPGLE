     H DEBUG
      *****************************************************************
/******  OVRDBF FILE(REPT1) TOFILE(FCREPTL1)                          *                     MD055265
/******  OVRDBF FILE(REPT2) TOFILE(FCREPTL1)                          *                     MD055265
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas SM Update output ins. on new FCREPTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM0866 - Update output ID on new FCREPTPD                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP016 *CREATE     Date 01Apr03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain - record not found
      *       69      Read, write or chain fail
      *
      *****************************************************************
     F*REPT1**** IF   E             DISK    INFSR(*PSSR)                                    MD055265
     F*REPT2**** UF   E           K DISK    INFSR(*PSSR)                                    MD055265
     F**********                           RENAME(@DXREIK:REPTF)                            MD055265
      *
      /EJECT
      * Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SQLDynStmt      S           5000A                                                    MD055265
      * Fields with the same name will need to be renamed.
     I*REPTF****                                                                            MD055265
     I**********    DXRNAM                      RNAM                                        MD055265
     I**********    DXLCD                       LCD                                         MD055265
     I**********    DXCHTP                      CHTP                                        MD055265
     I**********    DXCMOD                      CMOD                                        MD055265
     I**********    DXRDSC                      RDSC                                        MD055265
     I**********    DXGLVL                      GLVL                                        MD055265
     I**********    DXCLVL                      CLVL                                        MD055265
     I**********    DXBLVL                      BLVL                                        MD055265
     I**********    DXIPCY                      IPCY                                        MD055265
     I**********    DXCLBP                      CLBP                                        MD055265
     I**********    DXPDFL                      PDFL                                        MD055265
     I**********    DXDFTO                      DFTO                                        MD055265
     I**********    DXMIDQ                      MIDQ                                        MD055265
     I**********    DXALVL                      ALVL                                        MD055265
     I**********    DXDLVL                      DLVL                                        MD055265
      *
      * Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
     C*****COMP          KLIST                                                              MD055265
     C*********          KFLD                    DXRNAM                                     MD055265
      *
     C**********         READ      REPT1                                6920                MD055265
     C******IN69         IFEQ      *ON                                                      MD055265
     C**********         EXSR      *PSSR                                                    MD055265
     C**********         ENDIF                                                              MD055265
      **********                                                                            MD055265
     C******IN20         DOWEQ     '0'                                                      MD055265
     C*****COMP*         CHAIN     REPTF                              3069                  MD055265
     C******IN69         IFEQ      *ON                                                      MD055265
     C**********         EXSR      *PSSR                                                    MD055265
     C**********         ENDIF                                                              MD055265
      **********                                                                            MD055265
      **If*record not found then ignore otherwise update                                    MD055265
      **Default*Output ID field.                                                            MD055265
     C******IN30         IFEQ      *OFF                                                     MD055265
     C**********         MOVE      DXDFTO        DFTO                                       MD055265
     C**********         UPDATE    REPTF                                69                  MD055265
     C******IN69         IFEQ      *ON                                                      MD055265
     C**********         EXSR      *PSSR                                                    MD055265
     C**********         ENDIF                                                              MD055265
     C**********         ENDIF                                                              MD055265
      **********                                                                            MD055265
      **Read*next record                                                                    MD055265
     C**********         READ      REPT1                                6920                MD055265
     C******IN69         IFEQ      *ON                                                      MD055265
     C**********         EXSR      *PSSR                                                    MD055265
     C**********         ENDIF                                                              MD055265
      **********                                                                            MD055265
     C**********         ENDDO                                                              MD055265
      **********                                                                            MD055265
     C*****ENDPGM        TAG                                                                MD055265
                                                                                            MD055265
     C     *ENTRY        PLIST                                                              MD055265
     C                   PARM                    OldLib           10                        MD055265
     C                   PARM                    NewLib           10                        MD055265
                                                                                            MD055265
     C                   eval      SQLDynStmt = 'update ' + %trimr(NewLib) +                MD055265
     C                             '/FCREPXTD' +                                            MD055265
     C                             ' B set (B.DXDFTO) = (select A.DXDFTO' +                 MD055265
     C                             ' from ' + %trimr(OldLib) +                              MD055265
     C                             '/FCREPTPD A where A.DXRNAM = B.DXRNAM)' +               MD055265
     C                             ' where  exists (select * from ' +                       MD055265
     C                              %trimr(OldLib) +                                        MD055265
     C                             '/FCREPTPD A where A.DXRNAM = B.DXRNAM)'                 MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ prepare DynSQLStmnt                                                                 MD055265
     C+ from :SQLDynStmt                                                                    MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/exec SQL                                                                             MD055265
     C+ execute DynSQLStmnt                                                                 MD055265
     C/end-exec                                                                             MD055265
                                                                                            MD055265
     C                   If        SQLCode <> 0                                             MD055265
     C                             and SQLCode <> 100                                       MD055265
     C                   exsr      *PSSR                                                    MD055265
     C                   Endif                                                              MD055265
                                                                                            MD055265
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
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
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
