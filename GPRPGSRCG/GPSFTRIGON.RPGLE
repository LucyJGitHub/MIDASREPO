     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Add trigger programs for Switch. Feat.')
      *****************************************************************
      *                                                               *
      *  Midas - System Control module                                *
      *                                                               *
      *  GPSFTRIGON - Add triggers for Switchable Features            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK020  *CREATE    Date 03Nov04               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CPK020 - Report for any add/remove trigger errors instead    *
      *           of to msgq(MOPERQ).                                 *
      *           Global version of SCSFTRIGON.                       *
      *                                                               *
      *****************************************************************
     FGPSARTL0  IF   E           K DISK
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
     D RmvAllTrigs     S             12    INZ('*RMVALLTRIG')
      *
     D AddAllTrigs     S             12    INZ('*ADDTRIG')
      *
     D @RUN            S              1
     D LIVE            S              9
      *
     D TRFILE          S                   LIKE(GUFILE)                         Trigger file name
      *
     C     *ENTRY        PLIST
     C                   PARM                    Switch_Feat       6
      *
      * Initialise array index.
     C                   EVAL      Idx = 1
      *
      * Find first record for Switchable Feature.
     C     Switch_Feat   SETLL     GPSARTL0
     C     Switch_Feat   CHAIN     GPSARTL0                           41
      *
      * If a record is found, begin processing:
     C                   DOW       *IN41 = *OFF
      *
      * check array to see if file has already been processed.
     C                   EVAL      TRFILE  = GUFILE
     C                   EVAL      Element = %LOOKUP(TRFILE:FileName)
      * If it has not then store file name in array, increment the array
      *  index and process the file.
     C                   IF        Element = 0
     C                   EVAL      FileName(Idx) = TRFILE
     C                   EVAL      Idx = Idx + 1
      * Call program to remove triggers for the file.
     C                   EVAL      LIVE = '*ALLTRIG'
     C                   CALL      'GPMNTTRIG'
     C                   PARM                    RmvAllTrigs
     C                   PARM                    TRFILE
     C                   PARM                    LIVE
      *
      * Then call program to add all triggers for this file.
     C
     C                   EVAL      LIVE = '*LIVETRIG'
     C                   CALL      'GPMNTTRIG'
     C                   PARM                    AddAllTrigs
     C                   PARM                    TRFILE
     C                   PARM                    LIVE
      *
     C                   ENDIF
      *
      * Read next record on SCSARTPD.
     C                   READ      GPSARTL0                               41
      * If the Switchable Feature does not match the entry parameter
      *  then set on *IN41 to end DO loop.
     C                   IF        GUSARN <> Switch_Feat
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
      *
     C                   ENDDO
      *
      * End program.
     C     End_Program   TAG
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
