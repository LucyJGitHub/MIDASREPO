     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *          MD056611
/*STD *  RPGSQLMOD                                                    *          MD056611
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056611
/*EXI *  TEXT('Midas GP Copy Audit File Data')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0006 - Copy Audit File Data                              *
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

     F*GPAUFLL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAUFLD0:GPAUFLDX)                        MD056611
     FGPAUFLPD  O    E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L)                                        MD056611
     F*GPAUFDL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAUFDD0:GPAUFDDX)                        MD056611
     FGPAUFDPD  O    E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D)                                        MD056611
     F*GPAURNL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAURND0:GPAURNDX)                        MD056611
     FGPAURNPD  O    E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R)                                        MD056611
     F*GPAUASL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056611
     F**********                           RENAME(GPAUASD0:GPAUASDX)                        MD056611
     FGPAUASPD  O    E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A)                                        MD056611

     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
     D GPAUFL        E DS                  EXTNAME(GPAUFJW0)                                MD056611
     D                                     PREFIX(G)                                        MD056611
     D GPAUFD        E DS                  EXTNAME(GPAUDJW0)                                MD056611
     D                                     PREFIX(H)                                        MD056611
     D GPAUAS        E DS                  EXTNAME(GPAUAJW0)                                MD056611
     D                                     PREFIX(I)                                        MD056611
     D GPAURN        E DS                  EXTNAME(GPAURJW0)                                MD056611
     D                                     PREFIX(J)                                        MD056611
     D DSAUFL        E DS                  EXTNAME(GPAUFLPD)                                MD056611
     D                                     PREFIX(L)                                        MD056611
     D DSAUFD        E DS                  EXTNAME(GPAUFDPD)                                MD056611
     D                                     PREFIX(D)                                        MD056611
     D DSAURN        E DS                  EXTNAME(GPAURNPD)                                MD056611
     D                                     PREFIX(R)                                        MD056611
     D DSAUAS        E DS                  EXTNAME(GPAUASPD)                                MD056611
     D                                     PREFIX(A)                                        MD056611
     D* XXFILE       E                     EXTFLD(AFFILE)                                   MD056611
     D* XXRCID       E                     EXTFLD(AFRCID)                                   MD056611

     I*GPAUFLDX*                                                                            MD056611
     I**********    AFFILE                      XXFILE                                      MD056611
     I**********    AFRCID                      XXRCID                                      MD056611
     I*GPAUFDDX*                                                                            MD056611
     I**********    AFFILE                      XXFILE                                      MD056611
     I**********    AFRCID                      XXRCID                                      MD056611
     I*GPAURNDX*                                                                            MD056611
     I**********    AFFILE                      XXFILE                                      MD056611
     I**********    AFRCID                      XXRCID                                      MD056611
     I*GPAUASDX*                                                                            MD056611
     I**********    AFFILE                      XXFILE                                      MD056611
     I**********    AFRCID                      XXRCID                                      MD056611

     C     *ENTRY        PLIST
     C**********         PARM                    AFFILE           10                        MD056611
     C**********         PARM                    AFRCID           15                        MD056611
     C                   PARM                    P_FILE           10                        MD056611
     C                   PARM                    P_RCID           15                        MD056611
     C                   PARM                    CPFILE           10
     C                   PARM                    CPRCID           15

     C     GPAUFLK       KLIST
     C                   KFLD                    CPFILE
     C                   KFLD                    CPRCID

     C                   EXSR      AUFL
     C                   EXSR      AUFD
     C                   EXSR      AURN
     C                   EXSR      AUAS
     C                   SETON                                        LR

      /SPACE 5
      ********************************************************************
      * Copy GPAUFLPD
      *****************************************************************
     C     AUFL          BEGSR
     C*****GPAUFLK       SETLL     GPAUFLDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUFLDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ declare LCursor insensitive scroll cursor for                                       MD056611
     C+ select * from GPAUFJW0                                                              MD056611
     C+ where AFFILE = :P_FILE and AFRCID = :P_RCID                                         MD056611
     C+ order by AFFILE, AFRCID                                                             MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ open LCursor                                                                        MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from LCursor into :DSAUFL                                                MD056611
     C/END-EXEC                                                                             MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C     SQLCODE       DOWEQ     0                                                        MD056611
     C     SQLCODE       OREQ      30                                                       MD056611
     C                   WRITE     GPAUFLD0
     C*****GPAUFLK       READE     GPAUFLDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from LCursor into :DSAUFL                                                MD056611
     C/END-EXEC                                                                             MD056611
     C                   END
     C/EXEC SQL                                                                             MD056611
     C+ close LCursor                                                                       MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy GPAUFDPD
      *****************************************************************
     C     AUFD          BEGSR
     C*****GPAUFLK       SETLL     GPAUFDDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUFDDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ declare DCursor insensitive scroll cursor for                                       MD056611
     C+ select * from GPAUDJW0                                                              MD056611
     C+ where AFFILE = :P_FILE and AFRCID = :P_RCID                                         MD056611
     C+ order by AFFILE, AFRCID                                                             MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ open DCursor                                                                        MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from DCursor into :DSAUFD                                                MD056611
     C/END-EXEC                                                                             MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C     SQLCODE       DOWEQ     30                                                       MD056611
     C                   WRITE     GPAUFDD0
     C*****GPAUFLK       READE     GPAUFDDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from DCursor into :DSAUFD                                                MD056611
     C/END-EXEC                                                                             MD056611
     C                   END
     C/EXEC SQL                                                                             MD056611
     C+ close DCursor                                                                       MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy GPAURNPD
      *****************************************************************
     C     AURN          BEGSR
     C*****GPAUFLK       SETLL     GPAURNDX                                                 MD056611
     C*****GPAUFLK       READE     GPAURNDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ declare RCursor insensitive scroll cursor for                                       MD056611
     C+ select * from GPAURJW0                                                              MD056611
     C+ where AFFILE = :P_FILE and AFRCID = :P_RCID                                         MD056611
     C+ order by AFFILE, AFRCID                                                             MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ open RCursor                                                                        MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from RCursor into :DSAURN                                                MD056611
     C/END-EXEC                                                                             MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C     SQLCODE       DOWEQ     30                                                       MD056611
     C                   WRITE     GPAURND0
     C*****GPAUFLK       READE     GPAURNDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from RCursor into :DSAURN                                                MD056611
     C/END-EXEC                                                                             MD056611
     C                   END
     C/EXEC SQL                                                                             MD056611
     C+ close RCursor                                                                       MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy GPAUASPD
      *****************************************************************
     C     AUAS          BEGSR
     C*****GPAUFLK       SETLL     GPAUASDX                                                 MD056611
     C*****GPAUFLK       READE     GPAUASDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ declare ACursor insensitive scroll cursor for                                       MD056611
     C+ select * from GPAUAJW0                                                              MD056611
     C+ where AFFILE = :P_FILE and AFRCID = :P_RCID                                         MD056611
     C+ order by AFFILE, AFRCID                                                             MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ open ACursor                                                                        MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from ACursor into :DSAUAS                                                MD056611
     C/END-EXEC                                                                             MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C     SQLCODE       DOWEQ     30                                                       MD056611
     C                   WRITE     GPAUASD0
     C*****GPAUFLK       READE     GPAUASDX                               90    *           MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from ACursor into :DSAUAS                                                MD056611
     C/END-EXEC                                                                             MD056611
     C                   END
     C/EXEC SQL                                                                             MD056611
     C+ close ACursor                                                                       MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
