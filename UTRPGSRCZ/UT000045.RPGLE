     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Print Call Stack')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000045 - Program call stack print                          *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
 
     FUTPGMLL1  IF   E           K DISK
 
     FUTPGMLL2  IF   E           K DISK    PREFIX(A_)
     F                                     Rename(UTPGMLD0:UTPGMLR2)
 
     FUTPGMLL3  IF   E           K DISK    PREFIX(B_)
     F                                     Rename(UTPGMLD0:UTPGMLR3)
 
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOV)
 
      *********************************************************************
 
     D Arr             S             12A   DIM(99)
 
     D Idx             S              2S 0
     D Overflow        S              1A
     D TreeLvl         S              1A
     D SCount          S              2  0
     D OutString       S             60A
     D SpChar          S              5A   INZ('     ')
 
     D Refno           S                   LIKE(PCGPGM)
 
      ** Recursive Procedure
 
     D DetailProc      PR
     D  IPName                       10A
     D  Idx                           2S 0
 
      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************
 
      ** First read of the calls from the top level entry
 
     C                   READ      UTPGMLL1                             0101
 
      ** Loop in top level
 
     C                   DOW       *IN01 = *OFF
 
     C                   EVAL      Refno = PCGPGM
     C     Refno         CHAIN     UTPGMLL2                           02
 
     C                   IF        *IN02 = '0'
     C                   EVAL      TreeLvl = '+'
     C                   ELSE
     C                   EVAL      TreeLvl = ' '
     C                   ENDIF
 
     C                   EXSR      PRINT
 
      ** Recur on the called name
 
     C                   IF        *IN02 = '0'
     C                   CALLP     DetailProc(Refno:Idx)
     C                   ENDIF
 
     C                   EVAL      Idx = 1
 
      ** Read next in top level
 
     C                   READ      UTPGMLL1                               01
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
 
     C                   RETURN
      ******************************************************************
      /EJECT
      ******************************************************************
      * Print / output routine                                         *
      ******************************************************************
     C     Print         BEGSR
 
     C                   IF        *INOV = '1'
     C                   EVAL      Overflow = 'Y'
     C                   ENDIF
 
     C                   IF        Overflow = 'Y'
     C                   EXCEPT    HEADER
     C                   EVAL      Overflow = 'N'
     C                   ENDIF
 
     C                   EVAL      OutString = *BLANKS
     C                   IF        Idx < 2
     C                   EVAL      OutString =  Refno
     C                   ENDIF
     C                   EXCEPT    LINE
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      ******************************************************************
      * Initialize routine                                             *
      ******************************************************************
     C     *INZSR        BEGSR
 
     C                   EVAL      Idx = 1
     C                   EVAL      Overflow = 'Y'
 
     C                   ENDSR
 
      ******************************************************************
     OQSYSPRT   E            HEADER         2  3
     O                                           60 'Calling Program Stack'
     O                                           76 'Page:'
     O                       PAGE          Z   +  0
 
     O          E            HEADER         1
     O                                            9 'Calling'
     O                                           21 'Level'
 
     O          E            LINE        1  1
     O                       OutString           65
     O                       Treelvl             70
 
      ******************************************************************
      * Recursive Procedure                                            *
      ******************************************************************
     P DetailProc      B
 
     D  P@Ref          S                    LIKE(PCGPGM)
     D  C@Ref          S                    LIKE(PCGPGM)
 
     D DetailProc      PI
     D  IPName                       10A
     D  Idx                           2S 0
 
     C                   EVAL      Idx = Idx + 1
 
      ** Read in the current level
 
     C     IPName        SETLL     UTPGMLL3
     C     IPName        READE     UTPGMLL3                               03
 
      ** Loop through the current level
 
     C     *IN03         DOWEQ     *OFF
 
      ** Save file pointer
 
     C                   MOVE      B_PCGPGM      P@Ref
     C                   MOVE      B_PCDPGM      C@Ref
     C                   MOVE      Idx           TreeLvl
     C                   MOVE      B_PCDPGM      Refno
 
     C                   EXSR      PRINT
 
     C     Refno         CHAIN     UTPGMLL2                           04
 
      ** Recur
 
     C                   IF        *IN04 = '0'
     C                   CALLP     DetailProc(Refno:Idx)
     C                   EVAL      Idx = Idx - 1
     C                   ENDIF
 
      ** Restore file pointer
 
     C     K@SUBR        SETGT     UTPGMLL3
     C     K@SUBR        KLIST
     C                   KFLD                    P@Ref
     C                   KFLD                    C@Ref
 
      ** Read next record in current level
 
     C     P@Ref         READE     UTPGMLL3                               03
     C                   ENDDO
 
      ** Return
 
     C                   RETURN
      ******************************************************************
      /EJECT
      ******************************************************************
      * Print / output routine                                         *
      ******************************************************************
     C     Print         BEGSR
 
     C                   IF        *INOV = '1'
     C                   EVAL      Overflow = 'Y'
     C                   ENDIF
 
     C                   IF        Overflow = 'Y'
     C                   EXCEPT    HEADER
     C                   EVAL      Overflow = 'N'
     C                   ENDIF
 
     C                   EVAL      OutString = *BLANK
     C                   IF        Idx = 2
     C                   EVAL      OutString = SpChar + Refno
     C                   ENDIF
     C                   IF        Idx = 3
     C                   EVAL      OutString = SpChar + SpChar + Refno
     C                   ENDIF
     C                   IF        Idx = 4
     C                   EVAL      OutString = SpChar + SpChar + SpChar
     C                                         + Refno
     C                   ENDIF
     C                   IF        Idx = 4
     C                   EVAL      OutString = SpChar + SpChar + SpChar
     C                                         + SpChar + Refno
     C                   ENDIF
     C                   IF        Idx = 5
     C                   EVAL      OutString = SpChar + SpChar + SpChar
     C                                         + SpChar + SpChar + Refno
     C                   ENDIF
     C                   IF        Idx = 6
     C                   EVAL      OutString = SpChar + SpChar + SpChar
     C                                         + SpChar
     C                                         + SpChar + SpChar + Refno
     C                   ENDIF
     C                   IF        Idx = 7
     C                   EVAL      OutString = SpChar + SpChar + SpChar
     C                                         + SpChar + SpChar
     C                                         + SpChar + SpChar + Refno
     C                   ENDIF
     C                   EXCEPT    LINE
 
     C                   ENDSR
 
     P DetailProc      E
