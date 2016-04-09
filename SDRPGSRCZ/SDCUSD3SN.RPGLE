     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Input - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDCUSD3SN - SD Customers Input - Window                      *
      *                                                               *
      *  Function:  This function is the main screen input for        *
      *             customers.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** Current SD Customer in File Format  (WN)
     D CrDlFilFmt    E DS                  EXTNAME(SDCUX1L0)
 
      ** Current SD Customer in Screen Format (#LLX)
     D CrDlScnFmt    E DS                  EXTNAME(SDCURXPD)
     D                                     PREFIX(SS)
 
      ** New SD Customer in File Format (#LLXCU)
     D NwDlFilFmt    E DS                  EXTNAME(SDVCULX1PD)
 
      ** New SD Customer in Screen Format (#nLX)
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)
 
      ** Error indicators (OK#LLX)
     D OkFlags       E DS                  EXTNAME(SDECULX1PD)
 
      ** Data passed from caller program
     D/COPY QWINDSRC,SDCUSDDTA
     D PDATA           DS          1024
     D**#1FLD1**               1      6  0                                                   CSD027A
 
     D  #1CUST                 1      6
     D  #1PAIN                 7      7
     D  #1PCNB                 8     13
     D  #1COLC                15     16
     D  #1LINC                17     18
     D  #1BRCD                19     21
     D  #1BNBI                22     22
     D  #2CNCZ                23     24
     D  #1FOTR                45     64
     D  #1TMST                65     90Z
     D  #1CRNM                91    110
     D  #1NCOS               111    114
 
      **
      **   Declared variables
      **   ==================
      **
      *
      ** "Standard" variables
      *
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D TITLE           S              7
      *
      ** "Standard" modules parameters
      *
     D #LLXIDCO        S              2A
     D #LLXIDEN        S              9A
     D #LLXIMCO        S              2A
     D #LLXIMNB        S              9A
     D #LLXTYPE        S              2A
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
      *
      ** Define parameters for call module
      *
     D BRBKCO          S              2S 0
      *
      ** Error message fields received as parameters
      *
     D     Msg1        S                   LIKE(#MsgID)
     D ULX043          S              1
     D BGNWST          S              1
     D BJMRDT          S              1
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Standard parameter list for window manager                   *
      *                                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    W0RTN
     C                   PARM                    NwDlScnFmt
     C                   PARM                    NwDlFilFmt
     C                   PARM                    ULX043
     C                   PARM                    BGNWST
     C                   PARM                    BJMRDT
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C     WWERR         DOUEQ     'N'
      *
     C                   CALLB     'SDCUS10DP'
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
     C                   PARM                    @EIN20
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
     C                   PARM                    BJMRDT
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *BLANKS       W0RTN
      *
      ** Verify action
      *
     C     @INKC         CASEQ     '1'           SREXIT
     C     @INKE         CASEQ     '1'           SRRESET
     C     @INKJ         CASEQ     '1'           SRDELET
     C     @INKL         CASEQ     '1'           SRPREV
     C                   CAS                     SRVALID
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   EXSR      SREND
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Validate the screen                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALID       BEGSR
      *
      ** If the action code is enquire then simply exit from program
      *
     C                   IF        ACTN = 'E'  OR
     C                             ACTN = 'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   IF        ACTN = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'XXX9001'     MsgIdArr(1)
     C                   GOTO      VAEXIT
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'SDCUS10VL'
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      ** No errors so update the extension file
      *
     C                   IF        Idx = 0 AND
     C                             WIdx = 0
     C                   MOVE      'N'           WWERR
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELET - Delete record                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRDELET       BEGSR
      *
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Exit from program if F3 has been pressed             *
      *                                                               *
      *****************************************************************
      *
     C     SREXIT        BEGSR
      *
     C                   MOVE      'Y2U9999'     W0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESET - Refresh the screen if F5 has been pressed           *
      *                                                               *
      *****************************************************************
      *
     C     SRRESET       BEGSR
      *
      ** Clear the program message queue and call SR/SRINIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   EXSR      SRINIT
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPREV - Exit from program if F12 has been pressed            *
      *                                                               *
      *****************************************************************
      *
     C     SRPREV        BEGSR
      *
     C                   MOVE      'USR0790'     W0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Only do first time through
      *
     C                   IF        WFIRST = *BLANKS
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C     ACTN          WHENEQ    'E'
     C     ACTN          OREQ      'X'
     C                   MOVEL     'Y'           @EIN20
     C     ACTN          WHENEQ    'D'
     C                   MOVEL     'Y'           @EIN20
     C                   MOVEL     'Y'           @EINKJ
     C                   MOVEL     'N'           @EINKE
     C     ACTN          WHENEQ    'I'
     C     ACTN          OREQ      'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKE
     C                   ENDSL
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
      ** If delete does not require window to be displayed, do here
      *
     C                   IF        ACTN = 'D'
     C                   EXSR      SRDELET
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
