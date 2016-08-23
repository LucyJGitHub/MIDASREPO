     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Historic Market Data Maint (Screen 1)')       *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS000017 - Historic Market Data Maint/Enq/Rpt Screen 1       *
      *                                                               *
      *  Function:  Maintenance screen for Historic Market Data       *
      *             collection which uses regression method of        *
      *             assessment.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS007             Date 26Apr04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAS007 - Hedge Accounting Control                            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FAS000017DFCF   E             WORKSTN
     F                                     SFILE(AS000017S1:W@RRN)
 
      ** Hedge Linkage file using Hedge Assmt 'R'
     FASHGLKJ0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Hedge Linkage file by Hedge ID
     FASHGLKL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Hedge Linkage File
     D ASHGLK        E DS                  EXTNAME(ASHGLKPD)
                                                                                              CAS007
      ** External DS for SC Switchable Features                                               CAS007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS007
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Struture for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Formatted date field for use in the parameter list
     D PDatFmt         S              1A
     D PDate           S              6S 0
     D PReturnCode     S              7
 
      ** Work Variables
     D WERRMS          S              7
     D PINKC           S              1
     D W@RRN           S              5S 0
     D W@CNT           S              2S 0
     D W@EOF           S              1
     D WTRNN           S              6S 0
     D PACTN           S              1
     D P@ERR           S              1  0
     D P@TEST          S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6                                                       CAS007
 
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
 
      ** Initialization
 
     C                   EXSR      SRINIT
 
      ** Dont exit program unless user press F3
 
     C                   DOU       PINKC = '1'
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
      ** Build Sub-file
 
     C                   EXSR      SRBLDS
 
      ** Read Subfile Record
 
     C                   EXSR      SRRDSF
 
      ** Validate changes in screen
 
     C                   EXSR      SRVAL
 
      ** If record was selected, read ASHGLKPD file linkage details.
      ** Then call program to display detail screen
 
     C                   IF        #1SELT <> *Blanks  AND
     C                             WERRMS = *Blanks
 
     C                   EXSR      SRRDHG
 
     C                   CALL      'AS000018'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    ASHGLK
     C                   PARM                    PINKC
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDS - Build Subfile                                       *
      *                                                               *
      *****************************************************************
 
     C     SRBLDS        BEGSR
 
      **  Initialise subfile relative record number.
 
     C                   EVAL      W@RRN = 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     AS000017C1
     C                   EVAL      *IN97 = *OFF
 
      **  Set file pointer on key displayed on screen.
 
     C                   IF        #1TRNN <> *BLANK
     C     WTRNN         SETLL     ASHGLKJ0                           89
     C                   ELSE
     C     *LOVAL        SETLL     ASHGLKJ0                           89
     C                   ENDIF
 
      **  Read a Valid Transaction
 
     C                   EXSR      SRRDTR
 
      ** Set up message 'No data to display'
 
     C                   EVAL      *IN80 = *OFF
     C                   IF        W@EOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 is input.
 
     C                   DOW       *IN98 = *ON
 
      **  Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             W@CNT
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       W@EOF <> 'Y' AND
     C                             W@CNT < 16
 
      **  Increment the subfile record no. and records written fields.
 
     C                   ADD       1             W@RRN
     C                   ADD       1             W@CNT
 
      **  Format Transaction fields for output
 
     C                   EXSR      SRFMTT
 
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      #1SELT = *BLANK
     C                   EVAL      #1SFRN = W@RRN
     C                   WRITE     AS000017S1
 
      **  Read a valid Transaction
 
     C                   EXSR      SRRDTR
     C                   ENDDO
 
      **  Set up footer toggle text and write the footer
 
     C                   WRITE     AS000017F0
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      **  Write the message subfile
 
     C                   WRITE     AS000017C0
 
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
 
     C                   IF        W@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     AS000017C1
     c                   EVAL      *IN97 = *OFF
     C                   EVAL      W@RRN  = 1
     C                   EVAL      #1SFRN = 1
 
      **  Write to the subfile with non-display set on
 
     c                   EVAL      *IN93 = *ON
     C                   WRITE     AS000017S1
     C                   WRITE     AS000017C1
     c                   EVAL      *IN93 = *OFF
     c                   ELSE
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     AS000017C1
     c                   ENDIF
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      AS000017C1                             99
 
      **  If F3, bypass further processing.
 
     C                   IF        *INKC = *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
      ** Clear any messages before processing user input
 
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WERRMS     = *BLANKS
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDSF - Read Subfile Record                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRDSF        BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       *IN99 = *ON OR
     C                             #1SELT <> *BLANK
     C                   READC     AS000017S1                             99
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDHG - Read Hedge Linkage Details File (ASHGLK)            *
      *                                                               *
      *****************************************************************
 
     C     SRRDHG        BEGSR
 
     C     #1HEDI        CHAIN     ASHGLKL0
 
     C                   IF        NOT %FOUND(ASHGLKL0)
     C                   EVAL      DBFILE = 'ASHGLKPD'
     C                   EVAL      DBASE = 2
     C                   MOVE      #1HEDI        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTT - Format Transaction for Output                       *
      *                                                               *
      *****************************************************************
 
     C     SRFMTT        BEGSR
 
      ** Hedge ID
 
     C                   EVAL      #1HEDI = FSHEDI
 
      ** Hedge Strategy Shortname
 
     C                   EVAL      #1HGST = FSHGST
 
      ** Effective Date
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    FSEFFD
     C                   PARM                    PDatFmt
     C                   PARM                    PDate
     C     #1EFFD        PARM                    #1EFFD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDTR - Read a Transaction                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRDTR        BEGSR
 
     C                   EVAL      W@EOF = *Blanks
 
      **  Read the file initially - if W@EOF is set on then the end of
      **  the file has been reached.
 
     C                   READ      ASHGLKJ0                               96
 
      ** End of File
 
     C                   IF        *IN96 = *ON
     C                   EVAL      W@EOF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHAU - Check for User Authority if not Multi-branching     *
      *                                                               *
      *****************************************************************
 
     C     SRCHAU        BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PACTN
     C                   PARM                    P@ERR
 
      * Return error message
 
     C                   IF        P@ERR = 1
     C                   EVAL      WERRMS = 'FXM0292'
     C                   EXSR      SRSNDM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL  - Validate Screen Fields                              *
      *                                                               *
      *****************************************************************
 
     C     SRVAL         BEGSR
 
      **  Validate that the transaction reference is numeric or blank.
 
     C                   TESTN                   #1TRNN               98
     C                   MOVE      #1TRNN        W@TEST            1
     C                   TESTZ                   W@TEST                   99
 
     C                   IF        #1TRNN = *BLANKS OR
     C                             *IN98 = *ON AND
     C                             *IN99 = *ON
     C                   MOVE      #1TRNN        WTRNN
 
      ** Return error message
 
     C                   ELSE
     C                   EVAL      WERRMS = 'BBM0022'
     C                   EXSR      SRSNDM
     C                   ENDIF
 
      ** Validate selection code
 
     C                   IF        #1SELT <> '1' AND #1SELT <> *Blanks
     C                   EVAL      WERRMS = 'FIS0031'
     C                   EVAL      *IN92 = *ON
     C                   EXSR      SRSNDM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM - Send a Message to Detail Screen                     *
      *                                                               *
      *****************************************************************
 
     C     SRSNDM        BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     WERRMS        MsgIdArr(E)
 
     C     EndSRSNDM     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialization                                      *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Clear outputs
 
     C                   EVAL      #1TRNN = *BLANKS
     C                   EVAL      *INKC  = '0'
     C                   EVAL      PINKC  = '0'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'AS000017'
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WID = PsJobName
     C                   EVAL      #1USER = PsUser
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      #0PGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS007
      ** Check if CAS007 is installed                                                         CAS007
                                                                                              CAS007
     C                   CALL      'AOSARDR0'                                                 CAS007
     C                   PARM      *BLANKS       PRTCD                                        CAS007
     C                   PARM      '*VERIFY'     POPTN                                        CAS007
     C                   PARM      'CAS007'      PSARD                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
      ** If CAS007 is not installed, exit from the program                                    CAS007
                                                                                              CAS007
     C                   IF        PRTCD = '*NRF   '                                          CAS007
     C                   EVAL      *INLR = *ON                                                CAS007
     C                   RETURN                                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        PRTCD <> *BLANKS  AND                                      CAS007
     C                             PRTCD <> '*NRF   '                                         CAS007
     C                   EVAL      DBKEY = PSARD                                              CAS007
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS007
     C                   EVAL      DBASE  =  3                                                CAS007
     C                   EXSR      *PSSR                                                      CAS007
     C                   ENDIF                                                                CAS007
 
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SRCHAU
     C                   ENDIF
 
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
