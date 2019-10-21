     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Retail Accnt/Authority Holder Link Maint')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000105 - Retail Accnt/Authority Holder Link Maintenance    *
      *             2nd Screen                                        *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD038717           Date 18Oct19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23995 *CREATE   Date 19May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038717 - Not able to link Non-Account Holder to Retail     *
      *             Account.                                          *
      *           - Applied for MD050220                              *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23995 - Authority Holder/Retail account Link missing      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLoadFot - Load Footer                                      *
      *  SRLoad - Subrotuine to Load Subfile                          *
      *  SREndKy - Subrotuine to Update end keys and variables for    *
      *            file/subfile                                       *
      *  SRReset - Subrotuine to Clear/Reset Subfile                  *
      *  SRRepos - Subroutine to Reposition file                      *
      *  SRPgdn - Subroutine to Process Subfile Page Down             *
      *  SREnter - Subrotuine to Process enter key after subfile Disp *
      *  SRF03 - Subrotuine to process F3                             *
      *  SRF05 - Subrotuine to process F5                             *
      *  SRF09 - Subrotuine to Process F09 key toggle between ADD and *
      *          CHANGE mode                                          *
      *  SRF12 - Subrotuine to process F12                            *
      *  SRSflRc - Subroutine to Process subfile records after enter  *
      *  SRDelete - Subrotuine to Delete Records                      *
      *  SRRmvMsg - Remove program messages                           *
      *  SRSndMsg - Send message to program's message Queue           *
      *  SRValidate - Subrotuine to Perform Validation                *
      *  *INZSR   - Program initialization routine                    *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Accounts-Authority Holder Display File
      *
     FSD000105DFCF   E             WORKSTN INFDS(WSDS)
     F                                     SFILE(SD000105S0:WSflRrn)
      *
      ** Midas Authority holder/Retail Account Link - Update Index
      *
     FSDACAHL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Midas Authority holder/Retail Account Link - Retrieval Index
      *
     FSDACAHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACAHD0:SDACAHD1)
      *
      ** Midas SD Authority Types
      *
     FSDAUTPL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Link Types
      *
     FSDLINKL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Customer-Authority Holder Retrieval Index
      *
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Standard include for interactive programs
      ** Named hexadecimal constants for function keys
      *
     D WF01            C                   CONST(X'31')
     D WF02            C                   CONST(X'32')
     D WF03            C                   CONST(X'33')
     D WF04            C                   CONST(X'34')
     D WF05            C                   CONST(X'35')
     D WF06            C                   CONST(X'36')
     D WF07            C                   CONST(X'37')
     D WF08            C                   CONST(X'38')
     D WF09            C                   CONST(X'39')
     D WF10            C                   CONST(X'3A')
     D WF11            C                   CONST(X'3B')
     D WF12            C                   CONST(X'3C')
     D WF13            C                   CONST(X'B1')
     D WF14            C                   CONST(X'B2')
     D WF15            C                   CONST(X'B3')
     D WF16            C                   CONST(X'B4')
     D WF17            C                   CONST(X'B5')
     D WF18            C                   CONST(X'B6')
     D WF19            C                   CONST(X'B7')
     D WF20            C                   CONST(X'B8')
     D WF21            C                   CONST(X'B9')
     D WF22            C                   CONST(X'BA')
     D WF23            C                   CONST(X'BB')
     D WF24            C                   CONST(X'BC')
     D WClear          C                   CONST(X'BD')
     D WEnter          C                   CONST(X'F1')
     D WHelp           C                   CONST(X'F3')
     D WPagup          C                   CONST(X'F4')
     D WPagdn          C                   CONST(X'F5')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Standard include for all interactive programs
      ** Display file information data structure
      *
     D WSDS            DS
     D  WKey                 369    369
     D  WPagRrn              378    379B 0
      *
      ** DS for Entry Parameters
      *
     D PArmDS          DS
     D  DDACNO                 1     10
     D  DDCUST                11     16
     D  DDCCY                 17     19
     D  DDACOD                20     29
     D  DDACSQ                30     31
     D  DDBRCA                32     34
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Customer details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Additional Customer details
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** External Details for Non-Account Holder
      *
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
      ** Short DS used as parameter for access objects
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS 800 char Long to pass Access Object Details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Long DS to pass Access Object Details
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for access object programs
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PCust1          S              6A
     D PKySt           S              7A
     D PStKey          S              7A
      *
     D PBRCA           S              3
     D PCUSN           S              6
     D PCCY            S              3
     D PACOD           S              4
     D PACSQ           S              2
      *
      ** Working variables
      *
     D PMsgFile        S             10A
     D PMsgId          S             10A
     D PMsgData        S             45A
     D WExit           S              1A
     D WSflRrn         S              4P 0
     D WCount          S              2P 0
     D WMode           S              5A
     D WEndRrn         S              4P 0
     D WErr            S              1A
     D WERrn           S              4P 0
     D KfAcno          S             10S 0
     D KFLtyp          S              2A
     D DDACTN          S              1A
     D PAcno           S             10S 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Reset variables and clear subfile
      ** In case program called again after *INLR = *OFF
      ** ensures that program starts again properly
      *
     C                   RESET                   WExit
     C                   EXSR      SRReset
      *
     C                   EXSR      SRLoadFot
     C                   EXSR      SRLoad
      *
      ** Perform until exit requested Using F03
      *
     C                   DOU       WExit = *ON
      *
      ** Set time
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     SD000105C1
     C                   EXFMT     SD000105C0
      *
     C                   Z-ADD     WPagRrn       DDSFRC
      *
      ** Process response
      *
     C     WKey          CASEQ     WF03          SRF03
     C     WKey          CASEQ     WF05          SRF05
     C     WKey          CASEQ     WF09          SRF09
     C     WKey          CASEQ     WF12          SRF12
     C     WKey          CASEQ     WPagdn        SRPgdn
     C                   CAS                     SREnter
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** End of program
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadFot - Load Footer                                      *
      *                                                               *
      *  Called by: MAIN Processing, SRRepos, SRPgdn                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadFot     BEGSR
      *
     C                   IF        (DDACTN = 'I' OR DDACTN = 'A')
     C                   EVAL      *IN71  = *ON
     C                   EVAL      *IN72  = *ON
     C                   EVAL      *IN87  = *OFF
     C                   WRITE     SD000105F0
     C                   ELSEIF    DDACTN = 'E'
     C                   EVAL      *IN71  = *OFF
     C                   EVAL      *IN72  = *OFF
     C                   EVAL      *IN87  = *ON
     C                   WRITE     SD000105F0
     C                   EVAL      *IN89  = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad - Subrotuine to Load Subfile                          *
      *                                                               *
      *  Called by: MAIN Processing, SRRepos, SRPgdn                  *
      *                                                               *
      *  Calls: SREndKy, SRSndMsg                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
     C                   Z-ADD     0             WCount
     C                   MOVEL     DDACNO        PAcno
      *
     C                   IF        WMode = 'CHG'
      *
     C                   IF        WKey <> WPagdn
     C     PAcno         SETLL     SDACAHL1
     C                   ENDIF
      *
      ** Read a page of records or until EOF
      *
     C                   DOW       WCount < 12
     C     PAcno         READE     SDACAHL1
      *
     C                   IF        %EOF(SDACAHL1)
     C                   LEAVE
     C                   ELSE
      *
      ** Move Database contents into subfile fields
      *
     C                   EVAL      DDSELC = *BLANKS
     C                   EVAL      DDAUTH = AAAUTH
     C                   EVAL      DDLTYP = AALTYP
     C                   EVAL      DDTYPA = AATYPA
      *
      ** Populate hidden fields in subfile record
      *
     C                   EVAL      DDHACN =  AAACNO
     C                   EVAL      DDHAUT =  AAAUTH
     C                   EVAL      DDHLTP =  AALTYP
      *
      ** Get authority holder shortname
      ** Check if its a valid Non-Account Holder
      *
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDAUTH        PCust
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      MD050220
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD050220
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      DDAUSN = NHSHNM
     C                   ELSE
      *
      ** If not found, it must be a customer
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDAUTH        PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS OR
     C                             PStKey = 'ERROR'
     C                   EVAL      DDAUSN = *BLANKS
     C                   ELSE
     C                   EVAL      DDAUSN = BBCSSN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ADD       1             WCount
     C                   ADD       1             WSflRrn
     C                   WRITE     SD000105S0
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Set endkey values
      *
     C                   EXSR      SREndKy
      *
     C                   ELSE
      *
      ** In 'ADD' mode initialise the subfile with blank records
      *
     C                   DO        42
     C                   CLEAR                   SD000105S0
     C                   ADD       1             WSflRrn
     C                   WRITE     SD000105S0
     C                   ENDDO
     C                   Z-ADD     WSflRrn       WEndRrn
      *
     C                   ENDIF
      *
      ** If no records were added to subfile, set error indicators.
      *
     C                   IF        WSflRrn = *ZEROS
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN52 = *ON
     C                   WRITE     SD000105C0
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      PMsgId = 'USR3969'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ELSE
      *
      ** Else, set indicators to display subfile.
      *
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN42 = *ON
     C                   IF        %EOF(SDACAHL1)
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndKy - Subrotuine to Update end keys and variables for    *
      *            file/subfile                                       *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None r                                                *
      *                                                               *
      *****************************************************************
      *
     C     SREndKy       BEGSR
      *
     C                   MOVE      AAACNO        KfEAcno
     C                   EVAL      KfEAuth = AAAUTH
     C                   EVAL      KfELtyp = AALTYP
     C                   Z-ADD     WSflRrn       WEndRrn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Subrotuine to Clear/Reset Subfile                  *
      *                                                               *
      *  Called by: MAIN Processing, SRRepos                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear subfile and reset subfile display indicator.
      *
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *OFF
     C                   WRITE     SD000105C0
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
      *
     C                   MOVEA     '0000'        *IN(32)
      *
      ** Reset subfile record number and subfile position fields.
      *
     C                   RESET                   WSflRrn
     C                   RESET                   WEndRrn
     C                   RESET                   DDSFRC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRepos - Subroutine to Reposition file                      *
      *                                                               *
      *  Called by: SREnter, SRF05, SRF09                             *
      *                                                               *
      *  Calls: SRReset, SRLoadFot, SRLoad                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRepos       BEGSR
      *
      ** Clear subfile
      *
     C                   EXSR      SRReset
      *
     C                   EXSR      SRLoadFot
      *
      ** Reposition file to beginning
      *
     C                   EXSR      SRLoad
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPgdn - Subroutine to Process Subfile Page Down             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRLoadFot, SRLoad                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRPgdn        BEGSR
      *
      ** Only do if not EOF
      *
     C                   IF        NOT%EOF(SDACAHL1)
      *
      ** Continue with record after the last one read.
      *
     C     KFEKey        SETGT     SDACAHL1
     C                   Z-ADD     WEndRrn       WSflRrn
     C                   EXSR      SRLoadFot
     C                   EXSR      SRLoad
      *
      ** Set cursor position to first record on next page
      *
     C                   IF        WMode = 'CHG'
     C                   EVAL      DDSFRC = WSflRrn - WCount
     C                   EVAL      DDSFRC = DDSFRC + 1
     C                   ELSE
     C                   EVAL      DDSFRC = WSflRrn - 41
     C                   ENDIF
      *
      ** Page down beyond end of subfile
      *
     C                   ELSE
     C                   EVAL      *IN60 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnter - Subrotuine to Process enter key after subfile Disp *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRSflRc, SRRepos                                      *
      *                                                               *
      *****************************************************************
      *
     C     SREnter       BEGSR
      *
      ** Process subfile records
      *
     C                   EXSR      SRSflRc
      *
      ** Reposition the subfile if no errors
      *
     C                   IF        WMode = 'CHG'
      *
     C                   IF        WERrn = *ZEROS and WSFlRrn = *ZEROS
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      WExit = *ON
     C                   ELSEIF    WERrn = *ZEROS and WSFlRrn <> *ZEROS
     C                   EXSR      SRRepos
     C                   IF        WERrn = *ZEROS and WSFlRrn = *ZEROS
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      WExit = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WERrn = *ZEROS
     C                   EXSR      SRRepos
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF03 - Subrotuine to process F3                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRF03         BEGSR
      *
      ** set exit program flag
      *
     C                   EVAL      RetCodeIn = '*END'
     C                   EVAL      WExit = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF05 - Subrotuine to process F5                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRRmvMsg, SRRepos                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRF05         BEGSR
      *
      ** Remove previous error messages
      *
     C                   EXSR      SRRmvMsg
     C                   RESET                   WERrn
      *
      ** Set off error indicators
      *
     C                   MOVEA     '0000'        *IN(32)
      *
      ** Reposition subfile
      *
     C                   EXSR      SRRepos
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF09 - Subrotuine to Process F09 key toggle between ADD and *
      *          CHANGE mode                                          *
      *                                                               *
      *  Called by: MAIN Processing, SRF12                            *
      *                                                               *
      *  Calls: SRRmvMsg, SRRepos                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRF09         BEGSR
      *
     C                   IF        WMode = 'CHG'
     C                   EVAL      WMode = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      WMode = 'CHG'
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
      *
     C                   EXSR      SRRmvMsg
      *
      ** Clear and reload the subfile
      *
     C                   EXSR      SRRepos
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF12 - Subrotuine to process F12                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRF09                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRF12         BEGSR
      *
      ** Set exit program flag
      *
     C                   IF        WMode = 'CHG'
     C                   EVAL      RetCodeIn = '*PRV'
     C                   EVAL      WExit = *ON
     C                   ELSE
     C                   EXSR      SRF09
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSflRc - Subroutine to Process subfile records after enter  *
      *                                                               *
      *  Called by: SREnter                                           *
      *                                                               *
      *  Calls: SRRmvMsg, SRDelete, SRValidate                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSflRc       BEGSR
      *
      ** Remove previous error messages
      *
     C                   EXSR      SRRmvMsg
     C                   RESET                   WERrn
      *
      ** Set off error indicators
      *
     C                   MOVEA     '0000'        *IN(32)
      *
      * Read changed subfile records to end if sub file not empty
      *
     C                   IF        WSflRrn > *ZEROS
     C                   READC     SD000105S0                             98
     C                   DOW       *IN98 = *OFF
      *
     C                   EVAL      WErr = *OFF
     C                   IF        DDSELC = 'D'
     C                   EXSR      SRDelete
     C                   GOTO      LOOP
     C                   ENDIF
      *
      ** Do validation
      *
     C                   MOVEA     '0000'        *IN(32)
      *
     C                   EXSR      SRValidate
      *
      ** Change Mode
      *
     C                   IF        WMode = 'CHG'
      *
     C                   IF        DDSELC = *BLANKS AND
     C                             WErr = *OFF
     C     KFUKey        CHAIN     SDACAHL0
     C                   IF        %FOUND(SDACAHL0)
     C                   MOVE      DDACNO        AAACNO
     C                   EVAL      AAAUTH = DDAUTH
     C                   EVAL      AALTYP = DDLTYP
     C                   EVAL      AATYPA = DDTYPA
     C                   EVAL      AALCD  = BJRDNB
     C                   EVAL      AATYLC = 'C'
      *
      ** Reset hidden fields
      *
     C                   MOVE      DDACNO        DDHACN
     C                   EVAL      DDHAUT = DDAUTH
     C                   EVAL      DDHLTP = DDLTYP
      *
     C                   UPDATE    SDACAHD0
     C                   ENDIF
     C                   ENDIF
      *
      ** Add mode
      *
     C                   ELSE
     C                   IF        DDAUTH <> *BLANKS AND
     C                             DDLTYP <> *BLANKS AND
     C                             DDTYPA <> *BLANKS
      *
     C                   IF        WErr = *OFF
     C                   MOVE      DDACNO        AAACNO
     C                   EVAL      AAAUTH = DDAUTH
     C                   EVAL      AALTYP = DDLTYP
     C                   EVAL      AATYPA = DDTYPA
     C                   EVAL      AALCD  = BJRDNB
     C                   EVAL      AATYLC = 'I'
     C                   WRITE     SDACAHD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        WErr =  *ON
     C                   IF        WERrn = *ZEROS
     C                   Z-ADD     WSflRrn       WERrn
     C                   ENDIF
     C                   EVAL      *IN15 = *ON
     C                   ENDIF
      *
     C                   UPDATE    SD000105S0
     C                   MOVE      *OFF          *IN15
      *
     C     LOOP          TAG
     C                   READC     SD000105S0                             98
     C                   ENDDO
     C                   ENDIF
      *
     C                   IF        WERrn <> *ZEROS
     C                   Z-ADD     WERrn         DDSFRC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Subrotuine to Delete Records                      *
      *                                                               *
      *  Called by: SRSflRc                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
      ** Retrieve relevant record to be deleted
      *
     C     KFUKey        CHAIN     SDACAHL0
     C                   IF        %FOUND(SDACAHL0)
     C                   DELETE    SDACAHD0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRmvMsg - Remove program messages                           *
      *                                                               *
      *  Called by: SRF05, SRF09, SRSflRc                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRmvMsg      BEGSR
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send message to program's message Queue           *
      *                                                               *
      *  Called by : SRLoad, SRValidate                               *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMsg      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Subrotuine to Perform Validation                *
      *                                                               *
      *  Called by: SRSflRc                                           *
      *                                                               *
      *  Calls: SRSndMsg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
      *
     C                   IF        (WMode = 'ADD' AND
     C                             (DDAUTH <> *BLANKS OR
     C                             DDLTYP <> *BLANKS OR
     C                             DDTYPA <> *BLANKS)) OR
     C                             WMode = 'CHG'
      *
      ** Only action codes 'D' allowed
      *
     C                   IF        DDSELC <> 'D' AND
     C                             DDSELC <> *BLANKS
     C                   EVAL      PMsgId = 'USR5990'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
      *
      ** Authority Holder Number is mandatory
      *
     C                   IF        DDAUTH = *BLANKS
     C                   EVAL      PMsgId = 'USR5991'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN33 = *ON
      *
     C                   ELSE
      *
      ** Validate authority holder number entered
      *
     C                   IF        %SCAN('?':DDAUTH) <> *ZERO
     C                   EVAL      DDAUTH = '?'
     C                   ENDIF
      *
     C                   CLEAR                   SDCUST
      *
     C                   CALL      'AOCUSTR1'
      *
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C     PCust         PARM      DDAUTH        PCust
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF' AND
     C                             PRtCd <> '*CUSCLO'
      *
      ** Check if it is a valid Non - Account Holder
      *
     C                   CALL      'AONAHOR0'
      *
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C     PCust         PARM      DDAUTH        PCust
     C**********         PARM      SDNAHO        DSSDY                                      MD038717
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD038717
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      DDAUTH = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      PMsgId = 'USR5992'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN33 = *ON
      *
     C                   ELSE
      *
     C                   IF        DDAUTH = '?'
     C                   EVAL      DDAUTH = PCust
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDAUTH = '?'
     C                   EVAL      DDAUTH = PCust
     C                   ENDIF
      *
     C                   IF        PRtCd = '*CUSCLO'
     C                   EVAL      PMsgId = 'USR7681'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If customer number used cannot be same as customer of account
      *
     C                   IF        DDCUST = DDAUTH
     C                   EVAL      PMsgId = 'USR9933'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
      *
      ** Validate link type - mandatory
      *
     C                   IF        DDLTYP = *BLANKS
     C                   EVAL      PMsgId = 'USR5994'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN34 = *ON
     C                   ELSE
      *
      ** Link type must exist on link types table
      *
     C                   EVAL      KFLtyp = DDLTYP
      *
     C     KFLtyp        CHAIN     SDLINKL1
      *
     C                   IF        NOT %FOUND(SDLINKL1)
     C                   EVAL      PMsgId = 'USR5995'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN34 = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** If link type is 'WB' then the Address fields must be entered
      ** in the authority holder details or customer details.
      *
     C                   IF        DDLTYP = 'WB'
      *
     C                   CALL      'AOCUSTR1'
      *
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C     PCust         PARM      DDAUTH        PCust
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtCd = *BLANKS
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDAUTH        PCust
     C     SDACUS        PARM      SDACUS        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      E5BTHT = *BLANKS
     C                   EVAL      E5ZIPC = *BLANKS
     C                   EVAL      E5BTHC = *BLANKS
     C                   ENDIF
      *
     C                   IF        E5BTHT = *BLANKS OR
     C                             E5ZIPC = *BLANKS OR E5BTHC = *BLANKS
     C                   EVAL      PMsgId = 'USR9937'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   MOVEA     '11'          *IN(33)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Check if it is a valid Non - Account Holder
      *
     C                   CALL      'AONAHOR0'
      *
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C     PCust         PARM      DDAUTH        PCust
     C**********         PARM      SDNAHO        DSSDY                                      MD038717
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD038717
      *
     C                   IF        PRtCd = *BLANKS
     C                   IF        NHBTHT = *BLANKS OR
     C                             NHZIPC = *BLANKS OR NHCTYD = *BLANKS
     C**********         EVAL      PMsgId = 'USR9938'                                       MD038717
     C                   EVAL      PMsgId = 'USS0906'                                       MD038717
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   MOVEA     '11'          *IN(33)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check that the link has not already been set via the customer
      ** /authority holder link program.
      *
     C     KFCKey        CHAIN     SDCUAHL1
     C                   IF        %FOUND(SDCUAHL1)
     C                   IF        CAPRG1 = 'AL' OR CAPRG1 = 'RE'
     C                             OR CAPRG2 = 'AL' OR CAPRG2 = 'RE'
     C                             OR CAPRG3 = 'AL' OR CAPRG3 = 'RE'
     C                             OR CAPRG4 = 'AL' OR CAPRG4 = 'RE'
     C                   EVAL      PMsgId = 'USR9934'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   MOVEA     '111'         *IN(33)
     C                   ENDIF
     C                   ENDIF
      *
      ** Prevent duplicate keys being entered
      *
     C                   MOVE      DDACNO        KfAcno
     C                   IF        KfAcno <> DDHACN OR
     C                             DDAUTH <> DDHAUT OR
     C                             DDLTYP <> DDHLTP
     C     KfPKey        CHAIN     SDACAHL1
     C                   IF        %FOUND(SDACAHL1)
     C                   EVAL      PMsgId =   'USR5998'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   MOVEA     '111'         *IN(33)
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Authority types must exist on Authority Type Table
      *
     C                   EVAL      KFLtyp = DDTYPA
      *
     C     KFLtyp        CHAIN     SDAUTPL1
      *
     C                   IF        NOT %FOUND(SDAUTPL1)
     C                   EVAL      PMsgId = 'USR9935'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WErr  = *ON
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Action Code
      *
     C                   PARM                    DDACTN
      *
      ** Retail Account Details DS
      *
     C                   PARM                    PArmDs
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRtcd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      DDMRDT = BJMRDT
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Create program exit flag and set value to off
      *
     C                   MOVE      *OFF          WExit
      *
      ** Miscellaneous subfile program variables
      *
     C                   Z-ADD     0             WSflRrn
     C                   Z-ADD     0             WEndRrn
     C                   Z-ADD     0             WCount
     C                   Z-ADD     1             DDSFRC
      *
     C                   EVAL      WMode = 'CHG'
      *
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDPRGM = PSProcName
     C                   EVAL      DDJBNM = PSJobName
      *
     C     *LIKE         DEFINE    AAACNO        KfEAcno
     C     *LIKE         DEFINE    AAAUTH        KfEAuth
     C     *LIKE         DEFINE    AALTYP        KfELtyp
      *
      ** End key for repositioning subfile
      *
     C     KFEKey        KLIST
     C                   KFLD                    KfEAcno
     C                   KFLD                    KfEAuth
     C                   KFLD                    KfELtyp
      *
      ** Update key for updating and deleting - use hidden fields
      *
     C     KFUKey        KLIST
     C                   KFLD                    DDHACN
     C                   KFLD                    DDHAUT
     C                   KFLD                    DDHLTP
      *
      ** Key to Prevent duplicate keys being written
      *
     C     KFPKey        KLIST
     C                   KFLD                    KfAcno
     C                   KFLD                    DDAUTH
     C                   KFLD                    DDLTYP
      *
      ** Key to Prevent duplicate links on customer/account holder file
      *
     C     KFCKey        KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    DDAUTH
     C                   KFLD                    DDLTYP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
