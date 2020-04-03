     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Exemption Threshold Tape Extract Prompt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000792 - Midas SD Exemption Threshold Tape Extract Prompt  *
      *                                                               *
      *  Function: Selection of header branch and branches to report  *
      *            There are parameters pass to SD000791,who generate *
      *            the tape file SDSADVPD that includes the details   *
      *            of all withholding tax exemption applicants        *
      *            (FREISTELLUNGSANTRAEGE)                            *
      *                                                               *
      *  (phase(s)) This selectiion will be produced by Midas on -    *
      *             request during input cycle.                       *
      *                                                               *
      *  Called By: SDC000792 - Exemption Threshold Tape Extract      *
      *                         Prompt                                *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD055146           Date 04Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24173           Date 03Jun09               *
      *                 BUG22798           Date 11Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24173 - Exemption Threshold Extract contains no records   *
      *  BUG22798 - place validation to action code in subfile        *
      *           to flag appropriate branch                          *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *    42+43      Subfile for branches : Display indicators       *
      *    46         Subfile for branches : Field indicator          *
      *                                                               *
      *    50         Screen format 2 : Error indicator               *
      *    51         Screen format 1 : Error indicator               *
      *                                                               *
      *    85         Subfile for error : indicator                   *
      *    87         Bank Level User                                 *
      *    88+89      Bottom of screen indicator                      *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRDsply - Select Branch for tape header                      *
      *            (Branches to report onto heading branch)           *
      *  SRDsp2 - Select Branch for tape header into user agreed      *
      *           ones                                                *
      *  SRDsp3 - Display subfile to select branch to report          *
      *  SRFill - Fill array with branches                            *
      *  SRClr  - Clear Subfile                                       *
      *  SRLoad - Subfile - Load subfile reocrd from arrays           *
      *  SRSall - Subfile - Select all branches                       *
      *  SRRdSl - Subfile - Read selected branch(es)                  *
      *  SRDsp4 - Dsiplay confirmation SCREEN                         *
      *                                                               *
      *  SRSndMsg - Send message to program's message Queue           *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSD000792DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD000792S2:DDRRN1)
      *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** ArrAbCd in Four positions : 1 - 1 : Selected (if not blank)
      **                             2 - 4 : Branch Code
      ** ArrAbNm : Branch description
      *
     D ArrAbCd         S              4     DIM(200)
     D ArrAbNm         S             30     DIM(200)
      *
      ** WORK Parameter
      *
     D PBrch           DS
     D  DDWHBRCD               1      3
     D***Brcd***                       3    DIM(32)                                         MD055146
     D  Brcd                          3    DIM(999)                                         MD055146
      *
      ** System rundat information (AGMBIN : multi branching indicator)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** User default data structure (DBRN : Default branch)
      *
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
      *
      ** Short Data Structures used by Access Programs.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs, long data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Bank Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WSel            S              1A
     D WStop1          S              1A
     D WStop2          S              1A
     D WStop3          S              1A
     D WStop4          S              1A
     D WRun            S              1A
     D WInKi           S              1A
     D WAutAll         S              1A
     D WVali           S              1A
     D WAct            S              1A
     D WOne            S              1S 0
     D WCpy2           S             80A
     D WdPgm           S             10A
     D WdUsr           S             10A
     D PChkErr         S              1S 0
     D PChkBrc         S              3A
     D WLineErr        S              4S 0                                                  BUG22798
     D WOptErr         S               N                                                    BUG22798
      *
      ** Default Message File
      *
     D PMsgf           S             10A
     D Wj              S              3S 0
     D Wx              S              3S 0
     D Wi              S              3S 0
     D WChkSel         S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D PBrca           S              3A
     D PArmr           S              2A
     D ZDayNo          S              5S 0
     D ZDate           S              6S 0
     D ZAdate          S              7A
      *
      ** Program Queue
      *
     D ZApgm           S             10A
      *
      ** Rel Queue
      *
     D ZApgrl          S              5A
      *
      ** Message Id
      *
     D ZAmsid          S              7A
      *
      ** Message file
      *
     D ZAmsgf          S             10A
      *
      ** Message data
      *
     D ZAmsda          S            132A
      *
      ** Message type
      *
     D ZAmstp          S              7A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      ** MAIN PROCEDURE                                               *
      *****************************************************************
      *
     C                   IF        AGMBIN = 'Y'
      *
      ** Execute Screens processing to select Branch header
      ** and branch to report onto this heading branch.
      *
     C                   EXSR      SRDsply
      *
     C                   ENDIF
      *
     C                   IF        WVali = 'Y'
      *
      ** Loading parameter BRCD with selected branches
      *
     C                   IF        (WInKi = 'Y') AND
     C                             (WAutAll = *BLANKS)
     C                   MOVEA     *BLANKS       ArrAbCd(1)
     C                   ENDIF
      *
     C                   Z-ADD     1             Wj
      *
     C     1             DO        32            Wx
     C                   MOVEL     ArrAbCd(Wx)   WChkSel
     C                   IF        WChkSel <> *BLANKS
      *
     C                   MOVE      ArrAbCd(Wx)   Brcd(Wj)
     C                   EVAL      Wj = Wj + 1
      *
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
      *
     C                   MOVE      'F3'          PArmr
     C                   MOVE      *BLANKS       PBrch
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
      ** Return from Program
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDsply - Select Branch for tape header                      *
      *            Branches to report onto heading branch             *
      *                                                               *
      *  Called by : MAIN                                             *
      *                                                               *
      *  Calls : SRDsp2, SRDsp3, SRSndMsg                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDsply       BEGSR
      *
      ** Set indicator for bottom
      *
     C                   MOVEA     '00'          *IN(88)
      *
      ** Set working indicator WStop1 : Display screen 1 while = 'N'
      *
     C                   EVAL      WStop1 = 'N'
      *
     C                   DOW       WStop1 = 'N'
      *
      ** Affiche Screen 1
      *
     C                   WRITE     SD000792T1
     C                   WRITE     SD000792C0
      *
      ** Read first format screen
      *
     C                   EXFMT     SD000792F1
      *
      ** Initialise program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZApgm
     C                   PARM      '*SAME'       ZApgrl
      *
     C                   EVAL      *IN51 = *OFF
      *
      ** ENTER key pressed
      *
     C                   IF        (*INKC <> *ON) AND
     C                             (*INKF <> *ON)
      *
      ** Validate Y or N is entered in DDSCONT
      *
     C                   IF        (DDSCONT <> 'Y') AND
     C                             (DDSCONT <> 'N')
      *
     C                   EVAL      ZAmsid = 'USR8259'
     C                   EVAL      *IN51 = *ON
     C                   EXSR      SRSndMsg
     C                   ELSE
      *
     C                   IF        DDSCONT = 'Y'
      *
      ** Display Screen format 3 : subfile with branches
      *
     C                   EXSR      SRDsp3
     C                   ELSE
      *
      ** 'N' answered , quit screen processing
      *
     C                   EVAL      WStop1 = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Test function key F6
      *
     C                   IF        *INKF = *ON
      *
      ** Display screen fromat 2 : Select header branch
      *
     C                   EXSR      SRDsp2
     C                   ENDIF
      *
     C                   IF        *INKC = *ON
      *
     C                   EVAL      DDSCONT = 'N'
     C                   EVAL      WStop1 = 'Y'
     C                   EVAL      PArmr = 'F3'
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDsp2 - Select Branch for tape header into user agreed ones *
      *                                                               *
      *  Called by : SRDsply                                          *
      *                                                               *
      *  Calls : SRSndMsg                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDsp2        BEGSR
      *
      ** Set indicator for bottom/ setup Working field
      *
     C                   MOVEA     '01'          *IN(88)
     C                   EVAL      DDS1BRCD = DDSBRCD
      *
      ** Set working indicator WStop2 : Display screen 2 while = 'N'
      *
     C                   EVAL      WStop2 = 'N'
      *
     C                   DOW       WStop2 = 'N'
      *
      ** Affiche Screen 1
      *
     C                   WRITE     SD000792T2
     C                   WRITE     SD000792C0
      *
      ** Read first format screen
      *
     C                   EXFMT     SD000792F2
      *
      ** Initialise program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZApgm
     C                   PARM      '*SAME'       ZApgrl
      *
     C                   EVAL      *IN50 = *OFF
      *
      ** Enter key pressed
      *
     C                   IF        (*INKC <> *ON) AND
     C                             (*INKL <> *ON)
      *
      ** Check branch entered
      *
     C                   CALL      'ZVBBU'
     C                   PARM      DDS1BRCD      PChkBrc
     C                   PARM      *ZEROS        PChkErr
      *
     C                   IF        PChkErr <> *ZEROS
      *
      ** Not Authorised/Not Valid
      *
     C                   EVAL      *IN50 = *ON
     C                   EVAL      ZAmsid = 'USR8260'
     C                   EXSR      SRSndMsg
     C                   ELSE
      *
      ** Retrieve branch detail
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY   '     POptn
     C     DDS1BRCD      PARM      DDS1BRCD      PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
      ** Branch problem
      *
     C                   EVAL      *IN50 = *ON
     C                   EVAL      ZAmsid = 'USR8261'
     C                   EXSR      SRSndMsg
     C                   ELSE
      *
     C                   EVAL      WStop2 = 'Y'
     C                   EVAL      DDSBRCD = DDS1BRCD
     C                   EVAL      DDSBRNM = A8BRNM
     C                   EVAL      DDWHBRCD = DDSBRCD
     C                   EVAL      WHBRNM = DDSBRNM
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Test function key
      *
     C                   IF        (*INKL =  *ON) OR
     C                             (*INKC =  *ON)
      *
      ** Redisplay screen 1 with screen one contents
      *
     C                   EVAL      WStop2 = 'Y'
     C                   EVAL      DDSCONT = 'N'
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Reset Bottom indicators
      *
     C                   MOVEA     '00'          *IN(88)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDsp3 - Display subfile to select branch to report          *
      *                                                               *
      *  Called by : SRDsply                                          *
      *                                                               *
      *  Calls : SRFill, SRClr, SRLoad, SRSall, SRRdSl, SRSndMsg,     *
      *          SRDsp4                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRDsp3        BEGSR
      *
      ** Fill heading branch
      *
     C                   EVAL      DDS2BRC = DDSBRCD
     C                   EVAL      DDS2BRN = DDSBRNM
      *
      ** Read all branches of the system
      *
     C                   EXSR      SRFill
     C                   EXSR      SRClr
     C                   EVAL      WSel = '0'
     C                   EXSR      SRLoad
      *
      ** Display selected screen
      *
     C                   EVAL      WStop3 = 'N'
     C                   MOVEA     '10'          *IN(88)
      *
     C                   DOW       (WStop3 = 'N')
     C                   IF        *IN87 = *ON
      *
      ** Affiche Screen 3 : selection subfile
      *
     C                   WRITE     SD000792T3
     C                   WRITE     SD000792C0
     C                   ELSE
      *
     C                   WRITE     SD000792T4
     C                   WRITE     SD000792C0
     C                   ENDIF
      *
      *
      ** Read first format screen
      *
     C                   EXFMT     SD000792C2
      *
      ** Initialise program Message Queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZApgm
     C                   PARM      '*SAME'       ZApgrl
      *
     C                   Z-ADD     0             WOne
      *
      ** F9 Key : Select all
      *
     C                   IF        *INKI = *ON
      *
      ** Select all Branch
      *
     C                   EXSR      SRSall
     C                   EVAL      WInKi = 'N'
     C                   ENDIF
      *
      ** Test function key (F3 & F12)
      *
     C                   IF        (*INKC = *ON) OR
     C                             (*INKL = *ON)
      *
     C                   EVAL      DDSCONT = 'N'
     C                   EVAL      WStop3 = 'Y'
     C                   EVAL      *INKL = *OFF
     C                   ELSE
      *
      ** Validate at least one selection
      *
     C                   IF        *INKI <> *ON
     C                   EXSR      SRRdSl
     C                   ENDIF
      *
     C                   IF        WOne <> 1
      *
     C                   IF        WLineErr = 0                                             BUG22798
     C                   EVAL      ZAmsid = 'USR8262'
     C                   EXSR      SRSndMsg
     C                   ELSE                                                               BUG22798
      *                                                                                     BUG22798
      ** Use '1' to individual branches                                                     BUG22798
     C                   EVAL      ZAmsid = 'USR8306'                                       BUG22798
     C                   EXSR      SRSndMsg                                                 BUG22798
     C                   ENDIF                                                              BUG22798
      *
     C                   ELSE
      *
      ** Display confirmation screen
      *
     C                   EXSR      SRDsp4
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Reset bottom indicator
      *
     C                   MOVEA     '00'          *IN(88)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFill - Fill array with branches                            *
      *                                                               *
      *  Called by : SRDsp3                                           *
      *                                                               *
      *  Calls : *PSSR                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRFill        BEGSR
      *
      ** Fill arrays ArrAbCd and ArrAbNm
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM                    PRtcd
     C                   PARM      '*FIRST '     POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   Z-ADD     1             Wi
      *
     C                   DOW       PRtcd <> '*EOF   '
      *
     C                   IF        (PRtcd <> *BLANKS) AND
     C                             (PRtcd <> '*EOF')
      *
      ** Data base error occurs during read of sdbrchpd
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EVAL      DBKEY = 'Prev. BR' + 'ANCH : '
     C                   SUB       1             Wi
     C                   EVAL      DBKEY = DBKEY + ArrAbCd(Wi)
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
      *
      ** Check user is authorised to work with the branch,
      ** except if user is bank level agreed
      *
     C                   Z-ADD     0             PChkErr
      *
      ** User accrediation
      *
     C                   IF        *IN87 <> *ON
      *
     C                   CALL      'ZVBBU'
     C                   PARM      A8BRCD        PChkBrc
     C                   PARM                    PChkErr
      *
     C                   ENDIF
      *
      ** Authorised
      *
     C                   IF        PChkErr = *ZEROS
      *
     C                   MOVE      A8BRCD        ArrAbCd(Wi)
     C                   MOVEL     ' '           ArrAbCd(Wi)
     C                   MOVEL     A8BRNM        ArrAbNm(Wi)
     C                   EVAL      Wi = Wi + 1
      *
     C                   ELSE
      *
      ** Authorised to all
      *
     C                   EVAL      WAutAll = 'N'
      *
     C                   ENDIF
      *
      ** Max 200 branches
      *
     C                   IF        Wi < 200
      *
      ** Access next branch
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM                    PRtcd
     C                   PARM      '*NEXT  '     POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   ELSE
      *
      ** Force exit
      *
     C                   EVAL      PRtcd = '*EOF   '
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      Wi = Wi - 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClr - Clear Subfile                                        *
      *                                                               *
      *  Called by : SRDsp3, SRDsp4                                   *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClr         BEGSR
      *
     C                   EVAL      *IN42 = *ON
     C                   WRITE     SD000792C2
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad - Subfile - Load subfile reocrd from arrays           *
      *           ArrAbCd and ArrAbNm                                 *
      *                                                               *
      *  Called by : SRDsp3, SRDsp4                                   *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
     C                   IF        WSel = '0'
      *
      ** Display DDSACTN
      *
     C                   EVAL      *IN46 = *OFF
     C                   ELSE
      *
      ** Hide DDSACTN
      *
     C                   EVAL      *IN46 = *ON
      *
     C                   ENDIF
      *
     C                   Z-ADD     1             DDRRN1
      *
     C     1             DO        Wi            Wx
      *
      ** Fill subfile with all branch for selection
      *
     C                   IF        WSel = '0'
      *
     C                   MOVE      *BLANKS       DDSACTN
     C                   MOVEL     ' '           ArrAbCd(Wx)
     C                   MOVE      ArrAbCd(Wx)   DDSSBRC
     C                   MOVE      ArrAbNm(Wx)   DDSSBRN
     C                   WRITE     SD000792S2
     C                   EVAL      DDRRN1 = DDRRN1 + 1
     C                   ELSE
      *
      ** Fill subfile with selected branches
      *
     C                   MOVEL     ArrAbCd(Wx)   WAct
      *
     C                   IF        WAct <> *BLANKS
      *
     C                   MOVE      ArrAbCd(Wx)   DDSSBRC
     C                   MOVE      ArrAbNm(Wx)   DDSSBRN
     C                   WRITE     SD000792S2
     C                   EVAL      DDRRN1 = DDRRN1 + 1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   Z-ADD     1             DDRRN1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSall- Subfile - Select all branches                        *
      *                                                               *
      *  Called by : SRDsp3                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSall        BEGSR
      *
     C     1             DO        Wi            Wx
     C                   MOVEL     'S'           ArrAbCd(Wx)
     C                   ENDDO
      *
     C                   Z-ADD     1             WOne
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSl - Subfile - Read selected branch(es)                  *
      *                                                               *
      *  Called by : SRDsp3                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRRdSl        BEGSR
      *
      ** Modified to handle OPTION validation                                               BUG22798
     C                   Eval      WLineErr = 0                                             BUG22798
     C                   CLEAR                   ArrAbCd                                    BUG22798
     C                   READC     SD000792S2                             70
      *
     C                   DOW       *IN70 = *OFF
      *
     C                   EVAL      *IN90 = *OFF                                             BUG22798
     C                   EVAL      WOpterr = *off                                           BUG22798
     C                   Z-ADD     DDRRN1        Wx
      *
     C                   IF        DDSACTN <> *BLANKS
     C                   IF        DDSACTN = '1'                                            BUG22798
      *
     C                   MOVEL     DDSACTN       ArrAbCd(Wx)
     C                   MOVE      DDSSBRC       ArrAbCd(Wx)                                BUG24173
     C                   Z-ADD     1             WOne
     C                   ELSE
      *
     C                   IF        WLineErr = 0                                             BUG22798
     C                   EVAL      WLineErr = Wx                                            BUG22798
     C                   ENDIF                                                              BUG22798
     C                   EVAL      WOpterr = *ON                                            BUG22798
     C**********         MOVEL     ' '           ArrAbCd(Wx)                                BUG22798
      *
     C                   ENDIF                                                              BUG22798
     C                   EVAL      *IN90 = *ON                                              BUG22798
     C                   ENDIF
     C                   EVAL      *IN47 = WOpterr                                          BUG22798
     C                   UPDATE    SD000792S2                                               BUG22798
      *
      ** Next record
      *
     C                   READC     SD000792S2                             70
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDsp4  - Dsiplay confirmation SCREEN                        *
      *                                                               *
      *  Called by : SRDsp3                                           *
      *                                                               *
      *  Calls : SRLoad, SRClr, SRSndMsg                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDsp4        BEGSR
      *
      ** Bottom indicator
      *
     C                   MOVEA     '11'          *IN(88)
      *
      ** Fill Confirmation panel
      *
     C                   EXSR      SRClr
     C                   EVAL      WSel = '1'
     C                   EXSR      SRLoad
     C                   EVAL      WStop4 = 'N'
      *
     C                   DOU       WStop4 = 'Y'
      *
     C                   WRITE     SD000792T5
     C                   WRITE     SD000792C0
      *
      ** Display Screen 4
      *
     C                   EXFMT     SD000792C2
      *
      ** Initialise Program Message Queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZApgm
     C                   PARM      '*SAME'       ZApgrl
      *
      ** Check whether Enter Key has been pressed (not valid)
      *
     C                   IF        (*INKC <> *ON) AND
     C                             (*INKJ <> *ON) AND
     C                             (*INKL <> *ON)
      *
     C                   EVAL      ZAmsid = 'USR8263'
     C                   EXSR      SRSndMsg
      *
     C                   ENDIF
      *
      ** Check whether F12 or F3 has been pressed
      *
     C                   IF        (*INKC = *ON) OR
     C                             (*INKL = *ON)
      *
     C                   EVAL      DDSCONT = 'N'
     C                   EVAL      WStop4 = 'Y'
     C                   EVAL      WInKi = *BLANKS
      *
     C                   IF        *INKL = *ON
      *
      ** Fill subfile with all branches
      *
     C                   EXSR      SRClr
     C                   EVAL      WSel = '0'
     C                   EXSR      SRLoad
     C                   EVAL      *INKL = *OFF
     C                   MOVEA     '10'          *IN(88)
     C                   ELSE
      *
     C                   EVAL      WStop3 = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        *INKJ = *ON
      *
      ** Validation is complete : Run Tape processing
      ** Quit Screen 3, 2 & 1.
      *
     C                   EVAL      WStop4 = 'Y'
     C                   EVAL      WStop3 = 'Y'
     C                   EVAL      WStop2 = 'Y'
     C                   EVAL      WStop1 = 'Y'
      *
      ** Set Selection complete indicator to Y
      *
     C                   EVAL      WVali = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send message to program's message Queue           *
      *                                                               *
      *  Called by : SRDsply, SRDsp2, SRDsp3, SRDsp4                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMsg      BEGSR
      *
      ** If no message file specified, use the default message file
      *
     C                   IF        ZAmsgf = *BLANKS
     C                   MOVEL     PMsgf         ZAMsgf
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZApgm
     C                   PARM                    ZApgrl
     C                   PARM                    ZAmsid
     C                   PARM                    ZAmsgf
     C                   PARM                    ZAmsda
     C                   PARM                    ZAmstp
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   MOVEL     DDPGM         ZApgm
     C                   MOVEL     '*SAME'       ZApgrl
     C                   EVAL      ZAmsda = *BLANKS
     C                   EVAL      ZAmstp = *BLANKS
     C                   EVAL      ZAmsgf = *BLANKS
     C                   EVAL      ZAmsid = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C/COPY ZSRSRC,ZDATE2Z2LE
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Automatically called during the program          *
      *              initialisation                                   *
      *                                                               *
      *  Calls : ZDATE2, *PSSR                                        *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          WCpy2
      *
     C     *ENTRY        PLIST
     C                   PARM                    PArmr
     C                   PARM                    PBrch
      *
     C                   MOVEL     'SD000792'    DBPGM
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   MOVEL     'SDUSRMSG'    PMsgf
      *
      ** Fill in fields for subroutine SRSndMsg
      *
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDJOB = PSJobName
     C                   MOVEL     DDPGM         ZApgm
     C                   EVAL      ZAmsgf = *BLANKS
     C                   EVAL      ZApgrl = '*SAME'
     C                   EVAL      ZAmsid = *BLANKS
     C                   EVAL      ZAmsda = *BLANKS
     C                   EVAL      ZAmstp = *BLANKS
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error.
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     001           DBASE
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Check System Date Format,
      ** DDMMYY (*IN98 off) & MMDDYY (*IN98 on).
      *
     C                   EVAL      *IN98 = *OFF
     C                   MOVE      BJRDNB        ZDayno
     C                   EXSR      ZDATE2
     C                   EVAL      DDAGMRDT = ZAdate
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   MOVE      DBRN          DDWHBRCD
      *
      ** Prepare fields when Multi Branching is 'Y'
      *
     C                   IF        AGMBIN = 'Y'
      *
      ** When Mutli Branching User has to be Bank level Authorised
      *
     C                   IF        BANK <> 'Y'
      *
     C                   EVAL      *IN87 = *OFF
     C                   ELSE
     C                   EVAL      *IN87 = *ON
      *
     C                   ENDIF
      *
     C                   EVAL      WVali = 'N'
      *
      ** Retrieve Customer default branch detail
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDWHBRCD      PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   Z-ADD     002           DBASE
     C                   EVAL      DBKEY = DDWHBRCD
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   MOVEL     A8BRNM        DDSBRNM
     C     *LIKE         DEFINE    A8BRNM        WHBRNM
      *
     C                   EVAL      WHBRNM = A8BRNM
     C                   EVAL      DDSBRCD = DDWHBRCD
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      DDSCONT = 'N'
     C                   ELSE
      *
      ** Working defaulted parameters when Multi-Branching isn't on
      *
     C                   MOVE      'Y'           DDSCONT
      *
      ** Always Authorised
      *
     C                   EVAL      *IN87 = *ON
     C                   EVAL      WVali = 'Y'
     C                   Z-ADD     1             Wi
     C                   MOVE      DBRN          ArrAbCd(Wi)
     C                   MOVEL     'X'           ArrAbCd(Wi)
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by : SRFill, *INZSR                                    *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
