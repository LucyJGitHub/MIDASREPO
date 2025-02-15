     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Risk participant repair browse')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LERPRTRPB - Risk Participant Repair Browse                   *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of invalid risk participants  *
      *             for selection, the other picks off the selection  *
      *             made.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAAA03             Date 14Apr04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP069 *Create     Date 15Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAAA03 - Webfacing changes(re-compile).                      *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
     FLERPRTRDF CF   E             WORKSTN
     F                                     SFILE(LEIRPRTS1:@@RRN)
     FLEIRPRTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIRPRTD0:LEIRPRTX0)
     FLEIRPRTL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APILSETD0:APILSETX0)
     FAPILSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** � Automatically included D-specs       �
      ** � ==============================       �
      ** +--------------------------------------+
 
      **
      ** Standard D-specs
      ** ================
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** � End of automatically included D-specs�
      ** � =====================================�
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** � Manually included D-specs            �
      ** � =========================            �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
      ** +--------------------------------------+
 
     D InvTr         E DS                  EXTNAME(LEIRPRTPD)
     D InvTrSetIn    E DS                  EXTNAME(APILSETPD)
     D                                     PREFIX(S_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** Timestamp
     D @XTMSTSEL       S             26Z
     D @XREPNSEL       S              5S 0
 
      ** Successful Insert Text
     D                 DS
     D  S#FOTX                 1     40
     D  S#SIID                 1      6
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
      ** Array containing messages
 
      ** +--------------------------------------+
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+
 
      **   Timestamp selected
     D CSC011          S              1A
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S             26Z
 
      ** +--------------------------------------+
      ** � End of D-specs                       �
      ** � ==============                       �
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** �                                                                �
      ** � Initial processing is performed automatically: the *INZSR is   �
      ** � executed at program activation.                                �
      ** �                                                                �
      ** +----------------------------------------------------------------+
      *
      * INITIALISATION
      *
     C                   EXSR      INIT
      *
      * BUILD SUB-FILE
      *
     C     @BDSFL        IFEQ      'Y'
     C                   EXSR      BLDSFL
     C                   END
      *
      * READ SUBFILE RECORD
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEIRPRTS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
      **  If previous transaction was not successful due to record being
      **  updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   MOVE      *BLANKS       S#FOTX
     C     @SIID         IFNE      *BLANK
     C                   MOVEL     ErrorText(2)  S#FOTX
     C                   MOVEL     @SIID         S#SIID
     C                   MOVE      *BLANK        @SIID
     C                   MOVEL     S#FOTX        ERRORMSG
     C                   END
     C                   END
      *
     C                   WRITE     LEIRPRTF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     LEIRPRTL0
      *
      * Read an invalid risk participant
      *
     C                   EXSR      RDIRPRT
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LEV1005'     @ERRMS
     C                   EXFMT     LEIRPRTEND
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Write the invalid risk participant to the subfile.
      *
     C                   MOVE      *BLANK        S#OPT
     C                   Z-ADD     @@RRN         S#SFRN
     C                   MOVE      XREPN         @XREPN
     C                   MOVE      XTMST         @XTMST
     C                   WRITE     LEIRPRTS1
      *
      * Read an invalid risk participant
      *
     C                   EXSR      RDIRPRT
     C                   END
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     LEIRPRTS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEIRPRTS0                              99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     S#OPT         ORNE      *BLANK
     C                   READC     LEIRPRTS1                              99
      *
      * Validate repair option code
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      VALID_ROPT
     C                   END
      *
      ** If 'E' is input, enquire upon invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     S#OPT         ANDEQ     'E'
     C                   MOVE      @XREPN        @XREPNSEL
     C                   MOVE      @XTMST        @XTMSTSEL
     C                   EXSR      ENQ_INV
     C                   MOVEL     *BLANK        S#OPT
     C                   END
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     S#OPT         ANDEQ     'Q'
     C                   MOVE      @XREPN        @XREPNSEL
     C                   MOVE      @XTMST        @XTMSTSEL
     C                   EXSR      PROM_DELT
     C                   MOVEL     *BLANK        S#OPT
     C                   END
     C                   END
      *
      **  Return the selected option, action and repair sequence
      *
     C     *IN99         IFNE      '1'
     C     S#OPT         ANDNE     *BLANK
      *
     C                   MOVE      S#OPT         @OPSEL
     C                   MOVE      S#ACTN        @ACSEL
     C                   MOVE      @XREPN        @XREPNSEL
     C                   MOVE      @XTMST        @XTMSTSEL
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALID_ROPT - VALIDATE REPAIR OPTION CODE
      *****************************************************************
     C     VALID_ROPT    BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
 
      * INPUTS
 
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Option code
      * Front Office ID
      * Booking Branch
     C                   PARM                    S#OPT
     C                   PARM                    DDFRNT           20
     C                   PARM                    DDBRSN            3
 
      * ICD Single branch code
     C                   PARM                    BJSBRC
 
      * OUTPUTS
 
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      **  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, continue with next option
      *
     C     @INKL         IFEQ      '1'
     C                   MOVEL     *BLANK        S#OPT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - ENQUIRE ON INVALID TRANSACTION
      *****************************************************************
     C     ENQ_INV       BEGSR
 
      * Set up unique id
 
     C                   MOVE      @XREPNSEL     @XREPN
     C                   MOVE      @XREPNSEL     ##REPN            5
     C                   MOVE      @XTMSTSEL     @XTMST
     C                   MOVEL     'LERPRT'      @XMSGTYP         32
 
      * Pass the invalid transaction details to the enquiry
 
     C     LEIRPRTX      CHAIN     LEIRPRTX0                          99
     C                   CLEAR                   InvTrSetIn
     C     APILSETX      CHAIN     APILSETX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
 
      * INPUTS
 
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Action code
      * Front Office ID
      * Associated Front Office ID
      * Timestamp
     C                   PARM      S#ACTN        DDACTN            1
     C                   PARM                    DDFRNT
     C                   PARM                    DDFAFRT          20
     C                   PARM                    @XTMST
 
      * Invalid file names
     C                   PARM      'LEIRPRTPD'   InvFile1         10
     C                   PARM      'APILSETPD'   InvFile2         10
     C                   PARM                    InvFile3         10
     C                   PARM      *Blanks       InvFile4         10                        MD041294
 
      * Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM      InvTrSetIn    InvFDta2       4000
     C                   PARM                    InvFDta3       4000
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
 
      * OUTPUTS
 
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      **  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PROM_DELT - PROMPT FOR DELETION
      *****************************************************************
     C     PROM_DELT     BEGSR
 
      * Set up unique id
 
     C                   MOVE      @XREPNSEL     ##REPN            5
     C                   MOVE      @XTMSTSEL     @XTMST
      *
     C                   CALLB     'ZAINVTRDEL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action code
     C                   PARM      S#ACTN        DDACTN            1
      *
      * Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFRNT
     C                   PARM                    DDAFRT
      *
      * Timestamp
     C                   PARM                    @XTMST
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      S#PMFC        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      S#PMFT        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      S#PMFN        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      S#CSSN        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      S#JDTE        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      S#SHTP        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      S#SHAR        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM                    DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM                    DDFLD9           35
      *
      * OUTPUTS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      **  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F10, delete invalid risk participant
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      @XREPN        @XREPNSEL
     C                   MOVE      @XTMST        @XTMSTSEL
     C                   MOVEL     'LERPRT'      @XMSGTYP
     C     LEIRPRTK      CHAIN     LEIRPRTD0                          99
     C  N99              DELETE    LEIRPRTD0
     C     APILSETK      CHAIN     APILSETD0                          99
     C  N99              DELETE    APILSETD0
 
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'LERPRT'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = XTMST
 
     C     KAPLOG        CHAIN     APILOGL0                           99
 
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   COMMIT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Read an invalid risk participant
      *****************************************************************
     C     RDIRPRT       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      LEIRPRTL0                              96
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'LEA0302'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTXT - RETRIEVE TEXT
      *****************************************************************
     C     RTVTXT        BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALISATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * If 24x7 is present then journal APILOGL0
      *
     C                   IF        (CSC011 = 'Y')
     C                   OPEN      APILOGL0                             22
     C                   ENDIF
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @ACSEL
     C                   CLEAR                   @XREPNSEL
     C                   CLEAR                   @XTMSTSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
      *
      * Error in update of previous risk participant
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * REPAIR NUMBER OF TRANSACTION SELECTED
     C                   PARM                    @XREPNSEL
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @XTMSTSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Successful Insert ID
      *
     C                   PARM                    @SIID             6
      *
     C                   PARM                    CSC011
 
      ** Access SDSTAT and SC24X7 if CSC011 is installed
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
      ** Screen fields
 
     C                   MOVE      PSUser        S#USER
     C                   MOVE      PSJobName     S#WSID
     C                   MOVE      BJMRDT        S#RUNA
 
      ** Access SDSTAT and SC24X7 if CSC011 is installed
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      * Key Lists
 
     C     LEIRPRTK      KLIST
     C                   KFLD                    @XREPNSEL
     C                   KFLD                    @XTMSTSEL
     C     LEIRPRTX      KLIST
     C                   KFLD                    @XREPNSEL
     C                   KFLD                    @XTMSTSEL
     C     APILSETK      KLIST
     C                   KFLD                    @XMSGTYP
     C                   KFLD                    @XTMSTSEL
     C                   KFLD                    DDFRNT
     C     APILSETX      KLIST
     C                   KFLD                    @XMSGTYP
     C                   KFLD                    DDFRNT
     C                   KFLD                    @XTMSTSEL
 
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
      ** Message Type
 
     C                   MOVEL     'RPRT'        @MSGTYPE          4
 
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION
      *
     C                   MOVEL     'APA2011'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA2012'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA2013'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA2014'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA2015'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'APA2016'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA2017'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
**  Array of error messages - ErrorText
The last transaction was not applied to the database
xxxxxx successfully inserted.
