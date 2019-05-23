     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Enquiry')                                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCRNBBRW - Midas SD CRS Enquiry                             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD040563           Date 18Aug16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD040563 - Database Error encountered when F16(List by CRS   *
      *             Indicia) is pressed from Non-Account Holder       *
      *             Enquiry main screen                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCRNBBDF CF   E             WORKSTN
     F                                     SFILE(SDCRNDBS0:WWRRN)
      * NAHO file - by Front Office Id.
     FSDCRNNL0  IF   E           K DISK    INFSR(*PSSR)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------


      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @FTR            S             30    DIM(3) CTDATA PERRCD(1)

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D LENGTH1         S              3P 0
     D LENGTH2         S              3P 0
     D START           S              3P 0
     D TRANSLATE       S              1
     D TRIM            S              1
     D WILD            S              1
     D RESULT          S              3P 0
     D WWINCL          S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Build Sub-file
      *
     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas trade number was previously
      **  being run, then build subfile keyed on Midas trade number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     *INKN         DOUEQ     '0'

      *
     C                   EXSR      BLDSFL
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE
      *****************************************************************
     C     BLDSFL        BEGSR

      **  Initialise subfile relative record number.

     C                   Z-ADD     0             WWRRN             5 0

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNDBC0
     C                   MOVE      '0'           *IN97

      **  Set file pointer on key displayed on screen.

     C     *LOVAL        SETLL     SDCRNNL0

      **  Read a Valid Customer

     C                   EXSR      RDCUST

      **  set up message 'no data to display'

     C                   MOVE      *OFF          *IN80
     C     WWEOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END

      **  Set on ROLLUP indicator to drive initial loop.

     C                   MOVE      '1'           *IN98

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C     *IN98         DOWEQ     '1'

      **  Initialise count of records written to subfile page.

     C                   Z-ADD     0             WWCNT             3 0

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C     WWEOF         DOWNE     'Y'
     C     WWCNT         ANDLT     15

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             WWRRN
     C                   ADD       1             WWCNT

      **  Write the customer to the subfile.

      **  If action code or customer number selected is invalid
      **  the subfile postions on the error record and rebuilds

     C                   MOVE      *OFF          *IN92
     C     WWRRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      *BLANK        DDOPT2
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUSN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      *BLANK        DDOPT2
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     WWRRN         DDSFRN

     C                   EVAL      DDNAHO = F2NAHO
     C                   EVAL      DDNARN = F2NARN
     C                   EVAL      DDNATW = F2NATW
     C                   EVAL      DDCTRY = F2CTRY
     C                   EVAL      DDTYPE = F2TYPE
     C                   EVAL      DDSTYP = F2STYP
     C                   EVAL      DDREPT = F2REPT
     C                   EVAL      DDCRSA = F2CRSA
     C                   EVAL      DDCODO = F2CODO
     C                   EVAL      DDJACM = F2JACM
     C                   EVAL      DDMAIL = F2MAIL
     C                   EVAL      DDPHON = F2PHON
     C                   EVAL      DDREGP = F2REGP
     C                   EVAL      DDTINS = F2TINS

     C                   WRITE     SDCRNDBS0

      **  Read a valid Customer

     C                   EXSR      RDCUST

     C                   ENDDO

     C                   MOVE      '0'           *IN91
     C     *IN96         IFEQ      '1'
     C     WWRRN         ANDEQ     0
     C                   EVAL      DDNAHO = *Blanks
     C                   EVAL      DDNARN = *Blanks
     C                   EVAL      DDNATW = *Blanks
     C                   EVAL      DDCTRY = *Blanks
     C                   EVAL      DDTYPE = *Blanks
     C                   EVAL      DDSTYP = *Blanks
     C                   EVAL      DDREPT = *Blanks
     C                   EVAL      DDCRSA = *Blanks
     C                   EVAL      DDCODO = *Blanks
     C                   EVAL      DDJACM = *Blanks
     C                   EVAL      DDMAIL = *Blanks
     C                   EVAL      DDPHON = *Blanks
     C                   EVAL      DDREGP = *Blanks
     C                   EVAL      DDTINS = *Blanks
     C                   Z-ADD     1             WWRRN
     C                   Z-ADD     WWRRN         DDSFRN
     C                   MOVE      '1'           *IN91
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNDBC0
     C                   MOVE      '0'           *IN97

      **  write to the subfile with non-display set on

     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCRNDBS0
     C                   MOVE      '0'           *IN93
     C                   ENDIF

      **  Set up footer toggle text and write the footer

     C                   WRITE     SDCRNDBF1

      **  Write the message subfile

     C                   WRITE     SDCRNDBM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C     WWCNT         IFEQ      0
     C     WWEOF         ANDNE     'Y'

     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNDBS0
     c                   MOVE      '0'           *IN97

      **  write to the subfile with non-display set on

     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCRNDBS0
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDCRNDBC0
     c                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDCRNDBC0
     c                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDCRNDBC0                              99

      ** Clear any messages before processing user input

     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr

      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END

      **  If F14, bypass further processing.
     C     *INKN         IFEQ      '1'
     C                   MOVEL     '1'           @INKN
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      **  If F16, bypass further processing.
     C     *INKQ         IFEQ      '1'
     C                   MOVEL     '1'           @INKQ
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDSFLR - READ SUBFILE RECORD
      *****************************************************************
     C     RDSFLR        BEGSR

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     DDOPT2        ORNE      *BLANK
     C                   READC     SDCRNDBS0                              99
     C                   ENDDO

      **  Return the selected customer reference and option

     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
     C     PMODE         ANDNE     'E'
     C     *IN99         ORNE      '1'
     C     DDOPT2        ANDNE     *BLANK
     C*****PMODE         ANDEQ     'E'                                                      MD040563
     C     PMODE         ANDNE     'E'                                                      MD040563

     C     PMODE         IFNE      'E'
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      DDOPT2        @OPSEL                                     MD040563
     C                   ELSE
     C                   MOVE      DDOPT2        @OPSEL
     C                   ENDIF
     C                   MOVE      DDNAHO        @CUSEL

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDCUST - READ A CUSTOMER
      *****************************************************************
     C     RDCUST        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        WWEOF             1

      **  Read the file initially - if WWEOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.

     C     WWEOF         DOUEQ     'Y'
     C     F2NAHO        ORNE      *Blanks

      **  Read the file for back office MIDAS customer number view

     C                   READ      SDCRNNL0                               96

      ** Select records according to customer number mask

     C     S1NAHO        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    F2NAHO
     C                   PARM      6             LENGTH1
     C                   PARM      1             START
     C                   PARM                    S1NAHO
     C                   PARM      6             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        F2NAHO
     C                   ENDIF
     C                   ENDIF

      ** Select records according to customer shortname mask

     C     S1NARN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    F2NARN
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    S1NARN
     C                   PARM      20            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        F2NAHO
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer report town mask

     C     S1NATW        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    F2NATW
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    S1NATW
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        F2NAHO
     C                   ENDIF
     C                   ENDIF

     C                   IF        S1CTRY <> *Blanks
     C                             AND S1CTRY <> F2CTRY
     C                   EVAL      F2NAHO = *Blanks
     C                   ENDIF

     C                   EVAL      WWINCL = ' '
     C                   IF        (S1TYPF <> ' '
     C                             AND F2TYPE = 'F')
     C                             OR (S1TYPJ <> ' '
     C                             AND F2TYPE = 'J')
     C                             OR (S1TYPO <> ' '
     C                             AND F2TYPE = 'O')
     C                             OR (S1TYPP <> ' '
     C                             AND F2TYPE = 'P')
     C                             OR (S1TYPC <> ' '
     C                             AND F2STYP = 'AC')
     C                             OR (S1TYPA <> ' '
     C                             AND F2STYP = 'PA')
     C                             OR (S1TYPU <> ' '
     C                             AND F2STYP = 'UN')
     C                             OR (S1TYPF = ' '
     C                             AND S1TYPJ = ' '
     C                             AND S1TYPO = ' '
     C                             AND S1TYPP = ' '
     C                             AND S1TYPC = ' '
     C                             AND S1TYPA = ' '
     C                             AND S1TYPU = ' ')
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF
     C                   IF        WWINCL = ' '
     C                   EVAL      F2NAHO = *Blanks
     C                   ENDIF

     C                   IF        (S1REPT <> *Blanks
     C                             AND S1REPT <> F2REPT
     C                             AND S1REPT <> 'B'
     C                             AND (S1REPT = 'Y'
     C                             OR S1REPT = 'N'))
     C                             OR (S1REPT = 'B'
     C                             AND F2REPT <> ' ')
     C                   EVAL      F2NAHO = *Blanks
     C                   ENDIF

     C                   IF        (S1CRSA <> *Blanks
     C                             AND S1CRSA <> F2CRSA
     C                             AND S1CRSA <> 'B'
     C                             AND (S1CRSA = 'Y'
     C                             OR S1CRSA = 'N'))
     C                             OR (S1CRSA = 'B'
     C                             AND F2CRSA <> ' ')
     C                   EVAL      F2NAHO = *Blanks
     C                   ENDIF

     C                   EVAL      WWINCL = ' '

     C                   IF        S1CODO = ' '
     C                             AND S1JACM = ' '
     C                             AND S1MAIL = ' '
     C                             AND S1PHON = ' '
     C                             AND S1REGP = ' '
     C                             AND S1TINS = ' '
     C                   EVAL      WWINCL = 'Y'
     C                   ELSE

     C                   IF        (S1CODO = 'B'
     C                             AND F2CODO = ' ')
     C                             OR (S1CODO = 'Y'
     C                             AND F2CODO = 'Y')
     C                             OR (S1CODO <> 'B'
     C                             AND S1CODO <> 'Y'
     C                             AND S1CODO <> *Blanks)
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF

     C                   IF        (S1JACM = 'B'
     C                             AND F2JACM = ' ')
     C                             OR (S1JACM = 'Y'
     C                             AND F2JACM = 'Y')
     C                             OR (S1JACM <> 'B'
     C                             AND S1JACM <> 'Y'
     C                             AND S1JACM <> *Blanks)
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF

     C                   IF        (S1MAIL = 'B'
     C                             AND F2MAIL = ' ')
     C                             OR (S1MAIL = 'Y'
     C                             AND F2MAIL = 'Y')
     C                             OR (S1MAIL <> 'B'
     C                             AND S1MAIL <> 'Y'
     C                             AND S1MAIL <> *Blanks)
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF

     C                   IF        (S1PHON = 'B'
     C                             AND F2PHON = ' ')
     C                             OR (S1PHON = 'Y'
     C                             AND F2PHON = 'Y')
     C                             OR (S1PHON <> 'B'
     C                             AND S1PHON <> 'Y'
     C                             AND S1PHON <> *Blanks)
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF

     C                   IF        (S1REGP = 'B'
     C                             AND F2REGP = ' ')
     C                             OR (S1REGP = 'Y'
     C                             AND F2REGP = 'Y')
     C                             OR (S1REGP <> 'B'
     C                             AND S1REGP <> 'Y'
     C                             AND S1REGP <> *Blanks)
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF

     C                   IF        (S1TINS = 'B'
     C                             AND F2TINS = ' ')
     C                             OR (S1TINS = 'Y'
     C                             AND F2TINS = 'Y')
     C                             OR (S1TINS <> 'B'
     C                             AND S1TINS <> 'Y'
     C                             AND S1TINS <> *Blanks)
     C                   EVAL      WWINCL = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        WWINCL = ' '
     C                   EVAL      F2NAHO = *Blanks
     C                   ENDIF

      ** End of File
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           WWEOF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************

     C     INIT          BEGSR

      ** CLEAR OUTPUTS

     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @CUSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKI
     C                   MOVE      '0'           @INKN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************

     C     ZEDIT         BEGSR

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************

     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      ** INPUT PARAMETERS :
      ** RETURN CODE
      ** ACTION CODE
      ** Custo Ref Pointer
      ** BUILD SUB-FILE
      ** READ SUBFILE RECORD
      ** Browse screen

     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCUSN           10
     C                   PARM                    @BDSFL            1
     C                   PARM                    @RDSFL            1
     C                   PARM                    PMode             1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** OUTPUT PARAMETERS :
      ** ERROR MESSAGE
      ** OPTION SELECTED
      ** Custo Ref. selected

     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @CUSEL           10

      ** COMMAND KEYS

     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKQ             1

      ** Initialize program name

     C                   MOVEL     'SDCRNBBRW'   DBPGM

      ** Move workstation ID to screen field.

     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER

     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ

      ** ACCESS BANK DETAILS

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** DATABASE ERROR

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   SETOFF                                       55
     C     PMODE         IFEQ      'E'
     C                   SETON                                        55
     C                   ENDIF


      ** Check if CGL154 in ON

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL154'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CGL154'
     C                   EVAL      DBASE  = 920
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   SETON                                        82
     C                   ELSE
     C                   SETOFF                                       82
     C                   ENDIF

     C                   MOVE      *BLANK        S1NAHO
     C                   MOVE      *BLANK        S1NARN
     C                   MOVE      *BLANK        S1NATW
     C                   MOVE      *BLANK        S1CTRY
     C                   MOVE      *BLANK        S1TYPF
     C                   MOVE      'Y'           S1TYPJ
     C                   MOVE      *BLANK        S1TYPO
     C                   MOVE      'Y'           S1TYPP
     C                   MOVE      *BLANK        S1TYPC
     C                   MOVE      'Y'           S1TYPA
     C                   MOVE      *BLANK        S1TYPU
     C                   MOVE      *BLANK        S1REPT
     C                   MOVE      *BLANK        S1CRSA
     C                   MOVE      *BLANK        S1CODO
     C                   MOVE      *BLANK        S1JACM
     C                   MOVE      *BLANK        S1MAIL
     C                   MOVE      *BLANK        S1PHON
     C                   MOVE      *BLANK        S1REGP
     C                   MOVE      *BLANK        S1TINS

      ** If called from Customer Details Enquiry (SDCUSDENQ),
      ** only enquire function is allowed/activated

     C                   IF        PMode = 'E'
     C                   EVAL      *IN72 = *ON
     C                   EVAL      *IN36 = *ON                                              MD040563
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   EVAL      *IN36 = *OFF                                             MD040563
     C                   ENDIF

      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2016
