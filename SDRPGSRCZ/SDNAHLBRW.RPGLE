     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Browse')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLBRW - Non-account Holders Browse                       *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of non-account holders         *
      *             for Selection, the other picks off the            *
      *             Selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 03Aug17               *
      *  Prev Amend No. MD052599           Date 13Apr20               *
      *                 CSD102             Date 08Jan19               *
      *                 MD040639           Date 22Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL132             Date 01May13               *
      *                 AR740749           Date 25May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233295             Date 29Apr05               *
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender Fields for Non-Account Holder *
      *           (Recompile)                                         *
      *  MD052599 - BFM2.1 Logically deleted Non-account Holder       *
      *             dropped from the Maintenance screen. Remove       *
      *             checking of NHCHTP, and add display of DELETE     *
      *             and disable DDOPT for the deleted record.         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD040639 - Hats compatibility issue (Recompile)              *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  AR740749 - Non Account Holder Maintenance Usability Issues   *
      *             (Child: AR740750) (Recompile)                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSW207 - Swift 2007 Standard Changes (Recompile)             *
      *  233295 - Deletion problems on Non-account Holders.           *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDNAHLBDF CF   E             WORKSTN
     F                                     Sfile(SDNAHLS1:@@RRN)
     F                                     Sfile(SDNAHLS3:@@RRN)
     F                                     Infds(INFDS#)

      ** Non-A/C Holders file - by Non-account Holder Reference
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDNAHOD0:NAHOREF)

      ** Non-A/C Holders file - by Front Office Id.
     FSDNAHOL2  IF   E           K Disk    Infsr(*PSSR)
     F                                     Rename(SDNAHOD0:NAHOSFO)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        Disk    Infsr(*pssr)

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

     DINFDS#           DS
     D Min_rrn               378    379I 0


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @opsel          S              1A   Dim(ArrayMax)
     D @nasel          S             10A   Dim(ArrayMax)
     D @FTR            S             30    Dim(2) CTDATA PERRCD(1)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  Extname(DSFDY)
      ** External DS for SAR Details                                                          CGL177
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL177

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Working fields for calling QCLSCAN
     D LENGTH1         S              3  0
     D START           S              3  0
     D LENGTH2         S              3  0
     D TRANSLATE       S              1
     D TRIM            S              1
     D WILD            S              1
     D RESULT          S              3  0

      ** ZVACTU
     D ZACTN           S              1
     D @@ERR           S              1  0

      ** ZEDIT
     D ZFIELD          S             16
     D ZADEC           S              1  0

      ** ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

      ** entry parameter
     D DDACTN          S              1
     D DDNAHO          S             10
     D @BDSFL          S              1
     D @RDSFL          S              1
     D @IN36           S              1
     D @IN81           S              1                                                       CGL132
     D @ERRMS          S              7
     D @INKC           S              1
     D @INKI           S              1

     D @@NAHO          S             10
     D @@RRN           S              5  0
     D @@CNT           S              3  0
     D @@FOTD          S             20
     D @@EOF           S              1
     D WNAHO           S              1

     D X               S              3  0
     D @rrn            S              5  0
     D #FldNameArr     S            200
     D PRTCD           S              7                                                       CGL177
     D POPTN           S              7                                                       CGL177
     D PSARD           S              6                                                       CGL177

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

      ** Set up the Non-A/C Holder Reference to be used by the message handler

     C                   EVAL      TranRef = DDNAHO
     C                   EVAL      ActionCode = DDACTN
     C                   EVAL      *In36      = @in36
     C                   EVAL      *IN81 = @IN81                                              CGL132

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Initialization

     C                   EXSR      SRInit

      ** Build Sub-file

     C     @BDSFL        IFEQ      'Y'

      **  If First time in or subfile by Midas Non-A/C Holder Reference was previously
      **  being run, then build subfile keyed on Midas Non-A/C Holder Reference.
      **  Stay in loop while F11 toggle key is used.

     C     WNAHO         IFNE      'F'
     C                   MOVE      'B'           WNAHO

     C                   ENDIF

     C     *InKK         DOUEQ     *Off

      ** On F11, initialize position/select fields

     C     *InKK         IFEQ      *On

     C                   MOVE      *BLANK        SENAHO
     C                   MOVE      *BLANK        SEFODN
     C                   MOVE      *BLANK        SENARN
     C                   MOVE      *BLANK        SENATW
     C                   EVAL      *In98 = *Off

      ** Clear program message queue

     C                   CALL      'ZA0250'

     C                   ENDIF

     C     WNAHO         CASEQ     'B'           SRBLDSFL
     C     WNAHO         CASEQ     'F'           SRBLDSFL2
     C                   ENDCS
     C                   ENDDO

     C                   ENDIF

      ** Read Subfile Record

     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      SRRdSflr
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      ********************************************************************
      ** SRBldSfl - BUILD SUBFILE
      ********************************************************************

     C     SRBldSfl      BEGSR

      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING

     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChautN
     C                   ENDIF

     C                   IF        #FldNameArr <> *blanks
     C                   EXSR      SRGetErr
     C                   EVAL      *In90 = *On
     C                   GOTO      Dspl1
     C                   ENDIF

     C                   MOVE      DDNAHO        @@NAHO

     C                   IF        *In98 = *Off

      **  Initialise subfile relative record number.

     C                   Z-ADD     0             @@RRN
     C                   EVAL      *In95 = *Off

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   MOVE      *On           *In97
     C                   WRITE     SDNAHLS0
     C                   MOVE      *Off          *In97

      **  Set file pointer on key displayed on screen.

     C     *LOVAL        SETLL     NAHOREF

      **  Read a Valid Non-account Holder

     C                   EXSR      SRRdNaho
     C                   EVAL      *In98 = *On
     C                   EVAL      *In95 = *Off
     C                   ENDIF

      **  Set up message 'No Data to Display'

     C                   MOVE      *Off          *In80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *On           *In80
     C                   ENDIF


      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the END of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C     load1         TAG
     C                   IF        *In98 = *On

      **  Initialise count of records written to subfile page.

     C                   Z-ADD     0             @@CNT

      **  For each record read, write it to the subfile.
      **  Do this until END of file or the subfile page is full.

     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14

      ****Load*records*with*status*not*'D'.****************************

     C**********         IF        NHCHTP <> 'D'                                            MD052599

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT

      **  Format Non-A/C Holder fields for output

     C                   EXSR      SRFmtNah

      **  Write the Non-account holder to the subfile.

      **  If Action Code or Non-account holder selected is invalid
      **  the subfile postions on the error record and rebuilds

     C                   MOVE      *Off          *In92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDNAHO    '  LOOKUP    FldNameArr                             98
     C     *In99         IFNE      *On
     C     *In98         ANDNE     *On
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *On           *In92
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDNAHLS1

     C**********         ENDIF                                                              MD052599

      **  Read a valid Non-account holder

     C                   EXSR      SRRdNaho

     C                   END

      **  Set up footer toggle text and write the footer

     C     Dspl1         TAG
                                                                                              233295
      ** Show 'No Data to Display' if necessary.                                              233295
                                                                                              233295
     C                   IF        *IN80 = *OFF AND                                           233295
     C                             @@EOF = 'Y' AND                                            233295
     C                             @@CNT = *ZERO                                              233295
     C                   EVAL      *IN80 = *ON                                                233295
     C                   ENDIF                                                                233295
                                                                                              233295
     C                   MOVE      @FTR(1)       TOGLTEXT
     C                   WRITE     SDNAHLF1

      **  Write the message subfile

     C                   WRITE     SDNAHLM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C     @@CNT         IFEQ      0
     C                   MOVE      *On           *In97
     C                   WRITE     SDNAHLS0
     c                   MOVE      *Off          *In97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
     C                   EVAL      DDOPT = *BLANK                                             233295

      **  write to the subfile with non-display set on

     C                   MOVE      *On           *In93
     C                   MOVE      *On           *In91                                      MD052599
     C                   WRITE     SDNAHLS1
     C                   MOVE      *Off          *In93
     C                   MOVE      *Off          *In91                                      MD052599
     C                   WRITE     SDNAHLS0
     C                   ELSE

      **  write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDNAHLS0
     C                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDNAHLS0                               99

      ** Clear any messages before processing user input

     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr

     C                   SELECT

      **  If F3, bypass further processing.

     C                   WHEN      *Inkc = *On
     C                   MOVEL     *ON           @INKC
     C                   EVAL      *InLR = *On
     C                   RETURN

      **  If F9, bypass further processing.

     C                   WHEN      *Inki = *On
     C                   MOVEL     'I'           @OPSEL(1)
     C                   EVAL      *InLR = *On
     C                   RETURN

      ** Set indicator and flag for Midas Front Office I.D. browse key used

     C                   WHEN      *Inkk = *On
     C                   MOVE      'F'           WNAHO

      **  If Rollup, load sfl.

     C                   WHEN      *In98 = *On
     C                   GOTO      Load1
                                                                                              CGL132
     C                   WHEN      *INKN = *ON                                                CGL132
     C                   MOVEL     *ON           @INKN             1                          CGL132
     C                   RETURN                                                               CGL132
                                                                                              CGL177
     C                   WHEN      *INKQ = *ON                                                CGL177
     C                   MOVEL     *ON           @INKQ             1                          CGL177
     C                   RETURN                                                               CGL177

     C                   ENDSL

     C                   END

     C                   ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
      ** SRBldSfl2 - Build Subfile by Front Office ID.
      ********************************************************************

     C     SRBldSfl2     BEGSR

      ** Check for user Authority to Browse if not multi-branching

     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChautN
     C                   ENDIF

     C                   IF        #FldNameArr <> *Blanks
     C                   EXSR      SRGetErr
     C                   EVAL      *In90 = *On
     C                   GOTO      Dspl2
     C                   ENDIF

     C                   MOVE      DDNAHO        @@NAHO

      **  Get Front Office Non-account Holder Reference

     C                   IF        *In98 = *Off

     C     @@NAHO        CHAIN     NAHOREF                            89
     C                   MOVE      NHFRNT        @@FOTD
     C     *In89         IFEQ      *On
     C                   MOVE      *BLANK        @@FOTD
     C                   ENDIF

      **  Initialise subfile relative record number.

     C                   Z-ADD     0             @@RRN

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   MOVE      *On           *In97
     C                   WRITE     SDNAHLS2
     C                   MOVE      *Off          *In97

      **  Set file pointer on key displayed on screen.

     C     @@FOTD        SETLL     NAHOSFO

      ** Read a Valid Trade

     C                   EXSR      SRRdNaho
     C                   EVAL      *In95 = *Off
     C                   EVAL      *In98 = *On
     C                   ENDIF

      **  set up message 'no data to display'

     C                   MOVE      *Off          *In80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *On           *In80
     C                   ENDIF

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the END of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C     load2         TAG
     C                   IF        *In98 = *On

      **  Initialise count of records written to subfile page.

     C                   Z-ADD     0             @@CNT

      **  For each record read, write it to the subfile.
      **  Do this until END of file or the subfile page is full.

     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14

      **  Load records with status not 'D'.

     C**********         IF        NHCHTP <> 'D'                                            MD052599

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT

      ** Format Non-A/C Holder fields for output

     C                   EXSR      SRFmtNah

      **  write the Non-A/C Holder to the subfile.

      **  If action code or Non-A/C Holder reference selected is invalid,
      **  the subfile postions on the error record and rebuilds

     C                   MOVE      *Off          *In92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDNAHO    '  LOOKUP    FldNameArr                             98
     C     *In99         IFNE      *On
     C     *In98         ANDNE     *On
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *On           *In92
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDNAHLS3

     C**********         ENDIF                                                              MD052599

      ** Read a valid Non-A/C Holder

     C                   EXSR      SRRdNaho
     C                   END

      **  Set up footer toggle text and write the footer

     C     Dspl2         TAG
                                                                                              233295
      ** Show 'No Data to Display' if necessary.                                              233295
                                                                                              233295
     C                   IF        *IN80 = *OFF AND                                           233295
     C                             @@EOF = 'Y' AND                                            233295
     C                             @@CNT = *ZERO                                              233295
     C                   EVAL      *IN80 = *ON                                                233295
     C                   ENDIF                                                                233295
                                                                                              233295
     C                   MOVE      @FTR(2)       TOGLTEXT
     C                   WRITE     SDNAHLF1

      **  write the message subfile

     C                   WRITE     SDNAHLM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C     @@CNT         IFEQ      0
     c                   MOVE      *On           *In97
     C                   WRITE     SDNAHLS2
     c                   MOVE      *Off          *In97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
     C                   EVAL      DDOPT = *BLANK                                             233295

      **  write to the subfile with non-display set on

     C                   MOVE      *On           *In93
     C                   MOVE      *On           *In91                                      MD052599
     C                   WRITE     SDNAHLS3
     C                   MOVE      *Off          *In93
     C                   MOVE      *Off          *In91                                      MD052599
     C                   WRITE     SDNAHLS2
     C                   ELSE

      **  write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDNAHLS2
     C                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDNAHLS2                               99

      ** Clear any messages before processing user input

     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr

     C                   SELECT

      **  If F3, bypass further processing.

     C                   WHEN      *Inkc = *On
     C                   MOVEL     *ON           @INKC
     C                   EVAL      *InLR = *On
     C                   RETURN

      **  If F9, bypass further processing.

     C                   WHEN      *Inki = *On
     C                   MOVEL     'I'           @OPSEL(1)
     C                   EVAL      *InLR = *On
     C                   RETURN

      ** Set indicator and flag for Midas (back) office Non-A/C Holder number key

     C                   WHEN      *Inkk = *On
     C                   MOVE      'B'           WNAHO

      **  If Rollup, load sfl.

     C                   WHEN      *In98 = *On
     C                   GOTO      Load2
                                                                                              CGL132
     C                   WHEN      *INKN = *ON                                                CGL132
     C                   MOVEL     *ON           @INKN             1                          CGL132
     C                   RETURN                                                               CGL132
                                                                                              CGL177
     C                   WHEN      *INKQ = *ON                                                CGL177
     C                   MOVEL     *ON           @INKQ                                        CGL177
     C                   RETURN                                                               CGL177

     C                   ENDSL

     C                   END

     C                   ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
      ** SRRdSflR - Read Subfile Record
      ********************************************************************

     C     SRRdSflR      BEGSR

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C                   EVAL      x = 0
     C                   MOVEA     *blanks       @opsel
     C                   MOVEA     *blanks       @nasel
     C     *In99         DOWEQ     *Off

     C                   IF        Min_rrn > *zeros
     C                   EVAL      ddsfrn = Min_rrn
     C                   EVAL      @rrn   = Min_rrn
     C                   ENDIF

     C     WNAHO         IFEQ      'B'
     C                   READC     SDNAHLS1                               99
     C                   ENDIF

     C     WNAHO         IFEQ      'F'
     C                   READC     SDNAHLS3                               99
     C                   ENDIF

      **  RETURN the selected Non-A/C Holder reference and option

     C                   IF        *In99 = *Off  and
     C                             DDOPT <> *blank

     C                   EVAL      x = x + 1
     C                   EVAL      @opsel(X) = DDOPT
     C                   EVAL      @nasel(X) = DDNAHO

     C                   EVAL      *In95 = *Off

     C     WNAHO         IFEQ      'B'
     C                   UPDATE    SDNAHLS1
     C                   ENDIF

     C     WNAHO         IFEQ      'F'
     C                   UPDATE    SDNAHLS3
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C     EBLDSF        ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRGetErr - Get error.
      *****************************************************************

     C     SRGetErr      BEGSR

     C                   EVAL      @@cnt = 0
     C                   EVAL      x = 1

     C                   DOW       @opsel(x) <> ' '

     C                   SELECT

      ** Read subfile to get the record with error.

     C                   WHEN      wnaho = 'B'
     C     @rrn          CHAIN     SDNAHLS1                           99
     C                   DOW       *In99 = *Off and
     C                             @@cnt < 14

     C                   IF        DDnaho =  @NASEL(X)

     C                   IF        FldNameArr(X) <> *blanks
     C                   EVAL      *In95 = *On
     C                   EVAL      *In90 = *On
     C                   ELSE
     C                   EVAL      *In95 = *Off
     C                   ENDIF

     C                   UPDATE    sdnahls1
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      @@CNT = @@cnt + 1
     C                   EVAL      @rrn  = @rrn + 1
     C     @rrn          CHAIN     SDNAHLS1                           99
     C                   ENDDO

      ** Read subfile to get the record with error.

     C                   WHEN      wnaho = 'F'
     C     @rrn          CHAIN     SDNAHLS3                           99
     C                   DOW       *In99 = *Off   and
     C                             @@cnt < 14

     C                   IF        DDnaho =  @NASEL(X)

     C                   IF        FldNameArr(X) <> *blanks
     C                   EVAL      *In95 = *On
     C                   EVAL      *In90 = *On
     C                   ELSE
     C                   EVAL      *In95 = *Off
     C                   ENDIF

     C                   UPDATE    SDNAHLS3
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      @@CNT = @@cnt + 1
     C                   EVAL      @rrn  = @rrn + 1
     C     @rrn          CHAIN     SDNAHLS3                           99
     C                   ENDDO

     C                   ENDSL

     C                   EVAL      x = x  + 1
     C                   ENDDO

     C     EGetEr        ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRFmtNah - Format Non-account Holder for Output
      ******************************************************************

     C     SRFmtNah      BEGSR

      ** Non-account Holder Reference

     C                   MOVE      NHNAHO        DDNAHO
     C                   MOVE      NHNARN        DDNARN
     C                   MOVE      NHNATW        DDNATW
     C** If Type of Last Change (NHSCHTP) is equals to 'D', it will be                      MD052599
     C** indicated as 'DELETED' in the subfile. Else,  leave the                            MD052599
     C** indicator field as blank.                                                          MD052599
     C*                                                                                     MD052599
     C     'D'           IFEQ      NHCHTP                                                   MD052599
     C                   MOVE      'DELETED'     DDNAST                                     MD052599
     C                   MOVE      *On           *In91                                      MD052599
     C                   ELSE                                                               MD052599
     C                   MOVE      *BLANK        DDNAST                                     MD052599
     C                   MOVE      *Off          *In91                                      MD052599
     C                   ENDIF                                                              MD052599

      ** Front Office Non-account Holder

     C                   MOVE      NHFRNT        DDFODN

     C                   ENDSR

      ******************************************************************
      /EJECT
      *****************************************************************
      ** SRRdNaho - Read a Non-account Holder
      *****************************************************************

     C     SRRdNaho      BEGSR

      **  Reset END of File and skip record indicator

     C                   MOVE      *BLANK        @@EOF

      **  Read the file initially - if @@EOF is set on then the END of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.

     C     @@EOF         DOUEQ     'Y'
     C     NHNAHO        ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO

      **  Read the file for back office MIDAS Non-account Holder view

     C     WNAHO         IFEQ      'B'

      **  Position according to Non-account Holder

     C     SENAHO        IFNE      *BLANK
     C     SENAHO        SETLL     NAHOREF                            89
     C                   READ      NAHOREF                                96
     C                   MOVE      *BLANK        SENAHO
     C                   ELSE
     C                   READ      NAHOREF                                96
     C                   ENDIF

      ** Select according to Report name mask

     C     SENARN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    NHNARN
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SENARN
     C                   PARM      20            LENGTH2
     C                   PARM      *On           TRANSLATE
     C                   PARM      *On           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    Result

     C     Result        IFLT      1
     C                   MOVE      *BLANK        NHNAHO
     C                   ENDIF
     C                   ENDIF

      ** Select according to Report town mask

     C     SENATW        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    NHNATW
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SENATW
     C                   PARM      10            LENGTH2
     C                   PARM      *On           TRANSLATE
     C                   PARM      *On           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    Result

     C     Result        IFLT      1
     C                   MOVE      *BLANK        NHNAHO
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      **  Read the file for Front Office ID view

     C     WNAHO         IFEQ      'F'

      **  Position according to front office ID

     C     SEFODN        IFNE      *BLANK
     C     SEFODN        SETLL     NAHOSFO                            89
     C                   READ      NAHOSFO                                96
     C                   MOVE      *BLANK        SEFODN
     C                   ELSE
     C                   READ      NAHOSFO                                96
     C                   ENDIF

      ** Select records according to Non-account Holder mask

     C     SENAHO        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    NHNAHO
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SENAHO
     C                   PARM      10            LENGTH2
     C                   PARM      *On           TRANSLATE
     C                   PARM      *On           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    Result

     C     Result        IFLT      1
     C                   MOVE      *BLANK        NHNAHO
     C                   ENDIF
     C                   ENDIF

      ** Select records according to Non-account Holder report town mask

     C     SENATW        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    NHNATW
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SENATW
     C                   PARM      10            LENGTH2
     C                   PARM      *On           TRANSLATE
     C                   PARM      *On           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    Result

     C     Result        IFLT      1
     C                   MOVE      *BLANK        NHNAHO
     C                   ENDIF
     C                   ENDIF

     C                   END

      ** END of File

     C     *In96         IFEQ      *On
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF

     C                   ENDDO

     C     ERDNAHO       ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRChautN - Check for user authority if not multi-branching
      *****************************************************************

     C     SRChautN      BEGSR

     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    @@ERR

      ** RETURN error message

     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRInit - Initialisation
      *****************************************************************

     C     SRInit        BEGSR

      ** Clear outputs

     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *Off          @INKC
     C                   MOVEA     FldNameArr    #fldnamearr
     C                   EVAL      *In90 = *Off

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRZedit - Edit an unsigned field                             *
      *****************************************************************

     C     SRZedit       BEGSR

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRZdate2 - Format a date for output                          *
      *****************************************************************

     C     SRZdate2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   ENDSR

      ********************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

     C     *Entry        PLIST

      ** Input Parameters :

      ** RETURN Code
      ** Action Code
      ** Non-A/C Holder Ref Pointer
      ** Build Subfile
      ** Read Subfile Record
      ** Browse screen

     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM                    @BDSFL
     C                   PARM                    @RDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    @IN36
     C                   PARM                    @IN81                                        CGL132

      ** Output Parameters :

      ** Error Message
      ** Option selected
      ** Non-A/C Holder selecetd
      ** Command Keys
     C                   PARM                    @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @NASEL
     C                   PARM                    @INKC
     C                   PARM                    @INKI
     C                   PARM                    @INKN                                        CGL132
     C                   PARM                    @INKQ                                        CGL177

      ** Initialize program name

     C                   MOVEL     'SDNAHLBRW'   Dbpgm

      ** Move workstation ID to screen field.

     C                   MOVEL     PsJobName     Ddwid
     C                   MOVEL     PsUser        Dduser

     C                   MOVE      *On           *In94
     C                   MOVEL     '*'           Ddpgmq

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CGL177
      ** Access SAR details to check if CGL157 is installed                                   CGL177
                                                                                              CGL177
     C                   EVAL      *IN82 = *OFF                                               CGL177
     C                   CALLB     'AOSARDR0'                                                 CGL177
     C                   PARM      *BLANKS       PRTCD                                        CGL177
     C                   PARM      '*VERIFY'     POPTN                                        CGL177
     C                   PARM      'CGL157'      PSARD                                        CGL177
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL177
                                                                                              CGL177
     C     PRTCD         IFNE      *BLANKS                                                    CGL177
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL177
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL177
     C                   MOVEL     '905'         DBASE                                        CGL177
     C                   MOVEL     @SARD         DBKEY                                        CGL177
     C                   EXSR      *PSSR                                                      CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C     PRTCD         IFEQ      *BLANKS                                                    CGL177
     C                   EVAL      *IN82 = *ON                                                CGL177
     C                   ENDIF                                                                CGL177

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
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
(c) Finastra International Limited 2004
**  @FTR
F11=Toggle Front Office I.D.
F11=Toggle Non-account Holder