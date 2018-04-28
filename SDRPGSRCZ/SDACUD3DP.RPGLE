     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Additional Customer Details 3 Display')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD3DP - SD Additional Customer Details 3 Display         *
      *                                                               *
      *  Function:  This module displays the Additional Customer      *
      *             Details screen input function                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26470           Date 19Oct09               *
      *                 BUG26353           Date 13Oct09               *
      *                 BUG25533           Date 19Aug09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24743           Date 06Jul09               *
      *                 BUG23640A          Date 22May09               *
      *                 BUG23640           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23945           Date 11May09               *
      *                 BUG22201           Date 27Jan09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26470 - "State Code" field is enabled during enquiry      *
      *             (Recompile)                                       *
      *  BUG26353 - "State Code" field is present in Additional       *
      *             Customer Details Maintenance (Recompile)          *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Recompiled due to changes in SDACUD3DDF)         *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24743 - LF047 Problem with enquiry on additional CUSD     *
      *  BUG23640A - Renamed 'Tin Document Number/ID to Document      *
      *             Number/ID'  (Recompile)                           *
      *  BUG23640 - Labels were amended for clarity (Recompile)       *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23945 - New field should be use correct char §            *
      *           - Recompile Due to DSPF Modification               *
      *  BUG22201 - Recompiled due to display file changes            *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Additional Customer Details Screen 3
      *
     FSDACUD3DDFCF   E             WORKSTN
      *
      ** Table of field numbers and names
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display condition                                   *
      *       71  Display condition                                   *
      *       72  Display condition                                   *
      *       73  Position cursor on first field if no error          *
      *       79  Display Condition                                   *
      *       83  Enable/disable function for F7 F8                   *
      *       99  Read error                                          *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so
      ** requires STD_D_SPEC.
      *
      /COPY ZACPYSRC,FVAL_ARRAY
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
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
     D ArrEI           S              1    DIM(60)
     D ArrZ0           S              1    DIM(60) CTDATA PERRCD(60)
      *
      ** External DS for ACUD API Format Definition Screen - 3
      *
     D CustDet3      E DS                  EXTNAME(SDACU3DPD)
      *
      ** SDACUSPD Transaction Details in screen format
      *
     D TrnDets       E DS                  EXTNAME(SDACUDPD)
      *
      ** SDEACU1PD Transaction Details OK indicators
      *
     D OKCustDet3    E DS                  EXTNAME(SDEACU3PD)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Short DS for access programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CER054
      ** Data Structure for SAR Details                                                       CER054
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER054
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter for Access Object
      *
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter of *Entry
      *
     D PEDTFD          S              1A
     D PInKc           S              1A
     D PInKl           S              1A
     D PInKH           S              1A
      *
      ** Switchable features
      *
     D CER047          S              1A
     D CER048          S              1A
      *
      ** Index for error indicators
      *
     D WFldNum         S              2P 0
     D WInd            S              2P 0
                                                                                              CER054
     D PSard           S              6A                                                      CER054
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      SRMain
      *
      ** Return
      *
     C**********         IF        PInKc = '1'                                              BUG24743
     C                   EVAL      *INLR = *ON
     C**********         ENDIF                                                              BUG24743
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMain - Main Processing                                      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Move 'OK' Flags into array (For Checking)
      *
     C                   MOVEA     OKCustDet3    ArrEI
      *
      ** Set Screen Error Indicators according to Status of 'OK' Flags
      *
     C                   Z-ADD     1             WFldNum
     C                   Z-ADD     10            WInd
      *
     C                   DOU       WFldNum > 60
      *
     C                   IF        ArrEI(WFldNum) = 'N' OR
     C                             ArrEI(WFldNum) = 'W'
      *
     C                   MOVEL     '1'           *IN(WInd)
      *
     C                   ENDIF
     C                   ADD       1             WFldNum
     C                   ADD       1             WInd
      *
     C                   ENDDO
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Protect all fields
      *
     C                   EVAL      *IN70 = *OFF
      *
      ** Enable Detail Fields
      ** (All Fields except Action Code & Deal Number)
      *
     C                   IF        PEDTFD = 'Y'
      *
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
      *
     C                   ENDIF
      *
     C                   EVAL      *IN94 = *ON
      *
      ** Set footer indicator, based on calling program
      *
     C                   IF        RetCodeIn = 'SIN'
      *
     C                   EVAL      *IN99 = *ON
     C                   EVAL      RetCodeIn = *BLANKS
     C                   ELSE
     C                   EVAL      *IN99 = *OFF
     C                   EVAL      RetCodeIn = *BLANKS
      *
     C                   ENDIF
      *
      ** Write message subfile, Securities Clients Details and footer
      ** screen
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     SDACUD3M0
     C                   WRITE     SDACUD3D1
     C                   WRITE     SDACUD3F1
      *
     C                   READ      SDACUD3D1                              99
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     ArrZ0         *IN(10)
      *
      ** Set return keys
      *
     C                   EVAL      PInKc = *INKC
     C                   EVAL      PInKH = *INKH
     C                   EVAL      PInKl = *INKL
      *
     C                   ENDSR
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS :
      ** Return code
      *
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details in screen format
      *
     C                   PARM                    TrnDets
      *
      ** Transaction Details in screen format -3
      *
     C                   PARM                    CustDet3
      *
      ** Transaction Details OK indicators
      *
     C                   PARM                    OKCustDet3
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key & Detail Fields
      *
     C                   PARM                    PEDTFD
      *
      ** Switchable features
      *
     C                   PARM                    CER047
     C                   PARM                    CER048
      *
      ** OUTPUT PARAMETERS :
      ** Function Keys
      *
     C                   PARM                    PINKC
     C                   PARM                    PINKH
     C                   PARM                    PINKL
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SDACU3DDP'
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
      *
     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Turn on Screen Indicators based on the Switchable Feature
      *
     C                   IF        CER047 = 'Y'
      *
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
      *
     C                   ENDIF
      *
     C                   IF        CER048 = 'Y'
      *
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
      *
     C                   ENDIF
      *                                                                                       CER054
      ** Check if CER054 is enabled                                                           CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      *IN73 = *OFF                                               CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
     C                   EVAL      *IN73 = *ON                                                CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER054
     C                             (PRtcd <> '*NRF   ')                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBASE = 902                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      SRERR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      *
      /COPY SDCPYSRC,MSGHNDDATA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   EVAL      DBPGM = 'SDACUD3DP'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
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
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CTDATA @CPY
Misys International Banking Systems Ltd. 2008
** CTDATA ArrZ0
000000000000000000000000000000000000000000000000000000000000
