     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD AML trans. analysis mapping table browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDAMLMBRW - AML Transaction Analysis Mapping Table           *
      *              Maintenance Browse                               *
      *                                                               *
      *  Function:   This module will build sub-file of AML codes     *
      *              mapping table and picks off the selected record  *
      *              for processing.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDAMLMBDF CF   E             WORKSTN
     F                                     SFILE(SDAMLMS1:#1SFRN)

      ** AML Transaction file by Midas Transaction Retail Type
     FSDAMLML1  IF   E           K DISK    INFSR(*PSSR) RENAME(SDAMLMD0:SDAMLD1)

      ** AML Transation file by Deal Type/Sub-Type
     FSDAMLML2  IF   E           K DISK    INFSR(*PSSR) RENAME(SDAMLMD0:SDAMLD2)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  29 - Protect field indicator                                 *
      *  30 - Error indicator                                         *
      *  31 - Error indicator                                         *
      *  32 - Error indicator                                         *
      *  33 - Error indicator                                         *
      *  81 - Subfile Clear indicator                                 *
      *  82 - Subfile End indicator                                   *
      *  83 - Subfile Next Change indicator                           *
      *  98 - Rollup Indicator                                        *
      *  KC - F3 Exit                                                 *
      *  KE - F5 Refresh                                              *
      *  KI - F9 (Insert/Amend)                                       *
      *  KL - F12 Cancel                                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit      - Initialisation processing                      *
      *  SRBuildSFL  - Build Sub-File                                 *
      *  SRSFLPag    - Build Sub-File Page                            *
      *  SRReadChg   - Read Change in Sub-file                        *
      *  SRReadSFL   - Read Sub-File processing                       *
      *  SRUpdSFL    - Update Sub-File                                *
      *  SRRdsSFL    - Redisplay Subfile                              *
      *  SRRtvTxt    - Retrieve text                                  *
      *  SRReadRec   - Read a record AML transaction mapping file     *
      *  SRErrId     - Output error message without data              *
      *  SRErrDta    - Output error message with data                 *
      *  *INZSR      - Program Initialisation                         *
      *  *PSSR       - DB Error Processing                            *
      *                                                               *
      *****************************************************************

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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.

      /COPY ZACPYSRC,MSGHNDDCL

      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.

      /COPY ZACPYSRC,APICTLARR

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

     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96

     D CurScnDS        DS
     D  #1TTYP                 1      5
     D  #1DTYP                 6      7
     D  #1STYP                 8      9
     D  #1AMLT                10     34

     D PrvScnDS        DS
     D  #1TTYH                 1      5
     D  #1DTYH                 6      7
     D  #1STYH                 8      9
     D  #1AMLH                10     34

     D POrigScn        DS
     D  W1TTYH                 1      5
     D  W1DTYH                 6      7
     D  W1STYH                 8      9
     D  W1AMLH                10     34

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))

      ** Parameter
     D PDSPTYPE        S              1A
     D PACTN           S              1A
     D PRTTY           S              5A
     D PDLTP           S              2A
     D PDLST           S              2A
     D PAMLT           S             25A
     D PACTNOK         S              1A
     D PRTTYOK         S              1A
     D PDLTPOK         S              1A
     D PDLSTOK         S              1A
     D PAMLTOK         S              1A
     D PRTTYKEY        S              5A
     D PDLTPKEY        S              2A
     D PDLSTKEY        S              2A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKI           S              1A
     D PINKL           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PMsgId          S              7A
     D PMsgFNm         S             10A
     D PMsgDesc        S             80A
     D PSFLACTN        S              2A

      ** Work fields
     D W@CNT           S              3P 0
     D W@CTR           S              3P 0
     D W@RRN           S              4P 0
     D WErrPtr         S              4P 0
     D C               S              3P 0
     D WZMsgFile       S             10A
     D WZMsgId         S             10A
     D WZMsgData       S             45A
     D WMsgId          S              7A
     D WMsgDta         S             45A

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

      ** Initialization

     C                   EXSR      SRInit

      ** Build Sub-file

     C     PSFLACTN      CASEQ     'BS'          SRBuildSFL

      ** Read Sub-file

     C     PSFLACTN      CASEQ     'RE'          SRReadCHG

      ** Update Sub-File

     C     PSFLACTN      CASEQ     'UP'          SRUpdSFL

      ** Redisplay Sub-File

     C     PSFLACTN      CASEQ     'RD'          SRRdsSFL

     C                   ENDCS

      ** Return to calling program

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation processing                           *
      *                                                               *
      *****************************************************************

     C     SRInit        BEGSR

     C                   EVAL      *INKC = PINKC
     C                   EVAL      *INKL = PINKL
     C                   EVAL      *INKE = PINKE
     C                   EVAL      *INKI = PINKI

      ** Set subfile indicator to 'A' for the first pass

     C                   IF        PDSPTYPE = *BLANK
     C                   EVAL      PDSPTYPE = 'A'
     C                   ENDIF

      ** Protect selection fields

     C                   IF        PDSPTYPE = 'I'
     C                   EVAL      *IN29 = TRUE
     C                   ELSE
     C                   EVAL      *IN29 = FALSE
     C                   ENDIF

      ** Format Header

     C                   EVAL      #0MRDT = BJMRDT
     C                   EVAL      #0PROF = PSUSER
     C                   EVAL      #0WID =  PSJOBNAME

      ** Clear program message queue

     C                   CALL      'ZA0250'

      ** Set up key

     C                   EVAL      #1STTP = PRTTYKEY
     C                   EVAL      #1SDTP = PDLTPKEY
     C                   EVAL      #1SSTP = PDLSTKEY

      ** Write error messages to subfile when error or warning messages
      ** found

     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     MsgIdArr(C)   ANDNE     *Blank
     C                   MOVEL     MsgIdArr(C)   WMsgId
     C                   MOVEL     MsgDtaArr(C)  WMsgDta
     C                   IF        WMsgDta = *Blanks
     C                   EXSR      SRErrID
     C                   Else
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO

     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WMsgIdArr(C)  ANDNE     *Blank
     C                   MOVEL     WMsgIdArr(C)  WMsgId
     C                   MOVEL     WMsgDtaArr(C) WMsgDta
     C                   IF        WMsgDta = *Blanks
     C                   EXSR      SRErrID
     C                   ELSE
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuildSFL - Build Sub-File                                  *
      *                                                               *
      *****************************************************************

     C     SRBuildSFL    BEGSR

      ** Build subfile

     C                   EXSR      SRSFLPag

     C                   EVAL      PRTTYKEY = #1STTP
     C                   EVAL      PDLTPKEY = #1SDTP
     C                   EVAL      PDLSTKEY = #1SSTP

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSFLPag - Build Sub-File Page                                *
      *                                                               *
      *****************************************************************

     C     SRSFLPag      BEGSR

      ** Initialise subfile relative record number.

     C                   Z-ADD     0             W@RRN

      ** Clear subfile before filling by writing control record
      ** with SFLCLR active.

     C                   EVAL      *IN81 = TRUE
     C                   WRITE     SDAMLMC1
     C                   EVAL      *IN81 = FALSE

      ** Reset EndOfFile indicator

     C                   EVAL      EndOfFile = FALSE

      ** Amend mode

     C                   IF        PDSPTYPE = 'A'

      ** Setup footer

     C                   EVAL      PMsgID = 'USR9660'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TRLR = PMsgDesc

      ** Set file pointer on key displayed on screen.

     C                   SELECT

     C                   WHEN      (#1STTP <> *BLANK)
     C     KFLDList1     SETLL     SDAMLML1
     C                   WHEN      (#1SDTP <> *BLANK) OR
     C                             (#1SSTP <> *BLANK)
     C     KFLDList2     SETLL     SDAMLML2
     C                   OTHER
     C     *LOVAL        SETLL     SDAMLML1
     C     *LOVAL        SETLL     SDAMLML2

     C                   ENDSL

      ** Read all function code records

     C                   EXSR      SRReadRec

     C                   ENDIF

      ** Set footer for 'I'nsert mode

     C                   IF        PDSPTYPE = 'I'
     C                   EVAL      PMsgID = 'USR9661'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TRLR = PMsgDesc
     C                   ENDIF

      ** Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      *IN98 = TRUE

      ** Initialise record counter

     C                   Z-ADD     0             W@CTR

      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is taken

     C                   DOW       *IN98 = TRUE

      ** Initialise count of records written to subfile page.

     C                   Z-ADD     0             W@CNT

      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.

     C                   DOW       (EndOfFile = FALSE) AND (W@CNT < 14) OR
     C                             (PDSPTYPE = 'I') AND (W@CNT < 14)

      ** Increment the subfile record no. and records written fields.

     C                   ADD       1             W@RRN
     C                   ADD       1             W@CNT
     C                   ADD       1             W@CTR

      ** Write details to subfile for amend mode and blank record for insert

     C                   Z-ADD     W@RRN         #1SFRN

     C                   IF        PDSPTYPE = 'A'
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1TTYP = W6RTTY
     C                   EVAL      #1DTYP = W6DLTP
     C                   EVAL      #1STYP = W6DLST
     C                   EVAL      #1AMLT = W6AMLT
     C                   ELSE
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1TTYP = *BLANK
     C                   EVAL      #1DTYP = *BLANK
     C                   EVAL      #1STYP = *BLANK
     C                   EVAL      #1AMLT = *BLANK
     C                   ENDIF

      ** Save the current screen values

     C                   EVAL      PrvScnDS = CurScnDS

     C                   WRITE     SDAMLMS1

      ** Read next record for amend mode

     C                   IF        PDSPTYPE = 'A'
     C                   EXSR      SRReadRec
     C                   ENDIF

     C                   ENDDO

      ** Set the sub file end indicator if end of file encountered

     C                   IF        EndOfFile = TRUE
     C                   EVAL      *IN82 = TRUE
     C                   ELSE
     C                   EVAL      *IN82 = FALSE
     C                   ENDIF

      ** Write Header and Footer

     C                   WRITE     SDAMLMH0
     C                   WRITE     SDAMLMH1
     C                   WRITE     SDAMLMF0

      ** Write the message sub-file

     C                   WRITE     SDAMLMC0

      ** If there is no data to display write no record found and execute
      ** sub-header

     C                   IF        W@CTR = 0
     C                   WRITE     SDAMLMF1
     C                   EXFMT     SDAMLMH1

      ** If selection fields are blank, set on F5 function key indicator to
      ** rebuild the sub-file

     C                   IF        (*INKC = FALSE) AND (*INKE = FALSE) AND
     C                             (*INKI = FALSE) AND (*INKL = FALSE)
     C                   IF        (#1STTP = *BLANK) AND (#1SDTP = *BLANK) AND
     C                             (#1SSTP = *BLANK)
     C                   EVAL      *INKE = TRUE
     C                   ENDIF
     C                   ENDIF

      ** Reset rollup indicator

     C                   EVAL      *IN98 = FALSE

     C                   ELSE

      ** Write the subfile control record to the screen to display
      ** the subfile.

     C                   WRITE     SDAMLMC1

      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.

     C                   EXFMT     SDAMLMC1
     C                   ENDIF

      ** Clear message arrays

     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr

     C                   SELECT

      ** If F3, bypass further processing.

     C                   WHEN      *INKC = TRUE
     C                   EVAL      PINKC = TRUE
     C                   RETURN

      ** F5, clear necessary fields and arrays

     C                   WHEN      *INKE = TRUE
     C                   EVAL      PINKE = TRUE

     C                   EVAL      #1STTP = *BLANK
     C                   EVAL      #1SDTP = *BLANK
     C                   EVAL      #1SSTP = *BLANK

     C                   EVAL      PRTTYKEY = #1STTP
     C                   EVAL      PDLTPKEY = #1SDTP
     C                   EVAL      PDLSTKEY = #1SSTP

     C                   RETURN

      ** F9 or F12 switch to appropriate subfile screens

     C                   WHEN      (*INKI = TRUE) OR (*INKL = TRUE)
     C                   IF        *INKI = TRUE
     C                   EVAL      PINKI = TRUE
     C                   ENDIF
     C                   IF        *INKL = TRUE
     C                   EVAL      PINKL = TRUE

      ** Clear selection field

     C                   EVAL      #1STTP = *BLANK
     C                   EVAL      #1SDTP = *BLANK
     C                   EVAL      #1SSTP = *BLANK
     C                   ENDIF

     C                   EVAL      PRTTYKEY = #1STTP
     C                   EVAL      PDLTPKEY = #1SDTP
     C                   EVAL      PDLSTKEY = #1SSTP

     C                   IF        PDSPTYPE = 'A'
     C                   EVAL      PDSPTYPE = 'I'
     C                   ELSE
     C                   EVAL      PDSPTYPE = 'A'
     C                   ENDIF

     C                   RETURN

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadChg - Read Change in Sub-file                          *
      *                                                               *
      *****************************************************************

     C     SrReadChg     BEGSR

      ** Reposition subfile pointer to top of subfile

     C                   EVAL      #1SFRN = 1

      ** Read changes in subfile

     C                   IF        W@CTR <> 0
     C                   EXSR      SRReadSFL
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadSFL - Read Sub-File processing                         *
      *                                                               *
      *****************************************************************

     C     SRReadSFL     BEGSR

      ** Read the subfile for selected records

     C                   READC     SDAMLMS1                               99

      ** Return the selected record

     C                   IF        (*IN99 = FALSE)
     C                   EVAL      PACTN = #1ACTN
     C                   EVAL      PRTTY = #1TTYP
     C                   EVAL      PDLTP = #1DTYP
     C                   EVAL      PDLST = #1STYP
     C                   EVAL      PAMLT = #1AMLT
     C                   EVAL      POrigScn = PrvScnDS
     C                   ELSE
     C                   EVAL      PACTN = *BLANK
     C                   EVAL      PRTTY = *BLANK
     C                   EVAL      PDLTP = *BLANK
     C                   EVAL      PDLST = *BLANK
     C                   EVAL      PAMLT = *BLANK
     C                   EVAL      POrigScn = *BLANKS
     C                   ENDIF

     C                   EVAL      *INKC = FALSE
     C                   EVAL      *INKL = FALSE
     C                   EVAL      *INKE = FALSE
     C                   EVAL      *INKI = FALSE

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdSFl   - Update Sub-File                                 *
      *                                                               *
      *****************************************************************

     C     SRUpdSFL      BEGSR

     C                   IF        PACTNOK <> 'Y'
     C                   EVAL      *IN30 = TRUE
     C                   ENDIF

     C                   IF        PRTTYOK <> 'Y'
     C                   EVAL      *IN31 = TRUE
     C                   ENDIF

     C                   IF        PDLTPOK <> 'Y'
     C                   EVAL      *IN32 = TRUE
     C                   ENDIF

     C                   IF        PDLSTOK <> 'Y'
     C                   EVAL      *IN33 = TRUE
     C                   ENDIF

     C                   IF        PAMLTOK <> 'Y'
     C                   EVAL      *IN34 = TRUE
     C                   ENDIF

      ** Error on screen fields

     C                   IF        (*IN(30) <> '00000')
     C                   EVAL      #1ACTN = PACTN
     C                   EVAL      #1TTYP = PRTTY
     C                   EVAL      #1DTYP = PDLTP
     C                   EVAL      #1STYP = PDLST
     C                   EVAL      #1AMLT = PAMLT
     C                   IF        WErrPtr = 0
     C                   EVAL      WErrPtr = #1SFRN
     C                   ENDIF
     C                   ENDIF

      ** Set on SFLNXTCHG indicator to force the system to read the subfile
      ** record even without a change

     C                   EVAL      *IN83 = TRUE
     C                   UPDATE    SDAMLMS1
     C                   EVAL      *IN83 = FALSE

      ** Initialise ok flags and error indicators

     C                   EVAL      PACTNOK = 'Y'
     C                   EVAL      PRTTYOK = 'Y'
     C                   EVAL      PDLTPOK = 'Y'
     C                   EVAL      PDLSTOK = 'Y'
     C                   EVAL      PAMLTOK = 'Y'
     C                   EVAL      *IN30 = FALSE
     C                   EVAL      *IN31 = FALSE
     C                   EVAL      *IN32 = FALSE
     C                   EVAL      *IN33 = FALSE
     C                   EVAL      *IN34 = FALSE

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdsSFL   - Redisplay Subfile                               *
      *                                                               *
      *****************************************************************

     C     SRRdsSFL      BEGSR

      ** If WErrPtr is not zero, set subfile relative record no. by WErrPtr

     C                   IF        WErrPtr <> 0
     C                   EVAL      #1SFRN = WErrPtr
     C                   ENDIF

     C                   EVAL      WErrPtr = 0

      ** Reset EndOfFile indicator

     C                   EVAL      EndOfFile = FALSE

      ** Setup footer for 'A'mend mode

     C                   IF        PDSPTYPE = 'A'
     C                   EVAL      PMsgID = 'USR9660'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TRLR = PMsgDesc
     C                   ENDIF

      ** Set footer for 'I'nsert mode

     C                   IF        PDSPTYPE = 'I'
     C                   EVAL      PMsgID = 'USR9661'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TRLR = PMsgDesc
     C                   ENDIF

      ** Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      *IN98 = TRUE

      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is taken

     C                   DOW       *IN98 = TRUE

      ** Write Header and Footer

     C                   WRITE     SDAMLMH0
     C                   WRITE     SDAMLMH1
     C                   WRITE     SDAMLMF0

      ** Write the message sub-file

     C                   WRITE     SDAMLMC0

      ** Write the subfile control record to the screen to display
      ** the subfile.

     C                   WRITE     SDAMLMC1

      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.

     C                   EXFMT     SDAMLMC1

      ** Clear message arrays

     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr

     C                   SELECT

      ** If F3, bypass further processing.

     C                   WHEN      *INKC = TRUE
     C                   EVAL      PINKC = TRUE
     C                   RETURN

      ** F5, clear necessary fields and arrays

     C                   WHEN      *INKE = TRUE
     C                   EVAL      PINKE = TRUE

     C                   EVAL      #1STTP = *BLANK
     C                   EVAL      #1SDTP = *BLANK
     C                   EVAL      #1SSTP = *BLANK

     C                   EVAL      PRTTYKEY = #1STTP
     C                   EVAL      PDLTPKEY = #1SDTP
     C                   EVAL      PDLSTKEY = #1SSTP

     C                   RETURN

      ** F9 or F12 is pressed

     C                   WHEN      (*INKI = TRUE) OR (*INKL = TRUE)
     C                   IF        *INKI = TRUE
     C                   EVAL      PINKI = TRUE
     C                   ENDIF
     C                   IF        *INKL = TRUE
     C                   EVAL      PINKL = TRUE

      ** Clear selection field

     C                   EVAL      #1STTP = *BLANK
     C                   EVAL      #1SDTP = *BLANK
     C                   EVAL      #1SSTP = *BLANK
     C                   ENDIF

     C                   EVAL      PRTTYKEY = #1STTP
     C                   EVAL      PDLTPKEY = #1SDTP
     C                   EVAL      PDLSTKEY = #1SSTP

     C                   IF        PDSPTYPE = 'A'
     C                   EVAL      PDSPTYPE = 'I'
     C                   ELSE
     C                   EVAL      PDSPTYPE = 'A'
     C                   ENDIF

      ** Return to calling program

     C                   RETURN

      ** Rollup

     C                   WHEN      *IN98 = TRUE

      ** Initialise count of records written to subfile page.

     C                   Z-ADD     0             W@CNT

      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.

     C                   DOW       (EndOfFile = FALSE) AND (W@CNT < 14)

      ** Increment the subfile record no. and records written fields.

     C                   ADD       1             W@RRN
     C                   ADD       1             W@CNT

      ** Write details to subfile for amend mode and blank record for insert

     C                   Z-ADD     W@RRN         #1SFRN

     C                   IF        PDSPTYPE = 'A'
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1TTYP = W6RTTY
     C                   EVAL      #1DTYP = W6DLTP
     C                   EVAL      #1STYP = W6DLST
     C                   EVAL      #1AMLT = W6AMLT
     C                   ELSE
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1TTYP = *BLANK
     C                   EVAL      #1DTYP = *BLANK
     C                   EVAL      #1STYP = *BLANK
     C                   EVAL      #1AMLT = *BLANK
     C                   ENDIF

      ** Save the current screen values

     C                   EVAL      PrvScnDS = CurScnDS

     C                   WRITE     SDAMLMS1

      ** Read next record for amend mode

     C                   IF        PDSPTYPE = 'A'
     C                   EXSR      SRReadRec
     C                   ENDIF

     C                   ENDDO

     C                   ENDSL

     C                   ENDDO

     C                   EVAL      PRTTYKEY = #1STTP
     C                   EVAL      PDLTPKEY = #1SDTP
     C                   EVAL      PDLSTKEY = #1SSTP

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve text                                      *
      *                                                               *
      *****************************************************************

     C     SRRtvTxt      BEGSR

     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgID
     C                   PARM      'GBSDUSRMSG'  PMsgFNm
     C                   PARM      *BLANK        PMsgDesc

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadRec - Read a record AML transaction mapping file       *
      *                                                               *
      *****************************************************************

     C     SrReadRec     BEGSR

      ** Reset End of File indicator

     C                   EVAL      EndOfFile = FALSE

     C                   SELECT

      ** Transaction Type

     C                   WHEN      (#1STTP <> *BLANK) OR
     C                             (#1STTP = *BLANK) AND (#1SDTP = *BLANK) AND
     C                             (#1SSTP = *BLANK)
     C                   READ      SDAMLML1                               96

      ** Deal Type/Sub-Type

     C                   WHEN      (#1SDTP <> *BLANK) OR (#1SSTP <> *BLANK)
     C                   READ      SDAMLML2                               96

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrId - Output error message without data                  *
      *                                                               *
      *****************************************************************

     C     SRErrId       BEGSR

     C                   EVAL      WZMsgId = *Blank
     C                   EVAL      WZMsgId = WMsgId

     C                   CALL      'ZA0340'
     C                   PARM                    WZMsgFile
     C                   PARM                    WZMsgId

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output error message with data                    *
      *                                                               *
      *****************************************************************

     C     SRErrDta      BEGSR

     C                   EVAL      WZMsgId = *Blank
     C                   EVAL      WZMsgId = WMsgId

     C                   CALL      'ZA0350'
     C                   PARM                    WZMsgFile
     C                   PARM                    WZMsgId
     C                   PARM      WMsgDta       WZMsgData

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PSFLACTN
     C                   PARM                    PDSPTYPE
     C                   PARM                    PACTN
     C                   PARM                    PRTTY
     C                   PARM                    PDLTP
     C                   PARM                    PDLST
     C                   PARM                    PAMLT
     C                   PARM                    PRTTYKEY
     C                   PARM                    PDLTPKEY
     C                   PARM                    PDLSTKEY
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKI
     C                   PARM                    PINKL
     C                   PARM                    PACTNOK
     C                   PARM                    PRTTYOK
     C                   PARM                    PDLTPOK
     C                   PARM                    PDLSTOK
     C                   PARM                    PAMLTOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    POrigScn

      ** Key lists

     C     KFLDList1     KLIST
     C                   KFLD                    #1STTP

     C     KFLDList2     KLIST
     C                   KFLD                    #1SDTP
     C                   KFLD                    #1SSTP

      ** Initialize program name

     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAMLMBRW'   DBPGM
     C                   OUT       LDA

      ** Access bank detail

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initialise subfile program queue and message file

     C                   EVAL      #0PGMQ = '*'
     C                   EVAL      WZMsgFile = 'SDUSRMSG'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
