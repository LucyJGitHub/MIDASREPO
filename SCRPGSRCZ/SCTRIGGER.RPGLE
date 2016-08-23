     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas SC File trigger control program')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCTRIGGER - File Trigger Control Program                     *
      *                                                               *
      *  Function:  This program acts as a shell to determine which   *
      *             programs should be run as part of a Midas file's  *
      *             trigger processing and to execute the program.    *
      *                                                               *
      *  Attached to: Any Midas file requiring trigger processing.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         No further records on SDTRIGJ0                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
 
     FSCTRIGJ0  IF   E           K DISK    INFSR(*PSSR)
     FSCTLOGPD  O  A E             DISK    INFSR(*PSSR) USROPN
 
     D/COPY ZACPYSRC,PSDS
 
     D SCTRIGLOG       DS             1
     D WRT_TLOG                1      1
 
     D #_FIEVTI        S             12    DIM(500)
     D #_FITRPG        S            210    DIM(500)
 
     D #_PGMS          S             21    DIM(10)
     D #_PGM           S              1    DIM(21)
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event 1=Insert, 2=Delete, 3=Update, 4=Read
     D  TRGEVENT              31     31
      * Trigger time  1=After, 2=Before
     D  TRGTIME               32     32
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
     D #FIEVTI         DS
     D  #PFLNAME               1     10
     D  #TRGEVENT             11     11
     D  #TRGTIME              12     12
 
     D @RUN            S              1
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Check for associated trigger program(s)
 
     C                   EXSR      CHK_TRIGGER
 
      * Loop through the trigger programs
 
     C                   Z-ADD     1             #J
     C     #_PGMS(#J)    DOWNE     *BLANK
     C     WRT_TLOG      IFEQ      'Y'
     C                   EXSR      WRT_ENT_LOG
     C                   ENDIF
     C                   CALL      #_PGMS(#J)
     C                   PARM                    PARM1
     C                   PARM                    PARM2
     C                   ADD       1             #J
     C                   ENDDO
 
     C                   RETURN
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check for associated trigger program(s)
      *****************************************************************
     C     CHK_TRIGGER   BEGSR
 
     C                   MOVEL     PFLNAME       #PFLNAME
     C                   SELECT
     C     TRGEVENT      WHENEQ    '1'
     C                   MOVEL     'I'           #TRGEVENT
     C     TRGEVENT      WHENEQ    '2'
     C                   MOVEL     'D'           #TRGEVENT
     C     TRGEVENT      WHENEQ    '3'
     C                   MOVEL     'U'           #TRGEVENT
     C     TRGEVENT      WHENEQ    '4'
     C                   MOVEL     'R'           #TRGEVENT
     C                   ENDSL
     C     TRGTIME       IFEQ      '1'
     C                   MOVEL     'A'           #TRGTIME
     C                   ELSE
     C                   MOVEL     'B'           #TRGTIME
     C                   ENDIF
 
     C                   Z-ADD     1             #I                3 0
     C     #FIEVTI       LOOKUP    #_FIEVTI(#I)                           99    *
 
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_FIEVTI(#I)                           99
     C                   MOVEL     #FIEVTI       #_FIEVTI(#I)
     C                   MOVEL     *BLANK        #_PGMS
     C                   Z-ADD     0             #J                3 0
     C     FIEVTIK       SETLL     SCTRIGJ0
     C     FIEVTIK       READE     SCTRIGJ0                               99
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             #J
     C                   MOVE      *BLANK        #_PGM
     C                   MOVEA     TRPGML        #_PGM(1)
     C                   Z-ADD     1             #K                3 0
     C     *BLANK        LOOKUP    #_PGM(#K)                              99
     C                   MOVE      '/'           #_PGM(#K)
     C                   ADD       1             #K
     C                   MOVEA     TRPGM         #_PGM(#K)
     C                   MOVEA     #_PGM         #_PGMS(#J)
     C     FIEVTIK       READE     SCTRIGJ0                               99
     C                   ENDDO
     C                   MOVEA     #_PGMS        #_FITRPG(#I)
     C                   ELSE
     C                   MOVEA     #_FITRPG(#I)  #_PGMS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *********************************************************************
      * Write an entry to the log file
      *********************************************************************
     C     WRT_ENT_LOG   BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      TREVTD
     C                   MOVEL     TimeDate      TREVTT
     C                   MOVEL     #PFLNAME      TRTRGF
     C                   MOVEL     #TRGTIME      TRTRGT
     C                   MOVEL     #TRGEVENT     TRTRGE
     C                   MOVEL     #_PGMS(#J)    TRTRGP
     C     AOFF          ADD       1             OffSet            5 0
     C     ALen          SUBST     PARM1:OffSet  TRADTA
     C     BOFF          ADD       1             OffSet
     C     BLen          SUBST     PARM1:OffSet  TRBDTA
     C                   WRITE     SCTLOGD0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Write an error to the log file
      *********************************************************************
     C     WRT_ERR_LOG   BEGSR
     C                   TIME                    TimeDate
     C                   MOVE      TimeDate      TREVTD
     C                   MOVEL     TimeDate      TREVTT
     C                   MOVEL     PFLNAME       TRTRGF
     C                   MOVEL     TRGTIME       TRTRGT
     C                   MOVEL     TRGEVENT      TRTRGE
     C                   EVAL      TRTRGP = '*** ERROR ***'
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  TRADTA
     C     BOFF          ADD       1             OffSet
     C     BLen          SUBST     PARM1:OffSet  TRBDTA
     C                   WRITE     SCTLOGD0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Job details
 
     C                   EVAL      TRJOB  = PSJobName
     C                   EVAL      TRUSER = PSUser
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EVAL      TRJOBN = PSJobNoA
 
      * Get trigger log status
 
     C     *DTAARA       DEFINE                  SCTRIGLOG
     C     *LOCK         IN        SCTRIGLOG
     C                   OUT       SCTRIGLOG
 
     C     WRT_TLOG      IFEQ      'Y'
     C                   OPEN      SCTLOGPD
     C                   ENDIF
 
     C     FIEVTIK       KLIST
     C                   KFLD                    #PFLNAME
     C                   KFLD                    #TRGTIME
     C                   KFLD                    #TRGEVENT
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C     WRT_TLOG      IFEQ      'Y'
     C                   EXSR      WRT_ERR_LOG
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
