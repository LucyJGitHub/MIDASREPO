     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Additional Customer Details 4 Display')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD4DP - SD Additional Customer Details 4 Display         *
      *                                                               *
      *  Function:  This module displays the Additional Customer      *
      *             Details screen input function                     *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26637           Date 03Nov09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24743           Date 06Jul09               *
      *                 BUG22201           Date 27Jan09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26637 - Unable to exit to the main screen                 *
      *             Change in MSGHNDDATA (Recompile)                  *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24743 - LF047 Problem with enquiry on additional CUSD     *
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
     FSDACUD4DDFCF   E             WORKSTN
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
      *
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D ArrEI           S              1    DIM(60)
     D ArrZ0           S              1    DIM(60) CTDATA PERRCD(60)
      *
      ** External DS for ACUD API Format Definition Screen -2
      *
     D CustDet3      E DS                  EXTNAME(SDACU4DPD)
      *
      ** SDACUSPD Transaction Details in screen format
      *
     D TrnDets       E DS                  EXTNAME(SDACUDPD)
      *
      ** SDEACU1PD Transaction Details OK indicators
      *
     D OKCustDet3    E DS                  EXTNAME(SDEACU4PD)
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
     D PINKC           S              1A
     D PINKH           S              1A
     D PINKL           S              1A
      *
      ** Switchable features
      *
     D CER034          S              1A
     D CER038          S              1A
     D CER041          S              1A
     D CER045          S              1A                                                      CER045
      *
      ** Index for error indicators
      *
     D WFldNum         S              2P 0
     D WInd            S              2P 0
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
     C**********         IF        PINKC = '1'                                              BUG24743
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
     C                   EVAL      WFldNum = 1
     C                   EVAL      WInd = 10
      *
     C                   DOU       WFldNum > 60
      *
     C                   IF        ArrEI(WFldNum) = 'N' OR
     C                             ArrEI(WFldNum) = 'W'
      *
     C                   EVAL      *IN(WInd) = '1'
      *
     C                   ENDIF
     C                   EVAL      WFldNum = WFldNum + 1
     C                   EVAL      WInd = WInd +1
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
      *
     C                   IF        PEDTFD = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
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
      *                                                                                       CER045
      ** Display corresponding description of the Additional Borrowers                        CER045
      ** Statistics Key being entered.                                                        CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y' AND                                           CER045
     C                             DDABSK = 'H'                                               CER045
      *                                                                                       CER045
     C                   EVAL      *IN76 = *ON                                                CER045
     C                   ELSE                                                                 CER045
     C                   EVAL      *IN76 = *OFF                                               CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *
      ** Write message subfile, Securities Clients Details and footer
      ** screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDACUD4M0
     C                   WRITE     SDACUD4D1
     C                   WRITE     SDACUD4F1
      *
     C                   READ      SDACUD4D1                              98
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     ArrZ0         *IN(10)
      *
      ** Set return keys
      *
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKL = *INKL
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
      ** Transaction Details in screen format -2
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
     C                   PARM                    CER034
     C                   PARM                    CER038
     C                   PARM                    CER041
      *
      ** OUTPUT PARAMETERS :
      ** Function Keys
      *
     C                   PARM                    PINKC
     C                   PARM                    PINKH
     C                   PARM                    PINKL
      *                                                                                       CER045
      * Pass the value of CER045                                                              CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SDACUD4DP'
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
     C                   IF        CER034 = 'Y'
      *
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
      *
     C                   ENDIF
      *
     C                   IF        CER038 = 'Y'
      *
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
      *
     C                   ENDIF
      *
     C                   IF        CER041 = 'Y'
      *
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
      *
     C                   ENDIF
      *                                                                                       CER045
     C                   IF        CER045 = 'Y'                                               CER045
      *                                                                                       CER045
     C                   EVAL      *IN75 = *ON                                                CER045
     C                   ELSE                                                                 CER045
     C                   EVAL      *IN75 = *OFF                                               CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
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
     C                   EVAL      DBPGM = 'SDACUD4DP'
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
Finastra International Limited 2008
** CTDATA ArrZ0
000000000000000000000000000000000000000000000000000000000000
