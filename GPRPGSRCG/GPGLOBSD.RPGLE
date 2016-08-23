     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - SD')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLOBSD - Global Updates - SD                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 245952             Date 23Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6921            Date 21Nov05               *
      *                 BG6438             Date 30Mar05               *
      *                 BUG4521            Date 14Oct04               *
      *                 BUG1912 *CREATE    Date 10May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  245952 - New triggers for T_GPCUSTH, T_GPCTRYH and T_GRINDSH *
      *  BUG6921 - T_LVCONFIG has a record format longer than 20,000, *
      *            which means that the substring operation for the   *
      *            after image begins after the end of the EntryData  *
      *            variable.  Increase length of EntryData.           *
      *  BG6438 - Remove secondary triggers on consolidated files     *
      *           Create new triggers in zone instead.                *
      *  BUG4521- Update new GPCUSGPD file and T_GPUTILSR file        *
      *  BUG1912- Global customer details file                        *
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
 
     C*****PFLNAME       CASEQ     'GZSDCUSTPD'  GLOB_GZSDCUST                                BG6438
     C     PFLNAME       CASEQ     'GPCUSTPD'    GLOB_GPCUSTPD
     C     PFLNAME       CASEQ     'GPCUSTXPD'   GLOB_GPCUSTX
     C     PFLNAME       CASEQ     'GPCTRYPD'    GLOB_GPCTRYPD                               BUG4521
     C     PFLNAME       CASEQ     'GPINDSPD'    GLOB_GPINDSPD                               BUG4521
     C     PFLNAME       CASEQ     'T_GRCUSTG'   GLOB_T_GRCUSTG                              BUG4521
     C     PFLNAME       CASEQ     'T_GRCTRYG'   GLOB_T_GRCTRYG                              BUG4521
     C     PFLNAME       CASEQ     'T_GRINDSG'   GLOB_T_GRINDSG                              BUG4521
     C     PFLNAME       CASEQ     'T_LVCONFIG'  GLOB_T_LVCNFG                               BUG4521
     C*****PFLNAME       CASEQ     'GZSDCURRPD'  GLOB_GZSDCURR                       BUG4521  BG6438
     C     PFLNAME       CASEQ     'T_GRCUSTH'   GLOB_T_GRCUSTH                               245952
     C     PFLNAME       CASEQ     'T_GRCTRYH'   GLOB_T_GRCTRYH                               245952
     C     PFLNAME       CASEQ     'T_GRINDSH'   GLOB_T_GRINDSH                               245952
     C                   ENDCS
 
     C                   RETURN
 
      /SPACE 5
      **********                                                                              BG6438
      *****************************************************************                       BG6438
      **Global*Updates*-*Global*Customer*Details***********************                       BG6438
      *****************************************************************                       BG6438
     C*****GLOB_GZSDCUST BEGSR                                                                BG6438
      *COPY*GPCPYSRCG,GZSDCUSTPD                                                              BG6438
     C**********         ENDSR                                                                BG6438
      *SPACE*5**                                                                              BG6438
      *****************************************************************
      * Global Updates - Global Customer Details
      *****************************************************************
     C     GLOB_GPCUSTPD BEGSR
      /COPY GPCPYSRCG,GPCUSTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Global Customer Details
      *****************************************************************
     C     GLOB_GPCUSTX  BEGSR
      /COPY GPCPYSRCG,GPCUSTXPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - Global Country Details                                              BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_GPCTRYPD BEGSR                                                               BUG4521
      /COPY GPCPYSRCG,GPCTRYPD                                                               BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - Global Industry Details                                             BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_GPINDSPD BEGSR                                                               BUG4521
      /COPY GPCPYSRCG,GPINDSPD                                                               BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - Customer Group Details                                              BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_T_GRCUSTGBEGSR                                                               BUG4521
      /COPY GPCPYSRCG,T_GRCUSTG                                                              BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - Country Group Details                                               BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_T_GRCTRYGBEGSR                                                               BUG4521
      /COPY GPCPYSRCG,T_GRCTRYG                                                              BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - Industry Group Details                                              BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_T_GRINDSGBEGSR                                                               BUG4521
      /COPY GPCPYSRCG,T_GRINDSG                                                              BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5                                                                               BUG4521
      *****************************************************************                      BUG4521
      * Global Updates - List View Configuration Details                                     BUG4521
      *****************************************************************                      BUG4521
     C     GLOB_T_LVCNFG BEGSR                                                               BUG4521
      /COPY GPCPYSRCG,T_LVCONFIG                                                             BUG4521
     C                   ENDSR                                                               BUG4521
      *****************************************************************                      BUG4521
      /SPACE 5                                                                               BUG4521
      *****************************************************************          BUG4521      BG6438
      **Global*Updates*-*Global*Currency*Details***********************          BUG4521      BG6438
      *****************************************************************          BUG4521      BG6438
     C*****GLOB_GZSDCURR BEGSR                                                   BUG4521      BG6438
      *COPY*GPCPYSRCG,GZSDCURRPD                                                 BUG4521      BG6438
     C**********         ENDSR                                                   BUG4521      BG6438
      *****************************************************************          BUG4521      BG6438
      /SPACE 5                                                                                245952
      *****************************************************************                       245952
      * Global Updates - Customer Group Hierarchy details                                     245952
      *****************************************************************                       245952
     C     GLOB_T_GRCUSTHBEGSR                                                                245952
      /COPY GPCPYSRCG,T_GRCUSTH                                                               245952
     C                   ENDSR                                                                245952
      *****************************************************************                       245952
      /SPACE 5                                                                                245952
      *****************************************************************                       245952
      * Global Updates - Country Group Hierarchy details                                      245952
      *****************************************************************                       245952
     C     GLOB_T_GRCTRYHBEGSR                                                                245952
      /COPY GPCPYSRCG,T_GRCTRYH                                                               245952
     C                   ENDSR                                                                245952
      *****************************************************************                       245952
      /SPACE 5                                                                                245952
      *****************************************************************                       245952
      * Global Updates - Industry Group Hierarchy details                                     245952
      *****************************************************************                       245952
     C     GLOB_T_GRINDSHBEGSR                                                                245952
      /COPY GPCPYSRCG,T_GRINDSH                                                               245952
     C                   ENDSR                                                                245952
      *****************************************************************                       245952
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
