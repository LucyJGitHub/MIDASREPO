     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055682
/*STD *  RPGSQLBND                                                    *                     MD055682
/*EXI *  TEXT('Midas SC Add trigger programs for Switch. Feat.')
      *****************************************************************
      *                                                               *
      *  Midas - System Control module                                *
      *                                                               *
      *  SCSFTRIGON - Add triggers for Switchable Features            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055682           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP029             Date 22Oct04               *
      *                 CPK020             Date 12Aug04               *
      *                 CGP001  *CREATE    Date 02Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055682 - Deliverable Data Split for TRIG                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP029 - SCSARTL0 changed to include triggger file, so       *
      *           no need to chain to SCTRIGL0.                       *
      *  CPK020 - Add command to SCMNTTRIG.                           *
      *  CGP001 - Global Processing.                                  *
      *                                                               *
      *****************************************************************
     F*SCSARTL0* IF   E           K DISK                                                    MD055682
      *
     F*SCTRIGL0*IF***E           K DISK                                                       CUP029
      *
      * Array for hoding File names.
     D FileName        S             10    DIM(500)
      *
      * Array index.
     D Idx             S              3  0
      *
      * Element number.
     D Element         S              3  0
      *
     D*RmvAllTrigs*****S              1    INZ('X')                                           CPK020
     D RmvAllTrigs     S             12    INZ('*RMVALLTRIG')                                 CPK020
      *
     D*AddAllTrigs*****S              1    INZ('A')                                           CPK020
     D AddAllTrigs     S             12    INZ('*ADDTRIG')                                    CPK020
      *
     D @RUN            S              1
     D*LIVE************S              1                                                       CPK020
     D LIVE            S              9                                                       CPK020
      *
     D TRFILE          S                   LIKE(GUFILE)                         Trigger file name
     D SCSART        E DS                  EXTNAME(SCSRTJW0)                                MD055682
      *
     C     *ENTRY        PLIST
     C                   PARM                    Switch_Feat       6
      *
      * Initialise array index.
     C                   EVAL      Idx = 1
      *
      * Find first record for Switchable Feature.
     C*****Switch_Feat   SETLL     SCSARTL0                                                 MD055682
     C*****Switch_Feat   CHAIN     SCSARTL0                           41                    MD055682
     C/EXEC SQL                                                                             MD055682
     C+ declare ACursor insensitive scroll cursor for                                       MD055682
     C+ select * from SCSRTJW0                                                              MD055682
     C+ where GUSARN = :Switch_Feat                                                         MD055682
     C+ order by GUSARN, GUFILE, GUTIME, GUEVNT, GUSEQ                                      MD055682
     C/END-EXEC                                                                             MD055682
                                                                                            MD055682
     C/EXEC SQL                                                                             MD055682
     C+ open ACursor                                                                        MD055682
     C/END-EXEC                                                                             MD055682
                                                                                            MD055682
     C/EXEC SQL                                                                             MD055682
     C+ fetch next from ACursor into :SCSART                                                MD055682
     C/END-EXEC                                                                             MD055682
      *
      * If a record is found begin processing.
     C**********         DOW       *IN41 = *OFF                                             MD055682
     C                   DOW       SQLCODE = 0                                              MD055682
      *
      **Use*unique*number*to*chain*to*SCTRIGPD.                                               CUP029
     C*****GUUNQI        CHAIN     SCTRIGL0                           42                      CUP029
      *
      **If*the*unique*number**s*not*found*the*data*is*wrong ...                               CUP029
     C**********         IF        *IN42 = *ON                                                CUP029
     C**********         EXSR      *PSSR                                                      CUP029
     C**********         ELSE                                                                 CUP029
      * ... else check array to see if file has already been processed.
     C                   EVAL      TRFILE  = GUFILE                                           CUP029
     C                   EVAL      Element = %LOOKUP(TRFILE:FileName)
      * If it has not then store file name in array, increment the array
      *  index and process the file.
     C                   IF        Element = 0
     C                   EVAL      FileName(Idx) = TRFILE
     C                   EVAL      Idx = Idx + 1
      * Call program to remove triggers for the file.
     C**********         EVAL      LIVE = 'N'                                                 CPK020
     C                   EVAL      LIVE = '*ALLTRIG'                                          CPK020
     C                   CALL      'SCMNTTRIG'
     C                   PARM                    RmvAllTrigs
     C                   PARM                    TRFILE
     C                   PARM                    LIVE
      *
      * Then call program to add all triggers for this file.
     C
     C**********         EVAL      LIVE = 'Y'                                                 CPK020
     C                   EVAL      LIVE = '*LIVETRIG'                                         CPK020
     C                   CALL      'SCMNTTRIG'
     C                   PARM                    AddAllTrigs
     C                   PARM                    TRFILE
     C                   PARM                    LIVE
      *
     C                   ENDIF
      *
      * Read next record on SCSARTPD.
     C**********         READ      SCSARTL0                               41                MD055682
     C/EXEC SQL                                                                             MD055682
     C+ fetch next from ACursor into :SCSART                                                MD055682
     C/END-EXEC                                                                             MD055682
      * If the Switchable Feature does not match the entry parameter
      *  then set on *IN41 to end DO loop.
     C                   IF        GUSARN <> Switch_Feat
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
      *
     C**********         ENDIF                                                                CUP029
      *
     C                   ENDDO
      *
      * End program.
     C     End_Program   TAG
     C/EXEC SQL                                                                             MD055682
     C+ close ACursor                                                                       MD055682
     C/END-EXEC                                                                             MD055682
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
