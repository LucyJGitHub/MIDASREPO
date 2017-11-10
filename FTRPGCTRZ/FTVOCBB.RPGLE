     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Sender to Receiver Info(Cover B)')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCBB  - Validate Sender to Receiver Information (Cover B) *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG26186           Date 24Sep09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  BUG26186 - Sender to Receiver Info Cover B not higlighted    *
      *             during error                                      *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Array of DDBtb?OK error indicators
     D #ERR            S                   DIM(6) LIKE(OKCBB1)

      ** Incoming Transaction
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)

      ** Cover Message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)
     D NwOPCScnFmt   E DS                  EXTNAME(FTOPYCPD)


      ** Flags to indicate whether transaction fields are valid
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)

      ** Sender to Receiver data structure
     D SNDRCV          DS           210
     D  WCBB1                  1     35
     D  WCBB2                 36     70
     D  WCBB3                 71    105
     D  WCBB4                106    140
     D  WCBB5                141    175
     D  WCBB6                176    210

      *
      /COPY FTCPYSRC,SFTVALCSLE
      *
      /COPY FTCPYSRC,SFTADDRILE
      *

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0

      ** Work fields
     D ADLINE          S              1A
     D ADSLON          S              1A
     D Ctr             S              2S 0
     D Char            S              1A
     D AlphaFlag       S              1A
     D #R              S              3  0
     D #S              S              3  0
     D #T              S              1  0
     D ##001           S              1
     D POS02           S              1
     D NARR            S             33

     D*WErrFld**       S              5    INZ('SBBI ')                                     BUG26186
     D WErrFld         S              5    INZ('SCBB1')                                     BUG26186

      ** IBAN character test arrays
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)

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
      *
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      FldNamXAr  = *Blanks
     C                   Eval      MsgIDXAr   = *Blanks
     C                   Eval      MsgDtaXAr  = *Blanks
     C                   Eval      WFldNmXAr  = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      WIX = 0
     C                   Eval      Idx = 0

      ** Validate
     C                   ExSr      VOCBB
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCBB1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2CBB1 = SCBB1
     C                   Eval      O2CBB2 = SCBB2
     C                   Eval      O2CBB3 = SCBB3
     C                   Eval      O2CBB4 = SCBB4
     C                   Eval      O2CBB5 = SCBB5
     C                   Eval      O2CBB6 = SCBB6
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCBB - Validate Sender to Receiver Information (Cover B)
      *****************************************************************
      *
     C     VOCBB         BegSr
      *
     C                   Eval      WCBB1 = SCBB1
     C                   Eval      WCBB2 = SCBB2
     C                   Eval      WCBB3 = SCBB3
     C                   Eval      WCBB4 = SCBB4
     C                   Eval      WCBB5 = SCBB5
     C                   Eval      WCBB6 = SCBB6
      *
     C                   If        SOMVLF = 'COV'
      *
      ** Sender to Receiver (Cover B) can only be entered for
      ** Validation Flag Main COV
      *
     C                   ElseIf    SNDRCV <> *Blanks

     C                   Eval      OKCBB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBB1'
     C                   Eval      MsgDtaXAr(IDX) = SCBB1
     C                   Eval      MsgIDXAr(Idx) = 'ME00242'
     C                   LeaveSr
     C                   EndIf

     C                   If        SNDRCV <> *Blanks

     C                   Eval      ADDRSS = SNDRCV
      *
      ** Validate Address
      *
     C                   ExSr      VADDR
      *
     C                   Exsr      SRSEPT
      * If errors occurred set up flags

     C                   If        #ERR(1) = 'N'
     C                   Eval      OKCBB1 = 'N'
     C                   End

     C                   If        #ERR(2) = 'N'
     C                   Eval      OKCBB2 = 'N'
     C                   End

     C                   If        #ERR(3) = 'N'
     C                   Eval      OKCBB3 = 'N'
     C                   End

     C                   If        #ERR(4) = 'N'
     C                   Eval      OKCBB4 = 'N'
     C                   End

     C                   If        #ERR(5) = 'N'
     C                   Eval      OKCBB5 = 'N'
     C                   End

     C                   If        #ERR(6) = 'N'
     C                   Eval      OKCBB6 = 'N'
     C                   End


     C                   EndIf
      *
     C                   EndSr
     C*****************************************************************
      /EJECT
      *****************************************************************
      * VADDR - Validate Address
      *****************************************************************
      *
     C     VADDR         BegSr
      *
     C                   Eval      ADLINE = 'Y'
     C                   ExSr      ADCHK
      *
      ** Send error if Embedded blank lines exist
      *
     C                   If        *IN92 = *ON
     C                   Eval      OKCBB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBB1'
     C                   Eval      MsgDtaXAr(IDX) = SCBB1
     C                   Eval      MsgIDXAr(Idx)= 'ME00243'
     C                   EndIf
      *
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *  SRSEPT   : SWIFT validation changes                          *
      *****************************************************************
     CSR   SRSEPT        BegSr

      *  Check through each of the 8 fields in turn.
     C                   Eval      #S = 1
     C                   Eval      #ERR = *BLANKS

     C     1             Do        6             #T

      *  Set flag to show line correct and move data to work fields
     C     35            Subst     SNDRCV:#S     FLD

      *  If not equal to blanks validate
     C                   If        FLD <> *Blanks

      * If line is not blank then first position must be a "/"
     C     1             Subst     FLD:1         ##001

      *  First position must be a '/'
     C                   If        ##001 <> '/'
      * Send error to screen
     C                   Eval      #ERR(#T) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Move      #T            WErrFld
     C                   Eval      FldNamXAr(Idx) = WErrFld
     C                   Eval      MsgIdXAr(Idx) = 'ME00244'

     C                   Else

      *  The first special instruction line cannot have '/'
      *  in position 2
     C                   If        #S = 1
     C     1             Subst     FLD:2         ##001
     C                   If        ##001 = '/'
      * Send error to screen
     C                   Eval      #ERR(#T) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Move      #T            WErrFld
     C                   Eval      FldNamXAr(Idx) = WErrFld
     C                   Eval      MsgIdXAr(Idx) = 'ME00245'
     C                   End

     C                   End

      *  2nd - 8th special instruction line cannot have '/'
      *  in position 2 followed by a narrative of blanks.
     C                   If        #S <> 1
     C     1             Subst     FLD:2         POS02
     C     33            Subst     FLD:3         NARR

     C                   If        POS02 = '/' and
     C                             NARR = *Blanks
      * Send error to screen
     C                   Eval      #ERR(#T) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Move      #T            WErrFld
     C                   Eval      FldNamXAr(Idx) = WErrFld
     C                   Eval      MsgIdXAr(Idx) = 'ME00246'
     C                   End

     C                   End
      *
      *  Check the line for '8a/', where 8a represents
      *  up to eight upper case alphabetic charaters
      *
      *
     C                   Eval      #R = 2
     C     ALPHAN        CHECK     FLD:#R        #R
      *
     C                   If        #R >= 11
      * Send error to screen
     C                   Eval      #ERR(#T) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Move      #T            WErrFld
     C                   Eval      FldNamXAr(Idx) = WErrFld
     C                   Eval      MsgIdXAr(Idx) = 'ME00247'
     C                   End
      *
      *  If #R less than eleven then this character must be "/"
      *
     C                   If        #R < 11
     C     1             Subst     FLD:#R        ##001
     C                   If        ##001 <> '/'
      * Send error to screen
     C                   Eval      #ERR(#T) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Move      #T            WErrFld
     C                   Eval      FldNamXAr(Idx) = WErrFld
     C                   Eval      MsgIdXAr(Idx) = 'ME00248'
     C                   End

     C                   End
     C                   End
     C                   End

      * Move pointer on 35 characters
     C                   Eval      #S = #S + 35
     C                   End

      *
     CSR                 EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRCLE
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BegSr
      *
     C     *Entry        PList

     C                   Parm                    RetCodeIn
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   EndSr
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
**  Alpha - Array of alphabetic characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters
0123456789
