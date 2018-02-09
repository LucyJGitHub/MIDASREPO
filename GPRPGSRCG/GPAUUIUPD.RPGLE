     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Audit User Input Update')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUUIUPD - Audit User Input Update                          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP009             Date 22Dec04               *
      *                 BUG3420            Date 28Jun04               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BUG3420 - Audit reporting can't handle system date format MDY*
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGPAUUIPD  O  A E           K DISK    INFSR(*PSSR)
 
 
     D                 DS
     D  EFF_DATE               1      6
     D                 DS
     D  SYS_DATE               1      6
     D  SYS_DD                 1      2
     D  SYS_MM                 3      4
     D  SYS_YY                 5      6
 
 
     DPSDS            SDS
     D PSJobName             244    253
     D PSUser                254    263
     D PSJobNo               264    269S 0
 
 
     C**********         TIME                    TimeDate         12 0                       BUG3420
     C**********         MOVE      TimeDate      SYS_DATE                                    BUG3420
                                                                                             BUG3420
     C                   CALL      'CBTIME'                                                  BUG3420
     C                   PARM                    SystemDayNum      5                         BUG3420
     C                   PARM                    SystemTime        6                         BUG3420
     C                   PARM                    SystemDatFmt      1                         BUG3420
                                                                                             BUG3420
     C                   MOVEL     SystemDayNum  ZDAYNO                                      BUG3420
     C                   CALL      'ZDATE2'                                                  BUG3420
     C                   PARM                    ZDAYNO            5 0                       BUG3420
     C                   PARM      'D'           BJDFIN            1                         BUG3420
     C                   PARM                    ZDATE             6 0                       BUG3420
     C                   PARM                    ZADATE            7                         BUG3420
     C                   MOVEL     ZDATE         SYS_DATE                                    BUG3420
                                                                                             BUG3420
     C                   EVAL      EFF_DATE = SYS_YY + SYS_MM + SYS_DD
     C                   MOVEL     EFF_DATE      AIDATE
     C**********         MOVEL     TimeDate      AITIME                                      BUG3420
     C                   MOVEL     SystemTime    AITIME                                      BUG3420
     C                   ADD       1             AISEQN
     C                   MOVEL     PSJobName     AIJOBN
     C                   MOVEL     PSUser        AIJUSR
     C                   MOVEL     PSJobNo       AIJBNO
     C                   MOVEL     I#RDVL        AIRDVL
     C                   MOVEL     ZOZONE        AIZONE
     C                   Z-ADD     BJRDNB        AIRDNB
     C                   MOVEL     I#USER        AIUSER
     C                   MOVEL     I#LANG        AILANG
     C                   MOVEL     I#TTYP        AITTYP
     C                   MOVEL     I#UPYN        AIUPYN
     C                   MOVEL     I#TRID        AITRID
     C                   MOVEL     I#BUFF        AIBUFF
     C                   WRITE     GPAUUID0
 
     C                   RETURN
 
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RDVL            1
     C                   PARM                    I#SYS             2
     C                   PARM                    I#USER           10
     C                   PARM                    I#LANG            2
     C                   PARM                    I#TTYP            4
     C                   PARM                    I#UPYN            1
     C                   PARM                    I#TRID          300
     C                   PARM                    I#BUFF         9999
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
     C* GET ZONE
 
     C     I#SYS         CHAIN     GPZONED0                           99        *
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BAD SYSTEM:' + I#SYS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C* GET BANK DETAILS
 
     C     ZOZONE        CHAIN     SDBANKD0                           99        *
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BAD ZONE:' + ZOZONE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
