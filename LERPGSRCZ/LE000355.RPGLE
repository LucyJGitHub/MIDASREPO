     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS LE On Request COB Forward Manual Diary')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000355 - On Request COB Forward Manual Diary               *
      *                                                               *
      *  Function:  This function extracts Diary Events               *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055090           Date 20Jan20               *
      *  Prev Amend No. CLE070  *CREATE    Date 19Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055090 - Component LEC000355 Failed during COB             *
      *  CLE070 - Manual Diary                                        *
      *                                                               *
      *****************************************************************
     FLEMDIAL0  IF   E           K DISK    INFSR(*PSSR)
     FLEMDEXPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(P)
     FLEMDETPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(T)
     FLE000355AUO    E             PRINTER

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
     C     *ENTRY        PLIST
     C                   PARM                    INPUA             2
      *
     C                   MOVE      INPUA         INPUT             2 0
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
     C                   EVAL      DBPGM = 'LE000355'
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
     C                   EVAL      DBPGM = 'LE000355'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   EXSR      Sr_Audit
     C                   ENDIF
      *
     C                   MOVE      BCCY          ZCCY              3
      *
      **   SETUP FORWARD LIMIT DAY NUMBER
      *
     C     RUND          ADD       INPUT         LIMIT             5 0
     C                   Z-ADD     0             RWRITN                                     MD055090
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Process - Process Diary Events                            *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Process    BEGSR
      *
     C                   READ      LEMDIAL0
      *
     C                   DOW       NOT %EOF(LEMDIAL0)
      *
     C                   IF        RECI = 'D'
      *
     C     RREAD         ADD       1             RREAD             5 0
      *
     C                   IF        ACYF = *BLANKS
     C                   MOVE      *ON           *IN11
     C                   ELSE
     C                   MOVE      *OFF          *IN11
     C                   ENDIF
      *
      **   WRITE THIS RECORD IF ACTIVITY DATE FALLS BETWEEN
      **   DNWD AND LIMIT INCLUSIVE
      *
     C     ACYD          COMP      DNWD                               50  50
      *
     C     *IN50         IFEQ      *ON
     C     ACYD          COMP      LIMIT                                5050
     C                   ENDIF
      *
     C     *IN50         IFEQ      *OFF
     C                   GOTO      ENDDET
     C                   ENDIF
      *
      **   LOOP TO WRITE RECORD TO S/MDEX, COUNT RECORDS WRITTEN,
      **   CALCULATE FUTURE ACTIVITY DATES IF REQUIRED & WRITE
      **   RECORDS FOR ALL UP TO LIMIT DATE INCLUSIVE
      *
     C     LOOP          TAG
     C                   EXSR      Sr_Update
     C**********         MOVE      *OFF          *IN50                                      MD055090
     C                   IF        *IN50 = *ON                                              MD055090
     C     RWRITN        ADD       1             RWRITN            5 0
     C                   ENDIF                                                              MD055090
     C                   MOVE      *OFF          *IN50                                      MD055090
      *
     C     *IN11         IFEQ      *ON
     C                   GOTO      ENDDET
     C                   ENDIF
      *
     C                   Z-ADD     ACYD          ZDAYNO            5 0
     C                   MOVE      ACYF          ZFREQ             1
     C                   MOVE      ACDY          ZMDAY             2 0
      *
     C                   CALLB     'ZFREQB'
     C                   PARM                    RTNCDE            7
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC              3
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
     C                   Z-ADD     ZDAYNO        ACYD
      *
     C     ACYD          COMP      LIMIT                                5050
      *
     C     *IN50         IFEQ      *ON
     C     ACYD          COMP      ENDD                                 5050
     C                   GOTO      LOOP
     C                   ENDIF
      *
     C     ENDDET        TAG
     C                   EXSR      Sr_Update
      *
     C                   ENDIF
      *
     C                   READ      LEMDIAL0
      *
     C                   ENDDO
      *
     C                   MOVE      'T'           TRECI
     C                   MOVE      RWRITN        TNORE
     C                   WRITE     LEMDETF0
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
     C                   ADD       2             RREAD
      *
     C     RREAD         COMP      NORE                               4343
      *
     C     *IN43         IFEQ      *ON
     C                   MOVE      *ON           *INU8
     C                   ENDIF
      *
     C     *INU7         IFEQ      *ON
     C     *INU8         OREQ      *ON
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
     C                   WHEN      (*INU7 = *ON)
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
     C     *IN50         IFEQ      *ON
     C                   MOVE      'D'           PRECI
     C                   MOVE      DRYT          PDRYT
     C                   MOVE      NTCD          PNTCD
     C                   MOVE      CNUM          PCNUM
     C                   MOVE      ACYD          PACYD
     C                   MOVE      LNRF          PLNRF
     C                   MOVE      DYRF          PDYRF
     C                   MOVE      ACYF          PACYF
     C                   MOVE      NLN01         PNLN01
     C                   MOVE      NLN02         PNLN02
     C                   WRITE     LEMDEXF0
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
