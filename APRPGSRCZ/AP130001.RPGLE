     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('T_APIMSG Purging Program MODULE')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  AP130001 - T_APIMSG Purging Program                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD028229           Date 29Oct14               *
      *  Prev Amend No. CCB024A  *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     FAPIMSGL0  UF   E           K DISK    INFSR(*PSSR)
      ** API MQ Messages
      *
      *****************************************************************
      ** Data Structures and Variables                               **
      *****************************************************************
 
     DMidasRefDate     S              5P 0
     DMidasDate        S              5P 0
     DPRtCd            S              7A
     DPOptn            S              7A
 
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
 
     C     *LOVAL        SETLL     T_APIMSG
     C                   READ      T_APIMSG                               99
 
     C     *IN99         DOWEQ     '0'
 
      ** Convert the Timestamp to YYYYMMDD format for MIDAS Day conversion
 
     C                   EXTRCT    MQTMST:*Y     Year
     C                   EXTRCT    MQTMST:*M     Month
     C                   EXTRCT    MQTMST:*D     Day
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    YYYYMMDD
     C                   PARM      *ZERO         MidasDate
 
     C     MidasDate     IFLT      MidasRefDate
     C*****MQSTAT        ANDEQ     'P'                                                      MD028229
     C     MQSTAT        Ifeq      'C'                                                      MD028229
     C     MQSTAT        Oreq      'P'                                                      MD028229
 
     C                   DELETE    T_APIMSG
 
     C                   Endif                                                              MD028229
     C                   ENDIF
 
     C                   READ      T_APIMSG                               99
 
     C                   ENDDO
 
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
