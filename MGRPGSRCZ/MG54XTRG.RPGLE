     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SEMVTSPD Trigger.')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MG54XTRG- Trigger on SEMVTSPD for MT544-7 generation.        *
      *                                                               *
      *  Function:  This module is a trigger for SEMVTSPD.            *
      *                                                               *
      *  Called By: Automatic                                         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1085813          Date 06Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE039  *CREATE    Date 05Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1085813 - Remove unnecessary dumps generated.              *
      *  CSE039 - MT544-7 Message generation.                         *
      *                                                               *
      *****************************************************************
      *
      /SPACE 3
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
      *
      ***  Data Area giving Installation Control Details
     D PSDS           SDS
      *
      ***  Program Status Data Structure
     D  PGM              *PROC
      *
     D PARM1           DS
      * Physical file name
     D  FNAME                        10
      * Physical file library
     D  LNAME                        10
      * Member name
     D  MNAME                        10
      * Trigger event 1=Ins, 2=Del, 3=Upd
     D  TEVEN                         1
      * Trigger time  1=After, 2=Before
     D  TTIME                         1
      * Commit lock level
     D  CMTLCK                        1
      * Reserved
     D  FILL1                         3
      * CCSID
     D  CCSID                         9B 0
      * Reserved
     D  FILL2                         8
      * Offset to the original record (Add 1!)
     D  OLDOFF                        9B 0
      * length of the original record
     D  OLDLEN                        9B 0
      * Offset to the original record null byte map (Add 1!)
     D  ONOFF                         9B 0
      * length of the null byte map
     D  ONLEN                         9B 0
      * Offset to the new record (Add 1!)
     D  NEWOFF                        9B 0
      * length of the new record
     D  NEWLEN                        9B 0
      * Offset to the new record null byte map (Add 1!)
     D  NNOFF                         9B 0
      * length of the null byte map
     D  NNLEN                         9B 0
      * Reserved
     D  RESV3                        16
      * Records
     D  RECS                       4532
 
      * Trigger Buffer Length
     D PARM2           DS
     D  LENG                          9B 0
 
      * Record to be inserted or new values
     D NEW           E DS                  EXTNAME(SEMVTSPD)
      *
      * Set up the entry parameter list.
     C     *ENTRY        PLIST
     C     PARM1         PARM                    PARM1
     C     PARM2         PARM                    PARM2
      *
     C                   EVAL      NEW = %SUBST(PARM1:NEWOFF+1:NEWLEN)
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *                 M A I N   R O U T I N E                       *
      *                                                               *
      *****************************************************************
      *
      ***  if CSE039 is on and selection criteria are met, call extract pgm
      *
     C**********         dump                                                              AR1085813
     C                   IF        CSE039 = 'Y' and TMSWSC = 'PST'
     C                             and TMSCRQ ='Y' and TMSTMG <> 'Y'
     C                             or CSE039 = 'Y' and TMSWSC = 'SET'
     C                             and TMSCRQ ='Y' and TMSTMG <> 'Y'
     C                             or CSE039 = 'Y' and TMSWSC = 'CST'
     C                             and TMSCRQ ='Y' and TMSTMG <> 'Y'
     C                             or CSE039 = 'Y' and TMSWSC = 'RVS'
     C                             and TMSCRQ ='Y' and TMSTMG <> 'Y'
     C                   CALL      'MG54XTRD'
     C                   PARM                    NEw
     C                   ENDIF
      *
      ***  End program.
      *
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
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ***  Handle Database Error.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     PGM           DBPGM
     C                   MOVEL     'CALL  '      DBKEY
     C                   MOVEL     'MG54XTRG'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation subroutine                   *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ***  Define the LDA.
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ***  Access SAR details file to determine if CSE039
      ***  is switched on
      *
     C                   MOVEL     'N'           CSE039            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSE039'      @SARD             6
      *
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CSE039
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *****************************************************************
