     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade SWIFT Extended Settle Validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSESVAL - Midas SE Trade SWIFT Extended Settlement         *
      *              Validation                                       *
      *                                                               *
      *  Function: This module is for the validation and the setting  *
      *            up of default value for the Extended Settlement    *
      *            as in SE1806 and SE001810 for input into the       *
      *            Midas database.                                    *
      *                                                               *
      *  Component of: SETSESSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR596191           Date 19Aug14               *
      *                 MD022800           Date 18Oct13               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR640670           Date 13Sep10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13112           Date 29Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8004            Date 21Oct03               *
      *                 222331             Date 21Oct03               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR596191 - Error on Safekeeping Account is issued even if    *
      *             a valid value is inserted                         *
      *  MD022800 - No validation for clearing correspondent when     *
      *             clearance type is not 1 to 4                      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR640670 - Debtor address validation for warning messages    *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13112 - Trades - Safekeeping Acct is mandatory if         *
      *             ISO15022 is 'Y'                                   *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8004- System allows saving a record with a blank Safe -   *
      *           keeping account during input cycle. The same record *
      *           could not be processed during approval.             *
      *  222331 - Change of header box for subroutine                 *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
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
      *
      ** Security API Trades Extended Settlement details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Security API Trades Extended Settlement details valid file
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
      *
      ** Securities screen 1 error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Update error index
     D Ix              S              3P 0
      *
      ** Response Mode, received as a parameter from the common header
     D PResponse       S              1A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     D PMode           S              6A
     D PSAFA           S              6A
     D PINKS           S              1A
     D PINKT           S              1A
      *
      ** Switchable features
     D CSE028          S              1A
     D CSW014          S              1A
     D CSW201          S              1A
     D CSW210          S              1A                                                      CSW210
     D CFT004          S              1A                                                      CSW210
      *
      ** Work parameters
     D OVER2           S              1A
     D OVER3           S              1A
     D OVER6           S              1A
     D OVER7           S              1A
     D OVER8           S              1A
     D OVER9           S              1A
     D WTDTP           S              2A
     D WWCLTY          S              2A
     D SWRTN           S              7A
     D IAWBK           S              1A
     D WAWIN           S             10A
     D IBENF           S              1A
     D WBOFN           S             10A
     D WKSRL1          S              1A
     D WWACL1          S              1A
     D WWBLCD          S              8A
     D WWBNBI          S              1A
     D WWBOF1          S              1A
     D WWCABA          S              3P 0
     D WWCHID          S              6P 0
     D WWCHSC          S              6P 0
     D WWCSID          S             12A
     D WWCUSS          S              1A
     D WWFWCD          S              9A
     D WWNAL1          S              1A
     D WWSRL1          S              1A
     D WWSRL2          S              1A
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
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
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** M A I N  P R O C E S S I N G
      *
      *                                                                                      BUG8004
      ** Enable display of counterparty safekeeping a/c if                                   BUG8004
      ** CSE028 is on and ISO15022 is on.                                                    BUG8004
      *                                                                                      BUG8004
     C     CSE028        IFEQ      'Y'                                                       BUG8004
     C     PSNEW         ANDEQ     'Y'                                                       BUG8004
     C     PGMES         ANDEQ     'Y'                                                       BUG8004
     C                   EVAL      *IN88 = *ON                                               BUG8004
     C                   ELSE                                                                BUG8004
     C                   EVAL      *IN88 = *OFF                                              BUG8004
     C                   ENDIF                                                               BUG8004
      *
      ** Reset validations by F19
      *
     C     PINKT         IFEQ      *ON
     C                   MOVE      *BLANK        OVER2
     C                   MOVE      *BLANK        OVER3
     C                   MOVE      *BLANK        OVER6
     C                   MOVE      *BLANK        OVER7
     C                   MOVE      *BLANK        OVER8
     C                   MOVE      *BLANK        OVER9
     C                   ENDIF
      *
      ** Validate A/c for Payment fields (MT510)
      *
     C                   EXSR      SRAP1N
     C*****PSNEW         IFNE      'Y'                                                        CSW210
     C*****CSE028        ORNE      'Y'                                                        CSW210
     C                   EXSR      SRAP1L
     C**********         ENDIF                                                                CSW210
      *
      ** Validate Account For Payment fields
      *
     C                   EXSR      SRAP2N
     C*****PSNEW         IFNE      'Y'                                                        CSW210
     C*****CSE028        ORNE      'Y'                                                        CSW210
     C                   EXSR      SRAP2L
     C**********         ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Validate Debtor, Debtor Address Lines, Account Line                                  CSW210
      *                                                                                       CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   EXSR      SRDIDN                                                     CSW210
     C                   EXSR      SRDADS                                                     CSW210
     C                   EXSR      SRDLIN                                                     CSW210
     C                   ENDIF                                                                CSW210
      *
      ** Validate Account With Institution fields
      *
     C                   EXSR      SRAWIN
     C*****PSNEW         IFNE      'Y'                                                        CSW210
     C*****CSE028        ORNE      'Y'                                                        CSW210
     C                   EXSR      SRAWIL
     C**********         ENDIF                                                                CSW210
      *
      ** Validate Beneficiary of Money fields
      *
     C                   EXSR      SRBOFN
     C*****PSNEW         IFNE      'Y'                                                        CSW210
     C*****CSE028        ORNE      'Y'                                                        CSW210
     C                   EXSR      SRBOF1
     C                   EXSR      SRBOF2
     C**********         ENDIF                                                                CSW210
      *
      ** Validate Account For Charges fields
      *
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRACL1
     C                   EXSR      SRACL2
     C                   ENDIF
      *
      ** Validate Sender to Receiver Information
      *
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRSRL1
     C                   EXSR      SRSRL2
     C                   EXSR      SRSRL3
     C                   ENDIF
      *
      ** Validate Further Information field
      *
     C                   EXSR      SRFIN1
     C                   EXSR      SRFIN2
      *
      ** Validate Registration Details field
      *
     C                   EXSR      SRRED1
     C                   EXSR      SRRED2
      *
      ** Validate Narrative field
      *
     C                   EXSR      SRNAL1
     C                   EXSR      SRNAL2
      *
      ** If ccy clearing code entered for a/c w/ bank or beneficiary,
      ** check whether Issuer Code has been defined for the currency
      ** clearing system and output warning message if not defined.
      *
     C     SWRTN         IFEQ      'CSW098 '
     C     RetCodeOut    ANDEQ     *Blanks
     C     IAWBK         IFEQ      'Y'
     C                   MOVE      'N'           ESAWILOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESAWIL'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5176'     MsgIdXAr(IDx)
     C                   MOVEL     *BLANKS       IAWBK
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
     C     IBENF         IFEQ      'Y'
     C                   MOVE      'N'           ESBOF1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5176'     MsgIdXAr(IDx)
     C                   MOVEL     *BLANKS       IBENF
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Instructing Party fields
      *
     C                   EXSR      SRIPYN
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRIPYL
     C                   ENDIF
      *
      ** Validate Investor
      *
     C                   EXSR      SRINVE
      *
      ** Validate Counterparty fields
      *
     C                   EXSR      SRCTYN
     C                   EXSR      SRCTYL
      *
      ** Validate Safekeeping Account fields (MT510)
      *
     C                   EXSR      SRSA1N
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRSA1L
     C                   ENDIF
      *
      ** Validate Safekeeping Account fields
      *
     C     WWCLTY        IFNE      '14'
     C                   EXSR      SRSKAN
 
     C*****ESSKAL        IFEQ      *BLANKS                                                  BUG13112
     C     ESSKAN        IFEQ      *BLANKS                                                  BUG13112
     C     PSAFA         ANDEQ     *BLANKS
     C     *IN88         ANDEQ     *ON
     C                   Z-ADD     1             Ix                                         AR596191
     C     'SEW9004'     LOOKUP    MsgIDArr(Ix)                           99                AR596191
     C     *IN99         IFEQ      '0'                                                      AR596191
     C**********         MOVE      'N'           ESSKALOK                                   AR596191
     C                   ADD       1             IDx
     C                   MOVEL     'ESSKAL'      FldNamXAr(IDx)
     C                   MOVEL     'SEW9004'     MsgIdXAr(IDx)
     C                   EXSR      SRUpdatErrs
     C                   ENDIF                                                              AR596191
     C                   MOVE      'N'           ESSKALOK                                   AR596191
     C                   ENDIF
 
     C     ESSKAL        IFNE      *BLANKS
     C     PSAFA         ANDNE     *BLANKS
     C     *IN88         ANDEQ     *ON
     C                   Z-ADD     1             Ix                                         AR596191
     C     'SEW9007'     LOOKUP    MsgIDArr(Ix)                           99                AR596191
     C     *IN99         IFEQ      '0'                                                      AR596191
     C**********         MOVE      'N'           ESSKALOK                                   AR596191
     C                   ADD       1             IDx
     C                   MOVEL     'ESSKAL'      FldNamXAr(IDx)
     C                   MOVEL     'SEW9007'     MsgIdXAr(IDx)
     C                   EXSR      SRUpdatErrs
     C                   ENDIF                                                              AR596191
     C                   MOVE      'N'           ESSKALOK                                   AR596191
     C                   ENDIF
 
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRSKAL
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Clearing Correspondent fields
      *
     C*****WWCLTY        IFEQ      '14'                                                     MD022800
     C                   EXSR      SRCCTN
     C**********         ENDIF                                                              MD022800
      *
      ** Validate Deliverer's Instructing Party field
      *
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRDCTL
     C                   ENDIF
      *
      ** Validate Receiver of Securities fields
      *
     C                   EXSR      SRRSSN
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRRSS1
     C                   EXSR      SRRSS2
     C                   EXSR      SRRSS3
     C                   EXSR      SRRSS4
     C                   ENDIF
      *
      ** Validate Deliverer of Securities fields
      *
     C                   EXSR      SRDSSN
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRDSS1
     C                   EXSR      SRDSS2
     C                   EXSR      SRDSS3
     C                   EXSR      SRDSS4
     C                   ENDIF
      *
      ** Validate Beneficiary of Securities fields
      *
     C                   EXSR      SRBSSN
     C     PSNEW         IFNE      'Y'
     C     CSE028        ORNE      'Y'
     C                   EXSR      SRBSS1
     C                   EXSR      SRBSS2
     C                   ENDIF
      *
      ** Validate Intermediary, Safekeeping Account Fields, and Place of Settlement
      *
     C     CSE028        IFEQ      'Y'
     C                   EXSR      SRINTM
     C                   EXSR      SRSAFE
     C                   EXSR      SRPSET
     C                   ENDIF
      *                                                                                       CSW210
      ** Validate Qualified Foreign Intermediary and Place of Clearing                        CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'                                                        CSW210
     C                   EXSR      SRQFIN                                                     CSW210
     C                   EXSR      SRPCLR                                                     CSW210
     C                   ENDIF                                                                CSW210
 
     C                   EXSR      MOVEFIELD
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAP1N  - Account for Payment (MT510) Validation Process     *
      *                                                               *
      *****************************************************************
 
     C     SRAP1N        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVAP1N'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRAP1L  - Account for Payment A/C Line Validation Process    *
      *                                                               *
      *****************************************************************
 
     C     SRAP1L        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVAP1L'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
                                                                                              CSW210
     C                   PARM                    CSE028                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRAP2N  - Account for Payment :53: Validation Process        *
      *                                                               *
      *****************************************************************
 
     C     SRAP2N        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVAP2N'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WWCLTY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRAP2L - Account for Payment (A/c Line) 2 Validation Process *
      *                                                               *
      *****************************************************************
 
     C     SRAP2L        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVAP2L'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    WTDTP
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
                                                                                              CSW210
     C                   PARM                    CSE028                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRDIDN - Validate Debtor Identification                      *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRDIDN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Reset variables updated by each module                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRResetErrs                                                CSW210
      *                                                                                       CSW210
      ** Call validation module                                                               CSW210
      *                                                                                       CSW210
     C                   CALLB     'SEVDEBTID'                                                CSW210
      *                             =======                                                   CSW210
      ** INPUTS                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Return code                                                                          CSW210
     C                   PARM                    RetCodeOut                                   CSW210
      *                                                                                       CSW210
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW210
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW210
      ** Mode = '*RPR  ' (Repair function)                                                    CSW210
      ** Mode = '*SIN  ' (Screen input function)                                              CSW210
     C                   PARM                    PMode                                        CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements from incoming transaction                       CSW210
      ** - screen format                                                                      CSW210
     C                   PARM                    NwSE1ScnFmt                                  CSW210
      *                                                                                       CSW210
     C                   PARM                    PDATA                                        CSW210
      *                                                                                       CSW210
      ** OUTPUT                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW210
     C                   PARM                    FldNamXAr                                    CSW210
     C                   PARM                    MsgIDXAr                                     CSW210
     C                   PARM                    MsgDtaXAr                                    CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements error indicators                                CSW210
     C                   PARM                    SEETES                                       CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements Valid File                                      CSW210
     C                   PARM                    NwSEFilFmt                                   CSW210
      *                                                                                       CSW210
      ** Update error info with that returned from the validation module                      CSW210
      *                                                                                       CSW210
     C                   IF        RetCodeOut <> *BLANKS                                      CSW210
     C                   EXSR      SRUpdatErrs                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRDLIN - Validate Debtor Account Line                        *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRDLIN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Reset variables updated by each module                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRResetErrs                                                CSW210
      *                                                                                       CSW210
      ** Call validation module                                                               CSW210
      *                                                                                       CSW210
     C                   CALLB     'SEVDEBTACL'                                               CSW210
      *                             =======                                                   CSW210
      ** INPUTS                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Return code                                                                          CSW210
     C                   PARM                    RetCodeOut                                   CSW210
      *                                                                                       CSW210
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW210
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW210
      ** Mode = '*RPR  ' (Repair function)                                                    CSW210
      ** Mode = '*SIN  ' (Screen input function)                                              CSW210
     C                   PARM                    PMode                                        CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements from incoming transaction                       CSW210
      ** - screen format                                                                      CSW210
     C                   PARM                    NwSE1ScnFmt                                  CSW210
                                                                                              CSW210
     C                   PARM                    PDATA                                        CSW210
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
      *                                                                                       CSW210
      ** OUTPUT                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW210
     C                   PARM                    FldNamXAr                                    CSW210
     C                   PARM                    MsgIDXAr                                     CSW210
     C                   PARM                    MsgDtaXAr                                    CSW210
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements error indicators                                CSW210
     C                   PARM                    SEETES                                       CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements Valid File                                      CSW210
     C                   PARM                    NwSEFilFmt                                   CSW210
      *                                                                                       CSW210
      ** Update error info with that returned from the validation module                      CSW210
      *                                                                                       CSW210
     C                   IF        RetCodeOut <> *BLANKS                                      CSW210
     C                   EXSR      SRUpdatErrs                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRDADS - Validate Debtor Address                             *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRDADS        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Reset variables updated by each module                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRResetErrs                                                CSW210
      *                                                                                       CSW210
      ** Call validation module                                                               CSW210
      *                                                                                       CSW210
     C                   CALLB     'SEVDEBTADR'                                               CSW210
      *                             =======                                                   CSW210
      ** INPUTS                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Return code                                                                          CSW210
     C                   PARM                    RetCodeOut                                   CSW210
      *                                                                                       CSW210
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW210
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW210
      ** Mode = '*RPR  ' (Repair function)                                                    CSW210
      ** Mode = '*SIN  ' (Screen input function)                                              CSW210
     C                   PARM                    PMode                                        CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements from incoming transaction                       CSW210
      ** - screen format                                                                      CSW210
     C                   PARM                    NwSE1ScnFmt                                  CSW210
                                                                                              CSW210
     C                   PARM                    PDATA                                        CSW210
                                                                                              CSW210
      *                                                                                       CSW210
      ** OUTPUT                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW210
     C                   PARM                    FldNamXAr                                    CSW210
     C                   PARM                    MsgIDXAr                                     CSW210
     C                   PARM                    MsgDtaXAr                                    CSW210
      *                                                                                     AR640670
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR640670
     C                   PARM                    WFldNmXAr                                  AR640670
     C                   PARM                    WMsgIDXAr                                  AR640670
     C                   PARM                    WMsgDtXAr                                  AR640670
      *                                                                                       CSW210
      ** Security Trades Extended Settlements error indicators                                CSW210
     C                   PARM                    SEETES                                       CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements Valid File                                      CSW210
     C                   PARM                    NwSEFilFmt                                   CSW210
      *                                                                                       CSW210
      ** Update error info with that returned from the validation module                      CSW210
      *                                                                                       CSW210
     C                   IF        RetCodeOut <> *BLANKS                                      CSW210
     C                   EXSR      SRUpdatErrs                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
 
      *****************************************************************
      *                                                               *
      *  SRAWIN - A/c with Institution (Customer Number)              *
      *                                                               *
      *****************************************************************
 
     C     SRAWIN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVAWIN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    SWRTN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WWCUSS
 
     C                   PARM                    WWBNBI
 
     C                   PARM                    WWCABA
 
     C                   PARM                    WWCSID
 
     C                   PARM                    WWFWCD
 
     C                   PARM                    WWBLCD
 
     C                   PARM                    WWCHID
 
     C                   PARM                    WWCHSC
 
     C                   PARM                    WAWIN
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRAWIL - A/c with Institution (A/c Line)                     *
      *                                                               *
      *****************************************************************
 
     C     SRAWIL        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVAWIL'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
 
     C                   PARM                    WWCUSS
 
     C                   PARM                    WWBNBI
 
     C                   PARM                    WWCABA
 
     C                   PARM                    WWCSID
 
     C                   PARM                    WWFWCD
 
     C                   PARM                    WWBLCD
 
     C                   PARM                    WWCHID
 
     C                   PARM                    WWCHSC
 
     C                   PARM                    WAWIN
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
                                                                                              CSW210
     C                   PARM                    CSE028                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    PINKS
 
     C                   PARM                    OVER2
 
     C                   PARM                    IAWBK
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRBOFN - Beneficiary of Money Validation Process             *
      *                                                               *
      *****************************************************************
 
     C     SRBOFN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVBOFN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    SWRTN
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSE028
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WWCUSS
 
     C                   PARM                    WWBNBI
 
     C                   PARM                    WWCABA
 
     C                   PARM                    WWCSID
 
     C                   PARM                    WWFWCD
 
     C                   PARM                    WWBLCD
 
     C                   PARM                    WWCHID
 
     C                   PARM                    WWCHSC
 
     C                   PARM                    WBOFN
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRBOF1 - Beneficiary of Money (a/c line 1) Validation Process*
      *                                                               *
      *****************************************************************
 
     C     SRBOF1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVBOF1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
 
     C                   PARM                    CSE028
 
     C                   PARM                    WWCUSS
 
     C                   PARM                    WWBNBI
 
     C                   PARM                    WWCABA
 
     C                   PARM                    WWCSID
 
     C                   PARM                    WWFWCD
 
     C                   PARM                    WWBLCD
 
     C                   PARM                    WWCHID
 
     C                   PARM                    WWCHSC
 
     C                   PARM                    WBOFN
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    PINKS
 
     C                   PARM                    OVER3
 
     C                   PARM                    IBENF
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRBOF2 - Beneficiary of Money (a/c ln 2) Validation Process  *
      *                                                               *
      *****************************************************************
 
     C     SRBOF2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVBOF2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSE028
 
     C                   PARM                    WWBOF1
 
     C                   PARM                    OVER3
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRACL1 - Account for Charges line 1 Validation Process       *
      *                                                               *
      *****************************************************************
 
     C     SRACL1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVACL1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WWACL1
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRACL2 - Account for Charges line 2 Validation Process       *
      *                                                               *
      *****************************************************************
 
     C     SRACL2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVACL2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WWACL1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSRL1 - Sender to Receiver Information 1 Validation         *
      *           Process                                             *
      *                                                               *
      *****************************************************************
 
     C     SRSRL1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSRL1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WTDTP
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    CSW014
 
     C                   PARM                    CSW201
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WKSRL1
 
     C                   PARM                    WWSRL1
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSRL2 - Sender to Receiver Information 2 Validation         *
      *           Process                                             *
      *                                                               *
      *****************************************************************
 
     C     SRSRL2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSRL2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WWSRL1
 
     C                   PARM                    WKSRL1
 
     C                   PARM                    CSW201
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WWSRL2
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSRL3 - Sender to Receiver Information 3 Validation         *
      *           Process                                             *
      *                                                               *
      *****************************************************************
 
     C     SRSRL3        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSRL3'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WWSRL2
 
     C                   PARM                    CSW201
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRFIN1 - Further Information 1 Validation Process            *
      *                                                               *
      *****************************************************************
 
     C     SRFIN1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVFIN1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRFIN2 - Further Information 2 Validation Process            *
      *                                                               *
      *****************************************************************
 
     C     SRFIN2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVFIN2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRED1 - Registration Details 1 Validation Process           *
      *                                                               *
      *****************************************************************
 
     C     SRRED1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRED1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRED2 - Registration Details 2 Validation Process           *
      *                                                               *
      *****************************************************************
 
     C     SRRED2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRED2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRNAL1 - Narrative 1 Validation Process                      *
      *                                                               *
      *****************************************************************
 
     C     SRNAL1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVNAL1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WWNAL1
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRNAL2 - Narrative 2 Validation Process                      *
      *                                                               *
      *****************************************************************
 
     C     SRNAL2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVNAL2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WWNAL1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRIPYN - Instructing Party (Customer Number) Validation      *
      *           Process                                             *
      *                                                               *
      *****************************************************************
 
     C     SRIPYN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVIPYN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WWCLTY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRIPYL - Instructing Party (A/c Line) Validation Process     *
      *                                                               *
      *****************************************************************
 
     C     SRIPYL        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVIPYL'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WWCLTY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRINVE - Investor Validation Process                         *
      *                                                               *
      *****************************************************************
 
     C     SRINVE        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVINVE'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRCTYN - Counterparty (Customer Number) Validation Process   *
      *                                                               *
      *****************************************************************
 
     C     SRCTYN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVCTYN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRCTYL - Counterparty (A/c Line) Validation Process          *
      *                                                               *
      *****************************************************************
 
     C     SRCTYL        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVCTYL'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSA1N - Counterparty Safekeeping A/c (Customer Number)      *
      *           Validation Process                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSA1N        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSA1N'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
 
     C                   PARM                    CSE028
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSA1L - Counterparty Safekeeping A/c (a/c line)             *
      *           Validation Process                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSA1L        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSA1L'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
 
     C                   PARM                    WTDTP
 
     C                   PARM                    CSE028
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSKAN - Safekeeping A/c (Customer Number) Validation        *
      *           Process                                             *
      *                                                               *
      *****************************************************************
 
     C     SRSKAN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSKAN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WWCLTY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSKAL - Safekeeping A/c (a/c line 1) Validation Process     *
      *                                                               *
      *****************************************************************
 
     C     SRSKAL        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSKAL'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    OVER6
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRCCTN - Clearing Correspondent Validation Process           *
      *                                                               *
      *****************************************************************
 
     C     SRCCTN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVCCTN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WWCLTY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRDCTL - Deliverer's Instructing Party Validation Process    *
      *                                                               *
      *****************************************************************
 
     C     SRDCTL        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCTL'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRSSN - Receiver of Securities Validation Process           *
      *                                                               *
      *****************************************************************
 
     C     SRRSSN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRSSN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    CSE028
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRSS1 - Receiver of Securities Validation Process (Line 1)  *
      *                                                               *
      *****************************************************************
 
     C     SRRSS1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRSS1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    OVER7
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRSS2 - Receiver of Securities Validation Process (Line 2)  *
      *                                                               *
      *****************************************************************
 
     C     SRRSS2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRSS2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER7
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRSS3 - Receiver of Securities Validation Process (Line 3)  *
      *                                                               *
      *****************************************************************
 
     C     SRRSS3        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRSS3'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER7
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRRSS4 - Receiver of Securities Validation Process (Line 4)  *
      *                                                               *
      *****************************************************************
 
     C     SRRSS4        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVRSS4'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER7
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRDSSN - Deliverer of Securities Validation Process          *
      *           (Customer Number)                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDSSN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSSN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    CSE028
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRDSS1 - Deliverer of Securities Validation Process (Line 1) *
      *                                                               *
      *****************************************************************
 
     C     SRDSS1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSS1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    OVER8
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRDSS2 - Deliverer of Securities Validation Process (Line 2) *
      *                                                               *
      *****************************************************************
 
     C     SRDSS2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSS2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER8
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRDSS3 - Deliverer of Securities Validation Process (Line 3) *
      *                                                               *
      *****************************************************************
 
     C     SRDSS3        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSS3'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER8
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRDSS4 - Deliverer of Securities Validation Process (Line 4) *
      *                                                               *
      *****************************************************************
 
     C     SRDSS4        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSS4'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER8
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRBSSN - Beneficiary Securities Validation Process           *
      *                                                               *
      *****************************************************************
 
     C     SRBSSN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVBSSN'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRBSS1 - Beneficiary Securities (Line 1) Validation Process  *
      *                                                               *
      *****************************************************************
 
     C     SRBSS1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVBSS1'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER9
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRBSS2 - Beneficiary Securities (Line 2) Validation Process  *
      *                                                               *
      *****************************************************************
 
     C     SRBSS2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVBSS2'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    OVER9
 
     C                   PARM                    PINKS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRINTM - Intermediary Fields Validation Process              *
      *                                                               *
      *****************************************************************
 
     C     SRINTM        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVINTM'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRSAFE - Safekeeping Account Validation Process              *
      *                                                               *
      *****************************************************************
 
     C     SRSAFE        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSAFE'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRPSET - Place of Settlement Validation Process              *
      *                                                               *
      *****************************************************************
 
     C     SRPSET        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVPSET'
      *                             =======
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRQFIN - Qualified Foreign Intermediary Validation Process   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRQFIN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Reset variables updated by each module                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRResetErrs                                                CSW210
      *                                                                                       CSW210
      ** Call validation module                                                               CSW210
      *                                                                                       CSW210
     C                   CALLB     'SEVQFIN'                                                  CSW210
      *                             =======                                                   CSW210
      ** INPUTS                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Return code                                                                          CSW210
     C                   PARM                    RetCodeOut                                   CSW210
      *                                                                                       CSW210
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW210
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW210
      ** Mode = '*RPR  ' (Repair function)                                                    CSW210
      ** Mode = '*SIN  ' (Screen input function)                                              CSW210
     C                   PARM                    PMode                                        CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements from incoming transaction                       CSW210
      ** - screen format                                                                      CSW210
     C                   PARM                    NwSE1ScnFmt                                  CSW210
      *                                                                                       CSW210
      ** OUTPUT                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW210
     C                   PARM                    FldNamXAr                                    CSW210
     C                   PARM                    MsgIDXAr                                     CSW210
     C                   PARM                    MsgDtaXAr                                    CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements error indicators                                CSW210
     C                   PARM                    SEETES                                       CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements Valid File                                      CSW210
     C                   PARM                    NwSEFilFmt                                   CSW210
      *                                                                                       CSW210
      ** Update error info with that returned from the validation module                      CSW210
      *                                                                                       CSW210
     C                   IF        RetCodeOut <> *BLANKS                                      CSW210
     C                   EXSR      SRUpdatErrs                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRPCLR - Place of Clearing Validation Process                *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRPCLR        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Reset variables updated by each module                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRResetErrs                                                CSW210
      *                                                                                       CSW210
      ** Call validation module                                                               CSW210
      *                                                                                       CSW210
     C                   CALLB     'SEVPLCLEAR'                                               CSW210
      *                             =======                                                   CSW210
      ** INPUTS                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Return code                                                                          CSW210
     C                   PARM                    RetCodeOut                                   CSW210
      *                                                                                       CSW210
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW210
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW210
      ** Mode = '*RPR  ' (Repair function)                                                    CSW210
      ** Mode = '*SIN  ' (Screen input function)                                              CSW210
     C                   PARM                    PMode                                        CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements from incoming transaction                       CSW210
      ** - screen format                                                                      CSW210
     C                   PARM                    NwSE1ScnFmt                                  CSW210
      *                                                                                       CSW210
      ** OUTPUT                                                                               CSW210
      ** ======                                                                               CSW210
      *                                                                                       CSW210
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW210
     C                   PARM                    FldNamXAr                                    CSW210
     C                   PARM                    MsgIDXAr                                     CSW210
     C                   PARM                    MsgDtaXAr                                    CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements error indicators                                CSW210
     C                   PARM                    SEETES                                       CSW210
      *                                                                                       CSW210
      ** Security Trades Extended Settlements Valid File                                      CSW210
     C                   PARM                    NwSEFilFmt                                   CSW210
      *                                                                                       CSW210
      ** Update error info with that returned from the validation module                      CSW210
      *                                                                                       CSW210
     C                   IF        RetCodeOut <> *BLANKS                                      CSW210
     C                   EXSR      SRUpdatErrs                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
 
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *Blank        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   EVAL      IDx = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *Blank        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   EVAL      WIDx = ArrayMax - 1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ***SRAP1N**-*Account*for*Payment*(MT510)*Validation*Process *****                       222331
      * MOVEFIELD - Set up additional fields that are needed on the   *                       222331
      *        Valid file record.                                     *                       222331
      *                                                               *
      *****************************************************************
 
     C     MOVEFIELD     BEGSR
     C                   MOVE      PTDRF         T2TDRF
     C                   MOVE      ESAP1N        T2AP1N
     C                   MOVE      ESAP1L        T2AP1L
     C                   MOVE      ESAP2N        T2AFPN
     C                   MOVE      ESAP2L        T2AFPL
     C                   MOVE      ESAWIN        T2AWIN
     C                   MOVE      ESAWIL        T2AWIL
     C                   MOVE      ESBOFN        T2BOFN
     C                   MOVE      ESBOF1        T2BOF1
     C                   IF        CSW210 = 'N'                                               CSW210
     C                   MOVE      ESBOF2        T2BOF2
     C                   ENDIF                                                                CSW210
     C                   MOVE      ESACL1        T2ACL1
     C                   MOVE      ESACL2        T2ACL2
     C                   MOVE      ESSRL1        T2SRL1
     C                   MOVE      ESSRL2        T2SRL2
     C                   MOVE      ESSRL3        T2SRL3
     C                   MOVE      ESFIN1        T2FIN1
     C                   MOVE      ESFIN2        T2FIN2
     C                   MOVE      ESRED1        T2RED1
     C                   MOVE      ESRED2        T2RED2
     C                   MOVE      ESNAL1        T2NAL1
     C                   MOVE      ESNAL2        T2NAL2
     C                   MOVE      ESIPYN        T2IPYN
     C                   MOVE      ESIPYL        T2IPYL
     C                   MOVE      ESCTYN        T2CTYN
     C                   MOVE      ESCTYL        T2CTYL
     C                   MOVE      ESSA1N        T2SA1N
     C                   MOVE      ESSA1L        T2SA1L
     C                   MOVE      ESSKAN        T2SKAN
     C                   MOVE      ESSKAL        T2SKAL
     C                   MOVE      ESCCTN        T2CCTN
     C                   MOVE      ESDCTL        T2DCTL
     C                   MOVE      ESRSSN        T2RSSN
     C                   MOVE      ESRSS1        T2RSS1
     C                   MOVE      ESRSS2        T2RSS2
     C                   MOVE      ESRSS3        T2RSS3
     C                   MOVE      ESRSS4        T2RSS4
     C                   MOVE      ESDSSN        T2DSSN
     C                   MOVE      ESDSS1        T2DSS1
     C                   MOVE      ESDSS2        T2DSS2
     C                   MOVE      ESDSS3        T2DSS3
     C                   MOVE      ESDSS4        T2DSS4
     C                   MOVE      ESBSSN        T2BSSN
     C                   MOVE      ESBSS1        T2BSS1
     C                   MOVE      ESBSS2        T2BSS2
     C                   MOVE      ESINVE        T2INVE
     C                   MOVE      ESIMMD1       T2IMD1
     C                   MOVE      ESIMMD2       T2IMD2
     C**********         MOVE      ESIMMD3       T2IMD3                                      CSW206D
     C**********         MOVE      ESIMMD4       T2IMD4                                      CSW206D
     C**********         MOVE      ESIMMD5       T2IMD5                                      CSW206D
     C**********         MOVE      ESIMMD6       T2IMD6                                      CSW206D
     C**********         MOVE      ESIMMD7       T2IMD7                                      CSW206D
     C**********         MOVE      ESIMMD8       T2IMD8                                      CSW206D
     C**********         MOVE      ESIMMD9       T2IMD9                                      CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVE      ESIMMD3       T2IMD3                                      CSW206E
     C                   MOVE      ESIMMD4       T2IMD4                                      CSW206E
     C                   MOVE      ESIMMD5       T2IMD5                                      CSW206E
     C                   MOVE      ESIMMD6       T2IMD6                                      CSW206E
     C                   MOVE      ESIMMD7       T2IMD7                                      CSW206E
     C                   MOVE      ESIMMD8       T2IMD8                                      CSW206E
     C                   MOVE      ESIMMD9       T2IMD9                                      CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVE      ESIMSA1       T2IMS1
     C                   MOVE      ESIMSA2       T2IMS2
     C**********         MOVE      ESIMSA3       T2IMS3                                      CSW206D
     C**********         MOVE      ESIMSA4       T2IMS4                                      CSW206D
     C**********         MOVE      ESIMSA5       T2IMS5                                      CSW206D
     C**********         MOVE      ESIMSA6       T2IMS6                                      CSW206D
     C**********         MOVE      ESIMSA7       T2IMS7                                      CSW206D
     C**********         MOVE      ESIMSA8       T2IMS8                                      CSW206D
     C**********         MOVE      ESIMSA9       T2IMS9                                      CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVE      ESIMSA3       T2IMS3                                      CSW206E
     C                   MOVE      ESIMSA4       T2IMS4                                      CSW206E
     C                   MOVE      ESIMSA5       T2IMS5                                      CSW206E
     C                   MOVE      ESIMSA6       T2IMS6                                      CSW206E
     C                   MOVE      ESIMSA7       T2IMS7                                      CSW206E
     C                   MOVE      ESIMSA8       T2IMS8                                      CSW206E
     C                   MOVE      ESIMSA9       T2IMS9                                      CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVE      ESPSET        T2PSET
     C                   MOVE      ESNAC1        T2NAC1
     C                   MOVE      ESNAC2        T2NAC2
      * SWIFT 2010                                                                            CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   EVAL      T2DIDN = ESDIDN                                            CSW210
     C                   EVAL      T2DAD1 = ESDAD1                                            CSW210
     C                   EVAL      T2DAD2 = ESDAD2                                            CSW210
     C                   EVAL      T2DAD3 = ESDAD3                                            CSW210
     C                   EVAL      T2DAD4 = ESDAD4                                            CSW210
     C                   EVAL      T2DLIN = ESDLIN                                            CSW210
     C                   EVAL      T2QFIN = ESQFIN                                            CSW210
     C                   EVAL      T2PCLR = ESPCLR                                            CSW210
      * IBAN                                                                                  CSW210
     C                   IF        CFT004 = 'Y'                                               CSW210
     C                   IF        T2FAP1 = *BLANKS                                           CSW210
     C                   EVAL      T2FAP1 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        T2FAP2 = *BLANKS                                           CSW210
     C                   EVAL      T2FAP2 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        T2FDBT = *BLANKS                                           CSW210
     C                   EVAL      T2FDBT = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        T2FAI1 = *BLANKS                                           CSW210
     C                   EVAL      T2FAI1 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        T2FBF1 = *BLANKS                                           CSW210
     C                   EVAL      T2FBF1 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PResponse
      *
      ** Security API Trades Extended Settlement details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** MT5xx SSI Enhancements
     C                   PARM                    CSE028
      *
      ** ERI Information for non-EMU users
     C                   PARM                    CSW014
      *
      ** SWIFT 2001
     C                   PARM                    CSW201
      *
      ** CSW098
     C                   PARM                    SWRTN
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206            1                         CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      ** CFT004                                                                               CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** Other Parameters
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    PSAFA
      *
      ** Function Keys
     C                   PARM                    PINKS
 
     C                   PARM                    PINKT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Security API Trades Extended Settlements Error Indicators
     C                   PARM                    SEETES
      *
      ** Security API Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
      *
      ***Enable*display*of*counterparty*safekeeping*a/c*if*                                  BUG8004
      ***CSE028*is*on*and*ISO15022*is*on.******************                                  BUG8004
      *****************************************************                                  BUG8004
     C*****CSE028        IFEQ      'Y'                                                       BUG8004
     C*****PSNEW         ANDEQ     'Y'                                                       BUG8004
     C*****PGMES         ANDEQ     'Y'                                                       BUG8004
     C**********         EVAL      *IN88 = *ON                                               BUG8004
     C**********         ELSE                                                                BUG8004
     C**********         EVAL      *IN88 = *OFF                                              BUG8004
     C**********         ENDIF                                                               BUG8004
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2003
