     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD MD-54408 Data Patch Program')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTFC0841 - Midas SD Data Patch Program                       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD054408  *CREATE  Date 05Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054408 - TAIC013 - Periodic Report starts generating Daily *
      *                  if previous month does not have 31 days      *
      *                                                               *
      *****************************************************************

     FFCPREQPD  UF   E           K DISK
     FFCRREQPD  O    E             DISK
     FFCPARPL1  IF   E           K DISK
     FFCPARDPD  O    E             DISK
     FMAARCDPD  O    E             DISK
     FMAARCPL2  IF   E           K DISK
     FMUSER     IF   E           K DISK
     FSDBANKL1  IF   E           K DISK
     FUTFC0841P1O    E             PRINTER OFLIND(*IN25)
     F/COPY WNCPYSRC,FC0010F001
     D/COPY ZACPYSRC,STD_D_SPEC

     D ARRREM          S             50    DIM(15) CTDATA PERRCD(1)

      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for Customer Master File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data Structure for Bank Details File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure for Swtichable feature
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PKEY1           S             10
     D PKYST           S              7
     D PMODE           S              1
     D PRTN            S              1

      *
      ** Report Sequence Number
      *
     D REPSEQ          DS
     D  SEQ                    1      5  0

     D                 DS
     D  YYYYMMDD               1      8  0
     D  YYYY                   1      4  0
     D  MM                     5      6  0
     D  DD                     7      8  0
      *
     C                   EVAL      *IN10 = *OFF
     C                   IF        PMODE = 'A'
     C                             OR PMODE = 'a'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF
      ** Print Header
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader1
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader2
     C/COPY WNCPYSRC,FC0010C001
      *
      * PARAMETER PASSED FROM SCC01 : REPORT SEQ. NO.
      *
      **KLIST TO READ MAARCPPD & FCPARPPD IN REPORT NAME & SEQ. NO.
      **ORDER
      *
     C     ARCKEY        KLIST
     C                   KFLD                    D9RNAM
     C                   KFLD                    D9PSQN
      *
     C                   MOVEL     'FC0010'      DBPGM
      *
     C                   READ      FCPREQPD                               75
      *
      **PROCESS WHILE RECORDS EXIST ON FCPREQPD WITH A NEXT ACTIVE
      **DATE < NEXT WORKING DAY
      *
     C     *IN75         DOWEQ     '0'
     C*    D9PNDT        IFLT      BJDNWD
     C     D9PNDT        IFEQ      17226
     C     D9FREQ        ANDEQ     'M'
      *
      ** Obtain next sequence number from data area REPSEQ and update
      ** data area for next request.
      *
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      SEQ           REPCON            5 0
     C                   ADD       1             SEQ
     C                   OUT       REPSEQ
      *
     C                   MOVEL     D9RNAM        CHARCP           12
     C                   MOVE      D9PSQN        CHARCP
      *
      **WRITES A RECORD TO FCRREQPD FROM FCPREQPD, MUSERDD & REPCON
      *
     C                   MOVE      D9RNAM        D5RNAM
     C                   MOVE      REPCON        D5RQSQ
     C                   MOVE      D9SOID        D5SOID
     C                   MOVE      D9LVL         D5LVL
     C                   MOVE      D9ETTY        D5ETTY
      **MOVE 'N' TO INPUT CYCLE *
     C                   MOVE      'N'           D5IPCY
      * MOVE 'Y' TO PERIODIC *
     C                   MOVE      'Y'           D5PDFL
     C                   MOVE      D9DLS1        D5DLS1
     C                   MOVE      D9DLS2        D5DLS2
     C                   MOVE      D9USRO        D5USRO
     C                   MOVE      D9ARMF        D5ARMF
     C                   MOVE      D9AROD        D5AROD
     C                   MOVE      D9DRQD        D5DRQD
     C                   MOVE      D9USRR        D5USRR
      * SET REQ TIME TO ZERO *
     C                   Z-ADD     0             D5RQTM
      * 'N' TO CLOSE OF BUSINESS *
     C                   MOVE      'N'           D5COBR
     C                   MOVE      *BLANKS       D5JBNM
     C                   MOVE      *BLANKS       D5JUSR
     C                   MOVE      *BLANKS       D5JBNB
     C                   MOVE      D9PSQN        D5PSQR
     C                   MOVEL     D9COTT        D5COTT
     C                   MOVEL     D9CSEQ        D5CSEQ
      *
      **RETRIEVE USER BRANCH FROM MUSERDD THEN WRITE RECORD TO FCRREQPD
      *
     C     D9USRR        CHAIN     MUSER                              71
      *
     C     *IN71         IFEQ      '1'
     C                   MOVEL     'MUSER'       DBFILE
     C                   MOVEL     D9USRR        DBKEY
     C                   Z-ADD     1             DBASE
     C                   SETOFF                                           71
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      DBRN          D5DBRN
      *
      **UPDATES SEQUENCE NUMBER
      *
     C  N10              WRITE     FCRREQD0
      *
      **CHAIN TO FCPARPPD USING KEY ACCESSED ON FCPREQPD
      *
     C     ARCKEY        CHAIN     FCPARPL1                           28
      *
      **IF CHAIN SUCCESSFUL WRITE A RECORD TO FCPARDPD
      *
     C     *IN28         IFEQ      '0'
     C                   MOVE      D9RNAM        D7RNAM
     C                   MOVE      D5RQSQ        D7RQSQ
     C                   MOVEL     D8PARM        D7PARM
      *
     C  N10              WRITE     FCPARDD0
     C/COPY WNCPYSRC,FC0010C002
      *
     C                   ELSE
     C                   SETOFF                                       28
     C                   ENDIF
      *
      **IF ARCHIVED ON MICROFICHE AND/OR OPTICAL DISK = 'Y'
      **IN FCPREQPD WRITE A RECORD TO MAARCDPD
      *
     C     D9ARMF        IFEQ      'Y'
     C     D9AROD        OREQ      'Y'
      *
     C     ARCKEY        SETLL     MAARCPL2
      *
      **READ EQUAL ON LGL. FILE MAARCPL2(KEYED ON REPT.NAME & SEQ NO.)
      *
     C     ARCKEY        READE     MAARCPL2                               73
      *
     C     *IN73         IFEQ      '1'
      *
     C                   MOVEL     'MAARCPL2'    DBFILE
     C                   MOVEL     CHARCP        DBKEY
     C                   Z-ADD     2             DBASE
     C                   SETOFF                                           73
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN73         DOWEQ     '0'
     C                   MOVE      ECARID        EBARID
     C                   MOVE      D9RNAM        EBRNAM
     C                   MOVE      D5RQSQ        EBRQSQ
     C                   MOVE      ECRSFX        EBRSFX
     C                   MOVE      *BLANKS       EBCFLG
     C                   MOVE      *BLANKS       EBACFL
      *
     C  N10              WRITE     MAARCDD0
      *
     C     ARCKEY        READE     MAARCPL2                               73
     C                   ENDDO
      *
     C                   SETOFF                                           73
     C                   ENDIF
      *
      **CALLS PROGRAM FC0015 TO AMEND NEXT ACTIVE DATE
      **TO CORRECT VALUE
      *
     C                   MOVE      D9PNDT        NNXTDT            5 0
     C                   MOVE      D9FDAY        FDAY              2
      *
     C                   EVAL      PCTR+=1
     C                   EVAL      PRNAM = D9RNAM
     C                   EVAL      PPSQN = D9PSQN
     C                   EVAL      PPNDT_PN = D9PNDT
     C                   EXSR      ConvertDate
     C                   MOVE      YYYYMMDD      PPNDT_P

     C                   CALL      'FC0015'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM                    D9FREQ
     C                   PARM                    FDAY
     C                   PARM                    NNXTDT
      *
      **IF DATABASE ERROR OCCURRED IN FC0015, END PROG.
      *
     C     P@RTCD        IFEQ      '*FREQ'
     C                   MOVEL     'FCPREQPD'    DBFILE
     C                   MOVEL     CHARCP        DBKEY
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P@RTCD        IFEQ      '*FRQDAY'
     C                   MOVEL     'FCPREQPD'    DBFILE
     C                   MOVEL     CHARCP        DBKEY
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P@RTCD        IFEQ      '*AOGEL'
     C                   MOVEL     'SDGELRL1'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P@RTCD        IFEQ      '*AOBANK'
     C                   MOVEL     'SDBANKL1'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PPNDT_CN = NNXTDT
     C                   EXSR      CONVERTDATE
     C                   MOVE      YYYYMMDD      PPNDT_C
     C  N10              EVAL      PREM = ARRREM(1)
     C                   EXSR      PrintDetail1
     C* N10              EVAL      PPNDT_PN = NNXTDT
      *
     C  N10              MOVE      NNXTDT        D9PNDT
     C                   EXSR      CONVERTDATE
      *
     C  N10              UPDATE    FCPREQD0
      *
     C                   ENDIF
      *
      **READS NEXT RECORD ON FCPREQPD
      *
     C                   READ      FCPREQPD                               75
     C                   ENDDO
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTFC0841T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTFC0841E
     C                   SETON                                        LR

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     UTFC0841H1
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader2 - Print header 2                                *
      *****************************************************************

     C     PrintHeader2  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     UTFC0841H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail1  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTFC0841D1

     C                   ENDSR

      *****************************************************************
      *  PrintDetail2  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail2  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTFC0841D2

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *  ConvertDate   - Convert Date from DAYNO to YYYYMMDD          *
      *****************************************************************

     C     ConvertDate   BEGSR

     C                   CALLB     'ZDATE9'
     C                   PARM                    NNXTDT
     C                   PARM                    YYYYMMDD
     C                   PARM                    PRTN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMODE
      *
      ** Read Bank details via Access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     SDBANK        PARM                    SDBANK
      *
      ** If record not found, exit via DBERR subroutine
      *
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'UTFC0841'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CLEAR                   UTFC0841D1
     C                   CLEAR                   UTFC0841D2
     C                   CLEAR                   UTFC0841D2
      *
     C                   ENDSR

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

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**
Finastra International Limited 2019
** ARRAY REMARKS
Next Active Date has been updated
