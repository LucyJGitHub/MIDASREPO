     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS LE Daily Manual Diary Extract')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000354 - Midas LE Daily Manual Extract                     *
      *                                                               *
      *  Function:  This function extracts Diary Events               *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055140           Date 30Jan20               *
      *  Prev Amend No. CLE070  *CREATE    Date 19Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055140 - Fix Header Alignment of Forward Diary Report      *
      *  CLE070 - Manual Diary                                        *
      *                                                               *
      *****************************************************************
     FLEMDIAL1  IF   E           K DISK    INFSR(*PSSR)
     FLEDIAML0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DIARYMEF:DIARYMXF)
     F                                     PREFIX(WF)
     FLEDIATPD  UF   E             DISK    INFSR(*PSSR)
     FLE000354AUO    E             PRINTER

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      **
      **   Named constants
      **   ===============
      **

      **
      **   Arrays and Data Structures
      **   ==========================
      **
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for General Ledger Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      *
      ** DS for Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Do initialization everytime
      *
     C                   EXSR      Sr_Init
      *
     C                   EXSR      Sr_Process
      *
     C                   EXSR      Sr_Audit
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Init - Initialization Subroutine                          *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Init       BEGSR
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  1
     C                   EVAL      DBPGM = 'LE000354'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   EXSR      Sr_Audit
     C                   ENDIF
      *
     C                   MOVE      '0'           *IN98
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
     C                   MOVE      BJMRDT        RUNA              7
     C                   MOVE      BJRDNB        RUND              5 0
     C                   MOVE      BJURPT        TITL             53
     C                   MOVE      BJCYCD        BCCY              3
     C                   Z-ADD     BJDNWD        DNWD              5 0
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPGM = 'LE000354'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   EXSR      Sr_Audit
     C                   ENDIF
      *
     C                   Z-ADD     BKAPDT        APDA              5 0
     C                   MOVE      BCCY          ZCCY              3
     C                   Z-ADD     2             RECRDS
      *
     C                   ENDSR
      *
     1*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Process - Process Diary Events                            *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Process    BEGSR
      *
     C                   READ      LEMDIAL1
      *
     C                   DOW       NOT %EOF(LEMDIAL1)
      *
     C                   MOVE      *OFF          *IN43
     C                   MOVE      *OFF          *IN44
     C                   MOVE      *OFF          *IN48
      *
      **   COUNT DETAIL RECORDS READ FROM DIARY.
      *
     C     RECI          IFEQ      'D'
      *
     C     RECRDS        ADD       1             RECRDS            5 0
      *
     C                   IF        ACYF = *BLANKS
     C                   MOVE      *ON           *IN13
     C                   ELSE
     C                   MOVE      *OFF          *IN13
     C                   ENDIF
      *
      **   FLAG RECORD FOR DELETION IF DNWD GREATER THAN END DATE.
      *
     C     DNWD          COMP      ENDD                               43
     C     *IN43         IFEQ      *ON
     C     DELETS        ADD       1             DELETS            5 0
     C     RECRDS        SUB       1             RECRDS
     C                   GOTO      ENDDET
     C                   ENDIF
      *
      **   IF ACTIVITY DATE LESS THAN DNWD
      **   PERFORM KEPT REPORTING
      *
     C     ACYD          COMP      DNWD                                 44
     C     *IN44         IFEQ      *ON
      *
      **   IF ACTIVITY DATE LESS THAN DNWD, & IF
      **   FREQUENCY IS NON- BLANK, PERFORM ACTIVITY DATE UPDATING
      *
     C     *IN13         IFEQ      *ON
     C                   GOTO      ENDDET
     C                   ELSE
      *
     C     ACYD          COMP      DNWD                                 48
      *
     C     LOOP          TAG
      *
     C     *IN49         IFEQ      *OFF
     C                   Z-ADD     ACYD          ZDAYNO
     C                   ENDIF
      *
     C                   MOVE      ACYF          ZFREQ             1
     C                   Z-ADD     ACDY          ZMDAY             2 0
     C                   CALLB     'ZFREQB'
     C                   PARM                    RTNCDE            7
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
      *
     C     RTNCDE        IFEQ      'Error'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   EXSR      Sr_Audit
     C                   ENDIF
      *
      **   IF NEW DATE CALCULATED IS LESS THAN OR EQUAL TO
      **   DNWD, RECALCULATE.
      *
     C     ZDAYNO        COMP      DNWD                                 4949
     C     *IN49         IFEQ      *ON
     C     ZDAYNO        COMP      0                                  4949
     C                   ENDIF
      *
     C     *IN49         IFEQ      *ON
     C                   GOTO      LOOP
     C                   ENDIF
      *
     C     *IN48         IFEQ      *ON
     C     ZDAYNO        COMP      ENDD                                 4848
     C                   ENDIF
      *
     C     *IN44         IFEQ      *ON
     C                   MOVE      *ON           *IN48
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **   UPDATE FILE CONTROLS IF RECORDS HAVE BEEN DELETED
      *
     C     ENDDET        TAG
      *
     C                   ENDIF
      *
     C                   EXSR      Sr_Update
      *
     C                   READ      LEMDIAL1
      *
     C                   ENDDO
      *
     C                   MOVE      *OFF          *IN43
     C                   MOVE      *OFF          *IN48
      *
     C                   READ      LEDIATPD
     C     NORE          SUB       DELETS        NOREOP            5 0
     C     NLRB          SUB       DELETS        NLRBOP            5 0
     C                   MOVE      *ON           *IN02
     C                   EXSR      Sr_Update
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Audit - Output audit report                               *
      *                                                               *
      *****************************************************************
     C     Sr_Audit      BEGSR
      *
      **   COMPARE RUN CONTROLS.
      *
     C     NORE          COMP      RECRDS                             1515
      *                                                                                     MD055140
     C     *IN15         IFEQ      *ON                                                      MD055140
     C                   MOVE      *ON           *INU8                                      MD055140
     C                   ENDIF                                                              MD055140
      *
      **   CALCULATE NUMBER OF LIVE RECORDS AFTER RUN.
      *
     C                   MOVE      RECRDS        NLIVE             5 0
     C     *INU7         IFEQ      *ON
     C     *INU8         OREQ      *ON                                                      MD055140
     C                   DUMP
     C                   ENDIF
      *
      ** Output report header
      *
     C                   WRITE     HEADAU
      *
     C                   SELECT
      *
      ** If DB error occured, print the DB error information
      *
     C                   WHEN      *INU7 = *ON
     C                   WRITE     DBERROR
      *
      ** If records were processed, print file control details
      *
     C                   OTHER
     C                   WRITE     CONTROL
      *
     C                   ENDSL
      *
      ** Set on last record indicator and end program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Update - Update files                                     *
      *                                                               *
      *****************************************************************
     C     Sr_Update     BEGSR
      *
     C     *IN02         IFEQ      *ON
     C                   MOVE      NOREOP        NORE
     C                   MOVE      NLRBOP        NLRB
     C                   UPDATE    DIARYT1F
     C                   ENDIF
      *
     C     *IN43         IFEQ      *ON
     C     *IN48         OREQ      *ON
     C     DYRF          CHAIN     LEDIAML0
     C     *IN43         IFEQ      *ON
     C                   MOVE      '*'           WFRECI
     C                   MOVE      'D'           WFCHTP
     C                   MOVE      BJRDNB        WFLCD
     C                   ENDIF
     C     *IN48         IFEQ      *ON
     C                   MOVE      ZDAYNO        WFACYD
     C                   ENDIF
     C                   UPDATE    DIARYMXF
     C                   ENDIF
      *
     C                   IF        RECI = '*'
     C     LCD           ADD       365           WPURGE            5 0
     C                   IF        WPURGE <= BJRDNB
     C     DYRF          CHAIN     LEDIAML0
     C                   DELETE    DIARYMXF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Handling Subroutine                    *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        RUNBEFORE = *BLANK
     C                   EVAL      RUNBEFORE = 'Y'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2019
