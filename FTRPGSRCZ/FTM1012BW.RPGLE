     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT credit details browse')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1012BW - REQUEST FOR TRANSFER (MT101) CREDIT DETAILS      *
      *              BROWSE                                           *
      *                                                               *
      *  Function:  This module displays a list of transactions that  *
      *             have a common Request For Transfer (RFT) I.D.     *
      *             It also processes the actions the user takes      *
      *             against any individual transaction in the list.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188650             Date 15Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 10May00               *
      *                 177875             Date 16Apr00               *
      *                 CFT006  *CREATE    Date 26Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  188650 - Allow more than 1 subfile selection                 *
      *  178751 - Auto generation of references                       *
      *  177875 - Subfile positioner does not work correctly          *
      *  CFT006 - FT MT101/MT102 development.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1011BDFCF   E             WORKSTN
     F                                     SFILE(FTM1011BS1:@@RRN)
 
      * RFT Detail file (keyed on RFTID/TRNSID)
     FFT101DL0  IF   E           K DISK    INFSR(*PSSR)
 
      * RFT Detail file (keyed on RFTID)
     FFT101DL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FT101DD0:FT101DD2)
 
      * Message management MT101 and MT102 totals
     FMEIRFTL1  IF   E           K DISK    INFSR(*PSSR)
 
      * Incoming Message Index file
     FMSIXI2L2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       KC  Exit                                                *
      *       KE  Refresh                                             *
      *       KI  Add record                                          *
      *       KL  Cancel                                              *
      *                                                               *
      *       10  Error in Action Code                                *
      *       11  Error in Transaction Reference                      *
      *       12  Error in SWIFT Reference                            *
      *       13  Error in SWIFT Sequence                             *
      ******  14  Error in subfile selection                          *         178751
      *       09  Error in subfile selection                          *         178751
      *       14  Error in select option                              *         178751
      *                                                               *
      *       45  Write record to subfile if *On                      *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *       81  Enquire mode taken in header browse                 *
      *                                                               *
      *       92  SFLDSP                                              *
      *       93  SFLEND (Message subfile)                            *
      *       94  SFLDSPCTL (Message subfile)                         *
      *       95  SFLNXTCHG                                           *
      *       96  SFLEND / READ Detail file                           *
      *       97  SFLCLR                                              *
      *       98  ROLLUP                                              *
      *       99  READC                                               *
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
 
     D*BenLength****** C                   CONST(35)                            178751
     D BenLength       C                   CONST(33)                            178751
     D SeqNolgth       C                   CONST(3)                             178751
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*@EI******       S              1    DIM(4)                               178751
     D @EI             S              1    DIM(5)                               178751
 
      ** RFT Credit Details - Browse Screen format
     D BrwScnFmt       DS
     D  DDACTN                 1      1
     D  DDTRNSIDX              2     17
     D  DDSWREF               18     45
     D  DDSWSEQ               46     47
     D  DDSeqSel              48     50                                         178751
     D**DDTRNSel***           48     63                                         178751
     D  DDTRNSel              51     66                                         178751
     D**DDTBNASel**           64     98                                         178751
     D  DDTBNASel             67     99                                         178751
     D**DDSEL******           99     99                                         178751
     D  DDSEL                100    100                                         178751
 
      ** RFT Credit Details - File format
     D RFTFilFmt     E DS                  EXTNAME(FT101DPD)
 
      ** OK flags
     D OKFILE        E DS                  EXTNAME(FTE101BPD)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Variable - Controls which subroutine is called
     D SubRoutine      S              1A
 
      ** Previous RFT Id
     D PrevRFTID       S                   LIKE(RFTID)
 
      ** Error array index
     D I               S              3P 0
 
      ** Other parameters passed to modules
     D RetCdeOut       S             10A
 
      ** Constant for KLIST SWIFTSeqKey
     D MsgType         S              3A   INZ('101')
 
      ** Numeric form of DDSWSEQ
     D SWSEQNum        S              2P 0
 
      ** Parameters for QDCXLATE
     D QLength         S              5  0
     D*QBenSel*****    S             35                                         178751
     D*W#QBenSel***    S             35                                         178751
     D QBenSel         S             33                                         178751
     D W#QBenSel       S             33                                         178751
     D QSeqSel         S              3                                         178751
     D W#QSeqSel       S              3                                         178751
     D QConst1         S             10
     D QConst2         S             10
     D Posn            S              2  0
     D WseqNo          S              3                                         178751
 
      ** Parameters for QCLSCAN
     D QStart          S              3  0
     D QLength2        S              3  0
     D QLgthSrch       S              3  0
     D QTranslate      S              1
     D QTrim           S              1
     D QWild           S              1
     D QResult         S              3  0
                                                                                188650
      ** Reload subfile indicator                                               188650
     D RELOAD          S              1                                         188650
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
      *
      ** Initialization
     C                   EXSR      INITPR
      *
      ** Main processing
     C                   DOW       SubRoutine = 'M'
     C                   EXSR      MAINPR
     C                   ENDDO
      *
      ********************************************************************
      * LOADSFL - LOAD A SUBFILE PAGE
      ********************************************************************
     C     LOADSFL       BEGSR
      *
      **  Initialise count of records written to subfile page.
     C                   Z-ADD     0             SflCount          3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
     C                   DOW       EndOfFile <> 'Y' and SflCount < 9
      *
      **  If record selected for output, increment the subfile record
      **  number and records written fields.
     C                   IF        *IN45 = *On
     C                   ADD       1             @@RRN
     C                   ADD       1             SflCount
      *
      ** Format RFT detail fields for output
     C                   EXSR      FMTDET
      *
      **  Write the record to the subfile
     C                   MOVE      *BLANK        DDSEL
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FTM1011BS1
     C                   ENDIF
      *
      ** Read a valid RFT detail record
     C                   EXSR      READFILE
     C                   ENDDO
      *
      **  If no records exist set up an error message and deactivate SFLDSP.
      **  Also write the footer record format - this blanks existing subfile
      **  records.
     C                   IF        SflCount = 0
     C                   ADD       1             I
     C                   MOVE      'Dummy'       FldNameArr(I)
     C                   MOVE      'GEN0001'     MsgIdArr(I)
     C                   EVAL      *IN92 = *Off
     C                   WRITE     FTM1011BF1
     C                   ELSE
     C                   EVAL      *IN92 = *On
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * MAINPR - DISPLAY SUBFILE & PROCESS ALL SCREEN ENTRIES
      ********************************************************************
     C     MAINPR        BEGSR
                                                                                188650
     C                   IF        RELOAD = 'Y'                                 188650
      *
      **  Write the message subfile
     C                   WRITE     FTM1011BM0
      *
      **  Write the subfile control record to the screen to display
      **  the subfile
     C                   WRITE     FTM1011BS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
     C                   READ      FTM1011BS0                             99
                                                                                188650
     C                   ENDIF                                                  188650
      *
     C                   SELECT
      *
      **  If F3, bypass further processing
     C                   WHEN      *INKC = *On
     C                   MOVEL     '03'          ParmFuncKy
     C                   SETON                                        LR
     C                   RETURN
      *
      **  If F12, bypass further processing.
     C                   WHEN      *INKL = *On
     C                   MOVEL     '12'          ParmFuncKy
     C                   SETON                                        LR
     C                   RETURN
      *
      **  If F5, initialise the screen.
     C                   WHEN      *INKE = *On
     C                   EVAL      SubRoutine = *Blanks
      *
      **  If F9, add a new record.
     C                   WHEN      *INKI = *On
     C                   EVAL      ParmDDACTN = 'I'
     C                   EVAL      ParmTRNSID = *Blanks
     C                   EVAL      ParmSWREF  = DDSWREF
     C                   EVAL      ParmSWSEQ  = DDSWSEQ
     C                   EVAL      ParmFuncKy = '09'
     C                   MOVE      *ALL'Y'       OkFile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   RETURN
      *
      **  If ROLLUP (*IN98) - build next subfile page.  If there has been
      **  an error in subfile selection, do not allow rollup.
     C                   WHEN      *IN98 = *On
     C                   IF        SelCount = 0
     C                   EXSR      LOADSFL
     C                   ENDIF
      *
      **  Otherwise Enter has been pressed - process user input.
     C                   OTHER
     C                   EXSR      RESETERRS
     C                   EXSR      ENTER
      *
     C                   ENDSL
      *
      ** Process error messages
     C                   EXSR      PROCERRS
      *
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * ENTER - ENTER PRESSED
      ********************************************************************
     C     ENTER         BEGSR
      *
      ** Validate input.
     C                   EXSR      VALDET
     C                   IF        SflCount <> 0
     C                   EXSR      READSFL
     C                   ENDIF
      *
      ** If no errors, process action.
     C                   IF        I = 0
      *
     C                   IF        DDACTN <> *Blanks
     C                   EVAL      ParmDDACTN = DDACTN
     C                   EVAL      ParmTRNSID = DDTRNSIDX
     C                   EVAL      ParmFuncKy = *Blanks
     C                   MOVE      *ALL'Y'       OkFile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   RETURN
     C                   ELSE
      *
      ** If anything entered in SWIFT Reference, return control to
      ** FTM101SIN.
     C                   IF        DDSWREF <> *Blanks
     C                   EVAL      ParmDDACTN = 'I'
     C                   EVAL      ParmSWREF  = DDSWREF
     C                   EVAL      ParmSWSEQ  = DDSWSEQ
     C                   EVAL      ParmTRNSID = *Blanks
     C                   EVAL      ParmFuncKy = *Blanks
     C                   MOVE      *ALL'Y'       OkFile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   RETURN
     C                   ELSE
      *
      ** Process subfile action code
     C                   IF        SaveDDSEL <> *Blanks
     C                   EVAL      ParmDDACTN = SaveDDSEL
     C                   EVAL      ParmTRNSID = SaveTRNSID
     C                   EVAL      ParmFuncKy = *Blanks
     C                   MOVE      *ALL'Y'       OkFile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   RETURN
      *
      ** If no entries made display subfile page according to subfile
      ** selection fields.
     C                   ELSE
     C                   EXSR      CLEARSFL
      *
      **  Reposition pointer and rebuild subfile
     C                   SELECT
      *
     C                   WHEN      DDTRNSel <> *Blanks and
     C************                 DDTBNASel = *Blanks                          178751
     C                             DDTBNASel = *Blanks AND                      178751
     C                             DDSEQSEL = *Blanks                           178751
     C*******************EVAL      RFTID = *Blanks                              177875
     C     TrnRefKey1    SETLL     FT101DL0
      *
     C                   OTHER
     C     ParmRFTID     SETLL     FT101DL2
      *
     C                   ENDSL
      *
     C                   EXSR      READFILE
     C                   EXSR      LOADSFL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * VALDET - VALIDATE THE FIELDS THE USER HAS ENTERED (NOT SFL)
      *****************************************************************
     C     VALDET        BEGSR
      *
      * Validate Action Code:
      * If user chose action 'E' from header browse, only 'E' is available
      * here.
     C                   IF        ParmHActn = 'E'
     C                   IF        DDACTN  <> 'E'  and   DDACTN  <>  *Blanks
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             I
     C                   MOVE      'DDACTN'      FldNameArr(I)
     C                   MOVE      'RFCB016'     MsgIdArr(I)
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        DDACTN <> 'A' and DDACTN <> 'E' and
     C                             DDACTN <> 'D' and DDACTN <> 'R' and
     C                             DDACTN <> *Blanks
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             I
     C                   MOVE      'DDACTN'      FldNameArr(I)
     C                   MOVE      'RFCB001'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of If ParmHActn = 'E')
      *
      * Cannot enter both Transaction Ref. and SWIFT Ref.
     C                   IF        DDTRNSIDX <> *Blanks and
     C                             DDSWREF <> *Blanks
     C                   MOVE      'N'           DDTRNIDXOK
     C                   MOVE      'N'           DDSWREFOK
     C                   ADD       1             I
     C                   MOVE      'DDTRNSIDX'   FldNameArr(I)
     C                   MOVE      'RFCB007'     MsgIdArr(I)
     C                   ENDIF
      *
      * Validate Transaction Reference - Cannot be entered if no Action Code
      *                                - Must be entered if Action Code is.
     C                   IF        DDACTN = *Blanks
      *
     C                   IF        DDTRNSIDX <> *Blanks
     C                   MOVE      'N'           DDTRNIDXOK
     C                   ADD       1             I
     C                   MOVE      'DDTRNIDX'    FldNameArr(I)
     C                   MOVE      'RFCB008'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDTRNSIDX = *Blanks  and  DDACTNOK <> 'N'
     C                   MOVE      'N'           DDTRNIDXOK
     C                   ADD       1             I
     C                   MOVE      'DDTRNIDX'    FldNameArr(I)
     C                   MOVE      'RFCB009'     MsgIdArr(I)
     C                   ELSE
      *
      * If Transaction Ref. entered it must exist on RFT detail file
     C     TrnRefKey2    CHAIN     FT101DL0                           80
     C                   IF        *IN80 = *On
     C                   MOVE      'N'           DDTRNIDXOK
     C                   ADD       1             I
     C                   MOVE      'DDTRNSIDX'   FldNameArr(I)
     C                   MOVE      'RFCB003'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of If DDTRNSIDX = *Blanks)
      *
     C                   ENDIF
      *                  (End of If DDACTN = *Blanks)
      *
      * Validate SWIFT Reference - Cannot enter an action code if SWIFT
      * Reference has been entered (action code assumed to be 'I').
     C                   IF        DDSWREF <> *Blanks
     C                   IF        DDSWREF <> '?'
      *
     C                   IF        DDACTN <> *Blanks
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             I
     C                   MOVE      'DDACTN'      FldNameArr(I)
     C                   MOVE      'RFCB015'     MsgIdArr(I)
     C                   ENDIF
      *
      * Validate SWIFT Reference - Must exist in PF/MSIXI2PD
     C     DDSWREF       CHAIN     MSIXI2L2                           80
     C                   IF        *IN80 = *On
     C                   MOVE      'N'           DDSWREFOK
     C                   ADD       1             I
     C                   MOVE      'DDSWREF'     FldNameArr(I)
     C                   MOVE      'RFCB004'     MsgIdArr(I)
     C                   ENDIF
      *
      ** SWIFT Seq. must be entered if a non-'?' SWIFT Reference has
      ** been entered.
     C                   IF        DDSWSEQ = *Blanks
     C                   MOVE      'N'           DDSWSEQOK
     C                   ADD       1             I
     C                   MOVE      'DDSWSEQ'     FldNameArr(I)
     C                   MOVE      'RFCB010'     MsgIdArr(I)
     C                   ENDIF
      *
      ** If entered, SWIFT Sequence must be '?' or exist for the current
      ** SWIFT Reference.
     C                   IF        DDSWSEQ <> '?'
     C     SWIFTSeqKey   CHAIN     MEIRFTL1                           80
     C                   EXSR      CHKSEQ
      *
     C                   IF        *IN80 = *On   OR
     C                             *IN80 = *Off  AND  SWSEQNum > NUMTRN
     C                   MOVE      'N'           DDSWSEQOK
     C                   ADD       1             I
     C                   MOVE      'DDSWSEQ'     FldNameArr(I)
     C                   MOVE      'RFCB011'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of If DDSWSEQ = '?')
      *
     C                   ENDIF
      *                  (End of DDSWREF <> '?')
      *
     C                   ELSE
      *
      ** SWIFT Seq. cannot be entered if SWIFT Reference is blank.
     C                   IF        DDSWSEQ <> *Blanks
     C                   MOVE      'N'           DDSWSEQOK
     C                   ADD       1             I
     C                   MOVE      'DDSWSEQ'     FldNameArr(I)
     C                   MOVE      'RFCB017'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of If DDSWREF <> *Blanks)
      *
      ** When both of the Selection fields are not blank - error                178751
                                                                                178751
     C                   SELECT                                                 178751
     C                   When      ddSeqsel <> *BLANKS AND                      178751
     C                             ddtbnasel <> *BLANKS                         178751
     C                   MOVE      'N'           DDselok
     C                   Add       1             I                              178751
     C                   Move      'sssnddst'    FldNameArr(I)                  178751
     C                   Move      'RFCB018'     MsgIdArr(I)                    178751
     C                   ENDSL                                                  178751
                                                                                178751
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHKSEQ - CHECK IF SWIFT SEQUENCE EXCEEDS HIGHEST VALUE
      ******************************************************************
     C     CHKSEQ        BEGSR
      *
     C                   IF        *IN80 = *Off                                 ************
      *
      * Convert SWIFT Sequence screen field to numeric format
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok          1
     C                   PARM      DDSWSEQ       ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      2             ZADIG             2 0
     C                   MOVE      ZFIELD        SWSEQNum
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN80 = *On
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      ********************************************************************
      * READSFL - READ SUBFILE RECORD
      ********************************************************************
     C     READSFL       BEGSR
                                                                                188650
      * Count number of action codes entered in subfile                         188650
     C                   EVAL      SELCOUNT = 0                                 188650
                                                                                188650
     C                   READC     FTM1011BS1                             99    188650
                                                                                188650
     C                   DOW       *IN99 = *OFF                                 188650
     C                   ADD       1             SELCOUNT                       188650
     C                   EVAL      *IN95 = *ON                                  188650
     C                   UPDATE    FTM1011BS1                                   188650
     C                   READC     FTM1011BS1                             99    188650
     C                   ENDDO                                                  188650
                                                                                188650
      * Reset RRN to force read from top of subfile                             188650
     C                   EVAL      @@RRN = 0                                    188650
      *
      **  Read the subfile for selected records
     C                   READC     FTM1011BS1                             99
     C****************** DOW       *IN99 = *Off                                 188650
     C                   IF        *IN99 = *OFF                                 188650
      *
     C                   IF        DDSEL <> *Blanks
     C*********          EVAL      *IN95 = *On                                  188650
     C*********          ADD       1             SelCount                       188650
      *
      * If user chose action 'E' from header browse, only 'E' is available
      * here.
     C                   IF        ParmHActn = 'E'  and
     C                             DDSEL    <> 'E'
     C********           EVAL      *IN14 = *On                                  178751
     C                   EVAL      *IN09 = *On                                  178751
     C                   EVAL      DDSFRN = @@RRN
     C                   ADD       1             I
     C                   MOVE      'DDSEL'       FldNameArr(I)
     C                   MOVE      'RFCB016'     MsgIdArr(I)
     C                   ELSE
      *
      **  Validate selection if entered
     C                   IF        DDSEL <> 'A' and DDSEL <> 'E' and
     C                             DDSEL <> 'D' and DDSEL <> 'R'
     C********           EVAL      *IN14 = *On                                  178751
     C                   EVAL      *IN09 = *On                                  178751
     C                   EVAL      DDSFRN = @@RRN
     C                   ADD       1             I
     C                   MOVE      'DDSEL'       FldNameArr(I)
     C                   MOVE      'RFCB012'     MsgIdArr(I)
     C                   ELSE
      *
      ****Do*not*allow*more*than*one*subfile*selection*at*a*time****            188650
     C*********          IF        SelCount > 1                                 188650
     C********           EVAL      *IN14 = *On                                  178751
     C*********          EVAL      *IN09 = *On                                          178751188650
     C*********          EVAL      DDSFRN = @@RRN                                             188650
     C*********          ADD       1             I                                            188650
     C*********          MOVE      'DDSEL'       FldNameArr(I)                                188650
     C*********          MOVE      'RFCB013'     MsgIdArr(I)                                  188650
     C********           ELSE                                                                 188650
      *
      **  Else no errors - save selection and Transaction Ref.
     C                   MOVEL     DDSEL         SaveDDSEL         1
     C                   MOVEL     DDTRNSID      SaveTRNSID       16
     C*********          ENDIF                                                  188650
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Else selection is blank - turn off error indicator from prev record
     C                   ELSE
     C********           EVAL      *IN14 = *Off                                 178751
     C                   EVAL      *IN09 = *Off                                 178751
     C                   ENDIF
      *
     C                   EVAL      *IN95 = *IN09                                188650
     C                   UPDATE    FTM1011BS1
     C********           READC     FTM1011BS1                             99    188650
     C*******            ENDDO                                                  188650
     C                   ENDIF                                                  188650
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTDET - FORMAT RFT DETAIL FOR OUTPUT
      ******************************************************************
     C     FMTDET        BEGSR
      *
      * Transaction Reference
     C                   MOVE      TRNSID        DDTRNSID
      *
      * Currency
     C                   MOVE      TRNCCY        DDTRNCCY
      *
      * Obtain no. of decimal places for this currency
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      TRNCCY        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 902*
     C                   MOVEL     TRNCCY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Format Amount field
     C                   MOVE (P)  TRNAMT        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDTRNAMT
      *
      * Beneficiary
     C                   MOVEL     TBNA35        DDTBNA35
      *
      * Credit Sequence Number                                                  178751
     C                   MOVEL     TSEQNO        DDTSEQNO                       178751
      *                                                                         178751
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * READFILE - READ A RFT DETAIL RECORD
      *****************************************************************
     C     READFILE      BEGSR
      *
      **  Reset End of File indicator, reset record write indicator
     C                   MOVE      *Blanks       EndOfFile         1
     C                   MOVE      *On           *IN45
      *
      **  Read the file initially - if EndOfFile is set on then the end of
      **  the file has been reached.  Read until a valid record is found or
      **  until no more records exist.
      *
      **  Read the appropriate file (N.B. Tran. Ref. is a 'position to'
      **  field but Beneficiary is a 'select' type field - ANY record
      **  containing the string entered in Beneficiary will be selected).
     C                   SELECT
      *
     C*****************  WHEN      DDTRNSel <> *Blanks and                      177875
     C*****************            DDTBNASel = *Blanks                          177875
     C*****************  EVAL      PrevRFTID = RFTID                            177875
     C*****************  READ      FT101DL2                               96    177875
      *****************                                                         177875
     C*****************  IF        RFTID <> PrevRFTID and                       177875
     C*****************            PrevRFTID <> *Blanks                         177875
     C*****************  EVAL      *IN96 = *On                                  177875
     C*****************  ENDIF                                                  177875
                                                                                177875
     C                   When      DDTRnSel <> *Blanks and                      177875
     C***********                  DDTBNASel = *Blanks                    177875178751
     C                             DDTBNASel = *Blanks and                      178751
     C                             DDSEQSEL = *Blanks                           178751
     C     ParmRFTID     READE     FT101DL0                               96    177875
      *
     C                   OTHER
     C     ParmRFTID     READE     FT101DL2                               96
      *
      ** If selection made in Beneficiary scan current record for the search
      ** string, ignoring any leading blanks.
     C************       IF        DDTBNASel <> *Blanks                         178751
     C                   SELECT                                                 178751
     C                   WHEN      DDTBNASel <> *Blanks AND                     178751
     C                             DDSEQSEL = *Blanks                           178751
      *
     C                   CALL      'QDCXLATE'
     C                   PARM      BenLength     QLength
     C                   PARM      DDTBNASel     QBenSel
     C                   PARM      'QSYSTRNTBL'  QConst1
     C                   PARM      'QSYS'        QConst2
 
      ** Remove any leading blanks from beginning of search field
     C                   EVAL      Posn = *Zero
     C     ' '           CHECK     QBenSel:1     Posn
     C                   SUBST     QBenSel:Posn  W#QBenSel
     C                   EVAL      QBenSel   =   W#QBenSel
 
      ** Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    TBNA35
     C                   PARM      BenLength     QLength2
     C                   PARM      1             QStart
     C                   PARM                    QBenSel
     C                   PARM      BenLength     QLgthSrch
     C                   PARM      '1'           QTranslate
     C                   PARM      '1'           QTrim
     C                   PARM      '?'           QWild
     C                   PARM                    QResult
 
      ** If string not found in currenct record, prevent output to subfile
     C                   IF        QResult = *Zero
     C                   EVAL      *IN45 = *Off
     C                   ENDIF
 
     C************       ENDIF                                                  178751
 
     C                   WHEN      DDSEQSEL <> *Blanks AND                      178751
     C                             DDTBNASEL = *Blanks                          178751
      *                                                                         178751
     C                   CALL      'QDCXLATE'                                   178751
     C                   PARM      SeqnoLgth     QLength                        178751
     C                   PARM      DDSEQSEL      QSeqSel                        178751
     C                   PARM      'QSYSTRNTBL'  QConst1                        178751
     C                   PARM      'QSYS'        QConst2                        178751
                                                                                178751
      ** Remove any leading blanks from beginning of search field               178751
     C                   EVAL      Posn = *Zero                                 178751
     C     ' '           CHECK     QSeqSel:1     Posn                           178751
     C                   SUBST     QSeqSel:Posn  W#QSeqSel                      178751
     C                   EVAL      QSeqSel   =   W#QSeqSel                      178751
                                                                                178751
     C                   MOVE      TseqNo        WSeqNo                         178751
                                                                                178751
      ** Scan for search string                                                 178751
     C                   CALL      'QCLSCAN'                                    178751
     C                   PARM                    WSeqNo                         178751
     C                   PARM      SeqNoLgth     QLength2                       178751
     C                   PARM      1             QStart                         178751
     C                   PARM                    QSeqSel                        178751
     C                   PARM      SeqNoLgth     QLgthSrch                      178751
     C                   PARM      '1'           QTranslate                     178751
     C                   PARM      '1'           QTrim                          178751
     C                   PARM      '?'           QWild                          178751
     C                   PARM                    QResult                        178751
                                                                                178751
      ** If string not found in currenct record, prevent output to subfile      178751
     C                   IF        QResult = *Zero                              178751
     C                   EVAL      *IN45 = *Off                                 178751
     C                   ENDIF                                                  178751
                                                                                178751
     C                   ENDSL                                                  178751
 
     C                   ENDSL
      *
      * End of File
     C                   IF        *IN96 = *On
     C                   MOVEL     'Y'           EndOfFile
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - RESET ALL ERROR INDICATORS AND FLAGS
      ******************************************************************
     C     RESETERRS     BEGSR
      *
     C                   Z-ADD     0             I
     C                   MOVE      *ALL'Y'       OkFile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
      *
     C                   Z-ADD     0             SelCount          2 0
     C********           EVAL      *IN14 = *Off                                 178751
     C                   EVAL      *IN09 = *Off                                 178751
     C                   EVAL      SaveDDSEL = *Blanks
     C                   EVAL      SaveTRNSID = *Blanks
      *
      * Clear message subfile
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * PROCERRS - PROCESS ANY ERRORS THAT NEED TO BE DISPLAYED
      *****************************************************************
     C     PROCERRS      BEGSR
      *
      * Clear message subfile
     C                   CALL      'ZA0250'
      *
      * Set screen error indicators off
     C*********          MOVEA     '00000'       *IN(10)                        178751
     C                   MOVEA     '00000'       *IN(10)                        178751
      *
      * Move 'OK' flags into array (for checking)
     C                   MOVEA     OkFile        @EI
      *
      * Set screen error indicators according to status of 'OK' flags
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C*********          DOU       C > 4                                        178751
     C                   DOU       C > 5                                        178751
      *
     C                   IF        @EI(C) = 'N'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
      *
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      ** Set up the action code to be used by the message handler
     C                   EVAL      ActionCode = 'I'
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      * CLEARSFL - CLEAR SUBFILE
      *****************************************************************
     C     CLEARSFL      BEGSR
      *
      **  Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile by writing control record with SFLCLR active.
     C                   EVAL      *IN97 = *On
     C                   WRITE     FTM1011BS0
     C                   EVAL      *IN97 = *Off
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITPR - INITIALIZATION
      *****************************************************************
     C     INITPR        BEGSR
      *
      * Clear screen fields
     C                   CLEAR                   BrwScnFmt
      *
      * Load Request for Transfer Id
     C                   MOVEL     ParmRFTID     DDRFTID
      *
      * Clear outputs
     C                   MOVE      *Blanks       ParmFKey          1
      *
      * Condition screen output
     C                   IF        ParmHActn = 'E'
     C                   EVAL      *IN81 = *On
     C                   ENDIF
      *
      ** If more than one action code is used, do not reload subfile            188650
      *                                                                         188650
     C                   EVAL      RELOAD = 'N'                                 188650
      *                                                                         188650
     C                   IF        SELCOUNT = 1 OR SELCOUNT = 0                 188650
     C                   EVAL      RELOAD = 'Y'                                 188650
     C                   ENDIF                                                  188650
                                                                                188650
     C                   IF        RELOAD = 'Y'                                 188650
      * Clear message subfile and error flags
     C                   EXSR      RESETERRS
     C                   MOVEA     '0000'        *IN(10)
      *
      **  Write the select screen footer to the screen.
     C                   WRITE     FTM1011BF1
      *
      **  Clear subfile
     C                   EXSR      CLEARSFL
      *
      **  Position pointer at first record and build first subfile page
     C     ParmRFTID     SETLL     FT101DL2
     C                   EXSR      READFILE
     C                   EXSR      LOADSFL
      *
      **  If no records for this RFT Id display a message
     C                   IF        I <> 0
     C                   EXSR      PROCERRS
     C                   ENDIF
     C                   ENDIF                                                  188650
      *
     C                   EVAL      SubRoutine = 'M'
      *
     C                   ENDSR
      *****************************************************************
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
      * Return Code
 ad  C                   PARM                    RetCdeOut
      *
      * INPUT PARAMETERS :
      * RFT Id
      * Action from HBRW
     C                   PARM                    ParmRFTID        15
     C                   PARM                    ParmHActn         1
      *
      * OUTPUT PARAMETERS :
      * Transaction Reference
      * SWIFT Reference
      * SWIFT Sequence
      * Action Code
      * Function Key pressed
     C                   PARM                    ParmTRNSID       16
     C                   PARM                    ParmSWREF        28
     C                   PARM                    ParmSWSEQ         2
     C                   PARM                    ParmDDACTN        1
     C                   PARM                    ParmFuncKy        2
      ** OK file
     C                   PARM                    OkFile
      ** Errors
     C                   PARM                    I
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Initialize program name
     C                   MOVEL     'FTM1012BW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set up Key Lists
     C     TrnRefKey1    KLIST
     C                   KFLD                    ParmRFTID
     C                   KFLD                    DDTRNSel
      *
     C     TrnRefKey2    KLIST
     C                   KFLD                    ParmRFTID
     C                   KFLD                    DDTRNSIDX
      *
     C     SWIFTSeqKey   KLIST
     C                   KFLD                    DDSWREF
     C                   KFLD                    MsgType
      *
      *
      * Message subfile control
     C                   MOVE      '1'           *IN93
     C                   MOVEL     '*'           DDPGMQ
     C                   EVAL      SELCOUNT = 0                                 188650
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
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
(c) Finastra International Limited 2001
