     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                     MD039105
/*STD *  RPGSQLMOD                                                    *                     MD039105
/*EXI *  TEXT('T_APIMSG Purging Program MODULE')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  AP130001 - T_APIMSG Purging Program                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD031737           Date 27Jul17               *
      *  Prev Amend No. MD039105           Date 06Jun16               *
      *                 MD028229           Date 29Oct14               *
      *                 CCB024A  *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031737 - Housekeeping of ZATRNLOGPD is missing             *
      *  MD039105 - Data truncation encountered when trying to insert *
      *             CUSD MQ and SOAP transaction with UDF fields      *
      *  MD028229 - Added purging of 'C' records on T_APIMSG.         *
      *  CCB024A - COB Restructure - COB Tuning                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   98    - Read indicator for SDSVALPD                         *
      *   99    - Read until EOF of T_APIMSG                          *
      *                                                               *
      *****************************************************************
     FSDSVALL0  IF   E           K DISK    INFSR(*PSSR)
      ** System Value
      *
     F***APIMSGL0  UF   E           K DISK    INFSR(*PSSR)                                  MD039105
      ** API MQ Messages
      *
      *****************************************************************
      ** Data Structures and Variables                               **
      *****************************************************************
 
     DMidasRefDate     S              5P 0
     DMidasDate        S              5P 0
     DPRtCd            S              7A
     DPOptn            S              7A
     DMidasConvDate    S             10A                                                    MD039105
     D ULimit          S              5P 0 INZ(0)                                           MD039105
 
     D APMSGICD        C                   CONST('PurgeDaysOfAP_MQ_MSG')
 
     D                 DS
     D YYYYMMDD                1      8
     D Year                    1      4
     D Month                   5      6
     D Day                     7      8
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *****************************************************************
      * MAIN PROCESSING
      *****************************************************************
 
     C                   EXSR      INIT
 
     C                   EXSR      MAIN
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      * INIT
      *****************************************************************
     C     INIT          BEGSR
 
      ** Retrieve RUNDATE from SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     PRtCd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * INIT
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Retrieve the ICD Settings
 
     C     APMSGICD      CHAIN     SDSVALL0                           98
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Subtract the ICD Setting from the Rundate.
 
     C                   EVAL      MidasRefDate = BJRDNB - %INT(GIVAL)

     C                   CALLB     'ZDATE9'                                                 MD039105
     C                   PARM                    MidasRefDate                               MD039105
     C                   PARM                    YYYYMMDD                                   MD039105
     C                   PARM      *BLANKS       PRtCd                                      MD039105
                                                                                            MD039105
     C                   EVAL      MidasConvDate = Month + '/' + Day +                      MD039105
     C                                             '/' + Year                               MD039105
     C                   EVAL      ULimit = 0                                               MD039105
                                                                                            MD039105 
     C******LOVAL        SETLL     T_APIMSG                                                 MD039105
     C**********         READ      T_APIMSG                               99                MD039105
      **********                                                                            MD039105
     C******IN99         DOWEQ     '0'                                                      MD039105
      **********                                                                            MD039105
      ***Convert*the*Timestamp*to*YYYYMMDD*format*for*MIDAS*Day*conversion                  MD039105
      **********                                                                            MD039105
     C**********         EXTRCT    MQTMST:*Y     Year                                       MD039105
     C**********         EXTRCT    MQTMST:*M     Month                                      MD039105
     C**********         EXTRCT    MQTMST:*D     Day                                        MD039105
      **********                                                                            MD039105
     C**********         CALLB     'ZDATE10'                                                MD039105
     C**********         PARM                    YYYYMMDD                                   MD039105
     C**********         PARM      *ZERO         MidasDate                                  MD039105
      **********                                                                            MD039105
     C*****MidasDate     IFLT      MidasRefDate                                             MD039105
     C*****MQSTAT        ANDEQ     'P'                                                      MD028229
     C*****MQSTAT        Ifeq      'C'                                             MD028229 MD039105
     C*****MQSTAT        Oreq      'P'                                             MD028229 MD039105
      **********                                                                            MD039105
     C**********         DELETE    T_APIMSG                                                 MD039105
      **********                                                                            MD039105
     C**********         Endif                                                     MD028229 MD039105
     C**********         ENDIF                                                              MD039105
      **********                                                                            MD039105
     C**********         READ      T_APIMSG                               99                MD039105
      **********                                                                            MD039105
     C**********         ENDDO                                                              MD039105
                                                                                            MD039105
      ** Check and delete if record is found in ZATRNLOGPD                                  MD039105
      ** then delete record in T_APIMSG                                                     MD039105
                                                                                            MD039105
     C/EXEC SQL                                                                             MD039105
     C+ DELETE FROM ZATRNLOGL8                                                              MD039105
     C+ WHERE AAMSGLOGID IN                                                                 MD039105
     C+ (                                                                                   MD039105
     C+  SELECT MQMSID from T_APIMSG                                                        MD039105
     C+  WHERE DATE(MQTMST) < :MidasConvDate AND                                            MD039105
     C+  (MQSTAT = 'C' OR MQSTAT = 'P')                                                     MD039105
     C+ )                                                                                   MD039105
     C/END-EXEC                                                                             MD039105
                                                                                            MD039105
     C/EXEC SQL                                                                             MD039105
     C+ DELETE FROM T_APIMSG                                                                MD039105
     C+ WHERE DATE(MQTMST) < :MidasConvDate AND                                             MD039105
     C+ (MQSTAT = 'C' OR MQSTAT = 'P')                                                      MD039105
     C/END-EXEC                                                                             MD039105
 
     C                   ENDSR
      *****************************************************************
      * *PSSR                                                         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
