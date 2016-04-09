     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWLDDENQ - Watch List Enquiry                               *
      *                                                               *
      *  Function:   This module displays and accepts search string   *
      *              using FIRCOSOFT procedures.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC015  *CREATE    Date 14Oct02               *
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
 
     FSDWLDDEDF CF   E             WORKSTN
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  60 - Error in entered search string                          *
      *  61 - Protect search string fields                            *
      *  62 - Enable F6                                               *
      *  63 - Enable F7                                               *
      *                                                               *
      *  KC - F3 Exit                                                 *
      *  KF - F6 Prev Hit                                             *
      *  KG - F7 Next Hit                                             *
      *  KL - F12 Previous                                            *
      *  KP - Synonyms                                                *
      *  LR - Program Exit                                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit      - Initialisation                                 *
      *  SRDetail    - Display details of scan                        *
      *  SRGetHitDtl - Get Hit Details                                *
      *  SRSetupDsp  - Set up Display Fields                          *
      *  SRSynonym   - Process Synonyms                               *
      *  SRSndErr    - Send Error Message                             *
      *  SRRtvTxt    - Retrieve text                                  *
      *  *INZSR      - Initialisation                                 *
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Watch list configuration
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Name data structure
     D WNAME           DS
     D  WNAME1                 1     68
     D  WNAME2                69    105
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter
     D PINKC           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PMsgId          S              7A
     D PMsgFNm         S             10A
     D PMsgDesc        S             80A
     D PMsgFile        S             10A
     D PZMsgId         S             10A
     D PZMsgFile       S             10A
     D PHits           S              3P 0
     D PSearch1        S             78A
     D PSearch2        S             78A
     D PSearch3        S             78A
     D PSearch4        S             78A
     D PSearch5        S             78A
     D PSearch6        S             78A
 
      ** Work fields
     D DisplayHit      S              3P 0
     D WServError      S              1A
     D WTRLR1          S             78A
     D WTRLR2          S             78A
     D WTRLR3          S             78A
     D WTRLR4          S             78A
     D WTRLR5          S             78A
     D WZMsgId         S             10A
     D X               S              3P 0
 
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
 
      ** Initialisation processing
 
     C                   EXSR      SRInit
 
      ** Display search string fields for input
 
     C                   DOW       *INKC = FALSE
 
      ** Display screen
 
     C                   WRITE     SDWLDDEH0
     C                   WRITE     SDWLDDEF0
     C                   WRITE     SDWLDDED0
 
      ** Display error messages
 
     C                   WRITE     SDWLDDEC0
 
      ** If no server error, prompt for the search string
 
     C                   IF        WServError <> 'Y'
     C                   EXFMT     SDWLDDED0
     C                   ELSE
     C                   EXFMT     SDWLDDEF0
 
      ** Exit program after displaying the error
 
     C                   IF        *INKC = FALSE
     C                   EVAL      *INKC = TRUE
     C                   ENDIF
     C                   ENDIF
 
      ** Reset error indicator
 
     C                   EVAL      *IN60 = FALSE
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *INKC = FALSE
 
      ** Build string for checking
 
     C                   EVAL      chkstr = #0STR1 + #0STR2 + #0STR3 +
     C                                      #0STR4 + #0STR5 + #0STR6
 
      ** Scan data with parsing mode 'FOF_COMM_WHOLE'
 
     C                   IF        chkstr <> *BLANK
     C                   MOVEL     'CK'          Action
     C                   EVAL      res=FofExec(serv:1:chkstr:'TEST':'T':
     C                                            1)
 
      ** Error occured during scanning of data
 
     C                   IF        res <> 0
     C                   EVAL      *IN60 = TRUE
     C                   EVAL      WZMsgId = 'USR9625   '
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      **  Get Status of data scan
 
     C                   IF        res = 0
     C                   MOVEL     'ST'          Action
     C                   EVAL      res=FofRStatus(serv)
     C                   MOVE      res           result
 
     C                   SELECT
 
      ** No suspect display message 'String entered is clean'
 
     C                   WHEN      res = 0
     C                   EVAL      WZMsgId = 'USR9416   '
     C                   EXSR      SRSndErr
 
      ** Suspect detected, proceed to detail screen
 
     C                   WHEN      res = 1
     C                   EXSR      SRDetail
 
      ** Error on scan
 
     C                   OTHER
     C                   EVAL      *IN60 = TRUE
     C                   EVAL      WZMsgId = 'USR9625   '
     C                   EXSR      SRSndErr
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Close connection with server
 
     C                   MOVEL     'C '          Action
     C                   EVAL      res=FofClose(serv)
 
      ** Free the server context memory
 
     C                   MOVEL     'F '          Action
     C                   EVAL      res=FofClear(serv)
 
     C                   EVAL      *INLR = TRUE
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation processing                           *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Clear display fields
 
     C                   CLEAR                   SDWLDDED0
     C                   CLEAR                   SDWLDDED1
 
      ** Format Header
 
     C                   EVAL      #0MRDT = BJMRDT
     C                   EVAL      #0PROF = PSUSER
     C                   EVAL      #0WID =  PSJOBNAME
 
      ** Set protect indicator
 
     C                   EVAL      *IN61 = FALSE
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
      ** Setup footer
 
     C                   EVAL      PMsgID = 'USR9409'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WTRLR1 = PMsgDesc
 
     C                   EVAL      PMsgID = 'USR9410'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WTRLR2 = PMsgDesc
 
     C                   EVAL      PMsgID = 'USR9411'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WTRLR3 = PMsgDesc
 
     C                   EVAL      PMsgID = 'USR9412'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WTRLR4 = PMsgDesc
 
     C                   EVAL      PMsgID = 'USR9626'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WTRLR5 = PMsgDesc
 
     C                   EVAL      #0PGMR = 'SDWLDDP'
     C                   EVAL      #0TRLR = WTRLR1
 
      ** Get the configuration data for linking to the OFAC-Agent
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise server error indicator
 
     C                   EVAL      WServError = 'N'
 
      ** Initialise OFAC-Agent Server
 
     C                   MOVEL     'I '          Action
     C                   EVAL      res=FofInit(W1MDSR:W1OFSR:
     C                                            0:serv)
 
      ** Error occured during initialisation, send error message
 
     C                   IF        res <> 0
     C                   EVAL      *IN61 = TRUE
     C                   EVAL      WZMsgId = 'USR9413   '
     C                   EVAL      WServError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Open Client Connection to OFAC-AGENT Server
 
     C                   IF        res = 0
     C                   MOVEL     'O '          Action
     C                   EVAL      res=FofOpen(serv)
 
      ** Error occured during opening, send error message
 
     C                   IF        res <> 0
     C                   EVAL      *IN61 = TRUE
     C                   EVAL      WZMsgId = 'USR9414   '
     C                   EVAL      WServError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
      ** Check OFAC-Agent server is ready to process request
 
     C                   IF        res = 0
     C                   MOVEL     'R '          Action
     C                   EVAL      res=FofExecSrvReady(serv)
 
      ** Error occured during requesting, send error message
 
     C                   IF        res <> 0
     C                   EVAL      *IN61 = TRUE
     C                   EVAL      WZMsgId = 'USR9415   '
     C                   EVAL      WServError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail - Display details of scan                           *
      *                                                               *
      *****************************************************************
 
     C     SRDetail      BEGSR
 
      ** Get the number of hits
 
     C                   EVAL      hits=FofRHn(serv)
     C                   EVAL      DisplayHit = 1
 
      ** Get hit details
 
     C                   EXSR      SRGetHitDtl
 
      ** Set up display fields
 
     C                   EXSR      SRSetupDsp
 
      ** Protect search string fields
 
     C                   EVAL      *IN61 = TRUE
 
      ** Display hit details
 
     C                   DOW       (*INKC = FALSE) AND (*INKL = FALSE)
 
     C                   EVAL      #0PGMR = 'SDWLDDD'
     C                   WRITE     SDWLDDEH0
     C                   WRITE     SDWLDDEF0
 
      ** Display screen
 
     C                   WRITE     SDWLDDED0
     C                   WRITE     SDWLDDED1
 
      ** Display error messages
 
     C                   WRITE     SDWLDDEC0
     C                   EXFMT     SDWLDDED1
 
      ** F12 entered, enable search string fields
 
     C                   IF        *INKL = TRUE
     C                   EVAL      *IN61 = FALSE
     C                   EVAL      #0TRLR = WTRLR1
     C                   ENDIF
 
      ** F3 and F12 not entered
 
     C                   IF        (*INKC = FALSE) AND (*INKL = FALSE)
 
     C                   SELECT
 
      ** Previous hit
 
     C                   WHEN      *INKF = TRUE
     C                   EVAL      DisplayHit = DisplayHit - 1
 
      ** Get hit details
 
     C                   EXSR      SRGetHitDtl
 
      ** Set up display fields
 
     C                   EXSR      SRSetupDsp
 
      ** Next hit
 
     C                   WHEN      *INKG = TRUE
     C                   EVAL      DisplayHit = DisplayHit + 1
 
      ** Get hit details
 
     C                   EXSR      SRGetHitDtl
 
      ** Set up display fields
 
     C                   EXSR      SRSetupDsp
 
      ** Synonyms
 
     C                   WHEN      *INKP = TRUE
     C                   EXSR      SRSynonym
 
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetHitDtl - Get Hit Details                                *
      *                                                               *
      *****************************************************************
 
     C     SRGetHitDtl   BEGSR
 
     C                   EVAL      X = DisplayHit
 
      ** Watch List Identifier
 
     C                   EVAL      ofacid=%STR(FofRHofacIdI(serv:X-1))
 
      ** Origin
 
     C                   EVAL      ofname=%STR(FofRHoriginI(serv:X-1))
 
      ** Designation
 
     C                   EVAL      ofDesgn=%STR(FofRHdesigI(serv:X-1))
 
      ** Type
 
     C                   EVAL      oftype=%STR(FofRHtypeI(serv:X-1))
 
      ** Name
 
     C                   EVAL      ofname=%STR(FofRHnameI(serv:X-1))
 
      ** Address
 
     C                   EVAL      ofaddr=%STR(FofRHaddressI(serv:X-1))
 
      ** City
 
     C                   EVAL      ofcity=%STR(FofRHcityI(serv:X-1))
 
      ** Country
 
     C                   EVAL      ofcntry=%STR(FofRHcountryI(serv:X-1))
 
      ** Search Codes
 
     C                   EVAL      ofsrchcde=%STR(FofRHsearchkI(serv:X-1))
 
      ** User data 1
 
     C                   EVAL      ofusrdta1=%STR(FofRHuser1I(serv:X-1))
 
      ** User data 2
 
     C                   EVAL      ofusrdta2=%STR(FofRHuser2I(serv:X-1))
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetupDsp - Set up Display Fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRSetupDsp    BEGSR
 
     C                   EVAL      #1WLST = ofacid
     C                   EVAL      #1ORIG = oforigin
     C                   EVAL      #1DESI = ofDesgn
     C                   EVAL      #1TYPE = oftype
     C                   EVAL      WNAME = ofname
     C                   EVAL      #1NME1 = WNAME1
     C                   EVAL      #1NME2 = WNAME2
     C                   EVAL      #1ADDR = ofaddr
     C                   EVAL      #1CITY = ofcity
     C                   EVAL      #1CTRY = ofcntry
     C                   EVAL      #1CODE = ofsrchcde
     C                   EVAL      #1DTA1 = ofusrdta1
     C                   EVAL      #1DTA2 = ofusrdta2
 
      ** Set up trailer
 
     C                   IF        Hits = 1
     C                   EVAL      *IN62 = FALSE
     C                   EVAL      *IN63 = FALSE
     C                   EVAL      #0TRLR = WTRLR5
     C                   ENDIF
 
     C                   IF        (Hits > 1)
 
     C                   SELECT
 
     C                   WHEN      DisplayHit = 1
     C                   EVAL      *IN62 = FALSE
     C                   EVAL      *IN63 = TRUE
     C                   EVAL      #0TRLR = WTRLR3
 
     C                   WHEN      DisplayHit = Hits
     C                   EVAL      *IN62 = TRUE
     C                   EVAL      *IN63 = FALSE
     C                   EVAL      #0TRLR = WTRLR4
 
     C                   WHEN      (DisplayHit > 1) AND (DisplayHit < Hits)
     C                   EVAL      *IN62 = TRUE
     C                   EVAL      *IN63 = TRUE
     C                   EVAL      #0TRLR = WTRLR2
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSynonym - Process Synonyms                                 *
      *                                                               *
      *****************************************************************
 
     C     SRSynonym     BEGSR
 
     C                   EVAL      PHits = DisplayHit
 
     C                   CALL      'SDWLDDBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    serv
     C                   PARM                    PHits
     C                   PARM      #0STR1        PSearch1
     C                   PARM      #0STR2        PSearch2
     C                   PARM      #0STR3        PSearch3
     C                   PARM      #0STR4        PSearch4
     C                   PARM      #0STR5        PSearch5
     C                   PARM      #0STR6        PSearch6
     C                   PARM      FALSE         PINKC
 
      ** Terminate program when F3 entered
 
     C                   IF        PINKC = TRUE
     C                   EVAL      *INKC = TRUE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Send Error Message                                *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   EVAL      PZMsgId = *BLANK
     C                   EVAL      PZMsgId = WZMsgId
 
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG'    PZMsgFile
     C                   PARM                    PZMsgId
 
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
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDWLDDENQ'   DBPGM
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
      *
      * Uncomment line below to turn on the FircoSoft trace.
      * Replace 'LIB' with existing library name, i.e. 'NMXLIB'.
      * Replace 'FILE' with output trace file name. This does not
      * need to exist, but must be 7 characters or less in length.
      * Note that the file created has 'LOG' appended to the name.
      * I.e. 'FILE' becomes 'FILELOG' in library 'LIB'.
      *
     C*                  EVAL      res=FkCommTraceOn('LIB':'FILE')
      *
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
