     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Updates non-core switchable features file')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC0433 - Update Non-core switchable features                 *
      *                                                               *
      *  Function:  This program reads through switchable features    *
      *             file SCSARDPD to determine which features are     *
      *             non-core and updates the non-core features file.  *
      *                                                               *
      *  Called By: UTMENU                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC010  *CREATE    Date 10May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC010 - Switchable features enhancements.                   *
      *                                                               *
      *****************************************************************
      *
     F*SCSARDL0* IF   E           K DISK                                                    MD055681
      * Switchable features held on file
      *
     F*SCSARSL1* IF   E           K DISK                                                    MD055681
      * List of all core switchable features available
      *
     F*SCSARZL1* UF A E           K DISK                                                    MD055681
     F**********                           RENAME(SCSARSD0:SCSARZD0)                        MD055681
      * List of all non-core switchable features for this branch
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D WXFLRN          C                   CONST('ABSENG/DBAR4')
     D WXDOCN          C                   CONST('FEATURE.D02')
     D WXHELP          C                   CONST('NODETAIL')
      *
      ** Set up copyright parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    @RETRN            7
     C                   MOVEA     CPY@          MKI@             80
     C*
     C** Read next switchable feature on SARD
     C*
     C******LOVAL        SETLL     SCSARDL0                                                 MD055681
     C**********         READ      SCSARDL0                             8889                MD055681
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
                                                                                            MD055681
     C******IN88         IFEQ      *ON                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
     C                   EXSR      *PSSR
     C                   EXSR      EXIT
     C                   ENDIF
     C******IN89         DOWEQ     '0'                                                      MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
     C*
     C** Check if the feature is a core feature
     C*
     C*****ABSARN        CHAIN     SCSARSL1                           90                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :SARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C*
     C** If it is a core feature, read the next record on SARD
     C** If it is not on SARSL1, it is non-core, so prompt the
     C** user to enter details for that feature to update SARZ
     C*
     C******IN90         IFEQ      *ON                                                      MD055681
     C                   IF        SQLCODE = 100                                            MD055681
      *
     C** Check if there is already an entry on SARZ for this
      *
     C*****ABSARN        CHAIN     SCSARZL1                           91                    MD055681
      *
     C** If there is no entry already on SARZ, write
      *
     C******IN91         IFEQ      *ON                                                      MD055681
     C**********         MOVEL     ABSARN        AXSARN                                     MD055681
     C                   MOVEL     SARN          AXSARN                                     MD055681
     C**********         MOVEL     ABSARD        AXSARD                                     MD055681
     C                   MOVEL     SARD          AXSARD                                     MD055681
     C                   MOVEL     *BLANKS       AXPRIM
     C                   MOVEL     *BLANKS       AXCEMI
     C                   MOVEL     *BLANKS       AXRELL
     C                   MOVEL     *BLANKS       AXIREL
     C                   MOVEL     *BLANKS       AXCLVL
     C                   MOVEL     *BLANKS       AXRSTS
     C                   MOVEL     *BLANKS       AXDFLT
     C                   MOVEL     'B'           AXMNTB
     C                   MOVEL     *BLANKS       AXCHRG
     C                   MOVEL     WXFLRN        AXFLRN
     C                   MOVEL     WXDOCN        AXDOCN
     C                   MOVEL     WXHELP        AXHELP
     C                   CALL      'SC0434'
     C                   PARM                    WXRELL           10
     C                   PARM                    WXIREL            3
     C                   PARM                    PRTN              7
     C                   MOVEL     WXRELL        AXRELL
     C                   MOVEL     WXIREL        AXIREL
     C**********         WRITE     SCSARZD0                             73                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXSARD                                                                            MD055681
     C+ , AXPRIM                                                                            MD055681
     C+ , AXCEMI                                                                            MD055681
     C+ , AXRELL                                                                            MD055681
     C+ , AXIREL                                                                            MD055681
     C+ , AXCLVL                                                                            MD055681
     C+ , AXRSTS                                                                            MD055681
     C+ , AXDFLT                                                                            MD055681
     C+ , AXMNTB                                                                            MD055681
     C+ , AXCHRG                                                                            MD055681
     C+ , AXFLRN                                                                            MD055681
     C+ , AXDOCN                                                                            MD055681
     C+ , AXHELP                                                                            MD055681
     C+ , AXPROT                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , :AXSARD                                                                           MD055681
     C+ , :AXPRIM                                                                           MD055681
     C+ , :AXCEMI                                                                           MD055681
     C+ , :AXRELL                                                                           MD055681
     C+ , :AXIREL                                                                           MD055681
     C+ , :AXCLVL                                                                           MD055681
     C+ , :AXRSTS                                                                           MD055681
     C+ , :AXDFLT                                                                           MD055681
     C+ , :AXMNTB                                                                           MD055681
     C+ , :AXCHRG                                                                           MD055681
     C+ , :AXFLRN                                                                           MD055681
     C+ , :AXDOCN                                                                           MD055681
     C+ , :AXHELP                                                                           MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C**********         ENDIF                                                              MD055681
     C                   ENDIF
     C**********         READ      SCSARDL0                             8889                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN88         IFEQ      *ON                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
     C                             AND SQLCODE <> 100                                       MD055681
     C                   EXSR      *PSSR
     C                   EXSR      EXIT
     C                   ENDIF
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
     C                   EXSR      EXIT
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT   - Subroutine to END PROGRAM                           *
      *                                                               *
      *****************************************************************
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
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
