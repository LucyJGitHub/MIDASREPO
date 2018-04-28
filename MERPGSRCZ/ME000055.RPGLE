     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/MT942 Production Monitor')              *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME000055 - MT941/MT942 Production Monitor                    *
      *                                                               *
      *  Function:  This module will allow to activate or deactivate  *
      *             the scheduled production of MT941 and MT942.      *
      *             It also allows to set the running periodicity     *
      *             of the MT94x Automatic Generation program.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26815           Date 04Dec09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245711             Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 16Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26815 - No user friendly labelling                        *
      *  245711 - Subfile text is missing in Network Production       *
      *           Monitor.                                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    27->34     Error on Screen fields                          *
      *                                                               *
      *    89         Access MT941/MT942 Production Monitor File      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FME000055DFCF   E             WORKSTN SFILE(ME000055S0:#0SFRN)
     F                                     INFSR(*PSSR)
      ** MT941/MT942 Production Monitor Display File
 
     FGLNWKAPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas Network Activity Control File - Retrieve
 
     FGLNWKAL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas Network Activity Control File - Update
     F                                     RENAME(GLNWKAD0:UpGLNWKAD0)
     F                                     PREFIX(Up)
 
     FGLPRMOPD  UF A E             DISK    INFSR(*PSSR)
      ** Midas MT941/MT942 Production Monitor File
 
     FGLMR94L1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MT941/MT942 Messages Requested File - Retrieval
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D#DESC            S             27A   DIM(11) CTDATA PERRCD(1)                           245711
 
     D GLM94XDA      E DS                  EXTNAME(GLM94XDA) DTAARA(GLM94XDA)
      ** Midas MT94x Background Job Data Area
 
      ** External Data Structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data Structure for Production Monitor File
     D DSPRMO        E DS                  EXTNAME(GLPRMOPD)
 
      ** DS for access programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Various work fields
 
     D WMRPD           S              2S 0                                      Minimum Run. Period.
     D WPERQ           S              4S 0                                      Period of Expirity
 
     D WRun            S              1                                         Already run
     D PZADFMF         S             10                                         Default message file
     D WError          S              1                                         General Error Flag
     D WMT94x          S              1                                         Work. Msg Type Flag
     D WLRCD           S              5U 0 INZ(0)                               Last RRN
     D WRCTR           S              5U 0 INZ(0)                               Record by page
     D SavPOSN         S                   LIKE(#0POSN)                         Save Pos. on Network
 
      ** Parameter for QUSRJOBI
 
     D PReturn         DS           500                                         Receiver variable
     D  WJobStatus                   10A   OVERLAY(PReturn:51)                  Job status
     D  WActStatus                    4A   OVERLAY(PReturn:108)                 Active job status
     D PLength         S              4B 0 INZ(144)                             Length of rec. var.
     D PInput          S              8    INZ('JOBI0200')                      Format name
     D PQual           DS            26                                         Qualified job name
     D  WJobName               1     10                                         Job Name
     D  WUserID               11     20                                         User ID
     D  WJobNumber            21     26                                         Job Number
     D PIntr           S             16    INZ(*BLANKS)                         Internal job identif
 
      ** Work fields for Standard Access Object
     D PRtcd           S              7A                                        Return code
     D POption         S              7A                                        Option
 
      ** Parameter for GLC001410
     D POperation      S              6
     D PMode           S              7
     D PRetCode        S              7
 
      ** Parameter for ZALIGN
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** Fields used for Message Files
     D PMsgFile        S             10A   INZ('MEMSG')
     D PMsgID          S             10A
     D PMsgText        S             80A
 
      ** Counter fields
     D WCntReqs        S              6S 0 INZ(0)
     D WCntWait        S              6S 0 INZ(0)
     D WCntExpr        S              6S 0 INZ(0)
     D WCntSubm        S              6S 0 INZ(0)
     D WCntGenr        S              6S 0 INZ(0)
     D WCntDupr        S              6S 0 INZ(0)
     D WCntHldr        S              6S 0 INZ(0)
     D WCntErro        S              6S 0 INZ(0)
     D WCntMovt        S              6S 0 INZ(0)
 
      ** Parameters for QSNDDTAQ
     D PDataQueue      S             10    INZ('GLM94XDQ  ')
     D PLibrary        S             10    INZ('*LIBL     ')
     D PDataLength     S              5  0 INZ(1)
     D PData           S              1    INZ('C')
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   DOW       *INKC = *OFF
 
      ** Display initial screen
 
     C                   EXSR      SRInitScn
 
      ** Function key validation
 
     C                   SELECT
 
     C                   WHEN      *INKC = *ON
     C                   EXSR      SRInitProc
     C                   EXSR      SRExit
 
     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRefresh
 
     C                   WHEN      *INKF = *ON
     C                   EXSR      SRActivate
 
     C                   WHEN      *INKG = *ON
     C                   EXSR      SRDeactivate
 
     C                   WHEN      *INKP = *ON
     C                   EXSR      SRNetMonitor
 
     C                   OTHER
     C                   EXSR      SRValInit
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInitScn - Display the Initial Screen                       *
      *****************************************************************
 
     C     SrInitScn     BEGSR
 
     C                   IN        GLM94XDA
     C                   EVAL      PQual = MTBKGJ
 
      ** Call QUSRJOBI if Job Name is not blank
 
     C                   IF        WJobName <> *BLANKS
     C                   EXSR      SRJobStatus
     C                   ELSE
     C                   EVAL      PMsgID = 'ME00072'
     C                   ENDIF
 
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0JOBS = PMsgText
 
      ** In error, do not override the value entered.
 
     C                   IF        NOT *IN27                                    Error on Min. Period
     C                             AND NOT *IN28                                Error on Expirity
 
 
     ** Read GLPRMOPD to retrieve Minimum Running Periodicity and Period
     ** of Expiring Request
 
     C     1             CHAIN(N)  GLPRMOPD                           89
 
     ** Default Minimum Running Periodicity to 5 if field in file is blank
 
     C                   IF        *IN89
     C                             OR MDMRPD = *ZEROS
 
     C                   EVALR     #0MRPD = '5'
 
     C                   ELSE
 
     C                   MOVE(P)   MDMRPD        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        #0MRPD
 
     C                   ENDIF
 
     ** Default Period of Expiring Request to 60 if field in file is blank
 
     C                   IF        *IN89
     C                             OR MDPERQ =  *ZEROS
 
     C                   EVALR     #0PERQ = '60'
 
     C                   ELSE
 
     C                   MOVE(P)   MDPERQ        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        #0PERQ
 
     C                   ENDIF
 
     C                   ENDIF
 
     ** Generate MT941 by Schedule Active?
 
     C                   EVAL      WMT94x = MTS941
     C                   EXSR      SRStatus
     C                   EVAL      #0S941 = PMsgText
 
     ** Generate MT942 by Schedule Active?
 
     C                   EVAL      WMT94x = MTS942
     C                   EXSR      SRStatus
     C                   EVAL      #0S942 = PMsgText
 
     ** Generate MT941 by Manual Request Active?
 
     C                   EVAL      WMT94x = MTM941
     C                   EXSR      SRStatus
     C                   EVAL      #0M941 = PMsgText
 
     ** Generate MT942 by Manual Request Active?
 
     C                   EVAL      WMT94x = MTM942
     C                   EXSR      SRStatus
     C                   EVAL      #0M942 = PMsgText
 
     ** Generate MT941 by MT920 Request Active?
 
     C                   EVAL      WMT94x = MTR941
     C                   EXSR      SRStatus
     C                   EVAL      #0R941 = PMsgText
 
     ** Generate MT942 by MT920 Request Active?
 
     C                   EVAL      WMT94x = MTR942
     C                   EXSR      SRStatus
     C                   EVAL      #0R942 = PMsgText
 
     C                   EVAL      *IN21 = *ON
 
     C                   WRITE     ME000055F0                                   Header
     C                   WRITE     ME000055F2                                   Bottom
     C                   WRITE     ME000055C1                                   Messages
     C                   EXFMT     ME000055F1                                   Initial screen
 
     C                   EXSR      SRClear                                      Clear Pgm Msgq
 
     C                   MOVEA     '000000'      *IN(27)                        Reset Error Ind.
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRJobStatus - Determine Current Job Status                    *
      *****************************************************************
 
     C     SRJobStatus   BEGSR
 
     C                   CALL      'QUSRJOBI'                           99
     C                   PARM                    PReturn
     C                   PARM                    PLength
     C                   PARM                    PInput
     C                   PARM                    PQual
     C                   PARM                    PIntr
 
     C                   SELECT
 
      ** Error on QUSRJOBI (Job currently not available).
 
     C                   WHEN      *IN99
     C                   EVAL      PMsgID = 'ME00130'
 
      ** Submitted
 
     C                   WHEN      WActStatus = '    '
     C                             AND WJobStatus = '*JOBQ'
     C                   EVAL      PMsgID = 'ME00131'
 
      ** Active - Waiting
 
     C                   WHEN      WActStatus = 'DEQW'
     C                   EVAL      PMsgID = 'ME00085'
 
      ** Job ending
 
     C                   WHEN      WActStatus = 'END '
     C                             OR WActStatus = 'EOJ '
     C                   EVAL      PMsgID = 'ME00127'
 
      ** Job held
 
     C                   WHEN      WActStatus = 'HLD '
     C                   EVAL      PMsgID = 'ME00128'
 
      ** Job lock
 
     C                   WHEN      WActStatus = 'LCKW'
     C                   EVAL      PMsgID = 'ME00129'
 
      ** Message Waiting
 
     C                   WHEN      WActStatus = 'MSGW'
     C                   EVAL      PMsgID = 'ME00086'
 
      ** Active - Processing
 
     C                   WHEN      WActStatus = 'RUN '
     C                             OR WActStatus = 'DEQA'
     C                   EVAL      PMsgID = 'ME00087'
 
      ** Other
 
     C                   OTHER
 
     C                   EVAL      PMsgID = 'ME00130'
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValInit - Validate initial screen                          *
      *****************************************************************
 
     C     SrValInit     BEGSR
 
      ** Reset error indicator and working fields.
 
     C                   EVAL      WError = 'N'                                 General Error Flag
     C                   MOVEA     '000000'      *IN(27)                        Reset Error Ind.
     C                   EVAL      WMRPD = *ZEROS                               Minimum Run. Period.
     C                   EVAL      WPERQ = *ZEROS                               Period of Expirity
 
      ** Validate Minimum Running Periodicity
 
     C                   EVAL      ZFIELD = *BLANKS
 
     C                   IF        #0MRPD = *Blanks
     C                   EVALR     #0MRPD = '5'
     C                   ENDIF
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM      #0MRPD        ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      2             ZADIG
 
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      WError = 'Y'                                 General Error Flag
     C                   EVAL      *IN27 = *ON
     C                   EVAL      PMsgId = 'ME00074'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      ZFIELD        WMRPD                          Minimum Run. Period.
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        #0MRPD                         Minimum Run. Period.
     C                   ENDIF
 
      ** Validate Period of Expiring Request
 
     C                   IF        #0PERQ = *Blanks
     C                   EVALR     #0PERQ = '60'
     C                   ENDIF
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM      #0PERQ        ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      4             ZADIG
 
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      WError = 'Y'                                 General Error Flag
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PMsgID = 'ME00075'
     C                   EXSR      SRZasnms
     C                   ELSE
     c                   MOVE      ZFIELD        WPERQ                          Period of Expirity
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        #0PERQ                         Period of Expirity
     C                   ENDIF
 
      ** The Period of Expiring Request should be at least twince the running periodicity.
 
     C                   IF        WPERQ <= (WMRPD * 2)
     C                   EVAL      WError = 'Y'                                 General Error Flag
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PMsgId = 'ME00076'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate the Action on: MT941 on Schedule,
      **                         MT942 on Schedule,
      **                         MT941 on Manual request,
      **                         MT942 on Manual request,
      **                         MT941 on MT920,
      **                         MT942 on MT920.
 
      ** Valid Action code is 'A' or 'D'.
 
     C                   IF        #0ACT1 <> 'A' and #0ACT1 <> 'D'
     C                             and #0ACT1 <> ' '
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PMsgID = 'ME00077'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT2 <> 'A' and #0ACT2 <> 'D'
     C                             and #0ACT2 <> ' '
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PMsgID = 'ME00077'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT3 <> 'A' and #0ACT3 <> 'D'
     C                             and #0ACT3 <> ' '
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PMsgID = 'ME00077'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT4 <> 'A' and #0ACT4 <> 'D'
     C                             and #0ACT4 <> ' '
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PMsgID = 'ME00077'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT5 <> 'A' and #0ACT5 <> 'D'
     C                             and #0ACT5 <> ' '
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PMsgID = 'ME00077'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT6 <> 'A' and #0ACT6 <> 'D'
     C                             and #0ACT6 <> ' '
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PMsgID = 'ME00077'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Do not activate the request type if already active,
      ** Or not de-activate the request type if not active.
 
     C                   IF        #0ACT1 = 'A' and MTS941 = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PMsgID = 'ME00078'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT1 = 'D' and MTS941 <> 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PMsgID = 'ME00079'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT2 = 'A' and MTS942 = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PMsgID = 'ME00078'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT2 = 'D' and MTS942 <> 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PMsgID = 'ME00079'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT3 = 'A' and MTM941 = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PMsgID = 'ME00078'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT3 = 'D' and MTM941 <> 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PMsgID = 'ME00079'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT4 = 'A' and MTM942 = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PMsgID = 'ME00078'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT4 = 'D' and MTM942 <> 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PMsgID = 'ME00079'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT5 = 'A' and MTR941 = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PMsgID = 'ME00078'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT5 = 'D' and MTR941 <> 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PMsgID = 'ME00079'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT6 = 'A' and MTR942 = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PMsgID = 'ME00078'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #0ACT6 = 'D' and MTR942 <> 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PMsgID = 'ME00079'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** If no error, update value corresponding to first screen.
 
     C                   IF        WError = 'N'
     C                   EXSR      SrUpdInit
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * SrUpdInit - Update value corresponding to initial screen      *
      *****************************************************************
 
     C     SrUpdInit     BEGSR
 
      ** If Modification on Period.
 
     C                   IF        MDMRPD <> WMRPD
     C                             OR MDPERQ <> WPERQ
 
     C     1             CHAIN     GLPRMOD0                           89
     C                   EVAL      MDMRPD = WMRPD                               Minimum Running Peri
     C                   EVAL      MDPERQ = WPERQ                               Period of Expiring R
     C  N89              UPDATE    GLPRMOD0
     C   89              WRITE     GLPRMOD0
 
     C                   ENDIF
 
      ** If action on message type request.
 
     C                   IF        #0ACT1 <> *BLANK or
     C                             #0ACT2 <> *BLANK or
     C                             #0ACT3 <> *BLANK or
     C                             #0ACT4 <> *BLANK or
     C                             #0ACT5 <> *BLANK or
     C                             #0ACT6 <> *BLANK
 
     C     *LOCK         IN        GLM94XDA
 
      ** MT941 Schedule Request
 
     C                   SELECT
     C                   WHEN      #0ACT1 = 'A'
     C                   EVAL      MTS941 = 'Y'
     C                   WHEN      #0ACT1 = 'D'
     C                   EVAL      MTS941 = 'N'
     C                   ENDSL
 
      ** MT942 Schedule Request
 
     C                   SELECT
     C                   WHEN      #0ACT2 = 'A'
     C                   EVAL      MTS942 = 'Y'
     C                   WHEN      #0ACT2 = 'D'
     C                   EVAL      MTS942 = 'N'
     C                   ENDSL
 
      ** MT941 Manual Request
 
     C                   SELECT
     C                   WHEN      #0ACT3 = 'A'
     C                   EVAL      MTM941 = 'Y'
     C                   WHEN      #0ACT3 = 'D'
     C                   EVAL      MTM941 = 'N'
     C                   ENDSL
 
      ** MT942 Manual Request
 
     C                   SELECT
     C                   WHEN      #0ACT4 = 'A'
     C                   EVAL      MTM942 = 'Y'
     C                   WHEN      #0ACT4 = 'D'
     C                   EVAL      MTM942 = 'N'
     C                   ENDSL
 
      ** MT941 MT920 Request
 
     C                   SELECT
     C                   WHEN      #0ACT5 = 'A'
     C                   EVAL      MTR941 = 'Y'
     C                   WHEN      #0ACT5 = 'D'
     C                   EVAL      MTR941 = 'N'
     C                   ENDSL
 
      ** MT942 MT920 Request
 
     C                   SELECT
     C                   WHEN      #0ACT6 = 'A'
     C                   EVAL      MTR942 = 'Y'
     C                   WHEN      #0ACT6 = 'D'
     C                   EVAL      MTR942 = 'N'
     C                   ENDSL
 
     C                   OUT       GLM94XDA
 
      ** Reset action codes.
 
     C                   EVAL      #0ACT1 = *Blanks
     C                   EVAL      #0ACT2 = *Blanks
     C                   EVAL      #0ACT3 = *Blanks
     C                   EVAL      #0ACT4 = *Blanks
     C                   EVAL      #0ACT5 = *Blanks
     C                   EVAL      #0ACT6 = *Blanks
 
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * SRInitProc : Initiate Process                                 *
      *****************************************************************
 
     C     SRInitProc    BEGSR
 
      ** Send a 'C' to data queue GLM94XDQ to initiate process
      *
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    PDataQueue
     C                   PARM                    PLibrary
     C                   PARM                    PDataLength
     C                   PARM                    PData
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRExit - Exits from program                                   *
      *****************************************************************
 
     C     SRExit        BEGSR
 
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * SRRefresh - Refresh Input Capable Fields with Blanks          *
      *****************************************************************
 
     C     SRRefresh     BEGSR
 
      ** Reset error indicator and working fields.
 
     C                   EVAL      WError = 'N'                                 General Error Flag
     C                   MOVEA     '000000'      *IN(27)                        Reset Error Ind.
     C                   EVAL      WMRPD = *ZEROS                               Minimum Run. Period.
     C                   EVAL      WPERQ = *ZEROS                               Period of Expirity
 
      ** Reset action codes.
 
     C                   EVAL      #0ACT1 = *Blanks
     C                   EVAL      #0ACT2 = *Blanks
     C                   EVAL      #0ACT3 = *Blanks
     C                   EVAL      #0ACT4 = *Blanks
     C                   EVAL      #0ACT5 = *Blanks
     C                   EVAL      #0ACT6 = *Blanks
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRActivate - Activate Job                                     *
      *****************************************************************
 
     C     SRActivate    BEGSR
 
      ** Set up the flag "Requested Stop of the Production Monitor Job"
      ** to 'N'
 
     C     *LOCK         IN        GLM94XDA
     C                   EVAL      MTRQDS = 'N'
     C                   OUT       GLM94XDA
 
     C                   EVAL      POperation = '*START'
     C                   EVAL      PMode = *Blanks
 
     C                   CALL      'GLC001410'
     C                   PARM                    POperation
     C                   PARM                    PMode
     C                   PARM                    PRetCode
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDeactivate - Deactivate Job                                 *
      *****************************************************************
 
     C     SRDeactivate  BEGSR
 
      ** Not possible if the job isn't normally running
 
     C                   EXSR      SRJobStatus
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0JOBS = PMsgText
 
     C                   IF        PMsgID <> 'ME00085' AND PMsgID <> 'ME00087'
     C                   EVAL      PMsgId = 'ME00133'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Set up the flag "Requested Stop of the Production Monitor Job"
      ** to 'Y'
 
     C     *LOCK         IN        GLM94XDA
     C                   EVAL      MTRQDS = 'Y'
     C                   OUT       GLM94XDA
 
     C                   EVAL      POperation = '*END'
     C                   EVAL      PMode = '*SYNCH'
 
     C                   CALL      'GLC001410'
     C                   PARM                    POperation
     C                   PARM                    PMode
     C                   PARM                    PRetCode
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRNetMonitor - Network Monitor                                *
      *****************************************************************
 
     C     SRNetMonitor  BEGSR
 
     C                   EVAL      #0POSN  = *BLANKS                            Position on Network
     C                   EVAL      SavPOSN = #0POSN                             Save Pos. on Network
 
     C                   EXSR      SRClrSfl                                     Init. Subfile
     C                   EXSR      SRLoad                                       Load Subfile
 
     C                   DOW       *INKC = *OFF
 
     C                   EXSR      SRDisplay                                    Show screen
 
      ** Selection.
 
     C                   SELECT
     C                   WHEN      SavPOSN <> #0POSN                            Position on Network
     C                   EVAL      SavPOSN = #0POSN                             Save Pos. on Network
     C                   EXSR      SRClrSfl                                     Init. Subfile
     C                   EXSR      SRLoad                                       Load Subfile
 
      ** Exit.
 
     C                   WHEN      *INKC = *ON                                  Exit
     C                   EXSR      SRInitProc
     C                   EXSR      SRExit
 
      ** Refresh second screen.
 
     C                   WHEN      *INKE = *ON                                  Refresh
     C                   EVAL      #0POSN = *BLANKS                             Position on Network
     C                   EXSR      SRClrSfl                                     Init. Subfile
     C                   EXSR      SRLoad                                       Load Subfile
 
      ** Go back to first screen.
 
     C                   WHEN      *INKP = *ON
     C                   EXSR      SRRefresh                                    Refresh first Screen
     C                   LEAVE
 
      ** Roll up/back.
 
     C                   WHEN      *IN54 = *ON                                  Rollup
     C                   EXSR      SRLoad                                       Load Subfile
 
     C                   OTHER
 
      ** Pocess action.
 
     C                   EXSR      SRProcess
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRClrSfl - Initialise and Load Subfile Page                   *
      *****************************************************************
 
     C     SRClrSfl      BEGSR
 
      ** Clear Subfile.
 
     C                   EVAL      *IN50 = *ON                                  SFLCLR
     C                   WRITE     ME000055C0
     C                   EVAL      *IN50 = *OFF                                 SFLDSPCTL
     C                   EVAL      *IN51 = *OFF                                 SFLEND
     C                   EVAL      *IN53 = *OFF                                 SFLDSP
 
     C                   EVAL      WError = 'N'                                 General Error Flag
     C                   EVAL      *IN33 = *OFF                                 Error on Action
 
      ** Reset Number of Records in Subfile.
 
     C                   EVAL      WRCTR  = *ZEROS                              Records by Page
     C                   EVAL      #0SFRN = *ZEROS                              RRN
     C                   EVAL      WLRCD  = *ZEROS                              Last RRN
 
      ** Position on the selected network.
 
     C     #0POSN        SETLL     GLNWKAPD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLoad - Load Subfile Page                                    *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
     C                   EVAL      WRCTR  = *ZEROS                              Records by page
     C                   EVAL      #0SFRN = WLRCD                               Restore Last RRN
 
     C                   READ      GLNWKAPD
 
      ** No data to display.
 
     C                   IF        %EOF(GLNWKAPD)
     C                   EVAL      PMsgId = 'ME00080'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Load Subfile.
 
     C                   DOW       NOT %EOF(GLNWKAPD)                           Not End of File
     C                             AND WRCTR < 2                                Only 2 rcd by screen
 
     C                   EVAL      #0SELE = *Blanks                             Action Code
 
     C                   EVAL      #0NWRK = MTNWRK                              Network Code
     C                   EVAL      #DNWRK = #DESC(1)                                          245711
     C                   SELECT
     C                   WHEN      MTSSTS = 'A'                                 Network Status
     C                   EVAL      #0STAT = 'Active'                            Network Active
     C                   EVAL      #DSTAT = #DESC(2)                                          245711
     C                   WHEN      MTSSTS = 'I'                                 Network Status
     C                   EVAL      #0STAT = 'Inactive'                          Network Inactive
     C                   EVAL      #DSTAT = #DESC(2)                                          245711
     C                   ENDSL
 
      ** Reset the counters.                                                    Request
 
     C                   EVAL      WCntWait = *ZEROS                            Waiting
     C                   EVAL      WCntExpr = *ZEROS                            Expired
     C                   EVAL      WCntSubm = *ZEROS                            Submitted
     C                   EVAL      WCntGenr = *ZEROS                            Generated
     C                   EVAL      WCntDupr = *ZEROS                            Duplicate
     C                   EVAL      WCntHldr = *ZEROS                            Hold
     C                   EVAL      WCntErro = *ZEROS                            Error
     C                   EVAL      WCntMovt = *ZEROS                            No Movement
     C                   EVAL      WCntReqs = *ZEROS                            Nb. Request
 
      ** Retrieve the statistiques information concerning the network request.
 
     C     MTNWRK        SETLL     GLMR94L1
     C     MTNWRK        READE     GLMR94L1
 
     C                   DOW       NOT %EOF(GLMR94L1)
 
      ** Process only the today's request.
 
     C                   IF        MRRDTE = BJRDNB                              Request Date
 
     C                   EVAL      WCntReqs = WCntReqs + 1                      Nb. Request
 
     C                   SELECT
     C                   WHEN      MRSTAT = 'WAITING'
     C                   EVAL      WCntWait = WCntWait + 1
 
     C                   WHEN      MRSTAT = 'EXPIRED'
     C                   EVAL      WCntExpr = WCntExpr + 1
 
     C                   WHEN      MRSTAT = 'SUBMITTED'
     C                   EVAL      WCntSubm = WCntSubm + 1
 
     C                   WHEN      MRSTAT = 'GENERATED'
     C                   EVAL      WCntGenr = WCntGenr + 1
 
     C                   WHEN      MRSTAT = 'DUPLICATE'
     C                   EVAL      WCntDupr = WCntDupr + 1
 
     C                   WHEN      MRSTAT = 'HELD'
     C                   EVAL      WCntHldr = WCntHldr + 1
 
     C                   WHEN      MRSTAT = 'NO MOVT'
     C                   EVAL      WCntMovt = WCntMovt + 1
 
     C                   OTHER                                                  ERROR
     C                   EVAL      WCntErro = WCntErro + 1
 
     C                   ENDSL
     C                   ENDIF
 
     C     MTNWRK        READE     GLMR94L1
 
     C                   ENDDO
 
      ** Load screen fields
 
     C                   EVAL      #0REQS = WCntReqs
     C                   EVAL      #DREQS = #DESC(3)                                          245711
     C                   EVAL      #0WAIT = WCntWait
     C                   EVAL      #DWAIT = #DESC(4)                                          245711
     C                   EVAL      #0EXPR = WCntExpr
     C                   EVAL      #DEXPR = #DESC(5)                                          245711
     C                   EVAL      #0SUBM = WCntSubm
     C                   EVAL      #DSUBM = #DESC(6)                                          245711
     C                   EVAL      #0GENR = WCntGenr
     C                   EVAL      #DGENR = #DESC(7)                                          245711
     C                   EVAL      #0DUPR = WCntDupr
     C                   EVAL      #DDUPR = #DESC(8)                                          245711
     C                   EVAL      #0HLDR = WCntHldr
     C                   EVAL      #DHLDR = #DESC(9)                                          245711
     C                   EVAL      #0ERRO = WCntErro
     C                   EVAL      #DERRO = #DESC(10)                                         245711
     C                   EVAL      #0MOVT = WCntMovt
     C                   EVAL      #DMOVT = #DESC(11)                                         245711
 
      ** Subfile control update
 
     C                   EVAL      *IN23  = *OFF                                SFLNXTCHG
     C                   EVAL      *IN53  = *ON                                 SFLDSP
 
     C                   EVAL      #0SFRN = #0SFRN + 1
     C                   EVAL      WRCTR  = WRCTR + 1                           Nb. of records
 
     C                   WRITE     ME000055S0
 
     C                   READ      GLNWKAPD
 
     C                   ENDDO
 
     ** Seton SFLEND indicator if EOF
 
     C                   IF        %EOF(GLNWKAPD)
     C                   EVAL      *IN51 = *ON
     C                   ELSE
 
     ** Reposition on previous record to process the last record read but not treated
     ** due to the number of record by page.
 
     C                   READP     GLNWKAPD
     C                   ENDIF
 
     ** Save last relative record number to workfield
 
     C                   EVAL      WLRCD = #0SFRN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcess - Process screen input                              *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   EVAL      WError = 'N'                                 General Error Flag
 
      ** If Network found.
 
     C                   IF        *IN53
 
      ** Valid entries.
 
     C                   READC     ME000055S0
 
     C                   DOW       NOT %EOF(ME000055DF)
 
     C                   IF        #0SELE <> *Blanks
     C                   EVAL      *IN23  = *ON                                 SFLNXTCHG
     C                   ENDIF
 
     C                   EVAL      *IN33 = *OFF                                 Error on Action
 
      ** Determine if selection is to activate or deactivate
 
     C                   SELECT
     C                   WHEN      #0SELE <> *Blanks and #0SELE <> 'A'
     C                             and #0SELE <> 'D'
     C                   EVAL      WError = 'Y'                                 General Error Flag
     C                   EVAL      *IN33 = *ON                                  Error on Action
     C                   EVAL      PMsgId = 'ME00082'                           Invalid Action
     C                   EXSR      SRZasnms
 
      ** Activate
 
     C                   WHEN      #0SELE = 'A' and #0STAT = 'Active'
     C                   EVAL      WError = 'Y'                                 General Error Flag
     C                   EVAL      *IN33 = *ON                                  Error on Action
     C                   EVAL      PMsgId = 'ME00083'                           Already active
     C                   EXSR      SRZasnms
 
      ** Deactivate
 
     C                   WHEN      #0SELE = 'D' and #0STAT = 'Inactive'
     C                   EVAL      WError = 'Y'                                 General Error Flag
     C                   EVAL      *IN33 = *ON                                  Error on Action
     C                   EVAL      PMsgId = 'ME00084'                           Already inactive
     C                   EXSR      SRZasnms
     C                   ENDSL
 
     C                   UPDATE    ME000055S0
 
     C                   READC     ME000055S0
 
     C                   ENDDO
 
      ** If no error, update Network Status
 
     C                   IF        WError = 'N'                                 General Error Flag
 
      ** Position at the beginning of Subfile.
 
     C                   EVAL      #0SFRN = 1
 
     C                   READC     ME000055S0
 
     C                   DOW       NOT %EOF(ME000055DF)
 
      ** Only action code A or D are processed.
 
     C     #0NWRK        CHAIN     UpGLNWKAD0
     C                   IF        %FOUND
     C                   SELECT
     C                   WHEN      #0SELE   = 'A'                               Active
     C                   EVAL      UpMTSSTS = 'A'
     C                   WHEN      #0SELE   = 'D'                               Inactive
     C                   EVAL      UpMTSSTS = 'I'
     C                   ENDSL
     C                   UPDATE    UpGLNWKAD0
     C                   ENDIF
 
     C                   READC     ME000055S0
 
     C                   ENDDO
 
      ** Clear and Load the subfile to get the last information.
 
     C                   EXSR      SRClrSfl                                     Init. Subfile
     C                   EXSR      SRLoad                                       Load Subfile
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTxt - Retrieve a message from message file               *
      *****************************************************************
 
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgId
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgText
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRStatus - Determine Status of a field                        *
      *****************************************************************
 
     C     SRStatus      BEGSR
 
     C                   IF        WMT94x = 'Y'
     C                   EVAL      PMsgID = 'ME00081'
     C                   ELSE
     C                   EVAL      PMsgID = 'ME00072'
     C                   ENDIF
 
     C                   EXSR      SRRtvTxt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZasnms - Message Handling Subroutine                        *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRClear - Clear Messages in Program Queue                     *
      *****************************************************************
 
     C     SRClear       BEGSR
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDisplay - Displays Subfile Page                             *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     ** Display subfile page
 
     C                   EVAL      *IN21 = *OFF
 
     C                   WRITE     ME000055F0
     C                   WRITE     ME000055F2
     C                   WRITE     ME000055C1
     C                   EXFMT     ME000055C0
 
     ** Clear messages from program message queue
 
     C                   EXSR      SRClear
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = PSProcPgm
     C                   EVAL      DBMOD  = PSProcMod
     C                   EVAL      DBFILE = *Blanks
     C                   EVAL      DBKEY  =  *Blanks
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
 
      ** Obtain default message file
 
     C     *DTAARA       DEFINE    Y2MGFLA       PZADFMF
     C                   IN        PZADFMF
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0PGMQ = PSProcPgm
 
      ** Clear messages in program queue
 
     C                   EXSR      SRClear                                      Clear Pgm Msgq
 
      ** Initialise Data Structure to avoid decimal error.
 
     C                   CLEAR                   DSPRMO
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
** #DESC                                                                                    BUG26815
Network:                                                                                    BUG26815
Status:                                                                                     BUG26815
No. of requests...........:                                                                 BUG26815
No. of waiting requests...:                                                                 BUG26815
No. of expired requests...:                                                                 BUG26815
No. of submitted requests.:                                                                 BUG26815
No. of generated requests.:                                                                 BUG26815
No. of duplicated requests:                                                                 BUG26815
No. of held requests......:                                                                 BUG26815
No. of requests in error..:                                                                 BUG26815
No. of req with "No Movts":                                                                 BUG26815
