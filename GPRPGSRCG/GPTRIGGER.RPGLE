     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP File trigger control program')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPTRIGGER - File Trigger Control Program                     *
      *                                                               *
      *  Function:  This program acts as a shell to determine which   *
      *             programs should be run as part of a Midas file's  *
      *             trigger processing and to execute the program.    *
      *                                                               *
      *  Attached to: Any Midas file requiring trigger processing.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 245952             Date 23Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG6921            Date 21Nov05               *
      *                 BG2778R (reopen)   Date 24Jun04               *
      *                 BUG2778            Date 02Jun04               *
      *                 BG1736             Date 05Apr04               *
      *                 CGP001  *CREATE    Date 09Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245952 - New triggers for T_GPCUSTH, T_GPCTRYH and T_GRINDSH *
      *           Increase length of EntryData.                       *
      *  BUG6921 - T_LVCONFIG has a record format longer than 20,000, *
      *            which means that the substring operation for the   *
      *            after image begins after the end of the EntryData  *
      *            variable.  Increase length of EntryData.           *
      *  BG2778R - Reverse out all libl manipulation.                 *
      *            - Add pgm libs to the data source.                 *
      *  BUG2778 - Don't change the user library list at runtime to   *
      *            prevent the DB con info from being corrupted.      *
      *  BG1736 - Correct the job description                         *
      *  CGP001 - Global Processing                                   *
      *           Required to add triggers to global files            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         No further records on GPTRIGJ0                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
 
     FGPTRIGJ0  IF   E           K DISK    INFSR(*PSSR)
     FGPTLOGPD  O  A E             DISK    INFSR(*PSSR) USROPN
 
     D/COPY GPCPYSRCG,PSDS
 
     D GPTRIGLOG       DS             1
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
     D**EntryData******      117  10117A                                                     BUG6921
     D**EntryData******      117  22000A                                              BUG6921 245952
     D  EntryData            117  32000A                                                      245952
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
     D #FIEVTI         DS
     D  #PFLNAME               1     10
     D  #TRGEVENT             11     11
     D  #TRGTIME              12     12
 
     D @RUN            S              1
 
     D*Jobd*********** DS            20                                                      BG2778R
     D*JobDName*******         1     10    INZ('GBATCH    ')                                  BG1736
     D*JobDName*******         1     10    INZ('GPBATCH   ')                                  BG1736
     D*System*********        11     12                                                      BG2778R
     D*XLib***********        13     20    INZ('GXLIB   ')                                   BG2778R
      ****************                                                                       BG2778R
     D*Parm*********** DS          1000                                                      BG2778R
     D*OffSetB********       361    364B 0                                                   BG2778R
     D*LibCountB******       365    368B 0                                                   BG2778R
      ****************                                                                       BG2778R
     D*Len************ S              4B 0 INZ(1000)                                         BG2778R
 
      * If this buffer needs to increase a separate parameter will need to be added
     D Buffer          S           9999
 
     D*OffLen********* S              9  0                                                   BG2778R
     D*OffSet********* S              9  0                                                   BG2778R
     D*InLibl********* S           2750                                                      BG2778R
     D*Command******** S           2764                                                      BG2778R
      ****************                                                                       BG2778R
      **Error*message*format*for*retrieve*jobd*libl*********************************         BG2778R
     D*QUSEC*********  DS                                                                    BG2778R
      ***************                               Qus EC                                   BG2778R
     D*QUSBPRV*******          1      4B 0                                                   BG2778R
      ***************                               Bytes Provided                           BG2778R
     D*QUSBAVL*******          5      8B 0                                                   BG2778R
      ***************                               Bytes Available                          BG2778R
     D*QUSEI*********          9     15                                                      BG2778R
      ***************                               Exception Id                             BG2778R
     D*QUSERVED******         16     16                                                      BG2778R
      ***************                               Reserved                                 BG2778R
      *QUSED01*******         17     17                                                      BG2778R
      ***************                               Varying length                           BG2778R
     D*QUSExcData****         17     46                                                      BG2778R
      ***************                               Varying length field Exception Data      BG2778R
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
      *
      **Set*up*job*description*library*list***************************************           BG2778R
     C**********         CALL      'GPRTVLIB'                                                BG2778R
     C**********         PARM                    System                                      BG2778R
      **********                                                                             BG2778R
      **Set*up*job*description*library*list***************************************           BG2778R
     C**********         Call      'QWDRJOBD'                           9697                 BG2778R
     C**********         Parm                    Parm                                        BG2778R
     C**********         Parm                    Len                                         BG2778R
     C**********         Parm      'JOBD0100'    Format           10                         BG2778R
     C**********         Parm                    Jobd                                        BG2778R
     C**********         Parm                    QUSEC                                       BG2778R
     C**********         If        QUSEI = 'CPF9801' OR                                      BG2778R
     C**********                   QUSEI = 'CPF9810'                                         BG2778R
     C**********         EVAL      TRTRGP = ':::Midas system job +                           BG2778R
     C**********                   description not found:'                                   BG2778R
     C*****WRT_TLOG***   IFEQ      'Y'                                                       BG2778R
     C**********         EXSR      WRT_ERR_LOG                                               BG2778R
     C**********         ENDIF                                                               BG2778R
     C**********         Return                                                              BG2778R
     C**********         Endif                                                               BG2778R
     C**********         If        QUSEI = 'CPF9802' OR                                      BG2778R
     C**********                   QUSEI = 'CPF9820'                                         BG2778R
     C**********         EVAL      TRTRGP = ':::Not authorised to Midas +                    BG2778R
     C**********                   system job description:'                                  BG2778R
     C*****WRT_TLOG***   IFEQ      'Y'                                                       BG2778R
     C**********         EXSR      WRT_ERR_LOG                                               BG2778R
     C**********         ENDIF                                                               BG2778R
     C**********         Return                                                              BG2778R
     C**********         Endif                                                               BG2778R
      **********                                                                             BG2778R
     C**********         Eval      OffSet = OffSetB + 1                                      BUG2778
     C**********         Eval      OffLen = LibCountB * 11                                   BUG2778
     C**********         Eval      InLibl = %SubSt(Parm:OffSet:OffLen)                       BUG2778
     C**********         Eval      Command = ('CHGLIBL LIBL(' +                              BUG2778
     C**********                   InLibl + ')')                                             BUG2778
      **********                                                                             BG2778R
     C**********         Call      'QCMDEXC'                              92                 BUG2778
     C**********         Parm                    Command                                     BUG2778
     C**********         Parm      2764          Length           15 5                       BUG2778
                                                                                             BUG6921
      * If the after image extends beyond the EntryData field,  reset to                     BUG6921
      * the length actually available.  The remaining data will be lost,                     BUG6921
      * but this is not an issue as this only affects T_LVCONFIG and the                     BUG6921
      * last 20,000 bytes are not needed in the trigger program.                             BUG6921
      * Also affects T_GRCUSTH, T_GRINDSH and T_GRCTRYH but not an issue.                     245952
     C                   If        AOFF + ALEN > %Len(EntryData)                             BUG6921
     C                   Eval      ALEN = %Len(EntryData) - AOFF                             BUG6921
     C                   EndIf                                                               BUG6921
 
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
     C     FIEVTIK       SETLL     GPTRIGJ0
     C     FIEVTIK       READE     GPTRIGJ0                               99
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
     C     FIEVTIK       READE     GPTRIGJ0                               99
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
     C     AOFF          ADD       1             OffSetT           5 0
     C     ALen          SUBST     PARM1:OffSetT TRADTA
     C     BOFF          ADD       1             OffSetT
     C     BLen          SUBST     PARM1:OffSetT TRBDTA
     C                   WRITE     GPTLOGD0
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
     C     TRTRGP        IFEQ      *BLANKS
     C                   EVAL      TRTRGP = '*** ERROR ***'
     C                   ENDIF
     C     AOFF          ADD       1             OffSetT
     C     ALen          SUBST     PARM1:OffSetT TRADTA
     C     BOFF          ADD       1             OffSetT
     C     BLen          SUBST     PARM1:OffSetT TRBDTA
     C                   WRITE     GPTLOGD0
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
 
     C     *DTAARA       DEFINE                  GPTRIGLOG
     C     *LOCK         IN        GPTRIGLOG
     C                   OUT       GPTRIGLOG
 
     C     WRT_TLOG      IFEQ      'Y'
     C                   OPEN      GPTLOGPD
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
