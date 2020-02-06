     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      ****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS country details')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCRSNBRW - Midas SD CRS country details                     *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 MD036464           Date 06Nov15               *
      *                 MD036244           Date 30Oct15               *
      *                 MD036327           Date 27Oct15               *
      *                 MD036274           Date 21Oct15               *
      *                 MD036244           Date 21Oct15               *
      *                 MD036151           Date 13Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036464 - CRS Non account holder enquiry                    *
      *  MD036244 - Do not display blank subfile                      *
      *  MD036327 - Amend TIN error message                           *
      *  MD036274 - Local TIN validation changes                      *
      *  MD036244 - Change TIN header (Recompile)                     *
      *  MD036151 - F9 is allowed on enquire mode (Recompile)         *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCRSNBDF CF   E             WORKSTN
     F                                     SFILE(SDCRNBS1:@@RRN)

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
     D SVAL01          C                   CONST('CRSLocalTINMandatory')                    MD036274

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** CRS Country details 1
     D PCRSD1        E DS                  EXTNAME(SDCRNDPD)

     D PCrsdS          S            351A   DIM(30)                                            CGL177

     D CRSScrnFmt      DS
     D  DDCNTR                 1      2
     D  DDFIL1                 3      3
     D  DDSUBJ                 4      4
     D  DDFIL2                 5    174
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODQ               217    217                                                     MD036274
     D  DDJACQ               218    218                                                     MD036274
     D  DDMAIQ               219    219                                                     MD036274
     D  DDPHOQ               220    220                                                     MD036274
     D  DDRPAQ               221    221                                                     MD036274
     D  DDFIL3               222    349                                                     MD036274
     D  DDCRSA               350    350
     D  DDTINS               351    351                                                       CGL177

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @@RRN           S              5P 0
     D @@CNT           S              3P 0
     D @INKC           S              1
     D @INKI           S              1
     D @INKL           S              1
     D PMode           S              1
     D DDNAHO          S             10
     D DDACTN          S              1
     D @CUSEL          S              2
     D Y               S              4S 0
     D @@EOF           S              1
     D SVALK1          S             20                                                     MD036274
     D SVAL1           S            200                                                     MD036274
     D SVALK2          S             20                                                     MD036274
     D SVAL2           S            200                                                     MD036274
     D SVALK3          S             20                                                     MD036274
     D SVAL3           S            200                                                     MD036274
     D SVALK4          S             20                                                     MD036274
     D SVAL4           S            200                                                     MD036274
     D SVALK5          S             20                                                     MD036274
     D SVAL5           S            200                                                     MD036274
     D SVALK6          S             20                                                     MD036274
     D SVAL6           S            200                                                     MD036274
     D SVALK7          S             20                                                     MD036274
     D SVAL7           S            200                                                     MD036274
     D SVALK8          S             20                                                     MD036274
     D SVAL8           S            200                                                     MD036274
     D SVALK9          S             20                                                     MD036274
     D SVAL9           S            200                                                     MD036274
     D SVALK10         S             20                                                     MD036274
     D SVAL10          S            200                                                     MD036274
     D Ix              S              2S 0                                                  MD036274
     D Prtcd           S              7                                                     MD036274
     D PTinRq          S              1                                                     MD036274

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Initialization

     C                   EXSR      INIT

     C                   EVAL      DDNAHL = DDNAHO
     C                   TIME                    DDTIME

     C                   EVAL      *IN55 = '0'
     C                   IF        DDACTN = 'E'
     C                   EVAL      *IN55 = '1'
     C                   ENDIF

      ** Build Sub-file

     C                   IF        PMode = 'B'

     C     *INKN         DOUEQ     '0'

      * Clear program message queue
     C                   CALL      'ZA0250'

     C                   EXSR      BLDSFL

     C                   ENDDO
     C                   ENDIF

      ** Read Subfile Record

     C                   IF        PMode = 'R'
     C                   EXSR      RDSFLR
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE
      *****************************************************************
     C     BLDSFL        BEGSR

      **  Initialise subfile relative record number.

     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             @@CNT
     C                   EVAL      Y = 0
     C                   EVAL      Ix = 0                                                   MD036274
     C                   MOVEL     *BLANK        FldNameArr                                 MD036274
     C                   MOVEL     *BLANK        MsgIdArr                                   MD036274
     C                   MOVEL     *BLANK        MsgDtaArr                                  MD036274
     C                   EVAL      PTinRq = ' '                                             MD036274

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   MOVE      '0'           *IN96
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNBS0
     C                   MOVE      '0'           *IN97

      **  Load Country Details

     C                   EXSR      RDCUST

      **  set up message 'no data to display'

     C                   MOVE      *OFF          *IN80
     C                   IF        @@EOF = 'Y'
     C                   MOVE      *ON           *IN80
     C                   ENDIF

      **  Set on ROLLUP indicator to drive initial loop.

     C                   MOVE      '1'           *IN98
     C                   Z-ADD     @@RRN         DDSFRN

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C                   Z-ADD     0             @@CNT
     C                   Z-ADD     0             @@RRN

     C                   DOW       *IN98 = '1'

      **  Initialise count of records written to subfile page.

     C                   IF        @@EOF <> 'Y'
     C                   Z-ADD     0             @@CNT
     C                   ENDIF

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C                   DOW       @@EOF <> 'Y'
     C                             AND @@CNT < 10
     C                   IF        %SUBST(PCrsdS(Y):3:1) <> '*'                               CGL177

      **  Increment the records written fields.

     C                   ADD       1             @@CNT
     C                   ADD       1             @@RRN

      **  Write the country to the subfile.

     C                   MOVE      *BLANK        DDOPTN

     C                   Z-ADD     @@RRN         DDSFRN

     C                   WRITE     SDCRNBS1

     C                   ENDIF                                                                CGL177
      **  Read Country

     C                   EXSR      RDCUST
     C                   ENDDO

     C                   SETOFF                                       81
     C                   IF        @@EOF = 'Y' AND
     C                             @@CNT < 11
     C                   SETON                                        8196
     C                   SETOFF                                       97
     C                   ADD       1             @@RRN
     C                   IF        @@RRN <> 11                                              MD036244
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCRNBS1
     C                   MOVE      '0'           *IN93
     C                   ENDIF
     C                   ENDIF                                                              MD036244

      **  Set up footer toggle text and write the footer

     C                   WRITE     SDCRNBF1

      **  Write the message subfile

     D/COPY ZACPYSRC,MSGHNDDSP1                                                             MD036274
     C                   WRITE     SDCRNBM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C                   IF        @@CNT = 0
     C                             AND @@EOF <> 'Y'
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNBS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN

      **  Write to the subfile with non-display set on

     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCRNBS1
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDCRNBS0
     C                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDCRNBS0
     C                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDCRNBS0                               99

      **  If F3, bypass further processing.
     C                   IF        *INKC = '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      **  If F9, bypass further processing
     C                   IF        *INKI = '1'
     C                   MOVEL     *INKI         @INKI
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      **  If F12, bypass further processing.
     C                   IF        *INKL = '1'
     C                   MOVEL     '1'           @INKL
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************

     C     RDSFLR        BEGSR

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C                   DOU       *IN99 = '1'
     C                             OR DDOPTN <> *BLANK
     C                   READC     SDCRNBS1                               99
     C                   ENDDO

      **  Return the selected country

     C     *IN99         IFNE      '1'
     C     DDOPTN        ANDNE     *BLANK

     C                   MOVE      DDCNTR        @CUSEL

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * RDCUST - READ A CUSTOMER
      *****************************************************************

     C     RDCUST        BEGSR

      **  Reset End of File and skip record indicator

     C                   MOVE      *BLANK        @@EOF
     C                   EVAL      Y = Y + 1

     C                   EVAL      DDOPTN = *Blanks
     C                   IF        %SUBST(PCrsdS(Y):3:1) <> '*'                               CGL177
     C                   EVAL      CRSScrnFmt = PCrsdS(Y)

      ** End of File
     C                   MOVE      *OFF          *IN95                                      MD036274
     C                   IF        DDCNTR = *Blanks
     C                   MOVEL     'Y'           @@EOF
     C                   ELSE                                                               MD036274
      ** Validate country TIN details                                                       MD036274
     C                   IF        DDCNTR = BJCNCD                                          MD036274
     C                             AND DDTINN = *Blanks                                     MD036274
     C                             AND SVAL1 = 'Y'                                          MD036274
     C                             AND DDACTN <> 'E'                                        MD036464
     C                   IF        DDSUBJ = 'Y'                                             MD036274
     C                             OR (DDSUBJ = ' '                                         MD036274
     C                             AND (DDCODQ = 'Y'                                        MD036274
     C                             OR DDJACQ = 'Y'                                          MD036274
     C                             OR DDMAIQ = 'Y'                                          MD036274
     C                             OR DDPHOQ = 'Y'                                          MD036274
     C                             OR DDRPAQ = 'Y'))                                        MD036274
     C                   EVAL      PTinRq = 'Y'                                             MD036274
     C                   MOVE      *ON           *IN95                                      MD036274
     C                   ADD       1             Ix                                         MD036274
     C                   MOVEL     'DDOPTN'      FldNameArr(Ix)                             MD036274
     C                   MOVEL     'USS0657'     MsgIdArr(Ix)                               MD036274
     C                   MOVEL     DDCNTR        MsgDtaArr(Ix)                              MD036327
     C                   ENDIF                                                              MD036274
     C                   ENDIF                                                              MD036274
                                                                                            MD036274
     C                   ENDIF
     C                   ENDIF                                                                CGL177

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************

     C     INIT          BEGSR

      ** CLEAR OUTPUTS

     C                   MOVE      *BLANK        @CUSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKI
     C                   MOVE      '0'           @INKL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      * INPUT PARAMETERS :
      * RETURN CODE
      * ACTION CODE
      * Custo Ref Pointer
      * BUILD SUB-FILE
      * READ SUBFILE RECORD
      * Browse screen
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM                    PMode
     C                   PARM                    PCRSDS

      ** OUTPUT PARAMETERS :

      ** Country selected

     C                   PARM                    @CUSEL
      ** Command keys
     C                   PARM                    @INKC
     C                   PARM                    @INKI
     C                   PARM                    @INKL
     C                   PARM                    PTinRq                                     MD036274

      ** Initialize program name
     C                   MOVEL     'SDCRSNBRW'   DBPGM

      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER

     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
                                                                                            MD036274
      ** Check CRSLocalTINMandatory                                                         MD036274
     C                   CALL      'AOSVALR0'                                               MD036274
     C                   PARM                    Prtcd                                      MD036274
     C                   PARM      SVAL01        SVALK1                                     MD036274
     C                   PARM                    SVAL1                                      MD036274
     C                   PARM                    SVALK2                                     MD036274
     C                   PARM                    SVAL2                                      MD036274
     C                   PARM                    SVALK3                                     MD036274
     C                   PARM                    SVAL3                                      MD036274
     C                   PARM                    SVALK4                                     MD036274
     C                   PARM                    SVAL4                                      MD036274
     C                   PARM                    SVALK5                                     MD036274
     C                   PARM                    SVAL5                                      MD036274
     C                   PARM                    SVALK6                                     MD036274
     C                   PARM                    SVAL6                                      MD036274
     C                   PARM                    SVALK7                                     MD036274
     C                   PARM                    SVAL7                                      MD036274
     C                   PARM                    SVALK8                                     MD036274
     C                   PARM                    SVAL8                                      MD036274
     C                   PARM                    SVALK9                                     MD036274
     C                   PARM                    SVAL9                                      MD036274
     C                   PARM                    SVALK10                                    MD036274
     C                   PARM                    SVAL10                                     MD036274
                                                                                            MD036274
     C                   IF        @RTCD <> *Blanks AND                                     MD036274
     C                             @RTCD <> '*NRF'                                          MD036274
     C                   MOVEL     'SDSVALPD'    DBFILE                                     MD036274
     C                   MOVEL     '002'         DBASE                                      MD036274
     C                   MOVEL     SVALK1        DBKEY                                      MD036274
     C                   EXSR      *PSSR                                                    MD036274
     C                   ENDIF                                                              MD036274

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF


      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR
      *****************************************************************
      *
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
(c) Finastra International Limited 2015
