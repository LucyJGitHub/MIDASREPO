     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list enquiry browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWLDDBRW - Watch List Enquiry Browse                        *
      *                                                               *
      *  Function:   This module will build sub-file of the synonyms. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDWLDDBDF CF   E             WORKSTN
     F                                     SFILE(SDWLDDBS1:#1SFRN)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  61 - No record found narrative indicator                     *
      *  62 - Highlight indicator                                     *
      *  81 - Sub file clear indicator                                *
      *  82 - Sub file end indicator                                  *
      *  96 - End of file indicator                                   *
      *  98 - Roll-up indicator                                       *
      *                                                               *
      *  KC - F3 Function                                             *
      *  KL - F12 Function                                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit       - Initialisation                                *
      *  SRBuildSFL   - Build Sub-File                                *
      *  SRRtvTxt     - Retrieve text                                 *
      *  SRGetSynonm  - Get Number of Synonyms                        *
      *  SRGetNameDtl - Get Name Details                              *
      *  SRGetAddrDtl - Get Address Details                           *
      *  SRGetCityDtl - Get City Details                              *
      *  SRGetCtryDtl - Get Country Details                           *
      *  *INZSR       - Initialisation                                *
      *  *PSSR        - DB Error Processing                           *
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
 
      ** Name DS for subfile display
     D WName           DS
     D  WName1                 1     78
     D  WName2                79    105
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
 
      ** Parameter
     D PINKC           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PMsgId          S              7A
     D PMsgFNm         S             10A
     D PMsgDesc        S             80A
     D PMsgFile        S             10A
     D PHits           S              3P 0
     D PSearch1        S             78A
     D PSearch2        S             78A
     D PSearch3        S             78A
     D PSearch4        S             78A
     D PSearch5        S             78A
     D PSearch6        S             78A
 
      ** Work fields
     D W@CNT           S              3P 0
     D W@RRN           S              3P 0
     D X               S              3P 0
     D A               S              3P 0
     D WNameSyn        S              5I 0
     D WAddrSyn        S              5I 0
     D WCitySyn        S              5I 0
     D WCtrySyn        S              5I 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      ** Source Included from FOFAPI
 
     DFofInit          PR            10I 0 EXTPROC('FofInit')
     D host                            *   VALUE OPTIONS(*STRING)
     D service                         *   VALUE OPTIONS(*STRING)
     D openNow                       10I 0 VALUE
     D Pserver                         *
 
     DFofClose         PR            10I 0 EXTPROC('FofClose')
     D Pserver                         *   VALUE
 
     DFofClear         PR            10I 0 EXTPROC('FofClear')
     D Pserver                         *   VALUE
 
     DFofOpen          PR            10I 0 EXTPROC('FofOpen')
     D Pserver                         *   VALUE
 
     DFkCommTraceOn    PR            10I 0 EXTPROC('FkCommTraceOn')
     D path                            *   VALUE OPTIONS(*STRING)
     D name                            *   VALUE OPTIONS(*STRING)
 
     DFofExecSrvReady  PR            10I 0 EXTPROC('FofExecSrvReady')
     D Pserver                         *   VALUE
 
     DFofExec          PR            10I 0 EXTPROC('FofExec')
     D Pserver                         *   VALUE
     D mode                          10I 0 VALUE
     D message                         *   VALUE OPTIONS(*STRING)
     D id                              *   VALUE OPTIONS(*STRING)
     D type                            *   VALUE OPTIONS(*STRING)
     D details                       10I 0 VALUE
 
     DFofRHn           PR            10I 0 EXTPROC('FofRHn')
     D Pserver                         *   VALUE
 
     DFofRStatus       PR            10I 0 EXTPROC('FofRStatus')
     D Pserver                         *   VALUE
 
     DFofRHresultI     PR            10I 0 EXTPROC('FofRHresultI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHtagI        PR              *   EXTPROC('FofRHtagI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHmatchI      PR             4F   EXTPROC('FofRHmatchI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHofacIdI     PR              *   EXTPROC('FofRHofacIdI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHnameI       PR              *   EXTPROC('FofRHnameI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHnSynNameI   PR            10I 0 EXTPROC('FofRHnSynNameI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynNameIJ   PR              *   EXTPROC('FofRHsynNameIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHposIJK      PR            10I 0 EXTPROC('FofRHposIJK')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
     D K                             10I 0 VALUE
 
     DFofLast          PR              *   EXTPROC('FofLast')
 
     DFofExecGetParms  PR            10I 0 EXTPROC('FofExecGetParams')
     D Pserver                         *   VALUE
 
     DFofRThreshold    PR             4F   EXTPROC('FofRThreshold')
     D Pserver                         *   VALUE
 
     DFofRSeverity     PR              *   EXTPROC('FofRSeverity')
     D Pserver                         *   VALUE
 
     DFofExecSetParms  PR            10I 0 EXTPROC('FofExecSetParms')
     D Pserver                         *   VALUE
 
     DFofShutdown      PR            10I 0 EXTPROC('FofShutdown')
     D Pserver                         *   VALUE
 
     DFofExecReloadDb  PR            10I 0 EXTPROC('FofExecReloadDb')
     D Pserver                         *   VALUE
 
     D Result          S              3
     D Action          S              2
 
     D chkstr          S          31000
     D res             S             10I 0
     D serv            S               *
     D hits            S             10I 0
     D ofacid          S              5
     D ofname          S            105
     D ofaddr          S             70
     D ofcity          S             35
     D ofcntry         S             35
     D oforigin        S             10
     D ofDesgn         S             15
     D oftype          S              1
     D ofusrdta1       S             32
     D ofusrdta2       S             32
     D ofsrchcde       S             36
     D Sequence        S              3P 0
     D tstdat          S               D   DATFMT(*ISO)
 
      ** Why not included on set of definition for FOF
     DFofRHaddressI    PR              *   EXTPROC('FofRHaddressI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHcityI       PR              *   EXTPROC('FofRHcityI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHtypeI       PR              *   EXTPROC('FofRHtypeI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHcountryI    PR              *   EXTPROC('FofRHcountryI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHoriginI     PR              *   EXTPROC('FofRHoriginI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHuser1I      PR              *   EXTPROC('FofRHuser1I')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHuser2I      PR              *   EXTPROC('FofRHuser2I')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsearchkI    PR              *   EXTPROC('FofRHsearchkI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHnSynCityI   PR            10I 0 EXTPROC('FofRHnSynCityI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynCityIJ   PR              *   EXTPROC('FofRHsynCityIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHnSynCtryI   PR            10I 0 EXTPROC('FofRHnSynCountryI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynCtryIJ   PR              *   EXTPROC('FofRHsynCountryIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHnSynAddrI   PR            10I 0 EXTPROC('FofRHnSynAddressI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynAddIJ    PR              *   EXTPROC('FofRHsynAddressIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHdesigI      PR              *   EXTPROC('FofRHdesignationI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
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
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Build Sub-file
 
     C                   DOW       (*INKC = FALSE) AND (*INKL = FALSE)
 
      ** Build subfile
 
     C                   EXSR      SRBuildSFL
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
      ** Reset highlight indicator
 
     C                   EVAL      *IN62 = FALSE
 
     C                   ENDDO
 
     C                   IF        *INKC = TRUE
     C                   EVAL      PINKC = TRUE
     C                   ENDIF
 
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
 
      ** Clear subfile fields
 
     C                   CLEAR                   SDWLDDBS1
 
      ** Reset function key indicators
 
     C                   EVAL      *INKC = FALSE
     C                   EVAL      *INKL = FALSE
 
      ** Format Header
 
     C                   EVAL      #0MRDT = BJMRDT
     C                   EVAL      #0PROF = PSUSER
     C                   EVAL      #0WID =  PSJOBNAME
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
      ** Set up search string for display
 
     C                   EVAL      #0STR1 = PSearch1
     C                   EVAL      #0STR2 = PSearch2
     C                   EVAL      #0STR3 = PSearch3
     C                   EVAL      #0STR4 = PSearch4
     C                   EVAL      #0STR5 = PSearch5
     C                   EVAL      #0STR6 = PSearch6
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuildSFL - Build Sub-File                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBuildSFL    BEGSR
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             W@RRN
 
      ** Reset EndOfFile
 
     C                   EVAL      EndOfFile = FALSE
 
      ** Clear subfile before filling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN81 = TRUE
     C                   WRITE     SDWLDDBC1
     C                   EVAL      *IN81 = FALSE
 
      ** Setup footer
 
     C                   EVAL      PMsgID = 'USR9562'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TRLR = PMsgDesc
 
      ** Get all synonyms
 
     C                   EXSR      SRGetSynonm
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = TRUE
 
      ** Reset number of written record per synonym
 
     C                   Z-ADD     0             A
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is taken
 
     C                   DOW       (*IN98 = TRUE)
 
      ** Reset rollup indicator
 
     C                   EVAL      *IN98 = FALSE
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             W@CNT
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       (EndOfFile = FALSE) AND (W@CNT < 9)
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             W@RRN
     C                   ADD       1             W@CNT
 
     C                   SELECT
 
      ** Write synonyms
 
     C                   WHEN      WNameSyn <> 0
 
     C                   EVAL      A = A + 1
 
     C                   IF        A = 1
     C                   EVAL      *IN62 = TRUE
     C                   EVAL      #1DATA = 'NAME SYNONYMS'
     C                   ELSE
     C                   EVAL      *IN62 = FALSE
     C                   EXSR      SRGetNameDtl
     C                   EVAL      WNameSyn = WNameSyn - 1
     C                   ENDIF
 
      ** Reset index when all name synonyms have been written
 
     C                   IF        WNameSyn = 0
     C                   EVAL      A = 0
     C                   ENDIF
 
     C                   WHEN      WAddrSyn <> 0
 
     C                   EVAL      A = A + 1
 
     C                   IF        A = 1
     C                   EVAL      *IN62 = TRUE
     C                   EVAL      #1DATA = 'ADDRESS SYNONYMS'
     C                   ELSE
     C                   EVAL      *IN62 = FALSE
     C                   EXSR      SRGetAddrDtl
     C                   EVAL      WAddrSyn = WAddrSyn - 1
     C                   ENDIF
 
      ** Reset index when all address synonyms have been written
 
     C                   IF        WAddrSyn = 0
     C                   EVAL      A = 0
     C                   ENDIF
 
     C                   WHEN      WCitySyn <> 0
 
     C                   EVAL      A = A + 1
 
     C                   IF        A = 1
     C                   EVAL      *IN62 = TRUE
     C                   EVAL      #1DATA = 'CITY SYNONYMS'
     C                   ELSE
     C                   EVAL      *IN62 = FALSE
     C                   EXSR      SRGetCityDtl
     C                   EVAL      WCitySyn = WCitySyn - 1
     C                   ENDIF
 
      ** Reset index when all city synonyms have been written
 
     C                   IF        WCitySyn = 0
     C                   EVAL      A = 0
     C                   ENDIF
 
     C                   WHEN      WCtrySyn <> 0
 
     C                   EVAL      A = A + 1
 
     C                   IF        A = 1
     C                   EVAL      *IN62 = TRUE
     C                   EVAL      #1DATA = 'COUNTRY SYNONYMS'
     C                   ELSE
     C                   EVAL      *IN62 = FALSE
     C                   EXSR      SRGetCtryDtl
     C                   EVAL      WCtrySyn = WCtrySyn - 1
     C                   ENDIF
 
      ** Reset index when all city synonyms have been written
 
     C                   IF        WCtrySyn = 0
     C                   EVAL      A = 0
     C                   ENDIF
 
     C                   ENDSL
 
     C                   Z-ADD     W@RRN         #1SFRN
     C                   WRITE     SDWLDDBS1
 
      ** End of File
 
     C                   IF        (WNameSyn = 0) AND (WAddrSyn = 0) AND
     C                             (WCitySyn = 0) AND (WCtrySyn = 0)
     C                   EVAL      EndOfFile = TRUE
     C                   ENDIF
 
     C                   ENDDO
 
      ** Set the sub file end indicator if end of file encountered
 
     C                   IF        EndOfFile = TRUE
     C                   EVAL      *IN82 = TRUE
     C                   ELSE
     C                   EVAL      *IN82 = FALSE
     C                   ENDIF
 
      ** Write header and search string
 
     C                   WRITE     SDWLDDBH0
     C                   WRITE     SDWLDDBD0
 
      ** Write the message sub-file
 
     C                   WRITE     SDWLDDBC0
 
      **  If there is no data to display execute no details footer
 
     C                   IF        W@CNT = 0
     C                   WRITE     SDWLDDBF1
     C                   EXFMT     SDWLDDBF1
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   ELSE
     C                   WRITE     SDWLDDBF0
     C                   WRITE     SDWLDDBC1
 
      ** Read the subfile control record
 
     C                   EXFMT     SDWLDDBC1
     C                   ENDIF
 
     C                   ENDDO
 
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
 
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetSynonm - Get Number of Synonyms                         *
      *                                                               *
      *****************************************************************
 
     C     SRGetSynonm   BEGSR
 
      ** Name synonym
 
     C                   EVAL      WNameSyn=(FofRHnSynNameI(serv:X-1))
 
      ** Address synonym
 
     C                   EVAL      WAddrSyn=(FofRHnSynAddrI(serv:X-1))
 
      ** City synonym
 
     C                   EVAL      WCitySyn=(FofRHnSynCityI(serv:X-1))
 
      ** Country synonym
 
     C                   EVAL      WCtrySyn=(FofRHnSynCtryI(serv:X-1))
 
      ** End of File, if no synonyms
 
     C                   IF        (WNameSyn = 0) AND (WAddrSyn = 0) AND
     C                             (WCitySyn = 0) AND (WCtrySyn = 0)
     C                   EVAL      EndOfFile = TRUE
     C                   ENDIF
 
     C                   ENDSR
 
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetNameDtl - Get Name Details                              *
      *                                                               *
      *****************************************************************
 
     C     SRGetNameDtl  BEGSR
 
      ** Name synonym details
 
     C                   EVAL      ofname=%STR(FofRHsynNameIJ(serv:X-1:A-2))
     C                   EVAL      WName = ofname
     C                   EVAL      #1DATA = WName1
 
     C                   IF        WName2 <> *BLANK
     C                   Z-ADD     W@RRN         #1SFRN
     C                   WRITE     SDWLDDBS1
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             W@RRN
     C                   ADD       1             W@CNT
 
     C                   EVAL      #1DATA = WName2
     C                   ENDIF
 
     C                   ENDSR
 
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAddrDtl - Get Address Details                           *
      *                                                               *
      *****************************************************************
 
     C     SRGetAddrDtl  BEGSR
 
      ** Address synonym details
 
     C                   EVAL      ofaddr=%STR(FofRHsynAddIJ(serv:X-1:A-2))
 
     C                   EVAL      #1DATA = ofaddr
 
     C                   ENDSR
 
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCityDtl - Get City Details                              *
      *                                                               *
      *****************************************************************
 
     C     SRGetCityDtl  BEGSR
 
      ** City synonym details
 
     C                   EVAL      ofcity=%STR(FofRHsynCityIJ(serv:X-1:A-2))
 
     C                   EVAL      #1DATA = ofcity
 
     C                   ENDSR
 
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCtryDtl - Get Country Details                           *
      *                                                               *
      *****************************************************************
 
     C     SRGetCtryDtl  BEGSR
 
      ** Country synonym details
 
     C                   EVAL      ofcntry=%STR(FofRHsynCtryIJ(serv:X-1:A-2))
 
     C                   EVAL      #1DATA = ofcntry
 
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
     C                   PARM                    serv
     C                   PARM                    PHits
     C                   PARM                    PSearch1
     C                   PARM                    PSearch2
     C                   PARM                    PSearch3
     C                   PARM                    PSearch4
     C                   PARM                    PSearch5
     C                   PARM                    PSearch6
     C                   PARM                    PINKC
 
      ** Hit number
 
     C                   EVAL      X = PHits
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDWLDDBRW'   DBPGM
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
     C                   EVAL      PMsgFile = 'SDUSRMSG'
 
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
(c) Misys International Banking Systems Ltd. 2002
