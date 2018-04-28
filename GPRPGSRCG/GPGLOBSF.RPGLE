     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Global updates - SF')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLOBSF - Global Updates - SF                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 245952             Date 23Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6921            Date 21Nov05               *
      *                 BG7655             Date 22Jun05               *
      *                 BG6438             Date 30Mar05               *
      *                 BUG4241 *CREATE    Date 24Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  245952 - T_GRCUSTH, T_GRCTRYH and T_GRINDSH                  *
      *           all have a record format longer than 30,000,        *
      *           which means that the substring operation for the    *
      *           after image begins after the end of the EntryData   *
      *           variable.  Increase length of EntryData.            *
      *  BUG6921 - T_LVCONFIG has a record format longer than 20,000, *
      *            which means that the substring operation for the   *
      *            after image begins after the end of the EntryData  *
      *            variable.  Increase length of EntryData.           *
      *  BG7655 - Rework bug 6438.  Rename pgm GPMACBRDD to T_SECDATA *
      *  BG6438 - Remove secondary triggers on consolidated files     *
      *           GPMACBRDD should not be replicated to GZMACBRDD.    *
      *  BUG4241- Triggers for T_SECDATA file                         *
      *                                                               *
      *****************************************************************
 
     D/COPY GPCPYSRCG,STD_D_SPEC
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D**EntryData******      117  10117A                                                     BUG6921
     D**EntryData******      117  22000A                                              BUG6921 245952
     D  EntryData            117  32000A                                                      245952
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
 
 
      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   MOVE      ' '           I#BFAF
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   MOVE      'B'           I#BFAF
     C                   ENDIF
 
     C                   MOVEL     'Y'           I#TRAP
 
     C*****PFLNAME       CASEQ     'GZMACBRDD'   GLOB_GZMACBRDD                               BG6438
     C     PFLNAME       CASEQ     'GPMACBRDD'   GLOB_GPMACBRDD
     C     PFLNAME       CASEQ     'T_USERMENU'  GLOB_T_USERMEN                              BUG4521
     C                   ENDCS
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      **Global*Updates*-*Consolidated*User*Menu*Action*Codes***********                       BG6438
      *****************************************************************                       BG6438
      *******                                                                                 BG6438
     C*****GLOB_GZMACBRDDBEGSR                                                                BG6438
      *COPY*GPCPYSRCG,GZMACBRDD                                                               BG6438
     C*******            ENDSR                                                                BG6438
      *SPACE*5                                                                                BG6438
      *****************************************************************
      * Global Updates - Global User Menu Action Codes
      *****************************************************************
     C     GLOB_GPMACBRDDBEGSR
      *COPY*GPCPYSRCG,GPMACBRDD****************************************                       BG7655
      /COPY GPCPYSRCG,T_SECDATA                                                               BG7655
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - User to Menu Config file                                            BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_T_USERMENBEGSR                                                               BUG4521
      /COPY GPCPYSRCG,T_USERMEN                                                              BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
     C                   DUMP
      *
      * Log an error on the error log
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
