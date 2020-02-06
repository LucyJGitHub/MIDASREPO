     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDYRATENQ - Yield Rates Enquiry                              *
      *                                                               *
      *  Function:  This module will allow enquiry upon Yield Rates   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9331            Date 11Dec05               *
      *                 CAS008             Date 16Jun04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG9331 - Default values of Yield Rates when Yield Rates     *
      *            details are entered.                               *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Record found / not found on Yield Rates file.   *
      *    75         Disable action code field on display file.      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR       - Error processing                               *
      *  *INZSR      - Initialise                                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDYLDRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Yield Rates Master file Retrieval Index
      *
      *****************************************************************
      /EJECT
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
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(600)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNamArr      S             10A   DIM(ArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of warning message data.
     D WMsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Output Parameter Array for Maturity Date and Discount Factor
     D MatDateArr      S              7    DIM(98)
     D DiscFacArr      S             14    DIM(98)
 
      ** Yield Rates Transaction Details in Screen Format
     D YRATScnFmt    E DS                  EXTNAME(SDYRATPD)
 
      ** Yield Rates Transaction Details in File Format
     D YRATFilFMT    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(V_)
 
      ** Fields Ok Indicator
     D OKYRScnFld    E DS                  EXTNAME(SDEYRATPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CAS008
      ** External DS for SAR details                                                          CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
 
      ** Current Control Indicators for Main Detail screen
     D @CCI@M          DS
 
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKN                 6      6
     D  @EINKP                 7      7
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter fields for SDYRATRTV
     D ModeofOp        S              6
     D RespMode        S              1
     D PIACTN          S              1
     D PIYLDC          S              5
     D PIYCCY          S              3
     D PIYICM          S              1
     D PIYCFQ          S              1
     D PISPDY          S              2                                                       CAS008
     D PFOTRID         S             20
     D PACTNOk         S              1
     D PYLDCOk         S              1
     D PYCCYOk         S              1
     D PYICMOk         S              1
     D PYCFQOk         S              1
     D PSPDYOk         S              1                                                       CAS008
     D Ix              S              3P 0
     D PKYCFQ          S              1
 
      ** Input Parameter (Enable F7, F8, F10, F15 in Command Narrative
      ** and Key Fields)
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
     D PEKYFD          S              1A
 
      ** Output Parameter (Function Keys - 3,7,8,10,12 and 15)
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Output Parameter for SDYRATRED
     D PRDFWD          S              1
     D PRDBCK          S              1
     D PERRMS          S              7
 
      ** Workfields for key fields
     D WYLDC           S              5
     D WYCCY           S              3
     D WYICM           S              1
     D WYCFQ           S              1
     D WSPDY           S              2                                                       CAS008
 
      ** Parameters for AOBANKR0
     D PRtCd           S              7
     D POptn           S              7
 
     D PSard           S              6A                                                      CAS008
     D CAS008          S              1A                                                      CAS008
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      *IN75 = *ON
     C     *LOVAL        SETLL     SDYLDRL1
     C                   READ      SDYLDRL1                               21
     C                   IF        *IN21 = *OFF
     C                   EVAL      PIACTN = 'E'
     C                   EVAL      PIYLDC = FSYLDC
     C                   EVAL      PIYCCY = FSYCCY
     C                   EVAL      PIYICM = FSYICM
     C                   EVAL      PIYCFQ = FSYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   MOVE      FSSPDY        PISPDY                                       CAS008
     C                   ELSE                                                                 CAS008
     C                   MOVE      *BLANKS       PISPDY                                       CAS008
     C                   ENDIF                                                                CAS008
     C                   EVAL      PKYCFQ = 'N'
     C                   EXSR      SRRTVREC
     C                   ELSE
     C                   EVAL      PYLDCOk = 'N'
     C                   EVAL      PYCCYOk = 'N'
     C                   EVAL      PYICMOk = 'N'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIDArr(1) = 'USR9193'
     C                   EXSR      SRDSPREC
     C                   ENDIF
 
     C     PACTNOk       IFEQ      'N'
     C     PYLDCOk       OREQ      'N'
     C     PYCCYOk       OREQ      'N'
     C     PYICMOk       OREQ      'N'
     C     PYCFQOk       OREQ      'N'
     C     PSPDYOk       OREQ      'N'                                                        CAS008
     C     CAS008        ANDEQ     'Y'                                                        CAS008
     C                   MOVE      *ON           *INLR
     C                   ELSE
     C                   EXSR      SRCVTREC
     C                   ENDIF
 
     C                   DOW       PINKC = *OFF
 
     C                   EVAL      PINKG = *OFF
     C                   EVAL      PINKH = *OFF
     C                   EVAL      PERRMS = *Blanks
 
     C                   EXSR      SRCLRMSG
 
     C                   EXSR      SRDSPREC
 
     C                   IF        PINKG = *ON OR PINKH = *ON
 
      ** Initialise read indicators
 
     C                   EVAL      PRDFWD = *Blanks
     C                   EVAL      PRDBCK = *Blanks
 
      ** Initialise message array
 
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIDArr = *Blanks
 
      ** Set read indicator
 
     C                   IF        PINKG = TRUE
     C                   EVAL      PRDBCK = 'Y'
     C                   ELSE
     C                   EVAL      PRDFWD = 'Y'
     C                   ENDIF
 
      ** Read Yield Rates Details
 
     C                   EXSR      SRREDREC
     C                   ENDIF
 
     C                   EXSR      SRCLRMSG
 
      ** Error message returned from read, send it to detail screen
 
     C                   IF        PERRMS = *Blanks
     C                   EVAL      PIACTN = 'E'
     C                   EVAL      PIYLDC = #0YLDC
     C                   EVAL      PIYCCY = #0YCCY
     C                   EVAL      PIYICM = #0YICM
     C                   EVAL      PIYCFQ = #0YCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      PISPDY = #0SPDY                                            CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      PISPDY = *BLANKS                                           CAS008
     C                   ENDIF                                                                CAS008
     C**********         EVAL      PKYCFQ = 'N'                                              BUG9331
     C                   EVAL      PKYCFQ = 'Y'                                              BUG9331
     C                   EXSR      SRRTVREC
     C     PACTNOk       IFEQ      'N'
     C     PYLDCOk       OREQ      'N'
     C     PYCCYOk       OREQ      'N'
     C     PYICMOk       OREQ      'N'
     C     PYCFQOk       OREQ      'N'
     C     PSPDYOk       OREQ      'N'                                                        CAS008
     C     CAS008        ANDEQ     'Y'                                                        CAS008
     C                   MOVE      *ON           *INLR
     C                   ELSE
     C                   EXSR      SRCVTREC
     C                   ENDIF
     C                   ENDIF
 
      ** End of file reached for F8 key
 
     C                   IF        PERRMS = 'USR9249'
     C                   EVAL      PYLDCOk = 'N'
     C                   EVAL      PYCCYOk = 'N'
     C                   EVAL      PYICMOk = 'N'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIDArr(1) = 'USR9249'
     C                   ENDIF
 
      ** Beginning of file reached for F7 key
 
     C                   IF        PERRMS = 'USR9250'
     C                   EVAL      PYLDCOk = 'N'
     C                   EVAL      PYCCYOk = 'N'
     C                   EVAL      PYICMOk = 'N'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIDArr(1) = 'USR9250'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVREC - Retrieve the Details of the Yield Rate            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SDYRATRTV - YRAT Retrieve Function                *
      *                                                               *
      *****************************************************************
 
     C     SRRTVREC      BEGSR
 
     C                   CALLB     'SDYRATRTV'
     C                   PARM      *BLANKS       RetCodeIn
     C                   PARM      *BLANKS       ModeOfOp          6
     C                   PARM      'S'           RespMode
     C                   PARM                    PIACTN
     C                   PARM                    PIYLDC
     C                   PARM                    PIYCCY
     C                   PARM                    PIYICM
     C                   PARM                    PIYCFQ
     C                   PARM                    PISPDY                                       CAS008
     C                   PARM                    PFOTRID
     C                   PARM      *BLANKS       YRATFilFmt
     C                   PARM                    PACTNOk
     C                   PARM                    PYLDCOk
     C                   PARM                    PYCCYOk
     C                   PARM                    PYICMOk
     C                   PARM                    PYCFQOk
     C                   PARM                    PSPDYOk                                      CAS008
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Ix
     C                   PARM                    PKYCFQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCVTREC - Convert Details to Screen Format                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SDYRATCVT - YRAT Conversion: File to Screen       *
      *                                                               *
      *****************************************************************
 
     C     SRCVTREC      BEGSR
 
     C                   CALLB     'SDYRATCVT'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    YRATFilFmt
     C                   PARM                    YRATScnFmt
     C                   PARM                    MatDateArr
     C                   PARM                    DiscFacArr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSPREC - Displays Yield Rates                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SDYRATDSP - YRAT Display                          *
      *                                                               *
      *****************************************************************
 
     C     SRDSPREC      BEGSR
 
     C                   EVAL      #0ACTN = 'E'
     C                   EVAL      RetCodeIn = 'ENQUIRE'
 
     C                   CALLB     'SDYRATDSP'
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
     C                   PARM                    YRATScnFmt
     C                   PARM                    MatDateArr
     C                   PARM                    DiscFacArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OkYRScnFld
     C                   PARM                    PEKYFD
     C                   PARM      'Y'           Writeonly
     C                   PARM      'Y'           PEINKG
     C                   PARM      'Y'           PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREDREC - Read Yield Rates Details                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SDYRATRED - YRAT Read Function                    *
      *                                                               *
      *****************************************************************
 
     C     SRREDREC      BEGSR
 
     C                   CALLB     'SDYRATRED'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0ACTN
     C                   PARM                    #0YLDC
     C                   PARM                    #0YCCY
     C                   PARM                    #0YICM
     C                   PARM                    #0YCFQ
     C                   PARM                    #0SPDY                                       CAS008
     C                   PARM                    PRDFWD
     C                   PARM                    PRDBCK
     C                   PARM      *BLANK        PERRMS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLRMSG - Clears error message when review from entered     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRCLRMSG      BEGSR
 
     C                   EVAL      WYLDC = #0YLDC
     C                   EVAL      WYCCY = #0YCCY
     C                   EVAL      WYICM = #0YICM
     C                   EVAL      WYCFQ = #0YCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      WSPDY = #0SPDY                                             CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      WSPDY = *BLANKS                                            CAS008
     C                   ENDIF                                                                CAS008
 
     C                   IF        WYLDC <> PIYLDC OR
     C                             WYCCY <> PIYCCY OR
     C                             WYICM <> PIYICM OR
     C**********                   WYCFQ <> PIYCFQ                                            CAS008
     C                             WYCFQ <> PIYCFQ OR                                         CAS008
     C                             WSPDY <> PISPDY AND                                        CAS008
     C                             CAS008 = 'Y'                                               CAS008
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIDArr = *Blanks
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, *PSSR                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      PINKC = *OFF
     C                   EVAL      PINKG = *OFF
     C                   EVAL      PINKH = *OFF
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SDYRATENQ'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if switchable feature CAS008 is switched on.                                   CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY'     POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRtCd <> *BLANKS) AND                                     CAS008
     C                             (PRtCd <> '*NRF   ')                                       CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
