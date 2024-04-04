     H DEBUG
     H CCSID(*GRAPH:*SRC)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Main Client Details Update')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCLINTUPD - CUSTOMER STANDING DATA CLINT FILE UPDATE        *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD060329  *CREATE  Date 22Jan24               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD060329 - API Performance degradation SP25                  *
      *                                                               *
      *****************************************************************

      ** UPD : Customer Master File
     FCLINT     UF A E           K DISK
     F                                     COMMIT
     F                                     IGNORE(CLINTCAF)
     F                                     IGNORE(CLINTCCF)
     F                                     IGNORE(CLINTC1F)
     F                                     IGNORE(CLINTSEF)

      ** UPD : Correspondent Details Update index
     FCGCORRL0  UF A E           K DISK    USROPN
     F                                     COMMIT

     F/COPY WNCPYSRC,SDCLINTF01

      ********************************************************************
      /EJECT
      ********************************************************************

      ** Description : Copyright notice for inclusion in all programs
     D A@CPY           DS

      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)

      * UPD : Correspondent Details Update index
     D @1DBRC        E DS                  EXTNAME(CGCORRL0)

      **  Sar Text details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Modules Data Structure
     D MMODDS        E DS                  EXTNAME(SDMMODPD)

      ** Get Rundate - Rundate
     D RUNDTA        E DS                  EXTNAME(RUNDAT)

      ** Program data structure
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)

      ** Data Structures used by Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ********************************************************************
      /EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *                                                                  *
      *  Initial process - defines entry parameter list, key for client  *
      *                    file and reads client detail record.          *
      *                                                                  *
      *------------------------------------------------------------------*

      ** Define entry parameter list.
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    WCUST             6
     C                   PARM                    WCSSN            10
     C                   PARM                    WCRTN            10
     C                   PARM                    WPAIN             1
     C                   PARM                    WCRNM            20
     C                   PARM                    WACOC             2
     C                   PARM                    WCNCZ             2
     C                   PARM                    WCOLC             2
     C                   PARM                    WSSDT             5 0
     C                   PARM                    WDOIC             5 0
     C                   PARM                    WPCNB             6
     C                   PARM                    WCASC             8
     C                   PARM                    WBRCD             3
     C                   PARM                    WBNBI             1
     C                   PARM                    WLINC             2
     C                   PARM                    WLICD             3
     C                   PARM                    WCTNB            12
     C                   PARM                    WREID             4
     C                   PARM                    WBSIN             1
     C                   PARM                    WCSTY             1
     C                   PARM                    WTAIN             1
     C                   PARM                    WCSID            12
     C                   PARM                    WSTAD            12
     C                   PARM                    WTXA1            10
     C                   PARM                    WCHID             6 0
     C                   PARM                    WCHSC             6 0
     C                   PARM                    WCABA             3 0
     C                   PARM                    WRWCD             4
     C                   PARM                    WCGRP             1
     C                   PARM                    WABA2             4 0
     C                   PARM                    WTYLC             1
     C                   PARM                    WLCD              5 0
     C                   PARM                    WGPC1             4
     C                   PARM                    WGPC2             4
     C                   PARM                    WGPC3             4
     C                   PARM                    WGPC4             4
     C                   PARM                    WGPC5             4
     C                   PARM                    WLNID             2
     C                   PARM                    WCTYP            10

     C/COPY WNCPYSRC,SDCLINTC01

      ** Call initialise only once
     C     #FIRST        IFNE      'Y'
     C                   EXSR      SRINIT
     C                   ENDIF

      ** Define client file key.
     C     CLKEY         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    RCDT

      ** Read client file detail record.
     C                   MOVE      WCUST         CNUM
     C                   MOVE      'A'           RCDT
     C     CLKEY         CHAIN     CLINTCBF                           30

      ********************************************************************
      /EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *                                                                  *
      *  Main process.                                                   *
      *                                                                  *
      *  Calls subroutines:   MAPDTA                                     *
      *                       ERROR                                      *
      *                                                                  *
      *------------------------------------------------------------------*

      ** Code for last change type - insert.
     C     WTYLC         IFEQ      'I'

     C     *IN30         IFEQ      '1'

      ** Client detail record not found, therefore map data
     C                   EXSR      MAPDTA

      ** and write new record.
     C                   WRITE     CLINTCBF                             31

      ** Error on write.
     C     *IN31         IFEQ      '1'
     C                   EXSR      ERROR
     C                   ENDIF

      ** End of record not found code.
     C                   ENDIF

     C     *IN30         IFEQ      '0'

      ** Record found
     C     RECI          IFEQ      '*'

      ** Record is a previous deletion, therefore map data
     C                   EXSR      MAPDTA

      ** and update existing record.
     C                   UPDATE    CLINTCBF                             32
     C                   ENDIF

      ** Record exists and not previous deletion or update fails,
     C     RECI          IFNE      '*'
     C     *IN32         OREQ      '1'

      ** therefore error.
     C                   EXSR      ERROR
     C                   ENDIF

      ** End of record found code.
     C                   ENDIF

      ** Write or Update Correspondence File if needed
     C     BGN1ST        IFEQ      'Y'
     C     CCG001        ANDEQ     'CCG001'
     C/COPY WNCPYSRC,SDCLINTC02
     C                   EXSR      SRCORR
     C                   ENDIF

      ** End of change type - insert code.
     C                   ENDIF

      ** Code for last change type - amend or delete.
     C     WTYLC         IFEQ      'A'
     C     WTYLC         OREQ      'D'

      ** Record not found,
     C     *IN30         IFEQ      '1'

      ** therefore error.
     C                   EXSR      ERROR
     C                   ENDIF

      ** Record found.
     C     *IN30         IFEQ      '0'

      ** But record previously deleted,
     C     RECI          IFEQ      '*'

      ** therefore error.
     C                   EXSR      ERROR
     C                   ENDIF

      ** Record valid.
     C     RECI          IFEQ      'D'

      ** For last change type of amend, map data,
     C     WTYLC         IFEQ      'A'
     C                   EXSR      MAPDTA
     C                   ELSE

      ** else, only update last change date and type.
     C                   MOVE      'C'           RECI
     C                   Z-ADD     WLCD          LCD
     C                   MOVE      WTYLC         CHTP
     C                   Z-ADD     WLCD          DADE
     C                   ENDIF

      ** Update record.
     C                   UPDATE    CLINTCBF                             32
     C     *IN32         IFEQ      '1'

      ** Error if update fails.
     C                   EXSR      ERROR
     C                   ENDIF

      ** End of record valid code.
     C                   ENDIF
     C/COPY WNCPYSRC,SDCLINTC09

      ** End of record found code.
     C                   ENDIF
     C/COPY WNCPYSRC,SDCLINTC07

      ** End of change type amend/delete code.
     C                   ENDIF

      ********************************************************************
      /EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *                                                                  *
      *  Final process - updates insert/delete/amend totals of client    *
      *                  file control record.                            *
      *  Calls subroutine :   ERROR                                      *
      *                                                                  *
      *------------------------------------------------------------------*

     C                   MOVEL     'CLINTCA'     CLINTNAM         10
     C                   Z-ADD     *ZEROS        NUMTINS           5 0
     C                   Z-ADD     *ZEROS        NUMTDEL           5 0
     C                   Z-ADD     *ZEROS        NUMTAMD           5 0

      ** Determine which total field to update, then update.
      ** Insert
     C     WTYLC         IFEQ      'I'
     C                   Z-ADD     1             NUMTINS
     C                   ENDIF

      ** Delete
     C     WTYLC         IFEQ      'D'
     C                   Z-ADD     1             NUMTDEL
     C                   ENDIF

      ** Amend
     C     WTYLC         IFEQ      'A'
     C                   Z-ADD     1             NUMTAMD
     C                   ENDIF

      ** Start commitment control
     C/EXEC SQL
     C+ SET OPTION COMMIT = *CHG
     C/END-EXEC

      ** Write record to SDCLINTPP file
     C/EXEC SQL
     C+ insert into SDCLINTPP
     C+ (
     C+   CLNFILE
     C+ , CLNTINS
     C+ , CLNTDEL
     C+ , CLNTAMD
     C+ )
     C+ Values
     C+ (
     C+   :CLINTNAM
     C+ , :NUMTINS
     C+ , :NUMTDEL
     C+ , :NUMTAMD
     C+ )
     C/END-EXEC

      ** Write error detected.
     C                   IF        SQLCOD <> *Zero
     C                   EXSR      ERROR
     C                   ENDIF

     C/COPY WNCPYSRC,SDCLINTC06

     C/COPY WNCPYSRC,SDCLINTC05

     C                   MOVE      '1'           *INLR
     C                   RETURN

      ********************************************************************
      /EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *  Index to subroutines.                                           *
      *                                                                  *
      *  MAPDTA - maps data from entry parameter list to CLINTCB fields. *
      *  ERROR  - sends error return message to calling programme.       *
      *                                                                  *
      *  MAPDTA subroutine - maps data from entry parameter list to      *
      *                      CLINTCB fields.                             *
      *  Called by main process.                                         *
      *                                                                  *
      *  Input  - *ENTRY PLIST.                                          *
      *  Output - CLINTCB fields.                                        *
      *                                                                  *
      *------------------------------------------------------------------*

     C     MAPDTA        BEGSR

     C                   MOVE      'D'           RECI
     C                   MOVE      WCUST         CNUM
     C                   MOVE      'A'           RCDT
     C                   MOVE      WCRNM         CRNM
     C                   MOVE      WCRTN         CTWN
     C                   MOVE      WCSSN         CSNM
     C                   MOVE      WCASC         CASK
     C                   MOVEL     WTXA1         TELX
     C                   MOVEL     WCSID         CSID
     C                   MOVE      WACOC         ACOC
     C                   MOVE      WBSIN         CBSI
     C                   MOVE      WCNCZ         CCTZ
     C                   MOVE      WCOLC         CLOC
     C                   MOVE      WPCNB         CPAR
     C                   MOVE      WBRCD         BRCB
     C                   MOVE      WLINC         LINS
     C                   MOVE      WLICD         LOIC
     C                   Z-ADD     WSSDT         DASU
     C                   Z-ADD     WDOIC         CDIC
     C                   MOVEL     WRWCD         RWCD
     C                   MOVEL     WCGRP         CUGRP
     C                   MOVEL     WABA2         CAB2
     C                   MOVEL     WGPC1         GPC1
     C                   MOVEL     WGPC2         GPC2
     C                   MOVEL     WGPC3         GPC3
     C                   MOVEL     WGPC4         GPC4
     C                   MOVEL     WGPC5         GPC5

     C     WTYLC         IFEQ      'D'
     C                   Z-ADD     WLCD          DADE
     C                   ENDIF

      ** Set of customer master indicators.
     C                   BITOFF    '01234'       CMIN
     C     WBNBI         IFEQ      'Y'
     C                   BITON     '0'           CMIN
     C                   ENDIF
     C     WTAIN         IFEQ      'Y'
     C                   BITON     '1'           CMIN
     C                   ENDIF
     C     WPAIN         IFEQ      'P'
     C                   BITON     '2'           CMIN
     C                   ENDIF

     C                   MOVE      WCSTY         CTYP
     C                   MOVE      WCTNB         TELF
     C     WCHID         IFNE      *ZERO
     C                   MOVEL     WCHID         CHID
     C                   ELSE
     C                   MOVEL     *BLANK        CHID
     C                   ENDIF
     C                   MOVE      WCABA         CHAB
     C                   MOVE      WCSSN         DRSN

     C     WTXA1         IFNE      *BLANKS
     C                   MOVE      'T'           SWTX
     C                   ENDIF

     C                   MOVEL     WSTAD         STTX

     C     CSID          IFNE      *BLANKS
     C     WSTAD         ORNE      *BLANKS
     C     WTXA1         ORNE      *BLANKS
     C                   MOVE      'Y'           GSFM
     C                   ELSE
     C                   MOVE      *BLANKS       GSFM
     C                   ENDIF

     C                   MOVE      WREID         RTID
     C                   Z-ADD     WLCD          LCD
     C                   MOVE      WTYLC         CHTP

     C                   ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *                                                                  *
      *  ERROR subroutine - deals with CHAIN, WRITE and UPDATE errors.   *
      *                                                                  *
      *  Called by main process.                                         *
      *                                                                  *
      *  Output  - error flag to calling programme.                      *
      *------------------------------------------------------------------*

     C     ERROR         BEGSR

     C                   MOVE      '*ERROR*'     P0RTN
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C/COPY WNCPYSRC,SDCLINTC03

     C                   ENDSR

      ********************************************************************
     C/EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *                                                                  *
      *  SRINIT   : Initialisation                                       *
      *                                                                  *
      *  CALLED BY: Main processing                                      *
      *                                                                  *
      *  CALLS    : None                                                 *
      *                                                                  *
      *------------------------------------------------------------------*
     CSR   SRINIT        BEGSR

      ** Indicate that set up is complete
     C                   MOVEL     'Y'           #FIRST            1

      ** Check to see if User Defined Correspondance is installed.
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST '     ##OPTN            7
     C     MMODDS        PARM      *BLANKS       DSFDY

      ** If return with an error (LR seton in called program) then
      ** process for database error.
     C     *IN90         IFEQ      '1'
     C     ##RTCD        OREQ      '*ERROR*'
     C                   EXSR      ERROR
     C                   ENDIF

      ** Exit if UDC not installed
     C     BGN1ST        CABNE     'Y'           EXINIT

      ** Get Rundate - Rundate
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA

      ** Determine which SARs are in effect
      ** Write or Update Correspondent Details direct
     C                   CALL      'AOSARDR0'                           90
     C                   PARM      '       '     ##RTCD            7
     C                   PARM      '*VERIFY'     ##OPTN            7
     C                   PARM      'CCG001'      ##SARD            6
     C     SCSARD        PARM      *BLANKS       DSFDY

      ** If the Access Object returns an error code, process a
      ** database error.
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C     *IN90         OREQ      *ON
     C                   EXSR      ERROR
     C                   ENDIF

     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'CCG001'      CCG001            6
     C/COPY WNCPYSRC,SDCLINTC08
     C                   ENDIF

      ** Open CGCORRL0
     C                   OPEN      CGCORRL0

     C     EXINIT        TAG

     CSR                 ENDSR

     C/COPY WNCPYSRC,SDCLINTC04

      ********************************************************************
     C/EJECT
      ********************************************************************
      *------------------------------------------------------------------*
      *                                                                  *
      *  SRCORR   : Update or Write Correspondent record                 *
      *                                                                  *
      *  CALLED BY: Main processing                                      *
      *                                                                  *
      *  CALLS    : None                                                 *
      *                                                                  *
      *------------------------------------------------------------------*
     CSR   SRCORR        BEGSR

      ** Access Correspondent file to see if exists or not
     C                   MOVEL(P)  WCUST         CDCORR

     C     CDCORR        CHAIN     @CORRL0                            90
     C/COPY WNCPYSRC,SDCLINTC10

      ** If live error
     C     *IN90         IFEQ      '0'
     C     CDRECI        ANDEQ     'D'
     C/COPY WNCPYSRC,SDCLINTC12
     C                   EXSR      ERROR
     C                   ENDIF
     C/COPY WNCPYSRC,SDCLINTC11

      ** Clear and set fields
     C                   CLEAR                   @CORRL0
     C                   MOVEL(P)  WCUST         CDCORR
     C                   MOVEL     'D'           CDRECI
     C                   MOVEL     WCUST         CDCUST
     C     WCTYP         IFEQ      *BLANKS
     C                   MOVEL     'DEFAULT'     CDCTYP
     C                   ELSE
     C                   MOVEL     WCTYP         CDCTYP
     C                   ENDIF
     C                   MOVEL     'C'           CDRTYP
     C                   MOVEL     WLNID         CDLGID
     C                   EVAL      CDCORN = WCRNM + WCRTN
     C                   Z-ADD     AGRDNB        CDCDTE
     C                   MOVEL     'N'           CDPLAB
     C                   Z-ADD     AGRDNB        CDATDT
     C                   MOVEL     'Default'     CDCSTR
     C     WCUST         CAT(P)    WCRNM         CDDESC
     C                   MOVEL     ##JOB         CDAJOB
     C                   MOVEL     ##USR         CDAUSR
     C                   TIME                    CDATIM
     C                   MOVEL     AGMRDT        CDARDT
     C                   MOVEL     'I'           CDAACT
     C                   Z-ADD     AGRDNB        CDRDNB

      ** Copy source for customer Specific changes
     C/COPY WNCPYSRC,SDCLINTCOR

      ** Write record if not found else update
     C     *IN90         IFEQ      '1'
     C                   WRITE     @CORRL0                              90
     C                   ELSE
     C                   UPDATE    @CORRL0                              90
     C                   ENDIF

      ** If error on update on write
     C     *IN90         IFEQ      '1'
     C                   EXSR      ERROR
     C                   ENDIF

     CSR                 ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2024
