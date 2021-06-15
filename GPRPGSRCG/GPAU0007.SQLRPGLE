     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD056611
/*STD *  RPGSQLMOD                                                    *                     MD056611
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056611
/*EXI *  TEXT('Midas GP Update Audit File Data')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0007 - Update Audit File Data                            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD056611           Date 20Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056611 - Deliverable Data Split for Audit Reporting        *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************

     FGPAUFLPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(F)                                        MD056611
     F*GPAUFLL0* UF A E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAUFLD0:GPAUFLDX)                        MD056611
     FGPAUFDPD  IF   E             DISK    INFSR(*PSSR)
     F*GPAUFDL0* UF A E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAUFDD0:GPAUFDDX)                        MD056611
     FGPAURNPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R)                                        MD056611
     F*GPAURNL0* UF A E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAURND0:GPAURNDX)                        MD056611
     FGPAUASPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(A)                                        MD056611
     F*GPAUASL0* UF A E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAUASD0:GPAUASDX)                        MD056611

     D #_DTC           S              1    DIM(30)
     D #_VCH           S              1    DIM(80) CTDATA PERRCD(80)

     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
     D DSAUFL        E DS                  EXTNAME(GPAUFLPD)                                MD056611
     D                                     PREFIX(F)                                        MD056611
     D DSAURN        E DS                  EXTNAME(GPAURNPD)                                MD056611
     D                                     PREFIX(R)                                        MD056611
     D DSAUAS        E DS                  EXTNAME(GPAUASPD)                                MD056611
     D                                     PREFIX(A)                                        MD056611
     D DSAUFD        E DS                  EXTNAME(GPAUFDPD)                                MD056611
     D TotRow          S              3  0                                                  MD056611
     D FAFMODE         S              1                                                     MD056611
     D RAFMODE         S              1                                                     MD056611
     D AAFMODE         S              1                                                     MD056611
     D DAFMODE         S              1                                                     MD056611

     C     *ENTRY        PLIST
     C**********         PARM                    AFFILE           10                        MD056611
     C**********         PARM                    AFRCID           15                        MD056611
     C                   PARM                    P_FILE           10                        MD056611
     C                   PARM                    P_RCID           15                        MD056611

     C                   eval      AFFILE = P_FILE                                          MD056611
     C                   eval      AFRCID = P_RCID                                          MD056611
                                                                                            MD056611
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID

     C                   EXSR      AUFL
     C                   EXSR      AUFD
     C                   EXSR      AURN
     C                   EXSR      AUAS
     C                   SETON                                        LR

      /SPACE 5
      *****************************************************************
      * Copy data to GPAUFLPD
      *****************************************************************
     C     AUFL          BEGSR

     C* FIRST DELETE EXISTING RECORDS FOR FILE

      * Check if record is a core one                                                       MD056611
     C/EXEC SQL                                                                             MD056611
     C+ declare CoreCursor insensitive scroll cursor for                                    MD056611
     C+ select * from GPAUFCTD                                                              MD056611
     C+ where AFFILE = :AFFILE and AFRCID = :AFRCID                                         MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ open CoreCursor                                                                     MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ get diagnostics :TotRow = DB2_NUMBER_ROWS                                           MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ close CoreCursor                                                                    MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C*****GPAUFLK       SETLL     GPAUFLDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUFLDX                               90    *           MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C**********         DELETE    GPAUFLDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUFLDX                               90    *           MD056611
     C**********         END                                                                MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUFCTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUFBTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUFXTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611

     C* WRITE NEW RECORDS FOR FILE

     C                   READ      GPAUFLD0                               90    *
     C     *IN90         DOWEQ     '0'
     C**********         WRITE     GPAUFLDX                                                 MD056611
     C                   IF        TotRow > 0                                               MD056611
     C                   eval      FAFMODE = 'C'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUFCTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFDESC                                                                            MD056611
     C+  ,AFINPT                                                                            MD056611
     C+  ,AFRIFD                                                                            MD056611
     C+  ,AFRIOB                                                                            MD056611
     C+  ,AFRILN                                                                            MD056611
     C+  ,AFUSRI                                                                            MD056611
     C+  ,AFLAYO                                                                            MD056611
     C+  ,AFFDSP                                                                            MD056611
     C+  ,AFAUTH                                                                            MD056611
     C+  ,AFACTV                                                                            MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :FAFFILE                                                                          MD056611
     C+  ,:FAFRCID                                                                          MD056611
     C+  ,:FAFDESC                                                                          MD056611
     C+  ,:FAFINPT                                                                          MD056611
     C+  ,:FAFRIFD                                                                          MD056611
     C+  ,:FAFRIOB                                                                          MD056611
     C+  ,:FAFRILN                                                                          MD056611
     C+  ,:FAFUSRI                                                                          MD056611
     C+  ,:FAFLAYO                                                                          MD056611
     C+  ,:FAFFDSP                                                                          MD056611
     C+  ,:FAFAUTH                                                                          MD056611
     C+  ,:FAFACTV                                                                          MD056611
     C+  ,'C'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   else                                                               MD056611
     C                   eval      FAFMODE = 'B'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUFBTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFDESC                                                                            MD056611
     C+  ,AFINPT                                                                            MD056611
     C+  ,AFRIFD                                                                            MD056611
     C+  ,AFRIOB                                                                            MD056611
     C+  ,AFRILN                                                                            MD056611
     C+  ,AFUSRI                                                                            MD056611
     C+  ,AFLAYO                                                                            MD056611
     C+  ,AFFDSP                                                                            MD056611
     C+  ,AFAUTH                                                                            MD056611
     C+  ,AFACTV                                                                            MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :FAFFILE                                                                          MD056611
     C+  ,:FAFRCID                                                                          MD056611
     C+  ,:FAFDESC                                                                          MD056611
     C+  ,:FAFINPT                                                                          MD056611
     C+  ,:FAFRIFD                                                                          MD056611
     C+  ,:FAFRIOB                                                                          MD056611
     C+  ,:FAFRILN                                                                          MD056611
     C+  ,:FAFUSRI                                                                          MD056611
     C+  ,:FAFLAYO                                                                          MD056611
     C+  ,:FAFFDSP                                                                          MD056611
     C+  ,:FAFAUTH                                                                          MD056611
     C+  ,:FAFACTV                                                                          MD056611
     C+  ,'B'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   ENDIF                                                              MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUFXTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFDESC                                                                            MD056611
     C+  ,AFINPT                                                                            MD056611
     C+  ,AFRIFD                                                                            MD056611
     C+  ,AFRIOB                                                                            MD056611
     C+  ,AFRILN                                                                            MD056611
     C+  ,AFUSRI                                                                            MD056611
     C+  ,AFLAYO                                                                            MD056611
     C+  ,AFFDSP                                                                            MD056611
     C+  ,AFAUTH                                                                            MD056611
     C+  ,AFACTV                                                                            MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :FAFFILE                                                                          MD056611
     C+  ,:FAFRCID                                                                          MD056611
     C+  ,:FAFDESC                                                                          MD056611
     C+  ,:FAFINPT                                                                          MD056611
     C+  ,:FAFRIFD                                                                          MD056611
     C+  ,:FAFRIOB                                                                          MD056611
     C+  ,:FAFRILN                                                                          MD056611
     C+  ,:FAFUSRI                                                                          MD056611
     C+  ,:FAFLAYO                                                                          MD056611
     C+  ,:FAFFDSP                                                                          MD056611
     C+  ,:FAFAUTH                                                                          MD056611
     C+  ,:FAFACTV                                                                          MD056611
     C+  ,:FAFMODE                                                                          MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   READ      GPAUFLD0                               90    *
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Copy data to GPAUFDPD
      *****************************************************************
     C     AUFD          BEGSR

     C* FIRST DELETE EXISTING RECORDS FOR FILE

     C*****GPAUFLK       SETLL     GPAUFDDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUFDDX                               90    *           MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C**********         DELETE    GPAUFDDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUFDDX                               90    *           MD056611
     C**********         END                                                                MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUDCTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUDBTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUDXTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611

     C* WRITE NEW RECORDS FOR FILE

     C                   READ      GPAUFDD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   EXSR      VALFLD

     C                   SELECT
     C     AFLN          WHENNE    *ZERO
     C     AFLN          MULT      132           AFRSEQ
     C                   ADD       AFPS          AFRSEQ
     C                   Z-ADD     AFRSEQ        AFWSEQ
     C     AFRSEQ        WHENNE    99999
     C     90000         ADD       AFFLDN        AFRSEQ
     C                   Z-ADD     AFRSEQ        AFWSEQ
     C     AFWSEQ        WHENNE    99999
     C     90000         ADD       AFFLDN        AFWSEQ
     C                   ENDSL

     C**********         WRITE     GPAUFDDX                                                 MD056611
     C                   IF        TotRow > 0                                               MD056611
     C                   eval      DAFMODE = 'C'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUDCTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFRPGN                                                                            MD056611
     C+  ,AFSNAM                                                                            MD056611
     C+  ,AFFLDN                                                                            MD056611
     C+  ,AFFOBO                                                                            MD056611
     C+  ,AFTYPE                                                                            MD056611
     C+  ,AFLEN                                                                             MD056611
     C+  ,AFDIG                                                                             MD056611
     C+  ,AFDEC                                                                             MD056611
     C+  ,AFFDES                                                                            MD056611
     C+  ,AFCOL1                                                                            MD056611
     C+  ,AFCOL2                                                                            MD056611
     C+  ,AFCOL3                                                                            MD056611
     C+  ,AFEDTW                                                                            MD056611
     C+  ,AFEDTS                                                                            MD056611
     C+  ,AFREFF                                                                            MD056611
     C+  ,AFBRCF                                                                            MD056611
     C+  ,AFWSEQ                                                                            MD056611
     C+  ,AFRSEQ                                                                            MD056611
     C+  ,AFSPCB                                                                            MD056611
     C+  ,AFLN                                                                              MD056611
     C+  ,AFPS                                                                              MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :AFFILE                                                                           MD056611
     C+  ,:AFRCID                                                                           MD056611
     C+  ,:AFRPGN                                                                           MD056611
     C+  ,:AFSNAM                                                                           MD056611
     C+  ,:AFFLDN                                                                           MD056611
     C+  ,:AFFOBO                                                                           MD056611
     C+  ,:AFTYPE                                                                           MD056611
     C+  ,:AFLEN                                                                            MD056611
     C+  ,:AFDIG                                                                            MD056611
     C+  ,:AFDEC                                                                            MD056611
     C+  ,:AFFDES                                                                           MD056611
     C+  ,:AFCOL1                                                                           MD056611
     C+  ,:AFCOL2                                                                           MD056611
     C+  ,:AFCOL3                                                                           MD056611
     C+  ,:AFEDTW                                                                           MD056611
     C+  ,:AFEDTS                                                                           MD056611
     C+  ,:AFREFF                                                                           MD056611
     C+  ,:AFBRCF                                                                           MD056611
     C+  ,:AFWSEQ                                                                           MD056611
     C+  ,:AFRSEQ                                                                           MD056611
     C+  ,:AFSPCB                                                                           MD056611
     C+  ,:AFLN                                                                             MD056611
     C+  ,:AFPS                                                                             MD056611
     C+  ,'C'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   else                                                               MD056611
     C                   eval      DAFMODE = 'B'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUDBTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFRPGN                                                                            MD056611
     C+  ,AFSNAM                                                                            MD056611
     C+  ,AFFLDN                                                                            MD056611
     C+  ,AFFOBO                                                                            MD056611
     C+  ,AFTYPE                                                                            MD056611
     C+  ,AFLEN                                                                             MD056611
     C+  ,AFDIG                                                                             MD056611
     C+  ,AFDEC                                                                             MD056611
     C+  ,AFFDES                                                                            MD056611
     C+  ,AFCOL1                                                                            MD056611
     C+  ,AFCOL2                                                                            MD056611
     C+  ,AFCOL3                                                                            MD056611
     C+  ,AFEDTW                                                                            MD056611
     C+  ,AFEDTS                                                                            MD056611
     C+  ,AFREFF                                                                            MD056611
     C+  ,AFBRCF                                                                            MD056611
     C+  ,AFWSEQ                                                                            MD056611
     C+  ,AFRSEQ                                                                            MD056611
     C+  ,AFSPCB                                                                            MD056611
     C+  ,AFLN                                                                              MD056611
     C+  ,AFPS                                                                              MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :AFFILE                                                                           MD056611
     C+  ,:AFRCID                                                                           MD056611
     C+  ,:AFRPGN                                                                           MD056611
     C+  ,:AFSNAM                                                                           MD056611
     C+  ,:AFFLDN                                                                           MD056611
     C+  ,:AFFOBO                                                                           MD056611
     C+  ,:AFTYPE                                                                           MD056611
     C+  ,:AFLEN                                                                            MD056611
     C+  ,:AFDIG                                                                            MD056611
     C+  ,:AFDEC                                                                            MD056611
     C+  ,:AFFDES                                                                           MD056611
     C+  ,:AFCOL1                                                                           MD056611
     C+  ,:AFCOL2                                                                           MD056611
     C+  ,:AFCOL3                                                                           MD056611
     C+  ,:AFEDTW                                                                           MD056611
     C+  ,:AFEDTS                                                                           MD056611
     C+  ,:AFREFF                                                                           MD056611
     C+  ,:AFBRCF                                                                           MD056611
     C+  ,:AFWSEQ                                                                           MD056611
     C+  ,:AFRSEQ                                                                           MD056611
     C+  ,:AFSPCB                                                                           MD056611
     C+  ,:AFLN                                                                             MD056611
     C+  ,:AFPS                                                                             MD056611
     C+  ,'B'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   ENDIF                                                              MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUDXTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFRPGN                                                                            MD056611
     C+  ,AFSNAM                                                                            MD056611
     C+  ,AFFLDN                                                                            MD056611
     C+  ,AFFOBO                                                                            MD056611
     C+  ,AFTYPE                                                                            MD056611
     C+  ,AFLEN                                                                             MD056611
     C+  ,AFDIG                                                                             MD056611
     C+  ,AFDEC                                                                             MD056611
     C+  ,AFFDES                                                                            MD056611
     C+  ,AFCOL1                                                                            MD056611
     C+  ,AFCOL2                                                                            MD056611
     C+  ,AFCOL3                                                                            MD056611
     C+  ,AFEDTW                                                                            MD056611
     C+  ,AFEDTS                                                                            MD056611
     C+  ,AFREFF                                                                            MD056611
     C+  ,AFBRCF                                                                            MD056611
     C+  ,AFWSEQ                                                                            MD056611
     C+  ,AFRSEQ                                                                            MD056611
     C+  ,AFSPCB                                                                            MD056611
     C+  ,AFLN                                                                              MD056611
     C+  ,AFPS                                                                              MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :AFFILE                                                                           MD056611
     C+  ,:AFRCID                                                                           MD056611
     C+  ,:AFRPGN                                                                           MD056611
     C+  ,:AFSNAM                                                                           MD056611
     C+  ,:AFFLDN                                                                           MD056611
     C+  ,:AFFOBO                                                                           MD056611
     C+  ,:AFTYPE                                                                           MD056611
     C+  ,:AFLEN                                                                            MD056611
     C+  ,:AFDIG                                                                            MD056611
     C+  ,:AFDEC                                                                            MD056611
     C+  ,:AFFDES                                                                           MD056611
     C+  ,:AFCOL1                                                                           MD056611
     C+  ,:AFCOL2                                                                           MD056611
     C+  ,:AFCOL3                                                                           MD056611
     C+  ,:AFEDTW                                                                           MD056611
     C+  ,:AFEDTS                                                                           MD056611
     C+  ,:AFREFF                                                                           MD056611
     C+  ,:AFBRCF                                                                           MD056611
     C+  ,:AFWSEQ                                                                           MD056611
     C+  ,:AFRSEQ                                                                           MD056611
     C+  ,:AFSPCB                                                                           MD056611
     C+  ,:AFLN                                                                             MD056611
     C+  ,:AFPS                                                                             MD056611
     C+  ,:DAFMODE                                                                          MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   READ      GPAUFDD0                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy data to GPAURNPD
      *****************************************************************
     C     AURN          BEGSR

     C* FIRST DELETE EXISTING RECORDS FOR FILE

     C*****GPAUFLK       SETLL     GPAURNDX                                                 MD056611
     C*****GPAUFLK       READE     GPAURNDX                               90    *           MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C**********         DELETE    GPAURNDX                                                 MD056611
     C*****GPAUFLK       READE     GPAURNDX                               90    *           MD056611
     C**********         END                                                                MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAURCTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAURBTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAURXTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611

     C* WRITE NEW RECORDS FOR FILE

     C                   READ      GPAURND0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   EXSR      VAL_NAR
     C**********         WRITE     GPAURNDX                                                 MD056611
     C                   IF        TotRow > 0                                               MD056611
     C                   eval      RAFMODE = 'C'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAURCTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFFLDN                                                                            MD056611
     C+  ,AFNARR                                                                            MD056611
     C+  ,AFDIG                                                                             MD056611
     C+  ,AFLN                                                                              MD056611
     C+  ,AFPS                                                                              MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :RAFFILE                                                                          MD056611
     C+  ,:RAFRCID                                                                          MD056611
     C+  ,:RAFFLDN                                                                          MD056611
     C+  ,:RAFNARR                                                                          MD056611
     C+  ,:RAFDIG                                                                           MD056611
     C+  ,:RAFLN                                                                            MD056611
     C+  ,:RAFPS                                                                            MD056611
     C+  ,'C'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   else                                                               MD056611
     C                   eval      RAFMODE = 'B'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAURBTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFFLDN                                                                            MD056611
     C+  ,AFNARR                                                                            MD056611
     C+  ,AFDIG                                                                             MD056611
     C+  ,AFLN                                                                              MD056611
     C+  ,AFPS                                                                              MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :RAFFILE                                                                          MD056611
     C+  ,:RAFRCID                                                                          MD056611
     C+  ,:RAFFLDN                                                                          MD056611
     C+  ,:RAFNARR                                                                          MD056611
     C+  ,:RAFDIG                                                                           MD056611
     C+  ,:RAFLN                                                                            MD056611
     C+  ,:RAFPS                                                                            MD056611
     C+  ,'B'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   Endif                                                              MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAURXTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFFLDN                                                                            MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :RAFFILE                                                                          MD056611
     C+  ,:RAFRCID                                                                          MD056611
     C+  ,:RAFFLDN                                                                          MD056611
     C+  ,:RAFMODE                                                                          MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   READ      GPAURND0                               90    *
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Copy data to GPAUASPD
      *****************************************************************
     C     AUAS          BEGSR

     C* FIRST DELETE EXISTING RECORDS FOR FILE

     C*****GPAUFLK       SETLL     GPAUASDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUASDX                               90    *           MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C**********         DELETE    GPAUASDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUASDX                               90    *           MD056611
     C**********         END                                                                MD056611

     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUACTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUABTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C/EXEC SQL                                                                             MD056611
     C+ delete from GPAUAXTD where AFFILE = :AFFILE and AFRCID = :AFRCID                    MD056611
     C/END-EXEC                                                                             MD056611
     C* WRITE NEW RECORDS FOR FILE

     C                   READ      GPAUASD0                               90    *
     C     *IN90         DOWEQ     '0'
     C**********         WRITE     GPAUASDX                                                 MD056611
     C                   IF        TotRow > 0                                               MD056611
     C                   eval      AAFMODE = 'C'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUACTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                            MD056611
     C+  ,AFRCID                                                                            MD056611
     C+  ,AFACTN                                                                            MD056611
     C+  ,AFSELN                                                                            MD056611
     C+  ,AFSIAO                                                                            MD056611
     C+  ,AFBFAF                                                                            MD056611
     C+  ,AFSFLD                                                                            MD056611
     C+  ,AFSCMP                                                                            MD056611
     C+  ,AFSCPV                                                                            MD056611
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :AAFFILE                                                                          MD056611
     C+  ,:AAFRCID                                                                          MD056611
     C+  ,:AAFACTN                                                                          MD056611
     C+  ,:AAFSELN                                                                          MD056611
     C+  ,:AAFSIAO                                                                          MD056611
     C+  ,:AAFBFAF                                                                          MD056611
     C+  ,:AAFSFLD                                                                          MD056611
     C+  ,:AAFSCMP                                                                          MD056611
     C+  ,:AAFSCPV                                                                          MD056611
     C+  ,'C'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   else                                                               MD056611
     C                   eval      AAFMODE = 'B'                                            MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUABTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                          MD05661111
     C+  ,AFRCID                                                                          MD05661111
     C+  ,AFACTN                                                                          MD05661111
     C+  ,AFSELN                                                                          MD05661111
     C+  ,AFSIAO                                                                          MD05661111
     C+  ,AFBFAF                                                                          MD05661111
     C+  ,AFSFLD                                                                          MD05661111
     C+  ,AFSCMP                                                                          MD05661111
     C+  ,AFSCPV                                                                          MD05661111
     C+  ,AFMODE                                                                          MD05661111
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :AAFFILE                                                                          MD056611
     C+  ,:AAFRCID                                                                          MD056611
     C+  ,:AAFACTN                                                                          MD056611
     C+  ,:AAFSELN                                                                          MD056611
     C+  ,:AAFSIAO                                                                          MD056611
     C+  ,:AAFBFAF                                                                          MD056611
     C+  ,:AAFSFLD                                                                          MD056611
     C+  ,:AAFSCMP                                                                          MD056611
     C+  ,:AAFSCPV                                                                          MD056611
     C+  ,'B'                                                                               MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   ENDIF                                                              MD056611
     C/exec SQL                                                                             MD056611
     C+ insert into GPAUAXTD                                                                MD056611
     C+ (                                                                                   MD056611
     C+   AFFILE                                                                          MD05661111
     C+  ,AFRCID                                                                          MD05661111
     C+  ,AFACTN                                                                          MD05661111
     C+  ,AFSELN                                                                          MD05661111
     C+  ,AFSIAO                                                                          MD05661111
     C+  ,AFBFAF                                                                          MD05661111
     C+  ,AFSFLD                                                                          MD05661111
     C+  ,AFSCMP                                                                          MD05661111
     C+  ,AFSCPV                                                                          MD05661111
     C+  ,AFMODE                                                                            MD056611
     C+ )                                                                                   MD056611
     C+ values                                                                              MD056611
     C+ (                                                                                   MD056611
     C+   :AAFFILE                                                                          MD056611
     C+  ,:AAFRCID                                                                          MD056611
     C+  ,:AAFACTN                                                                          MD056611
     C+  ,:AAFSELN                                                                          MD056611
     C+  ,:AAFSIAO                                                                          MD056611
     C+  ,:AAFBFAF                                                                          MD056611
     C+  ,:AAFSFLD                                                                          MD056611
     C+  ,:AAFSCMP                                                                          MD056611
     C+  ,:AAFSCPV                                                                          MD056611
     C+  ,:AAFMODE                                                                          MD056611
     C+ )                                                                                   MD056611
     C/end-exec                                                                             MD056611
     C                   READ      GPAUASD0                               90    *
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate field data
      *****************************************************************
     C     VALFLD        BEGSR

     C* VALIDATE DESCRIPTION

     C                   MOVEA     AFFDES        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFFDES

     C* VALIDATE COLUMN HEADINGS

     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     AFCOL1        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL1
     C                   MOVEA     AFCOL2        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL2
     C                   MOVEA     AFCOL3        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL3
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate narrative data
      *****************************************************************
     C     VAL_NAR       BEGSR

     C* VALIDATE NARRATIVE

     C                   MOVE      *BLANK        #_DTC
     C**********         MOVEA     AFNARR        #_DTC                                      MD056611
     C                   MOVEA     RAFNARR       #_DTC                                      MD056611
     C                   EXSR      RMV_INVC
     C**********         MOVEA     #_DTC         AFNARR                                     MD056611
     C                   MOVEA     #_DTC         RAFNARR                                    MD056611
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Remove invalid characters
      *****************************************************************
     C     RMV_INVC      BEGSR
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     30
     C                   Z-ADD     1             Y                 3 0
     C     #_DTC(X)      LOOKUP    #_VCH(Y)                               99    *
     C  N99              MOVEL     *BLANK        #_DTC(X)
     C                   ADD       1             X
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR processing
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
** #_VCH
 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#@0123456789.,:;/+*_$%&()"|
