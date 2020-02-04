     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('MIDAS LE Daily Manual Diary Extract')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000356 - On Request COB Forward Manual Diary               *
      *                                                               *
      *  Function:  This function extracts Diary Events               *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055140           Date 30Jan20               *
      *  Prev Amend No. MD055155           Date 27Jan20               *
      *                 CLE070  *CREATE    Date 19Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055140 - Fix Header Alignment of Forward Diary Report      *
      *             (Recompile)                                       *
      *  MD055155 - LE000356  compilation failed (Recompile)          *
      *  CLE070 - Manual Diary                                        *
      *                                                               *
      *****************************************************************
     FLEMDEXL0  IF   E           K DISK    INFSR(*PSSR)
     FLE000356AUO    E             PRINTER
     FLE000356P1O    E             PRINTER OFLIND(P1OVERFLOW)

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
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Manual Diary Types code record format data structure
      *
     D SDMNDR        E DS                  EXTNAME(SDMNDRPD)
      *
      ** DS for Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D NARR60          DS
     D   NLN01                 1     30
     D   NLN02                31     60
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
     C                   MOVE      INPUA         FRWRD             2 0
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
     C                   EVAL      DBPGM = 'LE000356'
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
     C                   MOVE      *ON           *IN41
      *
     C                   WRITE     HEADP1
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
     C                   MOVE      *BLANKS       WKDRYT            2
      *
     C                   READ      LEMDEXL0
      *
     C                   DOW       NOT %EOF(LEMDEXL0)
      *
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN43
      *
     C     RECI          IFEQ      'T'
     C                   LEAVE
     C                   ENDIF
      *
     C     RECI          IFEQ      'D'
      *
     C                   IF        DRYT = *BLANKS
     C                   MOVE      *ON           *IN11
     C                   ELSE
     C                   MOVE      *OFF          *IN11
     C                   ENDIF
      *
     C                   IF        CNUM = *BLANKS
     C                   MOVE      *ON           *IN12
     C                   ELSE
     C                   MOVE      *OFF          *IN12
     C                   ENDIF
      *
     C                   IF        LNRF = *BLANKS
     C                   MOVE      *ON           *IN16
     C                   ELSE
     C                   MOVE      *OFF          *IN16
     C                   ENDIF
      *
     C     RECRDS        ADD       1             RECRDS            5 0
     C                   MOVE      RECRDS        RECRDS2           5 0
     C                   MOVE      *ON           *IN43
      *
     C     DRYT          IFNE      WKDRYT
     C     *IN11         ANDNE     *ON
      *
     C                   MOVE      *OFF          *IN06
     C                   MOVE      DRYT          DRYTA             2
      *
     C                   CALL      'AOMNDRR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DRYTA         KEYCCD            2
     C     SDMNDR        PARM      SDMNDR        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       TABNAR
     C                   ELSE
     C                   MOVE      *ON           *IN06
     C                   MOVE      AVDYNV        TABNAR           30
     C                   ENDIF
      *
     C                   IF        P1OVERFLOW
     C                   WRITE     HEADP1
     C                   EVAL      P1OVERFLOW = *OFF
     C                   ELSE
     C                   WRITE     HEADP2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      DRYT          WKDRYT
      *
     C                   MOVE      *OFF          *IN04
      *
     C     *IN12         IFEQ      *OFF
      *
     C                   MOVEL     CNUM          KEYC
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    KEYC             10
     C                   PARM                    KEYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   ELSE
     C                   MOVE      *ON           *IN04
     C                   MOVEL     BBCRTN        CTWN             10
     C                   MOVEL     BBCRNM        CRNM             20
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ACYD
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   ENDIF
      *
     C     ENDDET        TAG
      *
     C                   IF        P1OVERFLOW
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   EVAL      P1OVERFLOW = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETLP1
      *
     C                   READ      LEMDEXL0
      *
     C                   ENDDO
      *
     C     RECRDS        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
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
     C     RECRDS        COMP      NORE                               4444
      *
     C     *IN44         IFEQ      *ON
     C                   MOVE      *ON           *INU8
     C                   ENDIF
      *
     C     RECRDS        COMP      0                                      45
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
     C                   WHEN      *INU7 = *ON and *INU8 = *ON
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
